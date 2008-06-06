//
//  FileExport.h
//  lustro
//
//  Created by Jelle Vandebeeck on 23/05/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AddressBook/AddressBook.h>
#import "AddressBookExport.h"

@interface FileExport : AddressBookExport {
	@protected NSString *name;			// The dir + name of the file.
	@protected NSString *content;		// The content that needs to be written to the file.
}
@property (retain) NSString *name;
@property (retain, readwrite) NSString *content;
@end

#pragma mark -

@interface FileExport (AbstractMethods)
- (NSString *)extention;				// Returns the extention of the file.
@end