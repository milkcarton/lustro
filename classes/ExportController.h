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
#import <Carbon/Carbon.h>
#import "LogController.h"
#import "AuthenticateController.h"
#import "WarningController.h"
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
	@private BOOL authenticated;				// Used to check if authentication is successful.
	@private int disableControls;				// Used to disable controls when exporting.
	@private NSNotificationCenter *center;
	
	// Temporary export variables.
	@private BOOL commaTmp;
	@private BOOL tabTmp;
	@private BOOL htmlTmp;
	@private BOOL googleTmp;
	
	IBOutlet LogController *logController;
	IBOutlet AuthenticateController *authenticateController;
	IBOutlet WarningController *warningController;
	IBOutlet id mainWindow;
	IBOutlet id authenticationButtonCell;
	IBOutlet id exportButton;
	IBOutlet NSMenuItem *exportMenuItem;
}

- (void)setExportButton;							// Enables or disables the exportbutton.
- (void)setExportButtonWithGoogle;					// Enables or disables the exportbutton when google selected.
- (void)notifyAuthenticate:(BOOL)indicator;			// Called when sign in or cancel is clicked.
- (void)invocateFileExport;							// Needed to run the file export in a Thread.
- (void)invocateGoogleExport;						// Needed to run the google export in a Thread.
- (void)showWarningPanel;							// Opens the Google warning panel.
- (NSString *)showSaveSheet:(NSString *)name extention:(NSString *)extention title:(NSString *)title;		// Opens the file save sheet and returns the filename + dir.
- (void)continueGoogleExport;						// Run the Google exporter.
- (void)stopGoogleExport;							// Stop the Google exporter.
- (void)toggleControlsEnabled:(BOOL)myBool;			// Toggle the controls on and off.
- (void)fileExportThreadEnded:(NSNotification *)notification;	// Handle the exit fileexport thread.

- (IBAction)showLogPanel:(id)sender;				// Opens the log panel.
- (IBAction)showAutenticationPanel:(id)sender;		// Opens the Google authentication panel.
- (IBAction)selectExport:(id)sender;				// Check if the export button needs to be enabled.
- (IBAction)selectGoogleExport:(id)sender;			// Check if the export button needs to be enabled when selecting Google export.
- (IBAction)export:(id)sender;						// Start exporting the Address Book contacts.
- (IBAction)openHelp:(id)sender;					// Open the help files from the menu.

@property int commaCheckBox;
@property int tabCheckBox;
@property int HTMLCheckBox;
@property int googleCheckBox;
@property BOOL authenticated;
@property int disableControls;
@property (retain) LogController *logController;
@property (retain) AuthenticateController *authenticateController;
@property (retain) WarningController *warningController;
@property (retain) id mainWindow;
@property (retain) id authenticationButtonCell;
@property (retain) id exportButton;
@property (retain) NSMenuItem *exportMenuItem;
@end