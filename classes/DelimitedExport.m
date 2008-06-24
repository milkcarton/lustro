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
 
 Created by Jelle Vandebeeck on 2008.05.23.
*/

#import "DelimitedExport.h"

#define MAX_ELEMENTS 5;			// The max number of elements shown from a container.

@implementation DelimitedExport

- (BOOL)initialize
{
	content = @"";
	if (showHeader)
		[self printHeader];
	return [super initialize];
}

- (void)printHeader
{			
	content = [content stringByAppendingString:NSLocalizedString(@"FIRST_NAME", nil)];					// first name.
	content = [content stringByAppendingString:[self delimiter]];				// last name.
	content = [content stringByAppendingString:NSLocalizedString(@"LAST_NAME", nil)];
	content = [content stringByAppendingString:[self delimiter]];				// first name phonetic.
	content = [content stringByAppendingString:NSLocalizedString(@"FIRST_PHON", nil)];
	content = [content stringByAppendingString:[self delimiter]];				// last name phonetic.
	content = [content stringByAppendingString:NSLocalizedString(@"LAST_PHON", nil)];
	content = [content stringByAppendingString:[self delimiter]];				// birthday.
	content = [content stringByAppendingString:NSLocalizedString(@"BIRTH", nil)];
	content = [content stringByAppendingString:[self delimiter]];				// organization.
	content = [content stringByAppendingString:NSLocalizedString(@"ORG", nil)];	
	content = [content stringByAppendingString:[self delimiter]];				// department.
	content = [content stringByAppendingString:NSLocalizedString(@"DEP", nil)];
	content = [content stringByAppendingString:[self delimiter]];				// jobtilte.
	content = [content stringByAppendingString:NSLocalizedString(@"JOB", nil)];
	
	int max = MAX_ELEMENTS;
	for (int i = 0; i < max; i++) {												// URL's.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"URL", nil), i+1]];
	}
	for (int i = 0; i < max; i++) {												// calendar URL's.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"CAL_URL", nil), i+1]];
	}
	for (int i = 0; i < max; i++) {												// emails.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"EMAIL", nil), i+1]];
	}		
	for (int i = 0; i < max; i++) {												// addresses.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"ADDRESS", nil), i+1]];
	}
	for (int i = 0; i < max; i++) {												// phones.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"PHONE", nil), i+1]];
	}
	for (int i = 0; i < max; i++) {												// AIM addresses.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"AIM", nil), i+1]];
	}
	for (int i = 0; i < max; i++) {												// Jabber addresses.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"JABBER", nil), i+1]];
	}
	for (int i = 0; i < max; i++) {												// MSN addresses.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"MSN", nil), i+1]];
	}
	for (int i = 0; i < max; i++) {												// Yahoo addresses.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"YAHOO", nil), i+1]];
	}
	for (int i = 0; i < max; i++) {												// ICQ addresses.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"ICQ", nil), i+1]];
	}
	content = [content stringByAppendingString:[self delimiter]];				// note.
	content = [content stringByAppendingString:NSLocalizedString(@"NOTE", nil)];
	content = [content stringByAppendingString:[self delimiter]];				// middle name.
	content = [content stringByAppendingString:NSLocalizedString(@"MIDDLE_NAME", nil)];
	content = [content stringByAppendingString:[self delimiter]];				// middle name phonetic.
	content = [content stringByAppendingString:NSLocalizedString(@"MIDDLE_PHON", nil)];
	content = [content stringByAppendingString:[self delimiter]];				// title.
	content = [content stringByAppendingString:NSLocalizedString(@"TIT", nil)];
	content = [content stringByAppendingString:[self delimiter]];				// suffix.
	content = [content stringByAppendingString:NSLocalizedString(@"SUFFIX", nil)];
	content = [content stringByAppendingString:[self delimiter]];				// nick name.
	content = [content stringByAppendingString:NSLocalizedString(@"NICK", nil)];
	content = [content stringByAppendingString:[self delimiter]];				// maiden name.
	content = [content stringByAppendingString:NSLocalizedString(@"MAIDEN", nil)];
	for (int i = 0; i < max; i++) {												// other dates.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"OTHER_DATES", nil), i+1]];
	}
	for (int i = 0; i < max; i++) {												// related names.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"RELATED", nil), i+1]];
	}		

	[self finalizePerson];
}

- (void)addText:(NSString *)text
{
	if ([lineTemp length] > 0)
		lineTemp = [lineTemp stringByAppendingString:[self delimiter]];
	lineTemp = [lineTemp stringByAppendingString:text];
}

