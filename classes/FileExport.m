//
//  FileExport.m
//  lustro
//
//  Created by Jelle Vandebeeck on 23/05/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

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
		name = [@"~/Desktop/" stringByAppendingString:name];
		name = [name stringByAppendingString:[self extention]];
		name = [name stringByStandardizingPath];
	} else {
		name = [@"~/Desktop/contacts" stringByAppendingString:[self extention]];
		name = [name stringByStandardizingPath];
	}
	
	return YES;
}

- (BOOL)finalize
{
	// Check if content is filled.
	if ([content length] > 0) {
		NSError *error;
		BOOL written =  [content writeToFile:name atomically:YES encoding:NSUTF8StringEncoding error:&error];
		if (!written && error) {
			[super addErrorMessage:[error localizedDescription]];
			return NO;
		}
		return written;
	} else [super addErrorMessage:@"There was no content available to write the file."];
	return NO;
}

@synthesize name;
@synthesize content;
@end