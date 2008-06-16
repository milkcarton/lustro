/*
 Copyright (c) 2008 Jelle Vandebeeck, Simon Schoeters
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 Created by Simon Schoeters on 2008.06.09.
*/

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
		if (!password) {
			password = @"";
			[defaults setBool:NO forKey:@"KeyChainSave"];
		}
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
@synthesize defaults;
@synthesize errorLabel;
@synthesize usernameField;
@synthesize passwordField;
@synthesize signInButton;
@synthesize exportController;
@synthesize myKeyChain;
@end
