//
//  AuthenticateController.m
//  lustro
//
//  Created by Simon Schoeters on 09/06/08.
//  Copyright 2008 IMEC. All rights reserved.
//

#import "AuthenticateController.h"


@implementation AuthenticateController

- (IBAction)closeLogPanel:(id)sender
{
	[panel orderOut:nil];
	[NSApp endSheet:panel];
}

@synthesize panel;
@end
