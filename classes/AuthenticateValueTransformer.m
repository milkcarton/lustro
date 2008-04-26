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
//		- 2: success	==> OFF
//		- 3: warning	==> OFF
//		- 4: failed		==> OFF
//
- (id)transformedValue:(NSString *)indicator
{
	if ([indicator compare:@"0"] == NSOrderedSame) {
		return @"NO";
	}
	return @"YES";
}
@end
