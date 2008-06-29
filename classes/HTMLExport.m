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
	return @"html";
}

- (NSString *)title
{
	return @"Save File with hCards";
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

- (NSString *)addDivWithValue:(NSString *)value class:(NSString *)class
{
	NSString *HTMLentity = @"";
	HTMLentity = [HTMLentity stringByAppendingString:@"<div class=\""];
	HTMLentity = [HTMLentity stringByAppendingString:class];
	HTMLentity = [HTMLentity stringByAppendingString:@"\">"];
	HTMLentity = [HTMLentity stringByAppendingString:value];
	HTMLentity = [HTMLentity stringByAppendingString:@"</div>\n"];
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
	NSString *mailAddresses = @"<div>";
	for (int i = 0; i < [emails count]; i++) {
		NSString *label = [emails labelAtIndex:i];
		NSString *mail = [emails valueAtIndex:i];
		mailAddresses = [mailAddresses stringByAppendingString:@"<a class=\"email\" href=\"mailto:"];
		mailAddresses = [mailAddresses stringByAppendingString:mail];
		mailAddresses = [mailAddresses stringByAppendingString:@"\">"];
		mailAddresses = [mailAddresses stringByAppendingString:mail];
		label = [AddressBookExport cleanLabel:label];
		mailAddresses = [mailAddresses stringByAppendingString:@" "];
		mailAddresses = [mailAddresses stringByAppendingString:[self addSpanWithValue:label class:@"type"]];
		mailAddresses = [mailAddresses stringByAppendingString:@"</a><br />\n"];
	}
	mailAddresses = [mailAddresses stringByAppendingString:@"</div>\n"];
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
		entity = [entity stringByAppendingString:[self addSpanWithValue:value class:@"value"]];
		entity = [entity stringByAppendingString:[self addSpanWithValue:label class:@"type"]];
		phoneNumbers = [phoneNumbers stringByAppendingString:[self addSpanWithValue:entity class:@"tel"]];
	}
	return phoneNumbers;
}

- (NSString *)addURLs:(ABMultiValue *)URLs
{
	NSString *URLsOutput = @"<div class=\"urls\">\n";
	for (int i = 0; i < [URLs count]; i++) {
		NSString *label = [URLs labelAtIndex:i];					
		NSString *URL = [URLs valueAtIndex:i];
		URLsOutput = [URLsOutput stringByAppendingString:@"<a class=\"url\" href=\""];
		URLsOutput = [URLsOutput stringByAppendingString:URL];
		URLsOutput = [URLsOutput stringByAppendingString:@"\">"];
		URLsOutput = [URLsOutput stringByAppendingString:URL];
		URLsOutput = [URLsOutput stringByAppendingString:@" "];
		label = [AddressBookExport cleanLabel:label];
		URLsOutput = [URLsOutput stringByAppendingString:[self addSpanWithValue:label class:@"type"]];
		URLsOutput = [URLsOutput stringByAppendingString:@"</a><br />\n"];
	}
	URLsOutput = [URLsOutput stringByAppendingString:@"</div>\n"];
	return URLsOutput;
}

