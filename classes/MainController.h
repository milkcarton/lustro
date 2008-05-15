//
//  MainController.h
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 20/04/08.
//  Copyright 2008 eggnog. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AddressBook/AddressBook.h>
#import "StatusValueTransformer.h"
#import "ProgressValueTransformer.h"
#import "ErrorController.h"
#import "ExportController.h"
#import "ExporthCard.h"
#import "ExportGoogle.h"
#import "AGKeychain.h"

@interface MainController : NSObject {
	NSMutableDictionary *indicators;
	NSMutableArray *groups;
	NSUserDefaults *defaults;
	ErrorController *errorCtrl;

	IBOutlet id authSheet;			// The authentication sheet.
	IBOutlet id window;				// The main Lustro window.
	IBOutlet id groupsTable;
	IBOutlet id usernameField;		// The username textfield from the auth sheet.
	IBOutlet id passwordField;		// The password textfield from the auth sheet.
	IBOutlet id exportButton;		// The export button.
	IBOutlet id signInButton;		// The button to sign in to your Google account.
	NSString *username;
}
- (NSMutableDictionary *)indicators;				// Returns the indicators dictionary.
- (IBAction)export:(id)sender;						// Called when the export button is pressed.
- (IBAction)authenticate:(id)sender;				// Called when the authenticate button is pressed.
- (IBAction)closeSheet:(id)sender;					// Closes the sheet without any savings.
- (IBAction)callSheet:(id)sender;					// Show the authentication sheet.
- (IBAction)select:(id)sender;						// Called when any checkbox is selected.
- (IBAction)showLog:(id)sender;						// Show the log screen.
- (void)invocateExport;								// Method that is called in the background.
- (void)setSignInButton;							// Enables disables the sign in button depending on the input fields.
- (void)setExportButton;							// Enables disables the export button depending on the checkboxes.
@end