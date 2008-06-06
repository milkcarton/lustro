//
//  MainController.m
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 20/04/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import "MainController.h"

@implementation MainController
- (id)init
{
	self = [super init];
	
	// set the default indicators.
	NSArray *keys   = [NSArray arrayWithObjects:@"comma",@"tab", @"html", @"google", @"authenticate", nil];
    NSArray *values = [NSArray arrayWithObjects:@"0" ,@"0", @"0", @"0", @"YES", nil];
	indicators = [[NSMutableDictionary alloc] initWithObjects:values forKeys:keys];
	
	//Initialize the value transformers used throughout the application bindings
	NSValueTransformer *statusValueTransformer = [[StatusValueTransformer alloc] init];
    [NSValueTransformer setValueTransformer:statusValueTransformer forName:@"StatusValueTransformer"];
	NSValueTransformer *progressValueTransformer = [[ProgressValueTransformer alloc] init];
    [NSValueTransformer setValueTransformer:progressValueTransformer forName:@"ProgressValueTransformer"];
	NSValueTransformer *logImageValueTransformer = [[LogImageValueTransformer alloc] init];
    [NSValueTransformer setValueTransformer:logImageValueTransformer forName:@"LogImageValueTransformer"];
	
	return self;
}

- (void)awakeFromNib
{	
	// Initialize the checkbox to 1
	defaults = [NSUserDefaults standardUserDefaults];
    NSString *keyChainSaveValue = [defaults stringForKey:@"KeyChainSave"];
    if (keyChainSaveValue == nil) keyChainSaveValue = @"1";
	
	// Set username and password if the Google export option is selected in the defaults
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleChecked"]) {
		[self setCredentials];
	}
	[self setExportButton];
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
	[self performSelectorInBackground:@selector(invocateExport) withObject:nil];
	//[self invocateExport];
}

- (IBAction)authenticate:(id)sender
{
	username = [usernameField stringValue];
	if ([[defaults valueForKey:@"KeyChainSave"] boolValue]) {
		// add or modify keychain item.
		BOOL exists = [AGKeychain checkForExistanceOfKeychainItem:@"Internet Password" withItemKind:@"Lustro" forUsername:username];
		if (exists) {
			BOOL modified = [AGKeychain modifyKeychainItem:@"Internet Password" withItemKind:@"Lustro" forUsername:username withNewPassword:[passwordField stringValue]];
			if (modified) {
				[defaults setObject:username forKey:@"UserName"];
			}
		} else {
			BOOL added = [AGKeychain addKeychainItem:@"Internet Password" withItemKind:@"Lustro" forUsername:username withPassword:[passwordField stringValue]];
			if (added) {
				[defaults setObject:username forKey:@"UserName"];
			}
		}
	} else {
		[defaults setObject:@"" forKey:@"UserName"];
	}

	password = [passwordField stringValue];
	/*if ( ![ExportGoogle checkCredentialsWithUsername:username password:password] ) {
		username = nil;
		password = nil;
		[errorLabel setStringValue:@"Incorrect username or password."];
		[self setExportButton];
	} else {
		[self setExportButton];
		[authSheet orderOut:nil];
		[NSApp endSheet:authSheet];
	}*/
}

- (IBAction)closeSheet:(id)sender
{
	[authSheet orderOut:nil];
    [NSApp endSheet:authSheet];
}

- (IBAction)callSheet:(id)sender
{
	[self setCredentials];
	[self setSignInButton];
	[NSApp beginSheet:authSheet modalForWindow:window modalDelegate:self didEndSelector:NULL contextInfo:nil];
}

- (IBAction)select:(id)sender
{
	[self setExportButton];
}

// Read the credentials the first time the box is selected
-(IBAction)selectGoogle:(id)sender
{
	if ([sender state] == NSOnState) {
		[self setCredentials];
	}
	[self setExportButton];
}

- (IBAction)showLog:(id)sender
{
	[NSApp beginSheet:logSheet modalForWindow:window modalDelegate:self didEndSelector:NULL contextInfo:nil];
}

- (IBAction)closeLog:(id)sender
{
	[logSheet orderOut:nil];
	[NSApp endSheet:logSheet];
}

- (IBAction)copyLog:(id)sender
{
	[errorCtrl copyLog];
}

- (IBAction)openHelp:(id)sender
{
	CFBundleRef myApplicationBundle = CFBundleGetMainBundle();
    CFStringRef myBookName = CFBundleGetValueForInfoDictionaryKey(myApplicationBundle, CFSTR("CFBundleHelpBookName"));
    AHGotoPage (myBookName, CFSTR("index.html"), NULL);
}