- (NSString *)addAddresses:(ABMultiValue *)addresses
{
	NSString *streetAddresses = @"";
	for (int i = 0; i < [addresses count]; i++) {
		NSString *label = [addresses labelAtIndex:i];
		NSDictionary *address = [addresses valueAtIndex:i];
		label = [AddressBookExport cleanLabel:label];
		streetAddresses = [streetAddresses stringByAppendingString:@"<div class=\"adr\">\n"];
		if ([address objectForKey:@"Street"]) {
			streetAddresses = [streetAddresses stringByAppendingString:[self addSpanWithValue:[address objectForKey:@"Street"] class:@"street-address"]];	
			streetAddresses = [streetAddresses stringByAppendingString:@"<br />\n"];
		}
		if ([address objectForKey:@"City"])
			streetAddresses = [streetAddresses stringByAppendingString: [self addSpanWithValue:[address objectForKey:@"City"] class:@"locality"] ];
		if ([address objectForKey:@"ZIP"])
			streetAddresses = [streetAddresses stringByAppendingString: [self addSpanWithValue:[address objectForKey:@"ZIP"] class:@"postal-code"] ];
		if ([address objectForKey:@"City"] || [address objectForKey:@"ZIP"])
			streetAddresses = [streetAddresses stringByAppendingString:@"<br />\n"];
		if ([address objectForKey:@"region"])
			streetAddresses = [streetAddresses stringByAppendingString: [self addSpanWithValue:[address objectForKey:@"Province"] class:@"region"] ];
		if ([address objectForKey:@"Country"])
			streetAddresses = [streetAddresses stringByAppendingString: [self addSpanWithValue:[address objectForKey:@"Country"] class:@"country-name"] ];
		streetAddresses = [streetAddresses stringByAppendingString:[self addSpanWithValue:label class:@"type"] ];
		streetAddresses = [streetAddresses stringByAppendingString:@"</div>\n"];
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
	details = [[NSMutableDictionary alloc] init];
	content = hCardTemplate;
	return [super initialize];
}

- (BOOL)exportFirstName:(NSString *)firstName
{
	fnName = @"";
	if (firstName) {
		[details setObject:[self addSpanWithValue:firstName class:@"given-name"] forKey:@"firstName"];
		fnName = firstName;
		firstNameTemp = firstName;
	} else {
		firstNameTemp = @"";
	}
	return YES;
}

- (BOOL)exportLastName:(NSString *)lastName
{
	NSString *tmp = @"";
	if (lastName) {
		lastNameTemp = lastName;
		
		NSString *firstLetter = [lastName substringWithRange:NSMakeRange(0,1)];
		if (!firstLetter) firstLetter = @"";
		[details setObject:firstLetter forKey:@"ornamentLetter"];
		
		tmp = [tmp stringByAppendingString:[self addSpanWithValue:lastName class:@"family-name"]];
		if ([fnName length] > 0) {
			fnName = [fnName stringByAppendingString:@" "];
			fnName = [fnName stringByAppendingString:lastName];
		}
	} else lastNameTemp = @"";
	[details setObject:tmp forKey:@"lastName"];
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
		NSString *tmp = @"";
		NSString *birthdateFormatted = [birthDay descriptionWithCalendarFormat:@"%Y-%m-%d"];
		tmp = [tmp stringByAppendingString:@"<div>\n"];
		tmp = [tmp stringByAppendingString:[self addAbbrWithValue:birthdateFormatted class:@"bday" title:birthdateFormatted]];
		tmp = [tmp stringByAppendingString:[self addSpanWithValue:@"bday" class:@"type"]]; // Not needed for microformats but looks nice
		tmp = [tmp stringByAppendingString:@"</div>\n"];
		[details setObject:tmp forKey:@"bday"];
	}
	return YES;
}

- (BOOL)exportOrganization:(NSString *)organization
{
	org = @"";
	if (organization) {
		organisationTemp = organization;
		org = organization;
	}
	return YES;
}

- (BOOL)exportDepartment:(NSString *)department
{
	if ([org length] > 0 || department)
		[details setObject:[self addSpanWithOrganization:org department:department] forKey:@"org"];
	return YES;
}

- (BOOL)exportJobTitle:(NSString *)jobTitle
{
	if (jobTitle)
		[details setObject:[self addSpanWithValue:jobTitle class:@"title"] forKey:@"jobTitle"];
	return YES;
}

- (BOOL)exportURLs:(ABMultiValue *)URLs
{
	if (URLs)
		[details setObject:[self addURLs:URLs] forKey:@"URLs"];
	return YES;
}

- (BOOL)exportCalendarURLs:(ABMultiValue *)calendarURLs
{
	return YES;
}

- (BOOL)exportEmails:(ABMultiValue *)emails
{
	if (emails)
		[details setObject:[self addEmails:emails] forKey:@"mails"];
	return YES;
}

- (BOOL)exportAddresses:(ABMultiValue *)addresses
{
	if (addresses)
		[details setObject:[self addAddresses:addresses] forKey:@"addresses"];
	return YES;
}

