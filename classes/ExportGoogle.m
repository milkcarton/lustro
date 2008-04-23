//
//  ExportGoogle.m
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 22/04/08.
//  Copyright 2008 eggnog. All rights reserved.
//

#import "ExportGoogle.h"

@implementation ExportGoogle

//
//
- (id)initWithContacts:(NSArray *)contacts 
{
	self = [super initWithContacts:contacts];
	contactsList = contacts;
	return self;
}

//
//
- (void)export
{
	if ([contactsList count] > 0) {
		[self authenticateWithUsername:@"lustroapp@gmail.com" password:@"jellesimon"];
		[self createGDataContacts];
	}
}

// Get a contact service object with the current username/password
// A "service" object handles networking tasks. Service objects contain user authentication information as well as networking state information (such as cookies and the "last modified" date for fetched data.)
- (void)authenticateWithUsername:(NSString *)user password:(NSString *)pass
{
	if (!service) {
		service = [[GDataServiceGoogleContact alloc] init];
		
		[service setUserAgent:@"Eggnog-GoogleAPI-0.1"];
		[service setShouldCacheDatedData:YES]; 
		[service setServiceShouldFollowNextLinks:YES];
	}
	
	username = user;
	password = pass;
	[service setUserCredentialsWithUsername:username password:password];
}

// Creates a GData contact with the information from Address Book
- (void)createGDataContacts
{
	for (ABPerson *person in contactsList) {
		NSString *firstName = [person valueForProperty:kABFirstNameProperty];
		NSString *lastName = [person valueForProperty:kABLastNameProperty];
		NSString *organization = [person valueForProperty:kABOrganizationProperty];
		// Nickname seems to be missing in Google Contacts
		// Note seems to be missing in Google Contacts
		ABMultiValue *addresses = [person valueForProperty:kABAddressProperty];
		ABMultiValue *mails = [person valueForProperty:kABEmailProperty];
		// URLs seems to be missing in Google Contacts
		ABMultiValue *phones = [person valueForProperty:kABPhoneProperty];
		// Birthday seems to be missing in Google Contacts
		NSString *fullName = @"";
		
		if (firstName) {		
			fullName = [fullName stringByAppendingString:firstName];
		}
		if (lastName) {
			fullName = [fullName stringByAppendingString:@" "];
			fullName = [fullName stringByAppendingString:lastName];
		}
		GDataEntryContact *contact = [GDataEntryContact contactEntryWithTitle:fullName];
		
		if(organization) {
			GDataOrganization *gOrganization = [GDataOrganization organizationWithName:organization];
			[gOrganization setIsPrimary:true];
			[contact addOrganization:gOrganization];
		}
		
		if(addresses) {
			for (int i = 0; i < [addresses count]; i++) {
				NSString *address = [addresses valueAtIndex:i];
				[contact addPostalAddress:[GDataPostalAddress postalAddressWithString:address]];
				if (i == 0) {
					[contact setPrimaryPostalAddress:[GDataPostalAddress postalAddressWithString:address]];
				}
			}
		}
		
		if(mails) {
			for (int i = 0; i < [mails count]; i++) {
				NSString *label = [mails labelAtIndex:i];
				NSString *mail = [mails valueAtIndex:i];
				label = [self cleanLabel:label];
				[contact addEmailAddress:[GDataEmail emailWithLabel:label address:mail]];
				if (i == 0) {
					[contact setPrimaryEmailAddress:[GDataEmail emailWithLabel:label address:mail]];
				}
			}
		}
		
		if(phones) {
			for (int i = 0; i < [phones count]; i++) {
				NSString *phone = [phones valueAtIndex:i];
				[contact addPhoneNumber:[GDataPhoneNumber phoneNumberWithString:phone]];
				if (i == 0) {
					[contact setPrimaryPhoneNumber:[GDataPhoneNumber phoneNumberWithString:phone]];
				}
			}
		}
		
		NSLog(@"%@", [[contact primaryPostalAddress] stringValue]);
		NSLog(@"%@", [[contact primaryPhoneNumber] stringValue]);
		NSLog(@"%@", [[contact primaryEmailAddress] address]);
		NSLog(@"%@", [[contact primaryOrganization] orgName]);
		NSLog(@"--------------");
		
		[service fetchContactEntryByInsertingEntry:contact
										forFeedURL:[self getURL]
										  delegate:self
								 didFinishSelector:nil
								   didFailSelector:@selector(ticket:failedWithError:)];
	}
}

- (void)ticket:(GDataServiceTicketBase *)ticket failedWithError:(NSError *)error
{
	NSLog(@"Failed with %@", [error localizedDescription]);
}

// Requests the URL needed to post contacts to
- (NSURL *)getURL
{
	NSURL *url = [GDataServiceGoogleContact contactFeedURLForUserID:username];
	return url;
}

@end