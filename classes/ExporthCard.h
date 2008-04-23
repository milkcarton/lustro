//
//  ExporthCard.h
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 21/04/08.
//  Copyright 2008 eggnog. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABPerson.h>
#import "ExportController.h"

@interface ExporthCard : ExportController < ExportProtocol > {
	NSString *hCardTemplate;
}

- (void)export;
- (void)writeToFileWithHtml:(NSString *)html;
- (NSString *)addHTMLEntity:(NSString *)value withKey:(NSString *)key;
- (NSString *)addHTMLEntity:(NSString *)value withKey:(NSString *)key withTitle:(NSString *)title;
- (NSString *)addPhone:(ABMultiValue *)phones forIndex:(int)index;
- (NSString *)addAddress:(ABMultiValue *)addresses forIndex:(int)index;
- (NSString *)addMails:(ABMultiValue *)mails;
- (NSString *)addURLs:(ABMultiValue *)URLs;
- (NSString *)addOrganizationWithName:(NSString *)name unit:(NSString *)unit;

@end
