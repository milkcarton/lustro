//
//  AuthenticateController.h
//  lustro
//
//  Created by Simon Schoeters on 09/06/08.
//  Copyright 2008 IMEC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GoogleExport.h"
#import <Keychain/Keychain.h>

@interface AuthenticateController : NSObject {
	NSUserDefaults *defaults;
	IBOutlet NSWindow *panel;
	IBOutlet NSTextField *errorLabel;
	IBOutlet NSTextField *usernameField;
	IBOutlet NSTextField *passwordField;
	IBOutlet NSButton *signInButton;
	IBOutlet id exportController;
	@private NSString *username;
	@private NSString *password;
	@private Keychain *myKeyChain;
	@private BOOL getDefaultPassword;
}

- (IBAction)closeLogPanel:(id)sender;
- (IBAction)signIn:(id)sender;

@property (retain, readonly) NSWindow *panel;
@property (retain, readonly) NSString *username;
@property (retain, readonly) NSString *password;
@property BOOL getDefaultPassword;
@end
