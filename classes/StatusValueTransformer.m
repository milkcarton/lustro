//
//  StatusValueTransformer.m
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 26/04/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import "StatusValueTransformer.h"

@implementation StatusValueTransformer
//
// Handles the different transformation.
//
// Different values for indicator:
//		- 0: idle
//		- 1: running
//		- 2: success
//		- 3: warning
//		- 4: failed
//
- (id)transformedValue:(NSString *)indicator
{
	if ([indicator compare:@"2"] == NSOrderedSame) {
		return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"success.tif"];
	} else if ([indicator compare:@"3"] == NSOrderedSame) {
		return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"warning.tif"];
	} else if ([indicator compare:@"4"] == NSOrderedSame) {
		return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"error.tif"];
	}
	return nil;
}
@end
