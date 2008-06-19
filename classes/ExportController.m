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

- (void)notifyAuthenticate
{
	[self setExportButtonWithGoogle];
}

- (void)invocateExport
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"CommaChecked"]) {
		[self setValue:[NSNumber numberWithInt:1] forKey:@"commaCheckBox"];
		CommaExport *exporter = [[CommaExport alloc] init];
		exporter.delegate = logController;
		if ([exporter export] == kExportSuccess) [self setValue:[NSNumber numberWithInt:2] forKey:@"commaCheckBox"];
		else if ([exporter export] == kExportWarning) [self setValue:[NSNumber numberWithInt:3] forKey:@"commaCheckBox"];
		else [self setValue:[NSNumber numberWithInt:4] forKey:@"commaCheckBox"];
		[exporter release];
		exporter = nil;
	}
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TabChecked"]) {
		[self setValue:[NSNumber numberWithInt:1] forKey:@"tabCheckBox"];
		TabExport *exporter = [[TabExport alloc] init];
		exporter.delegate = logController;
		if ([exporter export] == kExportSuccess) [self setValue:[NSNumber numberWithInt:2] forKey:@"tabCheckBox"];
		else if ([exporter export] == kExportWarning) [self setValue:[NSNumber numberWithInt:3] forKey:@"tabCheckBox"];
		else [self setValue:[NSNumber numberWithInt:4] forKey:@"tabCheckBox"];
		[exporter release];
		exporter = nil;
	}
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HtmlChecked"]) {
		[self setValue:[NSNumber numberWithInt:1] forKey:@"HTMLCheckBox"];
		HTMLExport *exporter = [[HTMLExport alloc] init];
		exporter.delegate = logController;
		if ([exporter export] == kExportSuccess) [self setValue:[NSNumber numberWithInt:2] forKey:@"HTMLCheckBox"];
		else if ([exporter export] == kExportWarning) [self setValue:[NSNumber numberWithInt:3] forKey:@"HTMLCheckBox"];
		else [self setValue:[NSNumber numberWithInt:4] forKey:@"HTMLCheckBox"];
		[exporter release];
		exporter = nil;
	}
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleChecked"]) {
		// Check if warning for google export needs to be shown.
// TODO: Warning sheet triggers error
//		if (([[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleExportWarning"] && ![[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleExportWarningIndicator"]) || ![[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleExportWarning"])
//			[self showWarningPanel];
//		else {
			// Check if default value is OK or cancel.
//			if ([[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleExportWarningIndicator"])
				[self exportGoogle];
//		}
	}
	[pool release];
	pool = nil;
}

- (void)showWarningPanel
{
	[NSApp beginSheet:warningPanel modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (void)exportGoogle
{
	[self setValue:[NSNumber numberWithInt:1] forKey:@"googleCheckBox"];
	GoogleExport *exporter = [[GoogleExport alloc] initWithUsername:[authenticateController username] password:[authenticateController password]];
	exporter.delegate = logController;
	BOOL exportStatus = [exporter export];
	if (exportStatus == kExportSuccess) [self setValue:[NSNumber numberWithInt:2] forKey:@"googleCheckBox"];
	else if (exportStatus == kExportWarning) [self setValue:[NSNumber numberWithInt:3] forKey:@"googleCheckBox"];
	else [self setValue:[NSNumber numberWithInt:4] forKey:@"googleCheckBox"];
	[exporter release];
	exporter = nil;
}

- (IBAction)showLogPanel:(id)sender
{
	[NSApp beginSheet:logController.panel modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction)showAutenticationPanel:(id)sender
{
	[NSApp beginSheet:authenticateController.panel modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
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
	[self setValue:[NSNumber numberWithInt:0] forKey:@"commaCheckBox"];
	[self setValue:[NSNumber numberWithInt:0] forKey:@"tabCheckBox"];
	[self setValue:[NSNumber numberWithInt:0] forKey:@"HTMLCheckBox"];
	[self setValue:[NSNumber numberWithInt:0] forKey:@"googleCheckBox"];
	[self performSelectorInBackground:@selector(invocateExport) withObject:nil];
}

- (IBAction)openHelp:(id)sender
{
	CFBundleRef myApplicationBundle = CFBundleGetMainBundle();
    CFStringRef myBookName = CFBundleGetValueForInfoDictionaryKey(myApplicationBundle, CFSTR("CFBundleHelpBookName"));
    AHGotoPage(myBookName, CFSTR("index.html"), NULL);
}

- (IBAction)pressButton:(id)sender
{
	[warningPanel orderOut:nil];
	[NSApp endSheet:warningPanel];
	// If OK is pressed.
	if ([[sender title] compare:@"OK"] == NSOrderedSame) {
		[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:@"GoogleExportWarningIndicator"];
		[self exportGoogle];
	} else {
		[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"GoogleExportWarningIndicator"];
		[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"GoogleChecked"];
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
@synthesize tabCheckBox;
@synthesize HTMLCheckBox;
@synthesize googleCheckBox;
@synthesize authenticated;
@synthesize logController;
@synthesize authenticateController;
@synthesize mainWindow;
@synthesize authenticationButtonCell;
@synthesize exportButton;
@synthesize warningPanel;
@end
