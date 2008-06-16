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

#import "HTMLExport.h"

#define MAX_ELEMENTS 5;			// The max number of elements shown from a container.

@implementation HTMLExport

- (NSString *)extention
{
	return @".html";
}

- (NSString *)addSpanWithValue:(NSString *)value class:(NSString *)class
{
	NSString *HTMLentity = @"";
	HTMLentity = [HTMLentity stringByAppendingString:@"<span class=\""];
	HTMLentity = [HTMLentity stringByAppendingString:class];
	HTMLentity = [HTMLentity stringByAppendingString:@"\">"];
	HTMLentity = [HTMLentity stringByAppendingString:value];
	HTMLentity = [HTMLentity stringByAppendingString:@"</span>\n"];
	return HTMLentity;
}

- (NSString *)addAbbrWithValue:(NSString *)value class:(NSString *)class title:(NSString *)title
{
	NSString *HTMLentity = @"";
	HTMLentity = [HTMLentity stringByAppendingString:@"<abbr class=\""];
	HTMLentity = [HTMLentity stringByAppendingString:class];
	HTMLentity = [HTMLentity stringByAppendingString:@"\" title=\""];
	HTMLentity = [HTMLentity stringByAppendingString:title];
	HTMLentity = [HTMLentity stringByAppendingString:@"\">"];
	HTMLentity = [HTMLentity stringByAppendingString:value];
	HTMLentity = [HTMLentity stringByAppendingString:@"</abbr>\n"];
	return HTMLentity;
}

- (NSString *)addSpanWithOrganization:(NSString *)organization department:(NSString *)department
{
	NSString *HTMLentity = @"";
	HTMLentity = [HTMLentity stringByAppendingString:@"<span class=\"org\">"];
	if (organization)
		HTMLentity = [HTMLentity stringByAppendingString:[self addSpanWithValue:organization class:@"organization-name"]];
	if (department)
		HTMLentity = [HTMLentity stringByAppendingString:[self addSpanWithValue:department class:@"organization-unit"]];
	HTMLentity = [HTMLentity stringByAppendingString:@"</span>\n"];
	return HTMLentity;
}

- (NSString *)addEmails:(ABMultiValue *)emails
{
	NSString *mailAddresses = @"";
	for (int i = 0; i < [emails count]; i++) {
		NSString *label = [emails labelAtIndex:i];
		NSString *mail = [emails valueAtIndex:i];
		mailAddresses = [mailAddresses stringByAppendingString:@"<a class=\"email\" href=\"mailto:"];
		mailAddresses = [mailAddresses stringByAppendingString:mail];
		mailAddresses = [mailAddresses stringByAppendingString:@"\">"];
		mailAddresses = [mailAddresses stringByAppendingString:mail];
		label = [AddressBookExport cleanLabel:label];
		mailAddresses = [mailAddresses stringByAppendingString:[self addSpanWithValue:label class:@"type"]];
		mailAddresses = [mailAddresses stringByAppendingString:@"</a>\n"];
	}
	return mailAddresses;
}

- (NSString *)addPhones:(ABMultiValue *)phones
{
	NSString *phoneNumbers = @"";
	for (int i = 0; i < [phones count]; i++) {
		NSString *entity = @"";	
		NSString *label = [phones labelAtIndex:i];
		NSString *value = [phones valueAtIndex:i];
		label = [AddressBookExport cleanLabel:label];
		entity = [entity stringByAppendingString:[self addSpanWithValue:label class:@"type"]];
		entity = [entity stringByAppendingString:[self addSpanWithValue:value class:@"value"]];
		phoneNumbers = [phoneNumbers stringByAppendingString:[self addSpanWithValue:entity class:@"tel"]];
	}
	return phoneNumbers;
}

