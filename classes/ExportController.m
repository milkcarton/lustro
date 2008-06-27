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

#import "ExportController.h"

@implementation ExportController

- (void)awakeFromNib
{
	[mainWindow setDelegate:authenticateController];
	
	// Set startup binding values for the indicators.
	[self setValue:[NSNumber numberWithInt:0] forKey:@"commaCheckBox"];
	[self setValue:[NSNumber numberWithInt:0] forKey:@"tabCheckBox"];
	[self setValue:[NSNumber numberWithInt:0] forKey:@"HTMLCheckBox"];
	[self setValue:[NSNumber numberWithInt:0] forKey:@"googleCheckBox"];
	
	// Don't disable.
	[self setValue:[NSNumber numberWithInt:0] forKey:@"disableControls"];
	
	center = [NSNotificationCenter defaultCenter];
	
	[authenticateController startKeychainSession];
	[self setExportButtonWithGoogle];
}

- (void)setExportButton
{
	if (([[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleChecked"] && authenticated) 
		|| (![[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleChecked"] && ([[NSUserDefaults standardUserDefaults] boolForKey:@"CommaChecked"] 
			|| [[NSUserDefaults standardUserDefaults] boolForKey:@"TabChecked"] 
			|| [[NSUserDefaults standardUserDefaults] boolForKey:@"HtmlChecked"]))) {
		[exportButton setEnabled:YES];
	} else {
		[exportButton setEnabled:NO];
	}
}

- (void)setExportButtonWithGoogle
{
	authenticated = [GoogleExport autenticateWithUsername:[authenticateController username] password:[authenticateController password]];
	[self setExportButton];
}

- (void)notifyAuthenticate:(BOOL)indicator
{
	if (indicator)
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GoogleChecked"];
	[self setExportButtonWithGoogle];
}

- (void)invocateFileExport
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if (commaTmp) {
		[self setValue:[NSNumber numberWithInt:1] forKey:@"commaCheckBox"];
		CommaExport *exporter = [[CommaExport alloc] init];
		exporter.showHeader = YES;
		exporter.delegate = logController;
		exporter.mainController = self;
		BOOL exportStatus = [exporter export];
		if (exportStatus == kExportSuccess) [self setValue:[NSNumber numberWithInt:2] forKey:@"commaCheckBox"];
		else if (exportStatus == kExportWarning) [self setValue:[NSNumber numberWithInt:3] forKey:@"commaCheckBox"];
		else [self setValue:[NSNumber numberWithInt:4] forKey:@"commaCheckBox"];
		[exporter release];
		exporter = nil;
	}
	
	if (tabTmp) {
		[self setValue:[NSNumber numberWithInt:1] forKey:@"tabCheckBox"];
		TabExport *exporter = [[TabExport alloc] init];
		exporter.delegate = logController;
		exporter.showHeader = YES;
		exporter.mainController = self;
		BOOL exportStatus = [exporter export];
		if (exportStatus == kExportSuccess) [self setValue:[NSNumber numberWithInt:2] forKey:@"tabCheckBox"];
		else if (exportStatus == kExportWarning) [self setValue:[NSNumber numberWithInt:3] forKey:@"tabCheckBox"];
		else [self setValue:[NSNumber numberWithInt:4] forKey:@"tabCheckBox"];
		[exporter release];
		exporter = nil;
	}
	
	if (htmlTmp) {
		[self setValue:[NSNumber numberWithInt:1] forKey:@"HTMLCheckBox"];
		HTMLExport *exporter = [[HTMLExport alloc] init];
		exporter.delegate = logController;
		exporter.mainController = self;
		BOOL exportStatus = [exporter export];
		if (exportStatus == kExportSuccess) [self setValue:[NSNumber numberWithInt:2] forKey:@"HTMLCheckBox"];
		else if (exportStatus == kExportWarning) [self setValue:[NSNumber numberWithInt:3] forKey:@"HTMLCheckBox"];
		else [self setValue:[NSNumber numberWithInt:4] forKey:@"HTMLCheckBox"];
		[exporter release];
		exporter = nil;
	}
	[pool release];
	pool = nil;
}

- (void)invocateGoogleExport
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self setValue:[NSNumber numberWithInt:1] forKey:@"googleCheckBox"];
	GoogleExport *exporter = [[GoogleExport alloc] initWithUsername:[authenticateController username] password:[authenticateController password]];
	exporter.delegate = logController;
	BOOL exportStatus = [exporter export];
	if (exportStatus == kExportSuccess) [self setValue:[NSNumber numberWithInt:2] forKey:@"googleCheckBox"];
	else if (exportStatus == kExportWarning) [self setValue:[NSNumber numberWithInt:3] forKey:@"googleCheckBox"];
	else [self setValue:[NSNumber numberWithInt:4] forKey:@"googleCheckBox"];
	[exporter release];
	exporter = nil;
	[self toggleControlsEnabled:YES];
	[pool release];
	pool = nil;
}

- (void)showWarningPanel
{
	[NSApp beginSheet:warningController.panel modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
	[warningController.panel makeKeyWindow];

}

- (NSString *)showSaveSheet:(NSString *)name extention:(NSString *)extention title:(NSString *)title
{
	NSSavePanel *savePanel = [NSSavePanel savePanel];
	[savePanel setRequiredFileType:extention];
	[savePanel setMessage:title];
	[savePanel setExtensionHidden:YES];
	NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	if ([savePanel runModalForDirectory:path file:name] == NSOKButton)
		return [savePanel filename];
	return nil;
}

- (void)continueGoogleExport
{
	[NSThread detachNewThreadSelector:@selector(invocateGoogleExport) toTarget:self withObject:nil];
}

- (void)stopGoogleExport
{
	[self toggleControlsEnabled:YES];
}

- (void)toggleControlsEnabled:(BOOL)myBool
{
	[exportButton setEnabled:myBool];
}

- (void)fileExportThreadEnded:(NSNotification *)notification
{
	if (googleTmp) {
		[center removeObserver:self];
		if ([warningController showPanel]) [self showWarningPanel];
		else [self continueGoogleExport];
	} else {
		[self toggleControlsEnabled:YES];
	}
}

- (IBAction)showLogPanel:(id)sender
{
	[NSApp beginSheet:logController.panel modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction)showAutenticationPanel:(id)sender
{
	[NSApp beginSheet:authenticateController.panel modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
	[authenticateController.panel makeKeyWindow];
}

- (IBAction)selectExport:(id)sender
{
	[self setExportButton];
}

- (IBAction)selectGoogleExport:(id)sender
{
	if ([sender state] == NSOnState) [self setExportButtonWithGoogle];
	else [self setExportButton];
}

- (IBAction)export:(id)sender
{
	[self toggleControlsEnabled:NO];
	[self setValue:[NSNumber numberWithInt:0] forKey:@"commaCheckBox"];
	[self setValue:[NSNumber numberWithInt:0] forKey:@"tabCheckBox"];
	[self setValue:[NSNumber numberWithInt:0] forKey:@"HTMLCheckBox"];
	[self setValue:[NSNumber numberWithInt:0] forKey:@"googleCheckBox"];
	
	commaTmp = [[NSUserDefaults standardUserDefaults] boolForKey:@"CommaChecked"];
	tabTmp = [[NSUserDefaults standardUserDefaults] boolForKey:@"TabChecked"];
	htmlTmp = [[NSUserDefaults standardUserDefaults] boolForKey:@"HtmlChecked"];
	googleTmp = [[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleChecked"];
	
	if (htmlTmp || tabTmp || commaTmp) {
		[center addObserver:self selector:@selector(fileExportThreadEnded:) name:NSThreadWillExitNotification object:nil];
		[NSThread detachNewThreadSelector:@selector(invocateFileExport) toTarget:self withObject:nil];
	} else {
		if (googleTmp) {
			if ([warningController showPanel]) [self showWarningPanel];
			else [self continueGoogleExport];
		}
	}
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
	if ([menuItem tag] == 1 && ![exportButton isEnabled]) { // Tag 1 is the Export menu item
		return NO;
	}
 	return YES; // Return YES here so all other menu items are displayed
}

@synthesize commaCheckBox;
@synthesize disableControls;
@synthesize tabCheckBox;
@synthesize HTMLCheckBox;
@synthesize googleCheckBox;
@synthesize authenticated;
@synthesize logController;
@synthesize authenticateController;
@synthesize mainWindow;
@synthesize authenticationButtonCell;
@synthesize exportButton;
@synthesize warningController;
@synthesize exportMenuItem;
@end
