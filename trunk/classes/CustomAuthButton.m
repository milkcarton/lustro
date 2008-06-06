//
//  CustomAuthButton.m
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 27/04/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import "CustomAuthButton.h"

@implementation CustomAuthButton
- (void)mouseEntered:(NSEvent *)event
{
	[self setImage:[NSImage imageNamed:@"lockHover.tif"]];
}

- (void)mouseExited:(NSEvent *)event
{
	[self setImage:[NSImage imageNamed:@"lock.tif"]];
}

- (BOOL)showsBorderOnlyWhileMouseInside
{
	return YES;
}
@end