- (NSString *)addURLs:(ABMultiValue *)URLs
{
	NSString *URLsOutput = @"";
	for (int i = 0; i < [URLs count]; i++) {
		NSString *label = [URLs labelAtIndex:i];					
		NSString *URL = [URLs valueAtIndex:i];
		URLsOutput = [URLsOutput stringByAppendingString:@"<a class=\"url\" href=\""];
		URLsOutput = [URLsOutput stringByAppendingString:URL];
		URLsOutput = [URLsOutput stringByAppendingString:@"\">"];
		URLsOutput = [URLsOutput stringByAppendingString:URL];
		label = [AddressBookExport cleanLabel:label];
		URLsOutput = [URLsOutput stringByAppendingString:[self addSpanWithValue:label class:@"type"]];
		URLsOutput = [URLsOutput stringByAppendingString:@"</a>\n"];
	}
	return URLsOutput;
}

- (NSString *)addAddresses:(ABMultiValue *)addresses
{
	NSString *streetAddresses = @"";
	for (int i = 0; i < [addresses count]; i++) {
		NSString *label = [addresses labelAtIndex:i];
		NSDictionary *address = [addresses valueAtIndex:i];
		label = [AddressBookExport cleanLabel:label];
		streetAddresses = [streetAddresses stringByAppendingString:[self addSpanWithValue:label class:@"type"] ];
		if ([address objectForKey:@"Street"])
			streetAddresses = [streetAddresses stringByAppendingString:[self addSpanWithValue:[address objectForKey:@"Street"] class:@"street-address"]];	
		if ([address objectForKey:@"City"])
			streetAddresses = [streetAddresses stringByAppendingString: [self addSpanWithValue:[address objectForKey:@"City"] class:@"locality"] ];
		if ([address objectForKey:@"ZIP"])
			streetAddresses = [streetAddresses stringByAppendingString: [self addSpanWithValue:[address objectForKey:@"ZIP"] class:@"postal-code"] ];
		if ([address objectForKey:@"region"])
			streetAddresses = [streetAddresses stringByAppendingString: [self addSpanWithValue:[address objectForKey:@"Province"] class:@"region"] ];
		if ([address objectForKey:@"Country"])
			streetAddresses = [streetAddresses stringByAppendingString: [self addSpanWithValue:[address objectForKey:@"Country"] class:@"country-name"] ];
	}
	return streetAddresses;
}

#pragma mark Abstract Methods

- (BOOL)initialize
{
	// Read template from file in the resources directory
	NSError *error;
	NSString *path = [[[NSBundle mainBundle] autorelease] pathForResource:@"hCardTemplate" ofType:@""];
	NSString *hCardTemplate = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
	if (!hCardTemplate && error) [super addErrorMessage:[error localizedDescription]];
	if (!hCardTemplate) return NO;
	content = hCardTemplate;
	
	return [super initialize];
}

- (BOOL)exportFirstName:(NSString *)firstName
{
	content = [content stringByAppendingString:@"<div class=\"vcard\">\n"];
	fnName = @"";
	if (firstName) {
		content = [content stringByAppendingString:[self addSpanWithValue:firstName class:@"given-name"]];
		fnName = firstName;
	}
	return YES;
}

- (BOOL)exportLastName:(NSString *)lastName
{
	if (lastName) {
		content = [content stringByAppendingString:[self addSpanWithValue:lastName class:@"family-name"]];
		if ([fnName length] > 0) {
			fnName = [fnName stringByAppendingString:@" "];
			fnName = [fnName stringByAppendingString:lastName];
		}
	}	
	return YES;
}

- (BOOL)exportFirstNamePhonetic:(NSString *)firstNamePhonetic
{
	return YES;
}

- (BOOL)exportLastNamePhonetic:(NSString *)lastNamePhonetic
{
	return YES;
}

- (BOOL)exportBirthDay:(NSCalendarDate *)birthDay
{
	if (birthDay) {
		NSString *birthdateFormatted = [birthDay descriptionWithCalendarFormat:@"%Y-%m-%d"];
		content = [content stringByAppendingString:[self addAbbrWithValue:birthdateFormatted class:@"bday" title:birthdateFormatted]];
	}
	return YES;
}

