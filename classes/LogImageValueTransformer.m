//
//  LogImageValueTransformer.m
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 16/05/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import "LogImageValueTransformer.h"

@implementation LogImageValueTransformer
//
// Handles the different transformation.
//
// Different values for indicator:
//		- 0: success
//		- 1: warning
//		- 2: failed
//
- (id)transformedValue:(NSString *)indicator
{
	if ([indicator compare:@"0"] == NSOrderedSame) {
		return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"success.tif"];
	} else if ([indicator compare:@"1"] == NSOrderedSame) {
		return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"warning.tif"];
	} else if ([indicator compare:@"2"] == NSOrderedSame) {
		return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"error.tif"];
	}
	return nil;
}
@end
