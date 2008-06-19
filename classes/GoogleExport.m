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

#import "GoogleExport.h"

#define TIMEOUT 15		// timeout in seconds
#define MAXLIMIT 9999	// max entries per feed
#define GOOGLE_CLIENT_AUTH_URL @"https://www.google.com/accounts/ClientLogin"
#define GOOGLE_CAPTCHA_URL @"https://www.google.com/accounts/ErrorMsg"

@implementation GoogleExport

#pragma mark -

+ (BOOL)autenticateWithUsername:(NSString *)user password:(NSString *)pass
{
	if ([user length] > 0 && [pass length] > 0) { 
		if ([user hasSuffix:@"@gmail.com"] == NO) { // Add @gmail.com if missing
			user = [user stringByAppendingFormat:@"@gmail.com"];
		}
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:GOOGLE_CLIENT_AUTH_URL]];
		[request setTimeoutInterval:TIMEOUT];
		[request setHTTPMethod:@"POST"];
		[request addValue:@"Content-Type" forHTTPHeaderField:@"application/x-www-form-urlencoded"];
		NSString *lustroVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"]; // Set version for Google user agent from plist file
		NSString *requestBody = [[NSString alloc] initWithFormat:@"Email=%@&Passwd=%@&service=xapi&accountType=HOSTED_OR_GOOGLE&source=%@",	user, pass, lustroVersion];
		NSHTTPURLResponse *response;
		[request setHTTPBody:[requestBody dataUsingEncoding:NSASCIIStringEncoding]];
		[requestBody release];
		requestBody = nil;
		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];	
		[request release];
		request = nil;
	
		if ([response statusCode] == 200) { // Check if the username and password are correct
			return YES;
		} else {
			// Check if Google denies login due to captcha request
			NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			BOOL captcha = ([responseBody rangeOfString:@"CaptchaUrl" options:NSCaseInsensitiveSearch].location != NSNotFound);
			if (captcha) { // Google asks for token
				NSString *captchaURL = GOOGLE_CAPTCHA_URL;
				captchaURL = [captchaURL stringByAppendingString:[[responseBody componentsSeparatedByString:GOOGLE_CAPTCHA_URL] lastObject]];
				captchaURL = [captchaURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				
				// Show alert window to inform user why browser opens
				NSAlert *alertWindow = [[NSAlert alloc] init];
				[alertWindow addButtonWithTitle:@"OK"];
				[alertWindow setMessageText:@"Google account locked"];
				[alertWindow setInformativeText:@"Your Google is locked after too many failed login attempts. Fill in the Google captcha form and try once more."];
				[alertWindow setAlertStyle:NSWarningAlertStyle];
				[alertWindow runModal];
				[alertWindow release];
				alertWindow = nil;
				[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:captchaURL]];
			}
			[responseBody release];
			responseBody = nil;
		}
	}
	
	return NO; // Username or password are wrong
}