- (BOOL)exportOrganization:(NSString *)organization
{
	org = @"";
	if (organization) {
		org = organization;
		if ([fnName length] <= 0)
			fnName = organization;
	}
	if ([fnName length] <= 0)
		fnName = @"No Name";
	content = [content stringByAppendingString:[self addSpanWithValue:fnName class:@"n fn"]];
	return YES;
}

- (BOOL)exportDepartment:(NSString *)department
{
	if ([org length] > 0 || department)
		content = [content stringByAppendingString:[self addSpanWithOrganization:org department:department]];
	return YES;
}

- (BOOL)exportJobTitle:(NSString *)jobTitle
{
	if (jobTitle)
		content = [content stringByAppendingString:[self addSpanWithValue:jobTitle class:@"title"]];
	return YES;
}

- (BOOL)exportURLs:(ABMultiValue *)URLs
{
	if (URLs)
		content = [content stringByAppendingString:[self addURLs:URLs]];
	return YES;
}

- (BOOL)exportCalendarURLs:(ABMultiValue *)calendarURLs
{
	return YES;
}

- (BOOL)exportEmails:(ABMultiValue *)emails
{
	if (emails)
		content = [content stringByAppendingString:[self addEmails:emails]];
	return YES;
}

- (BOOL)exportAddresses:(ABMultiValue *)addresses
{
	if (addresses)
		content = [content stringByAppendingString:[self addAddresses:addresses]];
	return YES;
}

- (BOOL)exportPhones:(ABMultiValue *)phones
{
	if (phones)
		content = [content stringByAppendingString:[self addPhones:phones]];
	return YES;
}

- (BOOL)exportAIMAddresses:(ABMultiValue *)AIMAddresses
{
	return YES;
}

- (BOOL)exportJabberAddresses:(ABMultiValue *)jabberAddresses
{
	return YES;
}

- (BOOL)exportMSNAddresses:(ABMultiValue *)MSNAddresses
{
	return YES;
}

- (BOOL)exportYahooAddresses:(ABMultiValue *)yahooAddresses
{
	return YES;
}

- (BOOL)exportICQAddresses:(ABMultiValue *)ICQAddresses
{
	return YES;
}

- (BOOL)exportNote:(NSString *)note
{
	if (note)
		content = [content stringByAppendingString:[self addSpanWithValue:note class:@"note"]];
	return YES;
}

- (BOOL)exportMiddleName:(NSString *)middleName
{
	if (middleName)
		content = [content stringByAppendingString:[self addSpanWithValue:middleName class:@"additional-name"]];
	return YES;
}

- (BOOL)exportMiddleNamePhonetic:(NSString *)middleNamePhonetic
{
	return YES;
}

- (BOOL)exportTitle:(NSString *)title
{
	return YES;
}

- (BOOL)exportSuffix:(NSString *)suffix
{
	if (suffix)
		content = [content stringByAppendingString:[self addSpanWithValue:suffix class:@"honorific-suffix"]];
	return YES;
}

- (BOOL)exportNickName:(NSString *)nickName
{
	if (nickName)
		content = [content stringByAppendingString:[self addSpanWithValue:nickName class:@"nickname"]];
	return YES;
}

- (BOOL)exportMaidenName:(NSString *)maidenName
{
	return YES;
}

- (BOOL)exportOtherDates:(ABMultiValue *)otherDates
{
	return YES;
}

- (BOOL)exportRelatedNames:(ABMultiValue *)relatedNames
{
	return YES;
}

- (BOOL)finalizePerson
{
	content = [content stringByAppendingString:@"</div>\n"];
	numberExported++;
	return YES;
}

- (BOOL)finalize
{
	content = [content stringByAppendingString:@"\n</body>\n</html>\n"];
	return [super finalize];
}

@end
