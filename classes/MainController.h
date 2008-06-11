// DEPRECIATED

//
//  MainController.h
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 20/04/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <AddressBook/AddressBook.h>
//#import "StatusValueTransformer.h"
#import "ProgressValueTransformer.h"
#import "LogImageValueTransformer.h"
//#import "ErrorController.h"
#import "AGKeychain.h"

@interface MainController : NSObject {
	NSMutableDictionary *indicators;
	NSUserDefaults *defaults;
	IBOutlet id errorCtrl;

	IBOutlet id authSheet;			// The authentication sheet.
	IBOutlet id errorLabel;			// The message label when using the wrong Google username or password.
	IBOutlet id window;				// The main Lustro window.
	IBOutlet id logSheet;
	IBOutlet id usernameField;		// The username textfield from the auth sheet.
	IBOutlet id passwordField;		// The password textfield from the auth sheet.
	IBOutlet id exportButton;		// The export button.
	IBOutlet id signInButton;		// The button to sign in to your Google account.
	NSString *username;
	NSString *password;
}/*
- (NSMutableDictionary *)indicators;				// Returns the indicators dictionary.
- (IBAction)export:(id)sender;						// Called when the export button is pressed.
- (IBAction)authenticate:(id)sender;				// Called when the authenticate button is pressed.
- (IBAction)closeSheet:(id)sender;					// Closes the sheet without any savings.
- (IBAction)callSheet:(id)sender;					// Show the authentication sheet.
- (IBAction)select:(id)sender;						// Called when any checkbox (except Google) is selected.
- (IBAction)selectGoogle:(id)sender;				// Called when the Google checkbox is selected.
- (IBAction)showLog:(id)sender;						// Show the log screen.
- (IBAction)closeLog:(id)sender;
- (IBAction)copyLog:(id)sender;
- (IBAction)openHelp:(id)sender;
- (void)invocateExport;								// Method that is called in the background.
- (void)setSignInButton;							// Enables disables the sign in button depending on the input fields.
- (void)setExportButton;							// Enables disables the export button depending on the checkboxes.
- (void)setCredentials;								// Sets the username and password variables from Keychain.

@property (retain,getter=indicators) NSMutableDictionary *indicators;
@property (retain) NSUserDefaults *defaults;
@property (retain) ErrorController *errorCtrl;
@property (retain) id authSheet;
@property (retain) id window;
@property (retain) id usernameField;
@property (retain) id passwordField;
@property (retain) id exportButton;
@property (retain) id signInButton;
@property (retain) NSString *username;
@property (retain) id logSheet;*/
@end