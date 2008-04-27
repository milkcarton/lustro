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
#import "ExportController.h"
#import "ExporthCard.h"
#import "ExportGoogle.h"
#import "AGKeychain.h"

@interface MainController : NSObject {
	NSMutableDictionary *indicators;
	NSUserDefaults *defaults;

	IBOutlet id authSheet;			// The authentication sheet.
	IBOutlet id window;				// The main Lustro window.
	IBOutlet id usernameField;		// The username textfield from the auth sheet.
	IBOutlet id passwordField;		// The password textfield from the auth sheet.
}
// Returns the indicators dictionary.
- (NSMutableDictionary *)indicators;

// Called when the export button is pressed.
- (IBAction)export:(id)sender;

// Called when the authenticate button is pressed.
- (IBAction)authenticate:(id)sender;

// Closes the sheet without any savings.
- (IBAction)closeSheet:(id)sender;

// Show the authentication sheet.
- (IBAction)callSheet:(id)sender;

// Method that is called in the background.
- (void)invocateExport;
@end