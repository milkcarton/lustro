//
//  ExportGoogle.m
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 22/04/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import "ExportGoogle.h"

#define TIMEOUT 15		// timeout in seconds
#define MAXLIMIT 9999	// max entries per feed
#define GOOGLE_CLIENT_AUTH_URL @"https://www.google.com/accounts/ClientLogin"

@implementation ExportGoogle

+ (BOOL)checkCredentialsWithUsername:(NSString *)user password:(NSString *)pass
{
	if ([user hasSuffix:@"@gmail.com"] == FALSE) {
		user = [user stringByAppendingFormat:@"@gmail.com"];
	}
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:GOOGLE_CLIENT_AUTH_URL]];
	[request setTimeoutInterval:TIMEOUT];
	[request setHTTPMethod:@"POST"];
	[request addValue:@"Content-Type" forHTTPHeaderField:@"application/x-www-form-urlencoded"];
	NSString *lustroVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"];
	NSString *requestBody = [[NSString alloc] initWithFormat:@"Email=%@&Passwd=%@&service=xapi&accountType=HOSTED_OR_GOOGLE&source=%@",	user, pass, lustroVersion];
	NSHTTPURLResponse *response = nil;
	[request setHTTPBody:[requestBody dataUsingEncoding:NSASCIIStringEncoding]];
	[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
	if ([response statusCode] == 200) {
		return true;
	}
	return false;
}

// (ExportController) Adds the contacts to the contactList instance variable
- (id)initWithAddressBook:(ABAddressBook *)addressBook target:(id)errorCtrl
{
	self = [super initWithAddressBook:addressBook target:(id)errorCtrl];
	contactsList = [addressBook people];
	return self;
}

- (id)initWithAddressBook:(ABAddressBook *)addressBook username:(NSString *)user password:(NSString *)pass target:(id)errorCtrl
{
	if ([user hasSuffix:@"@gmail.com"] == FALSE) {
		user = [user stringByAppendingFormat:@"@gmail.com"];
	}
	username = user;
	password = pass;
	exportStatus = kExportSuccess;
	[self initWithAddressBook:addressBook target:errorCtrl];
	return self;
}

// (ExportProtocol) Start exporting by removing all old contacts and import all new ones
- (int)export
{
	if ([contactsList count] > 0) {
		// Logging, disabled for release versions
		//[GDataHTTPFetcher setIsLoggingEnabled:YES];
		[self authenticate];
		
		[self backupAllContacts];
		[self removeAllContacts];
		[service waitForTicket:ticket timeout:TIMEOUT fetchedObject:nil error:nil];

		// It seems that some 409 (duplicate mail) errors are caused by an contact that was not yet completly removed
		sleep(2);
		
		[self createContacts];
	} else {
		[super addFailedMessage:@"No contacts found in Address Book."];
		exportStatus = kExportWarning;
	}
	[ticket cancelTicket];
	[service release];
	
	if (exportStatus == kExportSuccess || exportStatus == kExportWarning) {
		[super addSuccessMessage:[NSString stringWithFormat:@"Exported %i contacts to Google.", [contactsList count]]];
	}
	
	return exportStatus;
}

- (void)authenticate
{
	if (!service) {
		// Set version for Google user agent from plist file
		NSString *lustroVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"];
		NSString *userAgent = @"milkcarton-GoogleAPI-";
		userAgent = [userAgent stringByAppendingString:lustroVersion];
		service = [[GDataServiceGoogleContact alloc] init];
		[service setUserAgent:userAgent];
	}

	[service setUserCredentialsWithUsername:username password:password];
}

