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
}

- (IBAction)export:(id)sender
{
}

- (IBAction)openHelp:(id)sender
{
}

@end
