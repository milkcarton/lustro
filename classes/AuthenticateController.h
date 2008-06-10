//
//  AuthenticateController.h
//  lustro
//
//  Created by Simon Schoeters on 09/06/08.
//  Copyright 2008 IMEC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GoogleExport.h"
#import "AGKeychain.h"

@interface AuthenticateController : NSObject {
	IBOutlet id panel;
	IBOutlet id errorLabel;
	IBOutlet id usernameField;
	IBOutlet id passwordField;
	IBOutlet id signInButton;
	@private NSUserDefaults *defaults;
	@private NSString *username;
	@private NSString *password;
}

- (IBAction)closeLogPanel:(id)sender;
- (IBAction)signIn:(id)sender;

@property (retain, readonly) id panel;
@property (retain, readonly) NSString *username;
@property (retain, readonly) NSString *password;
@end
