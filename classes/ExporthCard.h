//
//  ExporthCard.h
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 21/04/08.
//  Copyright 2008 eggnog. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ExportController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABPerson.h>

@interface ExporthCard : ExportController {
	NSString *hCardTemplate;
}

- (NSString *)addHTMLEntity:(NSString *)value withKey:(NSString *)key;
- (NSString *)addHTMLEntity:(NSString *)value withKey:(NSString *)key withTitle:(NSString *)title;
- (NSString *)addPhone:(ABMultiValue *)phones forIndex:(int)index;
- (NSString *)addAddress:(ABMultiValue *)addresses forIndex:(int)index;
- (NSString *)addMails:(ABMultiValue *)mails;
- (NSString *)addURLs:(ABMultiValue *)URLs;
- (NSString *)cleanLabel:(NSString *)label;

@end
