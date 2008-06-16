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
	content = [content stringByAppendingString:@"first name"];					// first name.
	content = [content stringByAppendingString:[self delimiter]];				// last name.
	content = [content stringByAppendingString:@"last name"];
	content = [content stringByAppendingString:[self delimiter]];				// first name phonetic.
	content = [content stringByAppendingString:@"first name phonetic"];
	content = [content stringByAppendingString:[self delimiter]];				// last name phonetic.
	content = [content stringByAppendingString:@"last name phonetic"];
	content = [content stringByAppendingString:[self delimiter]];				// birthday.
	content = [content stringByAppendingString:@"birthday"];
	content = [content stringByAppendingString:[self delimiter]];				// organization.
	content = [content stringByAppendingString:@"organization"];	
	content = [content stringByAppendingString:[self delimiter]];				// department.
	content = [content stringByAppendingString:@"department"];
	content = [content stringByAppendingString:[self delimiter]];				// jobtilte.
	content = [content stringByAppendingString:@"jobtitle"];
	
	int max = MAX_ELEMENTS;
	for (int i = 0; i < max; i++) {												// URL's.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:@"URL %i", i+1]];
	}
	for (int i = 0; i < max; i++) {												// calendar URL's.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:@"calendar URL %i", i+1]];
	}
	for (int i = 0; i < max; i++) {												// emails.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:@"email %i", i+1]];
	}		
	for (int i = 0; i < max; i++) {												// addresses.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:@"address %i", i+1]];
	}
	for (int i = 0; i < max; i++) {												// phones.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:@"phone %i", i+1]];
	}
	for (int i = 0; i < max; i++) {												// AIM addresses.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:@"AIM address %i", i+1]];
	}
	for (int i = 0; i < max; i++) {												// Jabber addresses.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:@"Jabber address %i", i+1]];
	}
	for (int i = 0; i < max; i++) {												// MSN addresses.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:@"MSN address %i", i+1]];
	}
	for (int i = 0; i < max; i++) {												// Yahoo addresses.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:@"Yahoo address %i", i+1]];
	}
	for (int i = 0; i < max; i++) {												// ICQ addresses.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:@"ICQ address %i", i+1]];
	}
	content = [content stringByAppendingString:[self delimiter]];				// note.
	content = [content stringByAppendingString:@"note"];
	content = [content stringByAppendingString:[self delimiter]];				// middle name.
	content = [content stringByAppendingString:@"middle name"];
	content = [content stringByAppendingString:[self delimiter]];				// middle name phonetic.
	content = [content stringByAppendingString:@"middle name phonetic"];
	content = [content stringByAppendingString:[self delimiter]];				// title.
	content = [content stringByAppendingString:@"title"];
	content = [content stringByAppendingString:[self delimiter]];				// suffix.
	content = [content stringByAppendingString:@"suffix"];
	content = [content stringByAppendingString:[self delimiter]];				// nick name.
	content = [content stringByAppendingString:@"nick name"];
	content = [content stringByAppendingString:[self delimiter]];				// maiden name.
	content = [content stringByAppendingString:@"maiden name"];
	for (int i = 0; i < max; i++) {												// other dates.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:@"other dates %i", i+1]];
	}
	for (int i = 0; i < max; i++) {												// related names.
		content = [content stringByAppendingString:[self delimiter]];
		content = [content stringByAppendingString:[NSString stringWithFormat:@"related names %i", i+1]];
	}		

	[self finalizePerson];
}

- (void)addText:(NSString *)text
{
	if ([content length] > 0)
		content = [content stringByAppendingString:[self delimiter]];
	content = [content stringByAppendingString:text];
}

- (void)addContainer:(ABMultiValue *)container
{
	int max = MAX_ELEMENTS;
	if(container) {
		// Loop all the elements in the container.
		for (int i = 0; i < [container count] && i < max; i++) {
			NSString *text = [container valueAtIndex:i];
			if ([content length] > 0)
				content = [content stringByAppendingString:[self delimiter]];
			content = [content stringByAppendingString:text];
		}
		// Add spaces to the content to reach the MAX_ELEMENTS
		for (int e = 0; [container count] < max && e < (max - [container count]); e++) {
			if ([content length] > 0)
				content = [content stringByAppendingString:[self delimiter]];
			content = [content stringByAppendingString:@""];
		}
	} else {
		
		// Set all MAX places to spaces.
		for (int e = 0; e < max; e++) {
			if ([content length] > 0)
				content = [content stringByAppendingString:[self delimiter]];
			content = [content stringByAppendingString:@""];
		}
	}
}

- (void)addArray:(NSArray *)array
{
	if(array) {
		int i = MAX_ELEMENTS;
		// Loop all the elements in the container.
		for (NSString *text in array) {
			if ([content length] > 0)
				content = [content stringByAppendingString:[self delimiter]];
			content = [content stringByAppendingString:text];
			i--;
			if (i == 0) break;
		}
		// Add spaces to the content to reach the MAX_ELEMENTS
		for (int e = 0; e < i; e++) {
			if ([content length] > 0)
				content = [content stringByAppendingString:[self delimiter]];
			content = [content stringByAppendingString:@""];
		}
	} else {
		int max = MAX_ELEMENTS;
		// Set all MAX places to spaces.
		for (int e = 0; e < max; e++) {
			if ([content length] > 0)
				[content stringByAppendingString:[self delimiter]];
			content = [content stringByAppendingString:@""];
		}
	}
}

- (BOOL)exportFirstName:(NSString *)firstName
{
	if (firstName) content = [content stringByAppendingString:firstName];
	else content = [content stringByAppendingString:@""];
	return YES;
}

- (BOOL)exportLastName:(NSString *)lastName
{
	if (lastName) [self addText:lastName];
	else [self addText:@""];
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
	if (organization) [self addText:organization];
	else [self addText:@""];
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
	content = [content stringByAppendingString:@"\n"];
	numberExported++;
	return YES;
}

@synthesize showHeader;
@end
