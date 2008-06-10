//
//  AuthenticateController.m
//  lustro
//
//  Created by Simon Schoeters on 09/06/08.
//  Copyright 2008 IMEC. All rights reserved.
//

#import "AuthenticateController.h"


@implementation AuthenticateController

- (void)windowWillBeginSheet:(NSNotification *)notification
{
	defaults = [NSUserDefaults standardUserDefaults];
	if ([[usernameField stringValue] compare:@""] != NSOrderedSame && [[passwordField stringValue] compare:@""] != NSOrderedSame)
		[signInButton setEnabled:YES];
	else [signInButton setEnabled:NO];
	[errorLabel setStringValue:@""];
	
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

- (void)controlTextDidChange:(NSNotification *)notification
{
	[self windowWillBeginSheet:notification];
}

- (IBAction)closeLogPanel:(id)sender
{
	[panel orderOut:nil];
	[NSApp endSheet:panel];
}

- (IBAction)signIn:(id)sender
{
	username = [usernameField stringValue];
	if ([[defaults valueForKey:@"KeyChainSave"] boolValue]) {
		// Add or modify a Keychain item
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
	
	if (![GoogleExport autenticateWithUsername:username password:password]) {
		username = nil;
		password = nil;
		[errorLabel setStringValue:@"Incorrect username or password."];
	} else {
		[panel orderOut:nil];
		[NSApp endSheet:panel];
	 }
}

@synthesize panel;
@synthesize username;
@synthesize password;
@end
