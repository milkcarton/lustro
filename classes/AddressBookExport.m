//
//  AddressBookExport.m
//  lustro
//
//  Created by Jelle Vandebeeck on 21/05/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import "AddressBookExport.h"

@implementation AddressBookExport

- (id)init
{
	self = [super init];
	addressBook = [ABAddressBook sharedAddressBook];
	return self;
}

+ (NSString *)cleanLabel:(NSString *)label
{	
	if ([label compare:@"_$!<" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 4)] == NSOrderedSame) {
		int end = [label length]-8;
		return [label substringWithRange:NSMakeRange(4, end)];
	}
	return label;
}

- (int)export
{	
	BOOL ok = [self initialize];
	NSArray *contacts = [addressBook people];
	numberExported = 0;
	
	// When the initialize went ok AND there are contacts available then loop the list
	if(ok && [contacts count] > 0) {
		kExportStatus status = kExportSuccess;
		// Loop the contacts.
		for (ABPerson *person in contacts) {
			NSString *firstName = [person valueForProperty:kABFirstNameProperty];						// first name.
			if (![self exportFirstName:firstName]) status = kExportWarning;
			NSString *lastName = [person valueForProperty:kABLastNameProperty];							// last name.
			if (![self exportLastName:lastName]) status = kExportWarning;
			NSString *firstNamePhonetic = [person valueForProperty:kABFirstNamePhoneticProperty];		// first name phonetic.
			if (![self exportFirstNamePhonetic:firstNamePhonetic]) status = kExportWarning;
			NSString *lastNamePhonetic = [person valueForProperty:kABLastNamePhoneticProperty];			// last name phonetic.
			if (![self exportLastNamePhonetic:lastNamePhonetic]) status = kExportWarning;
			NSCalendarDate *birthDay = [person valueForProperty:kABBirthdayProperty];							// birthday.
			if (![self exportBirthDay:birthDay]) status = kExportWarning;
			NSString *organization = [person valueForProperty:kABOrganizationProperty];					// organization.
			if (![self exportOrganization:organization]) status = kExportWarning;
			NSString *department = [person valueForProperty:kABDepartmentProperty];						// department.
			if (![self exportDepartment:department]) status = kExportWarning;
			NSString *jobTitle = [person valueForProperty:kABJobTitleProperty];							// jobtilte.
			if (![self exportJobTitle:jobTitle]) status = kExportWarning;
			ABMultiValue *URLs = [person valueForProperty:kABURLsProperty];								// URL's.
			if (![self exportURLs:URLs]) status = kExportWarning;
			ABMultiValue *calendarURLs = [person valueForProperty:kABCalendarURIsProperty];				// calendar URL's.
			if (![self exportCalendarURLs:calendarURLs]) status = kExportWarning;
			ABMultiValue *emails = [person valueForProperty:kABEmailProperty];							// emails.
			if (![self exportEmails:emails]) status = kExportWarning;
			ABMultiValue *addresses = [person valueForProperty:kABAddressProperty];						// addresses.
			if (![self exportAddresses:addresses]) status = kExportWarning;
			ABMultiValue *phones = [person valueForProperty:kABPhoneProperty];							// phones.
			if (![self exportPhones:phones]) status = kExportWarning;
			ABMultiValue *AIMAddresses = [person valueForProperty:kABAIMInstantProperty];				// AIM addresses.
			if (![self exportAIMAddresses:AIMAddresses]) status = kExportWarning;
			ABMultiValue *jabberAddresses = [person valueForProperty:kABJabberInstantProperty];			// Jabber addresses.
			if (![self exportJabberAddresses:jabberAddresses]) status = kExportWarning;
			ABMultiValue *MSNAddresses = [person valueForProperty:kABMSNInstantProperty];				// MSN addresses.
			if (![self exportMSNAddresses:MSNAddresses]) status = kExportWarning;
			ABMultiValue *yahooAddresses = [person valueForProperty:kABYahooInstantProperty];			// Yahoo addresses.
			if (![self exportYahooAddresses:yahooAddresses]) status = kExportWarning;
			ABMultiValue *ICQAddresses = [person valueForProperty:kABICQInstantProperty];				// ICQ addresses.
			if (![self exportICQAddresses:ICQAddresses]) status = kExportWarning;
			NSString *note = [person valueForProperty:kABNoteProperty];									// note.
			if (![self exportNote:note]) status = kExportWarning;
			NSString *middleName = [person valueForProperty:kABMiddleNameProperty];						// middle name.
			if (![self exportMiddleName:middleName]) status = kExportWarning;
			NSString *middleNamePhonetic = [person valueForProperty:kABMiddleNamePhoneticProperty];		// middle name phonetic.
			if (![self exportMiddleName:middleNamePhonetic]) status = kExportWarning;
			NSString *title = [person valueForProperty:kABTitleProperty];								// title.
			if (![self exportTitle:title]) status = kExportWarning;
			NSString *suffix = [person valueForProperty:kABSuffixProperty];								// suffix.
			if (![self exportSuffix:suffix]) status = kExportWarning;
			NSString *nickName = [person valueForProperty:kABNicknameProperty];							// nick name.
			if (![self exportNickName:nickName]) status = kExportWarning;
			NSString *maidenName = [person valueForProperty:kABMaidenNameProperty];						// maiden name.
			if (![self exportMaidenName:maidenName]) status = kExportWarning;
			ABMultiValue *otherDates = [person valueForProperty:kABOtherDatesProperty];					// other dates.
			if (![self exportOtherDates:otherDates]) status = kExportWarning;
			ABMultiValue *relatedNames = [person valueForProperty:kABRelatedNamesProperty];				// related names.
			if (![self exportRelatedNames:relatedNames]) status = kExportWarning;
			
			[self finalizePerson];
		}
		if ([self finalize]) {
			[self addSuccessMessage:[NSString stringWithFormat:@"Successfully exported %i contacts.", numberExported]];
			return status;
		} else {
			return kExportError;
		}
	} else {
		[self addWarningMessage:@"No contacts found."];
		return kExportWarning;
	}
}

- (void)dealloc
{
	[addressBook release];
	[delegate release];
	[super dealloc];
}

- (void)addSuccessMessage:(NSString *)message
{
	// Check if method is available in the delegate.
	if ([delegate respondsToSelector:@selector(addSuccessMessage:className:)])
        [delegate addSuccessMessage:message className:[self className]];
}

- (void)addWarningMessage:(NSString *)message
{
	// Check if method is available in the delegate.
	if ([delegate respondsToSelector:@selector(addSuccessMessage:className:)])
        [delegate addWarningMessage:message className:[self className]];
}

- (void)addErrorMessage:(NSString *)message
{
	// Check if method is available in the delegate.
	if ([delegate respondsToSelector:@selector(addSuccessMessage:className:)])
        [delegate addErrorMessage:message className:[self className]];
}

@synthesize delegate;
@synthesize addressBook;
@synthesize numberExported;
@end
