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
#import <AddressBook/AddressBook.h>
#import "AddressBookExport.h"

@interface FileExport : AddressBookExport {
	@protected NSString *name;					// The dir + name of the file.
	@protected NSString *content;				// The content that needs to be written to the file.
	@protected NSMutableArray *arrayContent;	// The content that needs to be sorted and written to the file.
	@protected NSString *lastNameTemp;			// Temporary store of firstname object.
	@protected NSString *firstNameTemp;			// Temporary store of lastname object.
	@protected NSString *organisationTemp;		// Temporary store of organisation object.
	@protected NSString *lineTemp;				// Temporary store of line object.
	@protected NSString *filename;				// Name of the file.
	id mainController;							// Used when ou want to display a save dialog.
}

- (NSString *)title;

@property (retain, readwrite) NSString *name;
@property (retain, readwrite) NSString *content;
@property (retain, readwrite) NSMutableArray *arrayContent;
@property (retain, readwrite) id mainController;
@end

#pragma mark -

@interface FileExport (AbstractMethods)
- (NSString *)extention;				// Returns the extention of the file.
@end