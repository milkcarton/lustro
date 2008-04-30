//
//  ExportGoogle.m
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 22/04/08.
//  Copyright 2008 eggnog. All rights reserved.
//

#import "ExportGoogle.h"

#define TIMEOUT 30 // timeout in seconds
#define MAXLIMIT 9999 // max entries per feed

@implementation ExportGoogle

// (ExportController) Adds the contacts to the contactList instance variable
- (id)initWithAddressBook:(ABAddressBook *)addressBook
{
	self = [super initWithAddressBook:addressBook];
	contactsList = [addressBook people];
	return self;
}

// (ExportProtocol) Start exporting by removing all old contacts and import all new ones
- (int)export
{
	if ([contactsList count] > 0) {
		// Logging, disabled for release versions
		[GDataHTTPFetcher setIsLoggingEnabled:YES];
		[self authenticateWithUsername:@"lustroapp@gmail.com" password:@"jellesimon"];
		
		[self removeAllContacts];
		[service waitForTicket:ticket timeout:TIMEOUT fetchedObject:nil error:nil];

		// It seems that some 409 (duplicate mail) errors are caused by an contact that was not yet completly removed
		sleep(1);
		
		[self createContacts];
	}
	[ticket cancelTicket];
	[service release];
	return kExportSuccess;
}

- (void)authenticateWithUsername:(NSString *)user password:(NSString *)pass
{
	// Set version for Google user agent from plist file
	NSString *lustroVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"];
	NSString *userAgent = @"Eggnog-GoogleAPI-";
	userAgent = [userAgent stringByAppendingString:lustroVersion];

	if (!service) {
		service = [[GDataServiceGoogleContact alloc] init];
		[service setUserAgent:userAgent];
	}
	
	username = user;
	password = pass;
	[service setUserCredentialsWithUsername:username password:password];
}

