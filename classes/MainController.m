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
	if (userName != nil) {
		[usernameField setStringValue:userName];
		[passwordField setStringValue:[AGKeychain getPasswordFromKeychainItem:@"Internet Password" withItemKind:@"Lustro" forUsername:userName]];
	}
	
	[NSApp beginSheet:authSheet modalForWindow:window modalDelegate:self didEndSelector:NULL contextInfo:nil];
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
		[controller export];
		[controller release];
		[indicators setValue:@"2" forKey:@"html"];
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

/* DELEGATE OF NSTEXTFIELD */
- (void)controlTextDidEndEditing:(NSNotification *)notification
{
	[passwordField setStringValue:[AGKeychain getPasswordFromKeychainItem:@"Internet Password" withItemKind:@"Lustro" forUsername:[usernameField stringValue]]];
}
@end