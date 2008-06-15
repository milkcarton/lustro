//
//  CustomMainWindow.m
//  lustro
//
//  Created by Jelle Vandebeeck on 15/06/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import "CustomMainWindow.h"

@implementation CustomMainWindow

- (void)close
{
	[[NSApplication sharedApplication] terminate:nil];
}

@end