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
 
 Created by Jelle Vandebeeck on 2008.05.23.
*/

#import <Cocoa/Cocoa.h>
#import "FileExport.h"

@interface HTMLExport : FileExport {
	NSString *fnName;
	NSString *org;
	NSMutableDictionary *details;
	/*	First add all details to the array to sort them in the finalizePerson method.
		index O: initialize div and firstName			index 7: addresses
		index 1: lastName								index 8: phones
		index 2: birthday								index 9: note
		index 3: organization							index 10: middleName
		index 4: jobTitle								index 11: suffix
		index 5: URLs									index 12: nickname
		index 6: e-mails								index 13: finalize div
	 */
}

- (NSString *)addSpanWithValue:(NSString *)value class:(NSString *)class;							// Add <span class="[class]">[value]</span>
- (NSString *)addAbbrWithValue:(NSString *)value class:(NSString *)class title:(NSString *)title;	// Add <span class="[class]" title="[title]">[value]</span>
- (NSString *)addSpanWithOrganization:(NSString *)organization department:(NSString *)department;	// Add <span class="org">...</span>
- (NSString *)addEmails:(ABMultiValue *)emails;														// Adds the emails to the string.
- (NSString *)addPhones:(ABMultiValue *)phones;														// Adds the phones to the string.
- (NSString *)addURLs:(ABMultiValue *)URLs;															// Adds the URL's to the string.
- (NSString *)addAddresses:(ABMultiValue *)addresses;												// Adds the addresses to the string.

@property (retain) NSString *fnName;
@property (retain) NSString *org;
@end
