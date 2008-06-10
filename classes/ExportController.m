//
//  ExportController.m
//  lustro
//
//  Created by Simon Schoeters on 09/06/08.
//  Copyright 2008 IMEC. All rights reserved.
//

#import "ExportController.h"


@implementation ExportController

- (void)awakeFromNib
{
	[mainWindow setDelegate:authentiacateController];
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
