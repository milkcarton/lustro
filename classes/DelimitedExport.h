//
//  DelimitedExport.h
//  lustro
//
//  Created by Jelle Vandebeeck on 23/05/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FileExport.h"

@interface DelimitedExport : FileExport {
	BOOL showHeader;						// If true a header is shown in the file.
}

- (NSString *)delimiter;								// Returns the delimiter used.
- (void)addText:(NSString *)text;						// Adds the text to the content.
- (void)addContainer:(ABMultiValue *)container;			// Loops the container and adds the content.
- (void)addArray:(NSArray *)array;						// Loops the array and adds the content.
- (void)printHeader;									// Print the header.

@property BOOL showHeader;
@end
