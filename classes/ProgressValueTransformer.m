//
//  ProgressValueTransformer.m
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 26/04/08.
//  Copyright 2008 eggnog. All rights reserved.
//

#import "ProgressValueTransformer.h"

@implementation ProgressValueTransformer
//
// Handles the different transformation.
//
// Different values for indicator:
//		- 0: idle		==> OFF
//		- 1: running	==> ON
//		- 2: success	==> OFF
//		- 3: warning	==> OFF
//		- 4: failed		==> OFF
//
- (id)transformedValue:(NSString *)indicator
{
	if ([indicator compare:@"1"] == NSOrderedSame) {
		return @"YES";
	}
	return @"NO";
}
@end