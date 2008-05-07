//
//  ExportController.h
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 21/04/08.
//  Copyright 2008 eggnog. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AddressBook/AddressBook.h>
#import "ExportProtocol.h"

typedef enum {
	kExportSuccess = 0,
	kExportWarning = 1,
	kExportError = 2
} kExportStatus;

@interface ExportController : NSOperation {
	NSArray *contactsList;
	NSString *message;
	id target;
	SEL addMessage;
}

- (id)initWithAddressBook:(ABAddressBook *)addressBook target:(id)errorCtrl selector:(SEL)msg;
- (NSString *)cleanLabel:(NSString *)label;
- (void)addError:(NSString *)errorMsg;

@property (copy, readwrite) NSString *message;
@end
