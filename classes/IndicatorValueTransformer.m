/*
 Copyright (c) 2008 Jelle Vandebeeck, Simon Schoeters
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 Created by Jelle Vandebeeck on 2008.04.26.
*/

#import "IndicatorValueTransformer.h"

@implementation IndicatorValueTransformer

/* 
 Handles the different transformation. Different values for indicator:
- 0: idle (show nothing)
- 1: running
- 2: success
- 3: warning
- 4: failed
*/

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