- (void)createContacts
{
	// TODO no pictures uploaded at the moment
	//for (int i = 0; i < [contactsList count]; i++) {
	for (int i = 0; i < 20; i++) {
		ABPerson *person = [contactsList objectAtIndex:i];
		NSString *firstName = [person valueForProperty:kABFirstNameProperty];
		NSString *lastName = [person valueForProperty:kABLastNameProperty];
		NSString *jobtitle = [person valueForProperty:kABJobTitleProperty];
		NSString *organization = [person valueForProperty:kABOrganizationProperty];
		ABMultiValue *aim = [person valueForProperty:kABAIMInstantProperty];
		ABMultiValue *jabber = [person valueForProperty:kABJabberInstantProperty];
		ABMultiValue *msn = [person valueForProperty:kABMSNInstantProperty];
		ABMultiValue *icq = [person valueForProperty:kABICQInstantProperty];
		ABMultiValue *yahoo = [person valueForProperty:kABYahooInstantProperty];
		// Nickname seems to be missing in Google Contacts, use it as title if no first- or lastname available
		NSString *nickname = [person valueForProperty:kABNicknameProperty];
		NSString *content = [person valueForProperty:kABNoteProperty];
		ABMultiValue *addresses = [person valueForProperty:kABAddressProperty];
		ABMultiValue *mails = [person valueForProperty:kABEmailProperty];
		// URLs seem to be missing in Google Contacts
		ABMultiValue *phones = [person valueForProperty:kABPhoneProperty];
		// Birthdays seem to be missing in Google Contacts
		//NSImage *personImage = [[NSImage alloc] initWithData:[person imageData]]; 
		NSString *title = @"";
		
		if (firstName) {		
			title = [title stringByAppendingString:firstName];
		}
		if (lastName) {
			title = [title stringByAppendingString:@" "];
			title = [title stringByAppendingString:lastName];
		}
		
		if (!firstName && !lastName && nickname) {
			title = nickname;
		}

		// Set company name as title if needed (Google will show an empty entry for a company if not)
		NSNumber *flagsValue = [person valueForProperty:kABPersonFlags];
		int flags = [flagsValue intValue];
		if ((flags & kABShowAsMask) == kABShowAsCompany) {
			title = organization;
		}
		
		GDataEntryContact *contact = [GDataEntryContact contactEntryWithTitle:title];
		
		/*
		if(personImage) {
			[contact setUserData:personImage];
		}
		[personImage release]; 	
		*/
			 
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
			for (int j = 0; j < [aim count]; j++) {
				NSString *label = [aim labelAtIndex:j];
				NSString *value = [aim valueAtIndex:j];
				GDataIM *gIM =  [GDataIM IMWithProtocol:[self makeRelFromLabel:@"aim"]
													rel:[self makeRelFromLabel:label]
												  label:nil
												address:value];
				[contact addIMAddress:gIM];
			}
		}
		
		if(jabber)	{
			for (int j = 0; j < [jabber count]; j++) {
				NSString *label = [jabber labelAtIndex:j];
				NSString *value = [jabber valueAtIndex:j];
				GDataIM *gIM =  [GDataIM IMWithProtocol:[self makeRelFromLabel:@"jabber"]
													rel:[self makeRelFromLabel:label]
												  label:nil
												address:value];
				[contact addIMAddress:gIM];
			}
		}
		
		if(msn) {
			for (int j = 0; j < [msn count]; j++) {
				NSString *label = [msn labelAtIndex:j];
				NSString *value = [msn valueAtIndex:j];
				GDataIM *gIM =  [GDataIM IMWithProtocol:[self makeRelFromLabel:@"msn"]
													rel:[self makeRelFromLabel:label]
												  label:nil
												address:value];
				[contact addIMAddress:gIM];
			}
		}
		
		if(icq) {
			for (int j = 0; j < [icq count]; j++) {
				NSString *label = [icq labelAtIndex:j];
				NSString *value = [icq valueAtIndex:j];
				GDataIM *gIM =  [GDataIM IMWithProtocol:[self makeRelFromLabel:@"icq"]
													rel:[self makeRelFromLabel:label]
												  label:nil
												address:value];
				[contact addIMAddress:gIM];
			}
		}
		
		if(yahoo) {
			for (int j = 0; j < [yahoo count]; j++) {
				NSString *label = [yahoo labelAtIndex:j];
				NSString *value = [yahoo valueAtIndex:j];
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
			for (int j = 0; j < [addresses count]; j++) {
				NSString *label = [addresses labelAtIndex:j];
				NSDictionary *value = [addresses valueAtIndex:j];
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
				[contact addPostalAddress:gAddress];
			}
		}
		
		if(mails) {
			for (int j = 0; j < [mails count]; j++) {
				NSString *label = [mails labelAtIndex:j];
				NSString *mail = [mails valueAtIndex:j];
				label = [self cleanLabel:label];
				[contact addEmailAddress:[GDataEmail emailWithLabel:label address:mail]];
			}
		}

		if(phones) {
			for (int j = 0; j < [phones count]; j++) {
				NSString *label = [phones labelAtIndex:j];
				NSString *phone = [phones valueAtIndex:j];
				GDataPhoneNumber *gPhone = [GDataPhoneNumber phoneNumberWithString:phone];
				[gPhone setRel:[self makeRelFromLabel:label]];
				[contact addPhoneNumber:gPhone];
			}
		}

		ticket = [service fetchContactEntryByInsertingEntry:contact
												 forFeedURL:[GDataServiceGoogleContact contactFeedURLForUserID:username]
												   delegate:self
										  didFinishSelector:nil
											didFailSelector:@selector(ticket:failedWithError:)];
		// TODO It waits for each contact, this is not efficient, batch would be better but is not supported by Google yet
		[service waitForTicket:ticket timeout:TIMEOUT fetchedObject:nil error:nil];

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
	// kGDataIMProtocolGoogleTalk seems to be an illegal value for Google
	//if([label caseInsensitiveCompare:@"gtalk"] == NSOrderedSame) { return kGDataIMProtocolGoogleTalk; }
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
	GDataQueryContact *query = [GDataQueryContact contactQueryForUserID:username];
	[query setMaxResults:MAXLIMIT];
	ticket = [service fetchContactQuery:query
							   delegate:self 
					  didFinishSelector:@selector(ticket:deleteFinishedWithFeed:) 
						didFailSelector:@selector(ticket:failedWithError:)];
}

- (void)ticket:(GDataServiceTicket *)ticket deleteFinishedWithFeed:(GDataFeedContact *)feed
{
	// Remove contact per contact
	for (GDataEntryContact *contact in [feed entries]) {
		NSArray *entryLinks = [contact links];
		GDataLink *link = [entryLinks editLink];
		NSURL* editURL = [link URL];
		[service deleteContactResourceURL:editURL
								 delegate:self 
						didFinishSelector:nil 
						  didFailSelector:@selector(ticket:failedWithError:)];
	}
}

- (void)ticket:(GDataServiceTicket *)aTicket failedWithError:(NSError *)error {	
	// Extract the contact's name for the contact that whent fubar
	NSDictionary *userInfo =[error userInfo];
	NSString *authError = [userInfo authenticationError];
	NSXMLDocument *userXml = [[NSXMLDocument alloc] initWithXMLString:[userInfo valueForKey:@"error"] options:NSXMLNodeOptionsNone error:nil];
	NSString *title = [[userXml nodesForXPath:@"/entry/title/text()" error:nil] objectAtIndex:0];
	[userXml release];

	NSString *errorMessage = @"ERROR: ";
	if([error code] == 409) {
		errorMessage = [errorMessage stringByAppendingString:@"Naming conflict, seems like duplicate mailaddresses or something"];
    } else if ([authError isEqual:kGDataServiceErrorCaptchaRequired]) {
		errorMessage = [errorMessage stringByAppendingString:@"Sounds like you'll need a captcha"];
    } else {
		errorMessage = [errorMessage stringByAppendingString:@"Some other uncategorized error"];
	}
	NSLog(@"%@ for %@.", errorMessage, title);
}
	
@end