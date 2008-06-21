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

#import "FileExport.h"

@implementation FileExport

- (BOOL)initialize
{
	ABPerson *me = [addressBook me];													// Initialize the filename.
	// Does the 'me' exists in address book.
	if (me) {
		name = @"";
		NSString *firstName = [me valueForProperty:kABFirstNameProperty];
		NSString *lastName = [me valueForProperty:kABLastNameProperty];
		if (firstName) name = [name stringByAppendingString:firstName];
		if (lastName) {
			if (firstName) name = [name stringByAppendingString:@" "];
			name = [name stringByAppendingString:lastName];
		}
		if (firstName || lastName) name = [name stringByAppendingString:@"'s "];
		name = [name stringByAppendingString:@"contacts"];
	} else {
		name = @"contacts";
	}
	if ([mainController respondsToSelector:@selector(showSaveSheet:extention:title:)]) {
		filename = [mainController showSaveSheet:name extention:[self extention] title:[self title]];
		if (!filename) {
			return NO;
		}
	} else 
		filename = [[[[@"~/Documents/" stringByAppendingString:name] stringByAppendingString:@"."] stringByAppendingString:[self extention]] stringByStandardizingPath];
	
	arrayContent = [NSMutableArray array];
	return YES;
}

- (BOOL)finalize
{
	// Sorting the array
	NSSortDescriptor *lastDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"LAST" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSSortDescriptor *firstDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"FIRST" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSSortDescriptor *orgDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"ORG" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSArray *descriptors = [NSArray arrayWithObjects:lastDescriptor, firstDescriptor, orgDescriptor, nil];
	NSArray *sortedArray = [arrayContent sortedArrayUsingDescriptors:descriptors];
	
	for (NSDictionary *dictionary in sortedArray) {
		content = [content stringByAppendingString:[dictionary objectForKey:@"CONTENT"]];
	}
	
	
	// Check if content is filled.
	if ([content length] > 0) {
		NSError *error;
		BOOL written =  [content writeToFile:filename atomically:YES encoding:NSUTF8StringEncoding error:&error];
		if (!written && error) {
			[super addErrorMessage:[error localizedDescription]];
			return NO;
		}
		return written;
	} else [super addErrorMessage:@"There was no content available to write the file."];
	return NO;
}

- (NSString *)title
{
	return @"Save";
}

@synthesize name;
@synthesize content;
@synthesize arrayContent;
@synthesize mainController;
@end