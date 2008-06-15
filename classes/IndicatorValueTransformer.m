//
//  IndicatorValueTransformer.m
//  lustro
//
//  Created by Jelle Vandebeeck on 26/04/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import "IndicatorValueTransformer.h"

@implementation IndicatorValueTransformer
//
// Handles the different transformation.
//
// Different values for indicator:
//		- 0: idle (show nothing)
//		- 1: running
//		- 2: success
//		- 3: warning
//		- 4: failed
//
- (id)transformedValue:(NSNumber *)indicator
{
	if ([indicator compare:[NSNumber numberWithInt:2]] == NSOrderedSame) {
		return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"success.tif"];
	} else if ([indicator compare:[NSNumber numberWithInt:3]] == NSOrderedSame) {
		return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"warning.tif"];
	} else if ([indicator compare:[NSNumber numberWithInt:4]] == NSOrderedSame) {
		return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"error.tif"];
	}
	return nil;
}
@end
