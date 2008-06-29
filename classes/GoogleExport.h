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
 
 Created by Simon Schoeters on 2008.05.08.
*/

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

@property (retain) GDataServiceGoogleContact* service;
@property (retain) NSString *filename;
@property (retain) NSString *username;
@property (retain) NSString *password;
@property (retain) NSString* first;
@property (retain) NSString* last;
@property (retain) NSString* nick;
@property (retain) GDataOrganization *gOrganization;
@property (retain) NSMutableArray *gMails;
@property (retain) NSMutableArray *gAddresses;
@property (retain) NSMutableArray *gPhones;
@property (retain) NSMutableArray *gAIMs;
@property (retain) NSMutableArray *gJabbers;
@property (retain) NSMutableArray *gMSNs;
@property (retain) NSMutableArray *gYahoos;
@property (retain) NSMutableArray *gICQs;
@property (retain) GDataEntryContent *gContent;
@property (retain) GDataServiceTicket *ticket;
@property (retain) NSMutableArray *collectedMails;
@property BOOL alert;
@end