+ (NSString *)makeRelFromLabel:(NSString *)label
{
	label = [AddressBookExport cleanLabel:label];
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

#pragma mark -

- (id)initWithUsername:(NSString *)user password:(NSString *)pass
{
	alert = NO;
	self = [super init];
	if ([user hasSuffix:@"@gmail.com"] == NO) { // Add @gmail.com if missing
		user = [user stringByAppendingFormat:@"@gmail.com"];
	}
	username = user;
	password = pass;
	return self;
}

- (BOOL)initialize
{
	if ([GoogleExport autenticateWithUsername:username password:password] && !service) { // If username/password combination is correct
		collectedMails = [[NSMutableArray alloc] init];
		NSString *lustroVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"]; // Set version for Google user agent from plist file
		NSString *userAgent = @"milkcarton-GoogleAPI-";
		userAgent = [userAgent stringByAppendingString:lustroVersion];
		service = [[[GDataServiceGoogleContact alloc] init] autorelease];
		[service setUserAgent:userAgent];
		[service setUserCredentialsWithUsername:username password:password];
		
		// Returning the status of alert so if no errors found alert will be NO (this may sound strange)
		BOOL backupFailed = [self backupAllContacts]; // Backup the current Google Contacts before deleting... you never know
		BOOL removeFailed = [self removeAllContacts]; // Clear all existing contacts in Google
		
		if (backupFailed || removeFailed) {
			return NO;
		}

	} else if (![GoogleExport autenticateWithUsername:username password:password]) { // Wrong username or password
		[super addErrorMessage:@"Wrong username or password."];
		return NO;
	}
	
	return YES; // All parameters set and ready for exporting
}

- (BOOL)backupAllContacts
{
	GDataQueryContact *query = [GDataQueryContact contactQueryForUserID:username];
	[query setMaxResults:MAXLIMIT];
	ticket = [service fetchContactQuery:query
							   delegate:self 
					  didFinishSelector:@selector(ticket:backupFinishedWithFeed:) 
						didFailSelector:@selector(ticket:backupFailedWithError:)];
	[service waitForTicket:ticket timeout:TIMEOUT fetchedObject:nil error:nil];
	return alert;
}

-(BOOL)removeAllContacts
{
	// TODO: It would be more efficient to reuse the feed downloaded in the backupAllContacts method instead of querying Google again
	GDataQueryContact *query = [GDataQueryContact contactQueryForUserID:username];
	[query setMaxResults:MAXLIMIT];
	ticket = [service fetchContactQuery:query
							   delegate:self 
					  didFinishSelector:@selector(ticket:fetchFinishedWithFeed:) 
						didFailSelector:@selector(ticket:fetchFailedWithError:)];
	[service waitForTicket:ticket timeout:TIMEOUT fetchedObject:nil error:nil];
	return alert;
}

- (BOOL)isEmailUnique:(NSString *)refMail
{
	for (NSString *email in collectedMails) {
		if ([email compare:refMail] == NSOrderedSame) {
			return NO;
		}
	}
	[collectedMails addObject:refMail];
	return YES;
}

- (BOOL)exportFirstName:(NSString *)firstName 
{
	if (firstName) {
		first = firstName;
	}
	return YES;
}

- (BOOL)exportLastName:(NSString *)lastName 
{
	if (lastName) {
		last = lastName;
	}
	return YES;
}

- (BOOL)exportFirstNamePhonetic:(NSString *)firstNamePhonetic { return YES; }

- (BOOL)exportLastNamePhonetic:(NSString *)lastNamePhonetic { return YES; }

- (BOOL)exportBirthDay:(NSCalendarDate *)birthDay {	return YES; }

- (BOOL)exportOrganization:(NSString *)organization 
{
	if(organization) {
		gOrganization = [GDataOrganization organizationWithName:organization];
		[gOrganization setRel:kGDataContactWork];
		[gOrganization setIsPrimary:true];
	}
	return YES;
}

- (BOOL)exportDepartment:(NSString *)department	{ return YES; }

- (BOOL)exportJobTitle:(NSString *)jobTitle	
{
	if(jobTitle) {
		[gOrganization setOrgTitle:jobTitle];
	}
	return YES;
}

- (BOOL)exportURLs:(ABMultiValue *)URLs	{ return YES; }

- (BOOL)exportCalendarURLs:(ABMultiValue *)calendarURLs { return YES; }

- (BOOL)exportEmails:(ABMultiValue *)emails	
{
	BOOL mailSuccess = YES;
	gMails = [[NSMutableArray alloc] init];
	for (int j = 0; j < [emails count]; j++) {
		NSString *email = [emails valueAtIndex:j];
		if([self isEmailUnique:email]) {
			NSString *label = [emails labelAtIndex:j];
			label = [AddressBookExport cleanLabel:label];
			GDataEmail *gMail = [GDataEmail emailWithLabel:label address:email];
			[gMails addObject:gMail];
		} else {
			[super addWarningMessage:(NSString *)[NSString stringWithFormat:@"Removed %@ as Google can't handle duplicate addresses.", email]];
			mailSuccess = NO;
		}
	}
	return mailSuccess;
}

- (BOOL)exportAddresses:(ABMultiValue *)addresses 
{
	gAddresses = [[NSMutableArray alloc] init];
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
		[gAddress setRel:[GoogleExport makeRelFromLabel:label]];
		[gAddresses addObject:gAddress];
	}
	return YES;
}
 
