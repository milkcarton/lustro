//
//  ExportController.h
//  lustro
//
//  Created by Simon Schoeters on 09/06/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import "LogController.h"
#import "AuthenticateController.h"
#import "IndicatorValueTransformer.h"
#import "AddressBookExport.h"
#import "HTMLExport.h"
#import "TabExport.h"
#import "CommaExport.h"
#import "GoogleExport.h"

@interface ExportController : NSObject {
	@private int commaCheckBox;					// Used for binding the comma checkbox's indicator.
	@private int tabCheckBox;					// Used for binding the tab checkbox's indicator.
	@private int HTMLCheckBox;					// Used for binding the HTML checkbox's indicator.
	@private int googleCheckBox;				// Used for binding the Google checkbox's indicator.
	@private BOOL authenticatedButton;			// Used for binding the Google authentication button's indicator.
	
	IBOutlet LogController *logController;
	IBOutlet AuthenticateController *authenticateController;
	IBOutlet id mainWindow;
	IBOutlet id authenticationButtonCell;
	IBOutlet id exportButton;
}

- (void)setExportButton;							// Enables or disables the exportbutton.
- (void)notifyAuthenticate;							// Called when sign in or cancel is clicked.
- (void)invocateExport;								// Needed to run the export in a Thread.

- (IBAction)showLogPanel:(id)sender;				// Opens the log panel.
- (IBAction)showAutenticationPanel:(id)sender;		// Opens the Google authentication panel.
- (IBAction)selectExport:(id)sender;				// Check if the export button needs to be enabled.
- (IBAction)selectGoogleExport:(id)sender;			// Check if the export button needs to be enabled when selecting Google export.
- (IBAction)export:(id)sender;						// Start exporting the Address Book contacts.
- (IBAction)openHelp:(id)sender;					// Open the help files from the menu.

@end