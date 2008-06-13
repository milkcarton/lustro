//
//  LockImageValueTransformer.m
//  lustro
//
//  Created by Jelle Vandebeeck on 13/06/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import "LockImageValueTransformer.h"

@implementation LockImageValueTransformer
//
// Handles the different authentication icons.
//
- (id)transformedValue:(NSNumber *)indicator
{
	if ([indicator compare:[NSNumber numberWithInt:0]] == NSOrderedSame) 
		return [[NSImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"lock.tif"]];
	return [[NSImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"unlock.tif"]];
}
@end