- (BOOL)exportPhones:(ABMultiValue *)phones	
{
	gPhones = [[NSMutableArray alloc] init];
	for (int j = 0; j < [phones count]; j++) {
		NSString *label = [phones labelAtIndex:j];
		NSString *phone = [phones valueAtIndex:j];
		GDataPhoneNumber *gPhone = [GDataPhoneNumber phoneNumberWithString:phone];
		[gPhone setRel:[GoogleExport makeRelFromLabel:label]];
		[gPhones addObject:gPhone];
	}
	return YES;
}

- (BOOL)exportAIMAddresses:(ABMultiValue *)AIMAddresses 
{
	gAIMs = [[NSMutableArray alloc] init];
	for (int j = 0; j < [AIMAddresses count]; j++) {
		NSString *label = [AIMAddresses labelAtIndex:j];
		NSString *value = [AIMAddresses valueAtIndex:j];
		GDataIM *gIM =  [GDataIM IMWithProtocol:[GoogleExport makeRelFromLabel:@"aim"] rel:[GoogleExport makeRelFromLabel:label] label:nil address:value];
		[gAIMs addObject:gIM];
	}
	return YES;
}

- (BOOL)exportJabberAddresses:(ABMultiValue *)jabberAddresses
{
	gJabbers = [[NSMutableArray alloc] init];
	for (int j = 0; j < [jabberAddresses count]; j++) {
		NSString *label = [jabberAddresses labelAtIndex:j];
		NSString *value = [jabberAddresses valueAtIndex:j];
		GDataIM *gIM =  [GDataIM IMWithProtocol:[GoogleExport makeRelFromLabel:@"jabber"] rel:[GoogleExport makeRelFromLabel:label] label:nil address:value];
		[gJabbers addObject:gIM];
	}
	return YES;
}

- (BOOL)exportMSNAddresses:(ABMultiValue *)MSNAddresses 
{
	gMSNs = [[NSMutableArray alloc] init];
	for (int j = 0; j < [MSNAddresses count]; j++) {
		NSString *label = [MSNAddresses labelAtIndex:j];
		NSString *value = [MSNAddresses valueAtIndex:j];
		GDataIM *gIM =  [GDataIM IMWithProtocol:[GoogleExport makeRelFromLabel:@"msn"]	rel:[GoogleExport makeRelFromLabel:label] label:nil address:value];
		[gMSNs addObject:gIM];
	}
	return YES;
}

- (BOOL)exportYahooAddresses:(ABMultiValue *)yahooAddresses 
{
	gYahoos = [[NSMutableArray alloc] init];
	for (int j = 0; j < [yahooAddresses count]; j++) {
		NSString *label = [yahooAddresses labelAtIndex:j];
		NSString *value = [yahooAddresses valueAtIndex:j];
		GDataIM *gIM =  [GDataIM IMWithProtocol:[GoogleExport makeRelFromLabel:@"yahoo"] rel:[GoogleExport makeRelFromLabel:label] label:nil address:value];
		[gYahoos addObject:gIM];
	}
	return YES;
}

- (BOOL)exportICQAddresses:(ABMultiValue *)ICQAddresses 
{
	gICQs = [[NSMutableArray alloc] init];
	for (int j = 0; j < [ICQAddresses count]; j++) {
		NSString *label = [ICQAddresses labelAtIndex:j];
		NSString *value = [ICQAddresses valueAtIndex:j];
		GDataIM *gIM =  [GDataIM IMWithProtocol:[GoogleExport makeRelFromLabel:@"icq"] rel:[GoogleExport makeRelFromLabel:label] label:nil address:value];
		[gICQs addObject:gIM];
	}
	return YES;
}