- (void)addContainer:(ABMultiValue *)container
{
	int max = MAX_ELEMENTS;
	if(container) {
		// Loop all the elements in the container.
		for (int i = 0; i < [container count] && i < max; i++) {
			NSString *text = [container valueAtIndex:i];
			if ([lineTemp length] > 0)
				lineTemp = [lineTemp stringByAppendingString:[self delimiter]];
			lineTemp = [lineTemp stringByAppendingString:text];
		}
		// Add spaces to the lineTemp to reach the MAX_ELEMENTS
		for (int e = 0; [container count] < max && e < (max - [container count]); e++) {
			if ([lineTemp length] > 0)
				lineTemp = [lineTemp stringByAppendingString:[self delimiter]];
			lineTemp = [lineTemp stringByAppendingString:@""];
		}
	} else {
		
		// Set all MAX places to spaces.
		for (int e = 0; e < max; e++) {
			if ([lineTemp length] > 0)
				lineTemp = [lineTemp stringByAppendingString:[self delimiter]];
			lineTemp = [lineTemp stringByAppendingString:@""];
		}
	}
}

- (void)addArray:(NSArray *)array
{
	if(array) {
		int i = MAX_ELEMENTS;
		// Loop all the elements in the container.
		for (NSString *text in array) {
			if ([lineTemp length] > 0)
				lineTemp = [lineTemp stringByAppendingString:[self delimiter]];
			lineTemp = [lineTemp stringByAppendingString:text];
			i--;
			if (i == 0) break;
		}
		// Add spaces to the lineTemp to reach the MAX_ELEMENTS
		for (int e = 0; e < i; e++) {
			if ([lineTemp length] > 0)
				lineTemp = [lineTemp stringByAppendingString:[self delimiter]];
			lineTemp = [lineTemp stringByAppendingString:@""];
		}
	} else {
		int max = MAX_ELEMENTS;
		// Set all MAX places to spaces.
		for (int e = 0; e < max; e++) {
			if ([lineTemp length] > 0)
				[lineTemp stringByAppendingString:[self delimiter]];
			lineTemp = [lineTemp stringByAppendingString:@""];
		}
	}
}

- (BOOL)exportFirstName:(NSString *)firstName
{
	lineTemp = @"";
	if (firstName) {
		lineTemp = [lineTemp stringByAppendingString:firstName];
		firstNameTemp = firstName;
	} else {
		lineTemp = [lineTemp stringByAppendingString:@""];
		firstNameTemp = @"";
	}
	return YES;
}

- (BOOL)exportLastName:(NSString *)lastName
{
	if (lastName) {
		[self addText:lastName];
		lastNameTemp = lastName;
	} else {
		[self addText:@""];
		lastNameTemp = @"";
	}
	return YES;
}

- (BOOL)exportFirstNamePhonetic:(NSString *)firstNamePhonetic
{
	if (firstNamePhonetic) [self addText:firstNamePhonetic];
	else [self addText:@""];
	return YES;
}

- (BOOL)exportLastNamePhonetic:(NSString *)lastNamePhonetic
{
	if (lastNamePhonetic) [self addText:lastNamePhonetic];
	else [self addText:@""];
	return YES;
}

- (BOOL)exportBirthDay:(NSCalendarDate *)birthDay
{
	if (birthDay) {
		[self addText:[birthDay descriptionWithCalendarFormat:@"%Y-%m-%d"]];
	} else [self addText:@""];
	return YES;
}

- (BOOL)exportOrganization:(NSString *)organization
{
	if (organization) {
		[self addText:organization];
		organisationTemp = organization;
	} else {
		[self addText:@""];
		organisationTemp = @"";
	}
	return YES;
}

- (BOOL)exportDepartment:(NSString *)department
{
	if (department) [self addText:department];
	else [self addText:@""];
	return YES;
}

- (BOOL)exportJobTitle:(NSString *)jobTitle
{
	if (jobTitle) [self addText:jobTitle];
	else [self addText:@""];
	return YES;
}

- (BOOL)exportURLs:(ABMultiValue *)URLs
{
	[self addContainer:URLs];
	return YES;
}

- (BOOL)exportCalendarURLs:(ABMultiValue *)calendarURLs
{
	[self addContainer:calendarURLs];
	return YES;
}

- (BOOL)exportEmails:(ABMultiValue *)emails
{
	[self addContainer:emails];
	return YES;
}

