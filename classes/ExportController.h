//
//  ExportController.h
//  lustro
//
//  Created by Simon Schoeters on 09/06/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LogController.h"
#import "AuthenticateController.h"
#import "IndicatorValueTransformer.h"

@interface ExportController : NSObject {
	@private int commaCheckBox;					// Used for binding the comma checkbox's indicator.
	@private int tabCheckBox;					// Used for binding the tab checkbox's indicator.
	@private int HTMLCheckBox;					// Used for binding the HTML checkbox's indicator.
	@private int googleCheckBox;				// Used for binding the Google checkbox's indicator.
	@private int authenticatedButton;			// Used for binding the Google authentication button's indicator.
	
	IBOutlet LogController *logController;
	IBOutlet AuthenticateController *authentiacateController;
	IBOutlet id mainWindow;
}

- (IBAction)showLogPanel:(id)sender;			// Opens the log panel
- (IBAction)showAutenticationPanel:(id)sender;	// Opens the Google authentication panel
- (IBAction)selectExport:(id)sender;			// Check if the export button needs to be enabled
- (IBAction)selectGoogle:(id)sender;			// Google is authenticated and selected
- (IBAction)export:(id)sender;					// Start exporting the Address Book contacts
- (IBAction)openHelp:(id)sender;				// Open the help files from the menu

@end