- (BOOL)exportPhones:(ABMultiValue *)phones
{
	if (phones)
		[details setObject:[self addPhones:phones] forKey:@"phones"];
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
		[details setObject:[self addDivWithValue:note class:@"note"] forKey:@"note"];
	return YES;
}

- (BOOL)exportMiddleName:(NSString *)middleName
{
	if (middleName)
		[details setObject:[self addSpanWithValue:middleName class:@"additional-name"] forKey:@"middleName"];
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
		[details setObject:[self addSpanWithValue:suffix class:@"honorific-suffix"] forKey:@"suffix"];
	return YES;
}

- (BOOL)exportNickName:(NSString *)nickName
{
	if (nickName) {
		nickName = [NSString stringWithFormat:@"-leftquote-%@-rightquote-", nickName];
		[details setObject:[self addDivWithValue:nickName class:@"nickname"] forKey:@"nickname"];
	}
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
	// Extract details from array in the order you like for the HTML layout
	lineTemp = @"<div class=\"vcard\">\n";
	if ([details objectForKey:@"ornamentLetter"]) lineTemp = [NSString stringWithFormat:@"%@<span class=\"ornament\">%@</span>\n<div class=\"card\">\n", lineTemp, [details objectForKey:@"ornamentLetter"]];
	
	lineTemp = [lineTemp stringByAppendingString:@"<div class=\"fn n\">\n"];
	
	if ([details objectForKey:@"firstName"]) lineTemp = [lineTemp stringByAppendingString:[details objectForKey:@"firstName"]];
	if ([details objectForKey:@"middleName"]) lineTemp = [lineTemp stringByAppendingString:[details objectForKey:@"middleName"]];
	if ([details objectForKey:@"lastName"]) lineTemp = [lineTemp stringByAppendingString:[details objectForKey:@"lastName"]];
	
	lineTemp = [lineTemp stringByAppendingString:@"</div>\n"];
	
	if ([details objectForKey:@"suffix"]) lineTemp = [lineTemp stringByAppendingString:[details objectForKey:@"suffix"]];
	if ([details objectForKey:@"nickname"]) lineTemp = [lineTemp stringByAppendingString:[details objectForKey:@"nickname"]];
	if ([details objectForKey:@"org"]) lineTemp = [lineTemp stringByAppendingString:[details objectForKey:@"org"]];
	if ([details objectForKey:@"jobTitle"]) lineTemp = [lineTemp stringByAppendingString:[details objectForKey:@"jobTitle"]];
	if ([details objectForKey:@"mails"]) lineTemp = [lineTemp stringByAppendingString:[details objectForKey:@"mails"]];
	if ([details objectForKey:@"URLs"]) lineTemp = [lineTemp stringByAppendingString:[details objectForKey:@"URLs"]];
	if ([details objectForKey:@"phones"]) lineTemp = [lineTemp stringByAppendingString:[details objectForKey:@"phones"]];
	if ([details objectForKey:@"addresses"]) lineTemp = [lineTemp stringByAppendingString:[details objectForKey:@"addresses"]];
	if ([details objectForKey:@"bday"]) lineTemp = [lineTemp stringByAppendingString:[details objectForKey:@"bday"]];
	if ([details objectForKey:@"note"]) lineTemp = [lineTemp stringByAppendingString:[details objectForKey:@"note"]];
	if ([details objectForKey:@"ornamentLetter"]) lineTemp = [lineTemp stringByAppendingString:@"</div>\n"]; // Close the card div if first name given
	lineTemp = [lineTemp stringByAppendingString:@"</div>\n\n"];
	lineTemp = [lineTemp stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
	lineTemp = [lineTemp stringByReplacingOccurrencesOfString:@"-leftquote-" withString:@"&ldquo;"]; // Replace the placeholders with valid XHTML
	lineTemp = [lineTemp stringByReplacingOccurrencesOfString:@"-rightquote-" withString:@"&rdquo;"];
	content = [content stringByAppendingString:lineTemp];
	[details release];
	details = [[NSMutableDictionary alloc] init];
	numberExported++;
	return YES;
}

- (BOOL)finalize
{
	content = [content stringByAppendingString:@"\n</body>\n</html>\n"];
	return [super finalize];
}

@synthesize fnName;
@synthesize org;
@end