- (void)invocateExport
{
	/*NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	ABAddressBook *book = [ABAddressBook sharedAddressBook];
	
	[indicators setValue:@"NO" forKey:@"authenticate"];

	// If comma separated is checked
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"CommaChecked"]) {
		[indicators setValue:@"1" forKey:@"comma"];
		ExportSeparatedFile *controller = [[ExportSeparatedFile alloc] initWithAddressBook:book target:errorCtrl separator:@"," extention:@"csv"];
		switch ([controller export]) {
			case kExportSuccess: [indicators setValue:@"2" forKey:@"comma"];
				break;
			case kExportWarning: [indicators setValue:@"3" forKey:@"comma"];
				break;
			default: [indicators setValue:@"4" forKey:@"comma"];
		}
		[controller release];
		controller = nil;
	}
	
	// If tab separated is checked
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TabChecked"]) {
		[indicators setValue:@"1" forKey:@"tab"];
		ExportSeparatedFile *controller = [[ExportSeparatedFile alloc] initWithAddressBook:book target:errorCtrl separator:@"\t" extention:@"tab"];
		switch ([controller export]) {
			case kExportSuccess: [indicators setValue:@"2" forKey:@"tab"];
				break;
			case kExportWarning: [indicators setValue:@"3" forKey:@"tab"];
				break;
			default: [indicators setValue:@"4" forKey:@"tab"];
		}
		[controller release];
	}
	
	// If Html is checked
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HtmlChecked"]) {
		[indicators setValue:@"1" forKey:@"html"];
		ExporthCard *controller = [[ExporthCard alloc] initWithAddressBook:book target:errorCtrl];
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
		NSString *googleUserName = username;
		NSString *googlePassword = [passwordField stringValue];

		// TODO the fields are empty when not opened first, load the username and password at startup
		ExportGoogle *controller = [[ExportGoogle alloc] initWithAddressBook:book username:googleUserName password:googlePassword target:errorCtrl];
		switch ([controller export]) {
			case kExportSuccess: [indicators setValue:@"2" forKey:@"google"];
				break;
			case kExportWarning: [indicators setValue:@"3" forKey:@"google"];
				break;
			default: [indicators setValue:@"4" forKey:@"google"];
		}
		
		[controller release];
	}
	
	[indicators setValue:@"YES" forKey:@"authenticate"];
	[pool release];
	pool = nil;*/
}

- (void)setSignInButton
{
	if ([[usernameField stringValue] compare:@""] != NSOrderedSame && [[passwordField stringValue] compare:@""] != NSOrderedSame)
		[signInButton setEnabled:YES];
	else [signInButton setEnabled:NO];
	[errorLabel setStringValue:@""];
}

- (void)setExportButton
{
	BOOL googleCheck = FALSE;
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleChecked"] && username && password) {
		googleCheck = TRUE;
	}

	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleChecked"] && ([[NSUserDefaults standardUserDefaults] boolForKey:@"CommaChecked"] || [[NSUserDefaults standardUserDefaults] boolForKey:@"TabChecked"] || [[NSUserDefaults standardUserDefaults] boolForKey:@"HtmlChecked"])) {
		[exportButton setEnabled:YES];
	} else if (googleCheck) {
		[exportButton setEnabled:YES];
	} else {
		[exportButton setEnabled:NO];
	}
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
		if ([tmpPassword compare:@"error"] != NSOrderedSame) {
			[passwordField setStringValue:tmpPassword];
		}
	} else {
		[passwordField setStringValue:@""];
	}
	[self setSignInButton];
}

- (void)setCredentials
{
	// Read user from defaults
	if (username == nil) {
		NSString *user = [defaults objectForKey:@"UserName"];
		if (user && [user compare:@""] != NSOrderedSame) {
			username = user;
		}
	}
	// Read password from Keychain
	if (password == nil && username) {
		password = [AGKeychain getPasswordFromKeychainItem:@"Internet Password" withItemKind:@"Lustro" forUsername:username];
	}
}

@synthesize indicators;
@synthesize defaults;
@synthesize errorCtrl;
@synthesize authSheet;
@synthesize window;
@synthesize usernameField;
@synthesize passwordField;
@synthesize exportButton;
@synthesize signInButton;
@synthesize username;
@synthesize logSheet;
@end