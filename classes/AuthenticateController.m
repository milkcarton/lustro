//
//  AuthenticateController.m
//  lustro
//
//  Created by Simon Schoeters on 09/06/08.
//  Copyright 2008 IMEC. All rights reserved.
//

#import "AuthenticateController.h"


@implementation AuthenticateController

- (void)controlTextDidChange:(NSNotification *)notification
{
	if ([[usernameField stringValue] compare:@""] != NSOrderedSame && [[passwordField stringValue] compare:@""] != NSOrderedSame)
		[signInButton setEnabled:YES];
	else [signInButton setEnabled:NO];		
}

- (IBAction)closeLogPanel:(id)sender
{
	[panel orderOut:nil];
	[NSApp endSheet:panel];
}

- (IBAction)signIn:(id)sender
{
	username = [usernameField stringValue];
	password = [passwordField stringValue];
	
	if ([[defaults valueForKey:@"KeyChainSave"] boolValue]) {
		BOOL exists = [AGKeychain checkForExistanceOfKeychainItem:@"Internet Password" withItemKind:@"Lustro" forUsername:username];
		if (exists) { // Modify the Keychain item
			BOOL modified = [AGKeychain modifyKeychainItem:@"Internet Password" withItemKind:@"Lustro" forUsername:username withNewPassword:password];
			if (modified) {
				[defaults setObject:username forKey:@"UserName"];
			}
		} else { // Add the Keychain item
			BOOL added = [AGKeychain addKeychainItem:@"Internet Password" withItemKind:@"Lustro" forUsername:username withPassword:password];
			if (added) {
				[defaults setObject:username forKey:@"UserName"];
			}
		}
	}
	
	if (![GoogleExport autenticateWithUsername:username password:password]) {
		username = nil;
		password = nil;
		[errorLabel setStringValue:@"Incorrect username or password."];
	} else {
		[panel orderOut:nil];
		[NSApp endSheet:panel];
	 }
}

#pragma mark Delegates of NSWindow

- (void)windowWillBeginSheet:(NSNotification *)notification
{
	defaults = [NSUserDefaults standardUserDefaults];
	
	[errorLabel setStringValue:@""];
	if (username == nil && [[usernameField stringValue] compare:@""] == NSOrderedSame) { // Read user from defaults
		NSString *user = [defaults objectForKey:@"UserName"];
		if (user && [user compare:@""] != NSOrderedSame) {
			username = user;
			[usernameField setStringValue:username];
		}
	}
	
	if (password == nil && username) { // Read password from Keychain
		password = [AGKeychain getPasswordFromKeychainItem:@"Internet Password" withItemKind:@"Lustro" forUsername:username];
		[passwordField setStringValue:password];
	}
	
	if ([[usernameField stringValue] compare:@""] != NSOrderedSame && [[passwordField stringValue] compare:@""] != NSOrderedSame)
		[signInButton setEnabled:YES];
	else [signInButton setEnabled:NO];
}

@synthesize panel;
@synthesize username;
@synthesize password;
@end
