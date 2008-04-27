//
//  ExportGoogle.m
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 22/04/08.
//  Copyright 2008 eggnog. All rights reserved.
//

#import "ExportGoogle.h"

// FIXME adds 162 cards while I have 163 contacts
@implementation ExportGoogle

// (ExportController) Adds the contacts to the contactList instance variable
- (id)initWithAddressBook:(ABAddressBook *)addressBook
{
	self = [super initWithAddressBook:addressBook];
	contactsList = [addressBook people];
	return self;
}

// (ExportProtocol) Start exporting by removing all old contacts and then importing all new ones
- (void)export
{
	if ([contactsList count] > 0) {
		// TODO disable logging
		[GDataHTTPFetcher setIsLoggingEnabled:YES];
		[self authenticateWithUsername:@"lustroapp@gmail.com" password:@"jellesimon"];
		//[self removeAllContacts];
		[self createGDataContacts];
	}
	[service release];
}

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

- (void)createGDataContacts
{
	// TODO not exporting AIM mails yet, add this feature
	// TODO no pictures uploaded at the moment
	// TODO Google Contacts has an 'other' field, maybe use this for birthdays or websites
	
	for (ABPerson *person in contactsList) {
	//NSArray *subarray = [contactsList subarrayWithRange:NSMakeRange(0,20)];
	//for (ABPerson *person in subarray) {
		NSString *firstName = [person valueForProperty:kABFirstNameProperty];
		NSString *lastName = [person valueForProperty:kABLastNameProperty];
		NSString *jobtitle = [person valueForProperty:kABJobTitleProperty];
		NSString *organization = [person valueForProperty:kABOrganizationProperty];
		ABMultiValue *aim = [person valueForProperty:kABAIMInstantProperty];
		ABMultiValue *jabber = [person valueForProperty:kABJabberInstantProperty];
		ABMultiValue *msn = [person valueForProperty:kABMSNInstantProperty];
		ABMultiValue *icq = [person valueForProperty:kABICQInstantProperty];
		ABMultiValue *yahoo = [person valueForProperty:kABYahooInstantProperty];
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
		
		// Set company name as title if needed (Google will show an empty entry for a company if not)
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
		
		if(aim) {
			for (int i = 0; i < [aim count]; i++) {
				NSString *label = [aim labelAtIndex:i];
				NSString *value = [aim valueAtIndex:i];
				GDataIM *gIM =  [GDataIM IMWithProtocol:[self makeRelFromLabel:@"aim"]
													rel:[self makeRelFromLabel:label]
												  label:nil
												address:value];
				[contact addIMAddress:gIM];
				
			}
		}
		
		if(jabber)	{
			for (int i = 0; i < [jabber count]; i++) {
				NSString *label = [jabber labelAtIndex:i];
				NSString *value = [jabber valueAtIndex:i];
				GDataIM *gIM =  [GDataIM IMWithProtocol:[self makeRelFromLabel:@"jabber"]
													rel:[self makeRelFromLabel:label]
												  label:nil
												address:value];
				[contact addIMAddress:gIM];
			}
		}
		
		if(msn) {
			for (int i = 0; i < [msn count]; i++) {
				NSString *label = [msn labelAtIndex:i];
				NSString *value = [msn valueAtIndex:i];
				GDataIM *gIM =  [GDataIM IMWithProtocol:[self makeRelFromLabel:@"msn"]
													rel:[self makeRelFromLabel:label]
												  label:nil
												address:value];
				[contact addIMAddress:gIM];
			}
		}
		
		if(icq) {
			for (int i = 0; i < [icq count]; i++) {
				NSString *label = [icq labelAtIndex:i];
				NSString *value = [icq valueAtIndex:i];
				GDataIM *gIM =  [GDataIM IMWithProtocol:[self makeRelFromLabel:@"icq"]
													rel:[self makeRelFromLabel:label]
												  label:nil
												address:value];
				[contact addIMAddress:gIM];
			}
		}
		
		if(yahoo) {
			for (int i = 0; i < [yahoo count]; i++) {
				NSString *label = [yahoo labelAtIndex:i];
				NSString *value = [yahoo valueAtIndex:i];
				GDataIM *gIM =  [GDataIM IMWithProtocol:[self makeRelFromLabel:@"yahoo"]
													rel:[self makeRelFromLabel:label]
												  label:nil
												address:value];
				[contact addIMAddress:gIM];
			}
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
		
		// TODO always sets first mail in the list as main one, this could be better
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

		// TODO always sets first phone in the list as main one, this could be better
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
	
		// Add entry to the service and upload in batch (automatically)
		[service fetchContactEntryByInsertingEntry:contact
										forFeedURL:[GDataServiceGoogleContact contactFeedURLForUserID:username]
										  delegate:self
								 didFinishSelector:nil
								   didFailSelector:nil];
	}
}

- (NSString *)makeRelFromLabel:(NSString *)label
{
	label = [self cleanLabel:label];
	// For phones and such
	if([label caseInsensitiveCompare:@"work"] == NSOrderedSame) { return kGDataPhoneNumberWork; }
	if([label caseInsensitiveCompare:@"home"] == NSOrderedSame) { return kGDataPhoneNumberHome; }
	if([label caseInsensitiveCompare:@"mobile"] == NSOrderedSame) { return kGDataPhoneNumberMobile; }
	if([label caseInsensitiveCompare:@"homefax"] == NSOrderedSame) { return kGDataPhoneNumberHomeFax; }
	if([label caseInsensitiveCompare:@"workfax"] == NSOrderedSame) { return kGDataPhoneNumberWorkFax; }
	if([label caseInsensitiveCompare:@"pager"] == NSOrderedSame) { return kGDataPhoneNumberPager; }
	if([label caseInsensitiveCompare:@"other"] == NSOrderedSame) { return kGDataPhoneNumberOther; }
	// For instant messengers
	if([label caseInsensitiveCompare:@"aim"] == NSOrderedSame) { return kGDataIMProtocolAIM; }
	if([label caseInsensitiveCompare:@"gtalk"] == NSOrderedSame) { return kGDataIMProtocolGoogleTalk; }
	if([label caseInsensitiveCompare:@"icq"] == NSOrderedSame) { return kGDataIMProtocolICQ; }
	if([label caseInsensitiveCompare:@"jabber"] == NSOrderedSame) { return kGDataIMProtocolJabber; }
	if([label caseInsensitiveCompare:@"msn"] == NSOrderedSame) { return kGDataIMProtocolMSN; }
	if([label caseInsensitiveCompare:@"iqq"] == NSOrderedSame) { return kGDataIMProtocolQQ; }
	if([label caseInsensitiveCompare:@"skype"] == NSOrderedSame) { return kGDataIMProtocolSkype; }
	if([label caseInsensitiveCompare:@"yahoo"] == NSOrderedSame) { return kGDataIMProtocolYahoo; }
	// TODO custom Address Book fields are converted to "other", this is wrong, should be a label instead
	return kGDataPhoneNumberOther;
}

-(void)removeAllContacts
{
	// FIXME seems asynchronious so it's adding contacts while removing, not good
	[service fetchContactFeedForUsername:username 
								delegate:self
						didFinishSelector:@selector(ticket:finishedWithFeed:)
						didFailSelector:nil];
}

- (void)ticket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedContact *)feed
{
	// Remove contact per contact
	for (GDataEntryContact *contact in [feed entries]) {
		NSArray *entryLinks = [contact links];
		GDataLink *link = [entryLinks editLink];
		NSURL* editURL = [link URL];
		[service deleteContactResourceURL:editURL
								 delegate:self 
						didFinishSelector:nil 
						  didFailSelector:nil];
	 }
}

@end