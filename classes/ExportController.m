//
//  ExportController.m
//  lustro
//
//  Created by Simon Schoeters on 09/06/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

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
		AddressBookExport *exporter = [[CommaExport alloc] init];
		exporter.delegate = logController;
		if ([exporter export] == kExportSuccess) [self setValue:[NSNumber numberWithInt:2] forKey:@"commaCheckBox"];
		else if ([exporter export] == kExportWarning) [self setValue:[NSNumber numberWithInt:3] forKey:@"commaCheckBox"];
		else [self setValue:[NSNumber numberWithInt:4] forKey:@"commaCheckBox"];
		[exporter release];
		exporter = nil;
	}
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TabChecked"]) {
		[self setValue:[NSNumber numberWithInt:1] forKey:@"tabCheckBox"];
		AddressBookExport *exporter = [[TabExport alloc] init];
		exporter.delegate = logController;
		if ([exporter export] == kExportSuccess) [self setValue:[NSNumber numberWithInt:2] forKey:@"tabCheckBox"];
		else if ([exporter export] == kExportWarning) [self setValue:[NSNumber numberWithInt:3] forKey:@"tabCheckBox"];
		else [self setValue:[NSNumber numberWithInt:4] forKey:@"tabCheckBox"];
		[exporter release];
		exporter = nil;
	}
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HtmlChecked"]) {
		[self setValue:[NSNumber numberWithInt:1] forKey:@"HTMLCheckBox"];
		AddressBookExport *exporter = [[HTMLExport alloc] init];
		exporter.delegate = logController;
		if ([exporter export] == kExportSuccess) [self setValue:[NSNumber numberWithInt:2] forKey:@"HTMLCheckBox"];
		else if ([exporter export] == kExportWarning) [self setValue:[NSNumber numberWithInt:3] forKey:@"HTMLCheckBox"];
		else [self setValue:[NSNumber numberWithInt:4] forKey:@"HTMLCheckBox"];
		[exporter release];
		exporter = nil;
	}
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleChecked"]) {
		// Check if warning for google export needs to be shown.
		if (([[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleExportWarning"] && ![[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleExportWarningIndicator"]) || ![[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleExportWarning"])
			[self showWarningPanel];
		else {
			// Check if default value is OK or cancel.
			if ([[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleExportWarningIndicator"])
				[self exportGoogle];
		}
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
	AddressBookExport *exporter = [[GoogleExport alloc] initWithUsername:[authenticateController username] password:[authenticateController password]];
	exporter.delegate = logController;
	if ([exporter export] == kExportSuccess) [self setValue:[NSNumber numberWithInt:2] forKey:@"googleCheckBox"];
	else if ([exporter export] == kExportWarning) [self setValue:[NSNumber numberWithInt:3] forKey:@"googleCheckBox"];
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

@end
