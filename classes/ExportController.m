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
	[mainWindow setDelegate:authentiacateController];
	
	// Set startup binding values for the indicators.
	[self setValue:[NSNumber numberWithInt:0] forKey:@"commaCheckBox"];
	[self setValue:[NSNumber numberWithInt:1] forKey:@"tabCheckBox"];
	[self setValue:[NSNumber numberWithInt:3] forKey:@"HTMLCheckBox"];
	[self setValue:[NSNumber numberWithInt:4] forKey:@"googleCheckBox"];
	// Set startup binding values for the authentication button.
	[self setValue:[NSNumber numberWithInt:0] forKey:@"authenticatedButton"];
}

- (IBAction)showLogPanel:(id)sender
{
	[NSApp beginSheet:logController.panel modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction)showAutenticationPanel:(id)sender
{
	[NSApp beginSheet:authentiacateController.panel modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction)selectExport:(id)sender
{
}

- (IBAction)selectGoogle:(id)sender
{
}

- (IBAction)export:(id)sender
{
}

- (IBAction)openHelp:(id)sender
{
}

@end
