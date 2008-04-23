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
- (id)initWithAddressBook:(ABAddressBook *)addressBook
{
	self = [super initWithAddressBook:addressBook];
	contactsList = [addressBook people];
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
	[service release];
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
	
	//for (ABPerson *person in contactsList) {
	NSArray *subarray = [contactsList subarrayWithRange:NSMakeRange(0,20)];
	for (ABPerson *person in subarray) {
		NSString *firstName = [person valueForProperty:kABFirstNameProperty];
		NSString *lastName = [person valueForProperty:kABLastNameProperty];
		NSString *jobtitle = [person valueForProperty:kABJobTitleProperty];
		NSString *organization = [person valueForProperty:kABOrganizationProperty];
		// Nickname seems to be missing in Google Contacts
		NSString *content = [person valueForProperty:kABNoteProperty];
		ABMultiValue *addresses = [person valueForProperty:kABAddressProperty];
		ABMultiValue *mails = [person valueForProperty:kABEmailProperty];
		// URLs seems to be missing in Google Contacts
		ABMultiValue *phones = [person valueForProperty:kABPhoneProperty];
		// Birthday seems to be missing in Google Contacts
		NSString *title = @"";
		
		if (firstName) {		
			title = [title stringByAppendingString:firstName];
		}
		if (lastName) {
			title = [title stringByAppendingString:@" "];
			title = [title stringByAppendingString:lastName];
		}
		
		// Set company name as title if needed
		NSNumber *flagsValue = [person valueForProperty:kABPersonFlags];
		int flags = [flagsValue intValue];
		if ((flags & kABShowAsMask) == kABShowAsCompany) {
			title = organization;
		}
		
		GDataEntryContact *contact = [GDataEntryContact contactEntryWithTitle:title];
		
		if(organization) {
			GDataOrganization *gOrganization = [GDataOrganization organizationWithName:organization];
			if(jobtitle) {
				[gOrganization setOrgTitle:jobtitle];
			}
			[gOrganization setRel:kGDataContactWork];
			[gOrganization setIsPrimary:true];
			[contact addOrganization:gOrganization];
		}
		
		if(content) {
			GDataEntryContent *gContent =  [GDataEntryContent textConstructWithString:content];
			[contact setContent:gContent];
		}
		
		if(addresses) {
			for (int i = 0; i < [addresses count]; i++) {
				NSString *label = [addresses labelAtIndex:i];
				NSDictionary *value = [addresses valueAtIndex:i];
				NSString *address = @"";
				
				if ([value objectForKey:@"Street"]) {
					address = [address stringByAppendingString:[value objectForKey:@"Street"]];
					address = [address stringByAppendingString:@"\n"];
				}
				
				if ([value objectForKey:@"City"]) {
					address = [address stringByAppendingString:[value objectForKey:@"City"]];
				}
				if ([value objectForKey:@"City"] && [value objectForKey:@"ZIP"]) {
					address = [address stringByAppendingString:@" "];
				}
				if ([value objectForKey:@"ZIP"]) {
					address = [address stringByAppendingString:[value objectForKey:@"ZIP"]];
				}
				address = [address stringByAppendingString:@"\n"];
				
				if ([value objectForKey:@"State"]) {
					address = [address stringByAppendingString:[value objectForKey:@"State"]];
				}
				if ([value objectForKey:@"State"] && [value objectForKey:@"Country"]) {
					address = [address stringByAppendingString:@", "];
				}
				if ([value objectForKey:@"Country"]) {
					address = [address stringByAppendingString:[value objectForKey:@"Country"]];
				}				
				
				GDataPostalAddress *gAddress = [GDataPostalAddress postalAddressWithString:address];
				[gAddress setRel:[self makeRelFromLabel:label]];
				if (i == 0) {
					[gAddress setIsPrimary:true];
				}
				[contact addPostalAddress:gAddress];
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
				NSString *label = [phones labelAtIndex:i];
				NSString *phone = [phones valueAtIndex:i];
				
				GDataPhoneNumber *gPhone = [GDataPhoneNumber phoneNumberWithString:phone];
				[gPhone setRel:[self makeRelFromLabel:label]];
				
				if (i == 0) {
					[gPhone setIsPrimary:true];
				}
				[contact addPhoneNumber:gPhone];
			}
		}
	
		[service fetchContactEntryByInsertingEntry:contact
										forFeedURL:[self getURL]
										  delegate:self
								 didFinishSelector:nil
								   didFailSelector:@selector(ticket:failedWithError:)];
	}
}

// Callback function when the uploads service reeturns an error
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

// Translates Address Book labels to Googles rel attributes or to the 'other' attribute if nothing found
- (NSString *)makeRelFromLabel:(NSString *)label
{
	label = [self cleanLabel:label];
	if([label caseInsensitiveCompare:@"work"] == NSOrderedSame) { return kGDataPhoneNumberWork; }
	if([label caseInsensitiveCompare:@"home"] == NSOrderedSame) { return kGDataPhoneNumberHome; }
	if([label caseInsensitiveCompare:@"mobile"] == NSOrderedSame) { return kGDataPhoneNumberMobile; }
	if([label caseInsensitiveCompare:@"homefax"] == NSOrderedSame) { return kGDataPhoneNumberHomeFax; }
	if([label caseInsensitiveCompare:@"workfax"] == NSOrderedSame) { return kGDataPhoneNumberWorkFax; }
	if([label caseInsensitiveCompare:@"pager"] == NSOrderedSame) { return kGDataPhoneNumberPager; }
	if([label caseInsensitiveCompare:@"other"] == NSOrderedSame) { return kGDataPhoneNumberOther; }
	return kGDataPhoneNumberOther;
}

@end