- (BOOL)exportNote:(NSString *)note	
{
	gContent =  [GDataEntryContent textConstructWithString:note];
	return YES;
}

- (BOOL)exportMiddleName:(NSString *)middleName { return YES; }

- (BOOL)exportMiddleNamePhonetic:(NSString *)middleNamePhonetic { return YES; }

- (BOOL)exportTitle:(NSString *)title { return YES; }

- (BOOL)exportSuffix:(NSString *)suffix { return YES; }

- (BOOL)exportNickName:(NSString *)nickName 
{
	nick = nickName;
	return YES;
}

- (BOOL)exportMaidenName:(NSString *)maidenName { return YES; }

- (BOOL)exportOtherDates:(ABMultiValue *)otherDates { return YES; }

- (BOOL)exportRelatedNames:(ABMultiValue *)relatedNames { return YES; }

- (BOOL)finalizePerson 
{
	NSString *title = @"";

	if (first) {		
		title = [title stringByAppendingString:first];
	}
	if (last) {
		title = [title stringByAppendingString:@" "];
		title = [title stringByAppendingString:last];
	}
	if (!first && !last && nick) {
		title = nick;
	}
	
	if (company) {
		title = [gOrganization orgName];
	}
	
	if ([title compare:@""] == NSOrderedSame) {
		[super addWarningMessage:@"Contact without name, nickname or company."];
		alert = YES;
	}

	GDataEntryContact *contact = [GDataEntryContact contactEntryWithTitle:title];
	if (gOrganization) {
		[contact addOrganization:gOrganization];
	}

	for (int i = 0; i < [gMails count]; i++) {
		[contact addEmailAddress:[gMails objectAtIndex:i]];
	}
	[gMails release];
	
	for (int i = 0; i < [gAddresses count]; i++) {
		[contact addPostalAddress:[gAddresses objectAtIndex:i]];
	}
	[gAddresses release];
	
	for (int i = 0; i < [gPhones count]; i++) {
		[contact addPhoneNumber:[gPhones objectAtIndex:i]];
	}
	[gPhones release];
	
	for (int i = 0; i < [gAIMs count]; i++) {
		[contact addIMAddress:[gAIMs objectAtIndex:i]];
	}
	[gAIMs release];
	
	for (int i = 0; i < [gJabbers count]; i++) {
		[contact addIMAddress:[gJabbers objectAtIndex:i]];
	}
	[gJabbers release];
	
	for (int i = 0; i < [gMSNs count]; i++) {
		[contact addIMAddress:[gMSNs objectAtIndex:i]];
	}
	[gMSNs release];
	
	for (int i = 0; i < [gYahoos count]; i++) {
		[contact addIMAddress:[gYahoos objectAtIndex:i]];
	}
	[gYahoos release];
	
	for (int i = 0; i < [gICQs count]; i++) {
		[contact addIMAddress:[gICQs objectAtIndex:i]];
	}
	[gICQs release];
	
	[contact setContent:gContent];

	ticket = [service fetchContactEntryByInsertingEntry:contact
											 forFeedURL:[GDataServiceGoogleContact contactFeedURLForUserID:username]
											   delegate:self
									  didFinishSelector:nil
										didFailSelector:@selector(ticket:uploadFailedWithError:)];
	// TODO It waits for each contact, this is not efficient, batch would be better but is not supported by Google yet
	[service waitForTicket:ticket timeout:TIMEOUT fetchedObject:nil error:nil];
	numberExported++;
	
	first = nil;
	last = nil;
	nick = nil;
	contact = nil;
	gOrganization = nil;
	gMails = nil;
	gMails = nil;
	gAddresses = nil;
	gPhones = nil;
	gAIMs = nil;
	gJabbers = nil;
	gMSNs = nil;
	gYahoos = nil;
	gICQs = nil;
	gContent = nil;
	
	return !alert;
}

