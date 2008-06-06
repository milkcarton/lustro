//
//  MainController.m
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 20/04/08.
//  Copyright 2008 eggnog. All rights reserved.
//

#import "MainController.h"

@implementation MainController
- (id)init
{
	self = [super init];
	NSArray *keys   = [NSArray arrayWithObjects:@"comma",@"tab", @"html", @"google", @"authenticate", nil];
    NSArray *values = [NSArray arrayWithObjects:@"0" ,@"0", @"0", @"0", @"YES", nil];
	indicators = [[NSMutableDictionary alloc] initWithObjects:values forKeys:keys];
	
	//Initialize the value transformers used throughout the application bindings
	NSValueTransformer *statusValueTransformer = [[StatusValueTransformer alloc] init];
    [NSValueTransformer setValueTransformer:statusValueTransformer forName:@"StatusValueTransformer"];
	NSValueTransformer *progressValueTransformer = [[ProgressValueTransformer alloc] init];
    [NSValueTransformer setValueTransformer:progressValueTransformer forName:@"ProgressValueTransformer"];
	return self;
}

- (void)awakeFromNib
{	
	// Initialize the checkbox to 1
	defaults = [NSUserDefaults standardUserDefaults];
    NSString *keyChainSaveValue = [defaults stringForKey:@"KeyChainSave"];
    if (keyChainSaveValue == nil) keyChainSaveValue = @"1";
	
	// Set button state.
	[self setExportButton];
	[self setSignInButton];
}

- (NSMutableDictionary *)indicators
{
	return indicators;
}

- (IBAction)export:(id)sender
{	
	[indicators setValue:@"0" forKey:@"comma"];
	[indicators setValue:@"0" forKey:@"tab"];
	[indicators setValue:@"0" forKey:@"html"];
	[indicators setValue:@"0" forKey:@"google"];
	//[self performSelectorInBackground:@selector(invocateExport) withObject:nil];
	
	[self invocateExport];
}

- (IBAction)authenticate:(id)sender
{
	if ([[defaults valueForKey:@"KeyChainSave"] boolValue]) {
		// add or modify keychain item.
		BOOL exists = [AGKeychain checkForExistanceOfKeychainItem:@"Internet Password" withItemKind:@"Lustro" forUsername:[usernameField stringValue]];
		if (exists) {
			BOOL modified = [AGKeychain modifyKeychainItem:@"Internet Password" withItemKind:@"Lustro" forUsername:[usernameField stringValue] withNewPassword:[passwordField stringValue]];
			if (modified) {
				[defaults setObject:[usernameField stringValue] forKey:@"UserName"];
			}
		} else {
			BOOL added = [AGKeychain addKeychainItem:@"Internet Password" withItemKind:@"Lustro" forUsername:[usernameField stringValue] withPassword:[passwordField stringValue]];
			if (added) {
				[defaults setObject:[usernameField stringValue] forKey:@"UserName"];
			}
		}
	} else {
		[defaults setObject:@"" forKey:@"UserName"];
	}
	
	[authSheet orderOut:nil];
    [NSApp endSheet:authSheet];
}

- (IBAction)closeSheet:(id)sender
{
	[authSheet orderOut:nil];
    [NSApp endSheet:authSheet];
}

- (IBAction)callSheet:(id)sender
{
	NSString *userName = [defaults objectForKey:@"UserName"];
	if (userName != nil && [userName compare:@""] != NSOrderedSame) {
		[usernameField setStringValue:userName];
		[passwordField setStringValue:[AGKeychain getPasswordFromKeychainItem:@"Internet Password" withItemKind:@"Lustro" forUsername:userName]];
	} else {
		[passwordField setStringValue:@""];
	}
	
	[NSApp beginSheet:authSheet modalForWindow:window modalDelegate:self didEndSelector:NULL contextInfo:nil];
}

- (IBAction)select:(id)sender
{
	[self setExportButton];
}

- (void)invocateExport
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	ABAddressBook *book = [ABAddressBook sharedAddressBook];
	[indicators setValue:@"NO" forKey:@"authenticate"];
	
	// If comma separated is checked
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"CommaChecked"]) {
		[indicators setValue:@"1" forKey:@"comma"];
		[indicators setValue:@"2" forKey:@"comma"];
	}
	
	// If tab separated is checked
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TabChecked"]) {
		[indicators setValue:@"1" forKey:@"tab"];
		[indicators setValue:@"2" forKey:@"tab"];
	}
	
	// If Html is checked
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HtmlChecked"]) {
		[indicators setValue:@"1" forKey:@"html"];
		ExporthCard *controller = [[ExporthCard alloc] initWithAddressBook:book];
		switch ([controller export]) {
			case kExportSuccess: [indicators setValue:@"2" forKey:@"html"];
								 break;
			case kExportWarning: [indicators setValue:@"3" forKey:@"html"];
								 break;
			default: [indicators setValue:@"4" forKey:@"html"];
		}
		[controller release];
	}
	
	// If Google is checked
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleChecked"]) {
		[indicators setValue:@"1" forKey:@"google"];
		ExportGoogle *controller = [[ExportGoogle alloc] initWithAddressBook:book];
		[controller export];
		[controller release];
		[indicators setValue:@"2" forKey:@"google"];
	}
	
	[indicators setValue:@"YES" forKey:@"authenticate"];
	[pool release];
}

- (void)setSignInButton
{
	if ([[usernameField stringValue] compare:@""] != NSOrderedSame && [[passwordField stringValue] compare:@""] != NSOrderedSame)
		[signInButton setEnabled:YES];
	else [signInButton setEnabled:NO]; 
}

- (void)setExportButton
{
	// Check if a checkbox is selected.
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"CommaChecked"] || [[NSUserDefaults standardUserDefaults] boolForKey:@"TabChecked"] || [[NSUserDefaults standardUserDefaults] boolForKey:@"HtmlChecked"] || [[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleChecked"])
		[exportButton setEnabled:YES];
	else [exportButton setEnabled:NO];
}

/* DELEGATE OF NSTEXTFIELD */
- (void)controlTextDidChange:(NSNotification *)notification
{
	[self setSignInButton];
}

- (void)controlTextDidEndEditing:(NSNotification *)notification
{
	if ([[usernameField stringValue] compare:@""] != NSOrderedSame) {
		NSString *tmpPassword = [AGKeychain getPasswordFromKeychainItem:@"Internet Password" withItemKind:@"Lustro" forUsername:[usernameField stringValue]];
		if ([tmpPassword compare:@"error"] == NSOrderedSame) {
			[passwordField setStringValue:@""];
		} else {
			[passwordField setStringValue:tmpPassword];
		}
	} else {
		[passwordField setStringValue:@""];
	}
	[self setSignInButton];
}
@end