//
//  HTMLExport.h
//  lustro
//
//  Created by Jelle Vandebeeck on 25/05/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FileExport.h"

@interface HTMLExport : FileExport {
	NSString *fnName;
	NSString *org;
}

- (NSString *)addSpanWithValue:(NSString *)value class:(NSString *)class;							// Add <span class="[class]">[value]</span>
- (NSString *)addAbbrWithValue:(NSString *)value class:(NSString *)class title:(NSString *)title;	// Add <span class="[class]" title="[title]">[value]</span>
- (NSString *)addSpanWithOrganization:(NSString *)organization department:(NSString *)department;	// Add <span class="org">...</span>
- (NSString *)addEmails:(ABMultiValue *)emails;														// Adds the emails to the string.
- (NSString *)addPhones:(ABMultiValue *)phones;														// Adds the phones to the string.
- (NSString *)addURLs:(ABMultiValue *)URLs;															// Adds the URL's to the string.
- (NSString *)addAddresses:(ABMultiValue *)addresses;												// Adds the addresses to the string.

@end
