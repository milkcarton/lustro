//
//  ExportSeparatedFile.h
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 16/05/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABPerson.h>
#import "ExportController.h"

@interface ExportSeparatedFile : ExportController {
	NSString *userName;
	NSString *separator;
	NSString *extention;
}
- (id)initWithAddressBook:(ABAddressBook *)addressBook target:(id)errorCtrl separator:(NSString *)separatorItem extention:(NSString *)extentionItem;
- (id)initWithAddressBook:(ABAddressBook *)addressBook target:(id)errorCtrl;
- (BOOL)writeToFileWithText:(NSString *)text;
- (NSString *)addEntity:(NSString *)value;
- (NSString *)addAddress:(ABMultiValue *)addresses forIndex:(int)index;
- (NSString *)addMails:(ABMultiValue *)mails;
- (NSString *)addURLs:(ABMultiValue *)URLs;
- (NSString *)addOrganizationWithName:(NSString *)name unit:(NSString *)unit;
@end