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
@property (retain) NSUserDefaults *defaults;
@property (retain) NSTextField *errorLabel;
@property (retain) NSTextField *usernameField;
@property (retain) NSTextField *passwordField;
@property (retain) NSButton *signInButton;
@property (retain) id exportController;
@property (retain) Keychain *myKeyChain;
@end
