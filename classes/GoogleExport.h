//
//  GoogleExport.h
//  lustro
//
//  Created by Simon Schoeters on 25/05/08.
//  Copyright 2008 IMEC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AddressBook/AddressBook.h>
#import "AddressBookExport.h"
#import "GData/GDataContacts.h"
#import "GData/GDataFeedGoogleBase.h"
#import "RotatingBackup.h"

@interface GoogleExport : AddressBookExport {
	@private GDataServiceGoogleContact* service;
	@private NSString *filename;
	@private NSString *username;
	@private NSString *password;
	@private NSString* first;
	@private NSString* last;
	@private NSString* nick;
	@private GDataOrganization *gOrganization;
	@private NSMutableArray *gMails;
	@private NSMutableArray *gAddresses;
	@private NSMutableArray *gPhones;
	@private NSMutableArray *gAIMs;
	@private NSMutableArray *gJabbers;
	@private NSMutableArray *gMSNs;
	@private NSMutableArray *gYahoos;
	@private NSMutableArray *gICQs;
	@private GDataEntryContent *gContent;
	@private GDataServiceTicket *ticket;
	@private NSMutableArray *collectedMails; // Appendable array to check if an e-mail address was used before (Google can't handle duplicate e-mails)
	@private BOOL alert;
}

#pragma mark -

+ (BOOL)autenticateWithUsername:(NSString *)user password:(NSString *)pass;	// Returns YES if the username and password are correct, NO if not
+ (NSString *)makeRelFromLabel:(NSString *)label;							// Returns the Google key for a given label

#pragma mark -

- (id)initWithUsername:(NSString *)user password:(NSString *)pass;			// Creates a new GoogleExport instance
- (BOOL)backupAllContacts;													// Gets and saves the current Google Contacts feed XML to disk
- (BOOL)removeAllContacts;													// Remove all current Google Contacts to begin with a blank sheet
- (BOOL)isEmailUnique:(NSString *)refMail;									// Returns true if this e-mail address is unique for all uploads so far

@end
