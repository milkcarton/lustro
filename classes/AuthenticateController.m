//
//  AuthenticateController.m
//  lustro
//
//  Created by Simon Schoeters on 09/06/08.
//  Copyright 2008 IMEC. All rights reserved.
//

#import "AuthenticateController.h"

@implementation AuthenticateController

- (void)awakeFromNib
{
	myKeyChain = [Keychain defaultKeychain];
	getDefaultPassword = [[[NSUserDefaults standardUserDefaults] valueForKey:@"KeyChainSave"] boolValue];
	[self windowWillBeginSheet:nil];
}

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
	[exportController notifyAuthenticate];
}

- (IBAction)signIn:(id)sender
{
	username = [usernameField stringValue];
	password = [passwordField stringValue];
	
	if ([[defaults valueForKey:@"KeyChainSave"] boolValue]) {
		[myKeyChain addGenericPassword:password onService:@"Lustro" forAccount:username replaceExisting:YES];
		if ([myKeyChain lastError] == 0)
			[defaults setObject:username forKey:@"UserName"];
	}
	
	if (![GoogleExport autenticateWithUsername:username password:password]) {
		username = nil;
		password = nil;
		[errorLabel setStringValue:@"Incorrect username or password."];
	} else {
		[panel orderOut:nil];
		[NSApp endSheet:panel];
		[exportController notifyAuthenticate];
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
	
	if (password == nil && username && getDefaultPassword) { // Read password from Keychain
		password = [myKeyChain passwordForGenericService:@"Lustro" forAccount:username];
		if (!password) password = @"";
		[passwordField setStringValue:password];
		getDefaultPassword = YES;
	}
	
	if ([[usernameField stringValue] compare:@""] != NSOrderedSame && [[passwordField stringValue] compare:@""] != NSOrderedSame)
		[signInButton setEnabled:YES];
	else [signInButton setEnabled:NO];
}

@synthesize panel;
@synthesize username;
@synthesize password;
@synthesize getDefaultPassword;
@end