- (BOOL)finalize 
{
	[collectedMails release];
	collectedMails = nil;
	return !alert;
}

#pragma mark -

- (void)ticket:(GDataServiceTicket *)thisTicket backupFinishedWithFeed:(GDataFeedContact *)feed
{
	if ([[feed entries] count] == 0) {
		[super addWarningMessage:@"No backup created as you didn't have any Google Contacts yet."];
		// This is not serious as it may be possible that the user has no Google Contacts yet, export should continue
		// The icon will indicate success, which is wrong because this is a warning but if I set the alert to YES here the export will not start
	}
	
	NSXMLDocument *doc = [feed XMLDocument];
    NSData* data = [doc XMLDataWithOptions:NSXMLNodePrettyPrint];
	RotatingBackup *backup = [[RotatingBackup alloc] initWithFilename:@"google_backup.xml" data:data];
	[backup createBackupFolder];
	[backup removeOldFilesInFolder];
	[backup save];
	[backup release];
	backup = nil;
}

- (void)ticket:(GDataServiceTicket *)thisTicket backupFailedWithError:(NSError *)error
{
	[super addWarningMessage:@"Google backup failed."];
	alert = YES;
}

- (void)ticket:(GDataServiceTicket *)thisTicket fetchFinishedWithFeed:(GDataFeedContact *)feed
{
	// Remove contact per contact
	for (GDataEntryContact *contact in [feed entries]) {
		NSArray *entryLinks = [contact links];
		NSURL *removeURL = [[entryLinks editLink] URL];
		[service deleteContactResourceURL:removeURL
								 delegate:self 
						didFinishSelector:nil
						  didFailSelector:@selector(ticket:removeFailedWithError:)];
	}
	// FIXME: The delete method will time out (return NO) but the contact is removed, wihtout the wait ticket nothing happens... WTF?
	[service waitForTicket:ticket timeout:1 fetchedObject:nil error:nil];
}

- (void)ticket:(GDataServiceTicket *)thisTicket fetchFailedWithError:(NSError *)error
{
	[super addWarningMessage:@"Couldn't retrieve previous Google Contacts."];
	alert = YES;
}

- (void)ticket:(GDataServiceTicket *)thisTicket removeFailedWithError:(NSError *)error
{
	[super addWarningMessage:@"Couldn't remove all previous Google Contacts."];
	alert = YES;
}

- (void)ticket:(GDataServiceTicket *)thisTicket uploadFailedWithError:(NSError *)error
{
	// Extract the contact's name for the contact that went fubar
	NSDictionary *userInfo =[error userInfo];
	NSString *authError = [userInfo authenticationError];
	NSXMLDocument *userXml = [[NSXMLDocument alloc] initWithXMLString:[userInfo valueForKey:@"error"] options:NSXMLNodeOptionsNone error:nil];
	NSString *title = [[userXml nodesForXPath:@"/entry/title/text()" error:nil] objectAtIndex:0];
	[userXml release];
	userXml = nil;
	
	if([error code] == 409) {
		[super addErrorMessage:(NSString *)[NSString stringWithFormat:@"Duplicate e-mail address for %@.", title]];
    } else if ([authError isEqual:kGDataServiceErrorCaptchaRequired]) {
		[super addErrorMessage:@"Captcha required, your account is blocked."];
    } else {
		[super addWarningMessage:(NSString *)[NSString stringWithFormat:@"Something went wrong with %@ (%i).", title, [error code]]];
	}
	alert = YES;	
}

@synthesize service;
@synthesize filename;
@synthesize username;
@synthesize password;
@synthesize first;
@synthesize last;
@synthesize nick;
@synthesize gOrganization;
@synthesize gMails;
@synthesize gAddresses;
@synthesize gPhones;
@synthesize gAIMs;
@synthesize gJabbers;
@synthesize gMSNs;
@synthesize gYahoos;
@synthesize gICQs;
@synthesize gContent;
@synthesize ticket;
@synthesize collectedMails;
@synthesize alert;
@end