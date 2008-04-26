//
//  AuthenticateValueTransformer.m
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 26/04/08.
//  Copyright 2008 eggnog. All rights reserved.
//

#import "AuthenticateValueTransformer.h"

@implementation AuthenticateValueTransformer
//
// Handles the different transformation.
//
// Different values for indicator:
//		- 0: idle		==> ON
//		- 1: running	==> OFF
//		- 2: success	==> ON
//		- 3: warning	==> ON
//		- 4: failed		==> ON
//
- (id)transformedValue:(NSString *)indicator
{
	if ([indicator compare:@"1"] == NSOrderedSame) {
		return @"YES";
	}
	return @"NO";
}
@end
