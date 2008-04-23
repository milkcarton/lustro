//
//  ExportGoogle.h
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 22/04/08.
//  Copyright 2008 eggnog. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABPerson.h>
#import "ExportController.h"
#import "ExportProtocol.h"
#import "GData/GDataContacts.h"

@interface ExportGoogle : ExportController < ExportProtocol > {
	GDataServiceGoogleContact* service;
	NSString *username;
	NSString *password;
}

- (void)export;
- (void)authenticateWithUsername:(NSString *)user password:(NSString *)pass;
- (void)createGDataContacts;
- (NSURL *)getURL;

- (void)ticket:(GDataServiceTicketBase *)ticket failedWithError:(NSError *)error;

@end
