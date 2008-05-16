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
}

- (id)initWithAddressBook:(ABAddressBook *)addressBook target:(id)errorCtrl;
- (NSString *)cleanLabel:(NSString *)label;
- (void)addSuccessMessage:(NSString *)successMsg;
- (void)addFailedMessage:(NSString *)failedMsg;
- (void)addErrorMessage:(NSString *)errorMsg;

@property (copy, readwrite) NSString *message;
@property (retain) NSArray *contactsList;
@property (retain) id target;
@end
