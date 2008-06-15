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
	
	[self setExportButton];
}

- (void)setExportButton
{
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleChecked"] || ([[NSUserDefaults standardUserDefaults] boolForKey:@"CommaChecked"] || [[NSUserDefaults standardUserDefaults] boolForKey:@"TabChecked"] || [[NSUserDefaults standardUserDefaults] boolForKey:@"HtmlChecked"])) {
		[exportButton setEnabled:YES];
	} else {
		[exportButton setEnabled:NO];
	}
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
	[self setExportButton];
}

- (IBAction)export:(id)sender
{
}

- (IBAction)openHelp:(id)sender
{
	CFBundleRef myApplicationBundle = CFBundleGetMainBundle();
    CFStringRef myBookName = CFBundleGetValueForInfoDictionaryKey(myApplicationBundle, CFSTR("CFBundleHelpBookName"));
    AHGotoPage(myBookName, CFSTR("index.html"), NULL);
}

@end