- (void)createContacts
{
	// TODO no pictures uploaded at the moment, not supported by Google yet
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
		
		if ([title compare:@""] == NSOrderedSame) {
			[super addFailedMessage:@"Contact without name, nickname or company."];
			exportStatus = kExportWarning;
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
				GDataIM *gIM =  [GDataIM IMWithProtocol:[self makeRelFromLabel:@"aim"] rel:[self makeRelFromLabel:label] label:nil address:value];
				[contact addIMAddress:gIM];
			}
		}
		
		if(jabber)	{
			for (int j = 0; j < [jabber count]; j++) {
				NSString *label = [jabber labelAtIndex:j];
				NSString *value = [jabber valueAtIndex:j];
				GDataIM *gIM =  [GDataIM IMWithProtocol:[self makeRelFromLabel:@"jabber"] rel:[self makeRelFromLabel:label] label:nil address:value];
				[contact addIMAddress:gIM];
			}
		}
		
		if(msn) {
			for (int j = 0; j < [msn count]; j++) {
				NSString *label = [msn labelAtIndex:j];
				NSString *value = [msn valueAtIndex:j];
				GDataIM *gIM =  [GDataIM IMWithProtocol:[self makeRelFromLabel:@"msn"]	rel:[self makeRelFromLabel:label] label:nil address:value];
				[contact addIMAddress:gIM];
			}
		}
		
		if(icq) {
			for (int j = 0; j < [icq count]; j++) {
				NSString *label = [icq labelAtIndex:j];
				NSString *value = [icq valueAtIndex:j];
				GDataIM *gIM =  [GDataIM IMWithProtocol:[self makeRelFromLabel:@"icq"] rel:[self makeRelFromLabel:label] label:nil address:value];
				[contact addIMAddress:gIM];
			}
		}
		
		if(yahoo) {
			for (int j = 0; j < [yahoo count]; j++) {
				NSString *label = [yahoo labelAtIndex:j];
				NSString *value = [yahoo valueAtIndex:j];
				GDataIM *gIM =  [GDataIM IMWithProtocol:[self makeRelFromLabel:@"yahoo"] rel:[self makeRelFromLabel:label] label:nil address:value];
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

-(void)backupAllContacts
{
	GDataQueryContact *query = [GDataQueryContact contactQueryForUserID:username];
	[query setMaxResults:MAXLIMIT];
	ticket = [service fetchContactQuery:query
							   delegate:self 
					  didFinishSelector:@selector(ticket:backupFinishedWithFeed:) 
						didFailSelector:@selector(ticket:failedWithError:)];
}

- (void)ticket:(GDataServiceTicket *)ticket backupFinishedWithFeed:(GDataFeedContact *)feed
{
	// Create the backup directory if it doesn't exist
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *folder =[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Application Support/Lustro/Backups"];

	if ([fileManager fileExistsAtPath:folder] == NO)
	{
		[fileManager createDirectoryAtPath:folder attributes:nil];
	}
	
	// Remove old (older then 31 days) backup files
	NSString *file;
	NSTimeInterval month = 24 * 60 * 60 * 31;
	NSDate *refDate = [[NSDate date] addTimeInterval:-month];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:folder];
    while (file = [dirEnum nextObject])
    {
		NSString *filePath = [NSString stringWithFormat:@"%@/%@", folder, [file stringByStandardizingPath]];
		NSDictionary *dict = [fileManager fileAttributesAtPath:filePath traverseLink:YES];
		NSDate *fileCreationDate = [dict objectForKey:NSFileCreationDate];
		if(fileCreationDate < refDate) {
			[fileManager removeFileAtPath:filePath handler:nil];
		}
    }
	
	// Create the new backup file with a random number
	int random = ([NSDate timeIntervalSinceReferenceDate] - (int)[NSDate timeIntervalSinceReferenceDate]) * 100000;
	NSString *filename = [NSString stringWithFormat:@"backup_google_%i.xml", random];
	NSString *path = [folder stringByAppendingPathComponent:filename];
	NSXMLDocument *doc = [feed XMLDocument];
    NSData* data = [doc XMLDataWithOptions:NSXMLNodePrettyPrint];
	[data writeToFile:path atomically:YES];
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
	// Extract the contact's name for the contact that went fubar
	NSDictionary *userInfo =[error userInfo];
	NSString *authError = [userInfo authenticationError];
	NSXMLDocument *userXml = [[NSXMLDocument alloc] initWithXMLString:[userInfo valueForKey:@"error"] options:NSXMLNodeOptionsNone error:nil];
	NSString *title = [[userXml nodesForXPath:@"/entry/title/text()" error:nil] objectAtIndex:0];
	[userXml release];

	if([error code] == 409) {
		[super addFailedMessage:(NSString *)[NSString stringWithFormat:@"Naming conflict for %@.", title]];
		exportStatus = kExportWarning;
    } else if ([authError isEqual:kGDataServiceErrorCaptchaRequired]) {
		[super addErrorMessage:@"Captcha required, your account is blocked."];
		exportStatus = kExportError;
    } else {
		[super addFailedMessage:(NSString *)[NSString stringWithFormat:@"Something went wrong with %@ (%i).", title, [error code]]];
		exportStatus = kExportWarning;
	}
}
	
@synthesize service;
@synthesize username;
@synthesize password;
@synthesize ticket;
@end