- (BOOL)exportAddresses:(ABMultiValue *)addresses
{
	NSMutableArray *addressesArray = [NSMutableArray array];
	
	for (int i=0; i < [addresses count]; i++) {
		NSString *addressOutput = @"";
		NSDictionary *address = [addresses valueAtIndex:i];
		// Add street.
		if ([address objectForKey:@"Street"]) {
			addressOutput = [addressOutput stringByAppendingString:[address objectForKey:@"Street"]];	
		}
		if ([address objectForKey:@"City"]) {
			if ([addressOutput length] > 0) addressOutput = [addressOutput stringByAppendingString:@" "];
			addressOutput = [addressOutput stringByAppendingString:[address objectForKey:@"City"]];
		}
		if ([address objectForKey:@"ZIP"]) {
			if ([addressOutput length] > 0) addressOutput = [addressOutput stringByAppendingString:@" "];
			addressOutput = [addressOutput stringByAppendingString:[address objectForKey:@"ZIP"]];
		}
		if ([address objectForKey:@"region"]) {
			if ([addressOutput length] > 0) addressOutput = [addressOutput stringByAppendingString:@" "];
			addressOutput = [addressOutput stringByAppendingString:[address objectForKey:@"Province"]];
		}
		if ([address objectForKey:@"Country"]) {
			if ([addressOutput length] > 0) addressOutput = [addressOutput stringByAppendingString:@" "];
			addressOutput = [addressOutput stringByAppendingString:[address objectForKey:@"Country"]];
		}
		if ([addressOutput length] > 0)
			[addressesArray addObject:addressOutput];
	}
	[self addArray:addressesArray];
	return YES;
}

- (BOOL)exportPhones:(ABMultiValue *)phones
{
	[self addContainer:phones];
	return YES;
}

- (BOOL)exportAIMAddresses:(ABMultiValue *)AIMAddresses
{
	[self addContainer:AIMAddresses];
	return YES;
}

- (BOOL)exportJabberAddresses:(ABMultiValue *)jabberAddresses
{
	[self addContainer:jabberAddresses];
	return YES;
}

- (BOOL)exportMSNAddresses:(ABMultiValue *)MSNAddresses
{
	[self addContainer:MSNAddresses];
	return YES;
}

- (BOOL)exportYahooAddresses:(ABMultiValue *)yahooAddresses
{
	[self addContainer:yahooAddresses];
	return YES;
}

- (BOOL)exportICQAddresses:(ABMultiValue *)ICQAddresses
{
	[self addContainer:ICQAddresses];
	return YES;
}

- (BOOL)exportNote:(NSString *)note
{
	if (note) [self addText:note];
	else [self addText:@""];
	return YES;
}

- (BOOL)exportMiddleName:(NSString *)middleName
{
	if (middleName) [self addText:middleName];
	else [self addText:@""];
	return YES;
}

- (BOOL)exportMiddleNamePhonetic:(NSString *)middleNamePhonetic
{
	if (middleNamePhonetic) [self addText:middleNamePhonetic];
	else [self addText:@""];
	return YES;
}

- (BOOL)exportTitle:(NSString *)title
{
	if (title) [self addText:title];
	else [self addText:@""];
	return YES;
}

- (BOOL)exportSuffix:(NSString *)suffix
{
	if (suffix) [self addText:suffix];
	else [self addText:@""];
	return YES;
}

- (BOOL)exportNickName:(NSString *)nickName
{
	if (nickName) [self addText:nickName];
	else [self addText:@""];
	return YES;
}

- (BOOL)exportMaidenName:(NSString *)maidenName
{
	if (maidenName) [self addText:maidenName];
	else [self addText:@""];
	return YES;
}

- (BOOL)exportOtherDates:(ABMultiValue *)otherDates
{
	[self addContainer:otherDates];
	return YES;
}

- (BOOL)exportRelatedNames:(ABMultiValue *)relatedNames
{
	[self addContainer:relatedNames];
	return YES;
}

- (BOOL)finalizePerson
{
	lineTemp = [lineTemp stringByAppendingString:@"\n"];
	[arrayContent addObject:[NSDictionary dictionaryWithObjectsAndKeys:firstNameTemp, @"FIRST", lastNameTemp, @"LAST", organisationTemp, @"ORG", lineTemp, @"CONTENT", nil]];
	numberExported++;
	return YES;
}

@synthesize showHeader;
@end
