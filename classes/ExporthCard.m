//
//  ExporthCard.m
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 21/04/08.
//  Copyright 2008 eggnog. All rights reserved.
//

#import "ExporthCard.h"

#define EXTENTION ".html"

@implementation ExporthCard

//
//
//
- (id)initWithContacts:(NSArray *)contacts
{
	self = [super initWithContacts:contacts];
	contactsList = contacts;
	
	// Read template from file in the resources directory
	NSError *error;
	NSString *path = [[[NSBundle mainBundle] autorelease] pathForResource:@"hCardTemplate" ofType:@""];
	hCardTemplate = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
	if (hCardTemplate == nil) { 
		NSLog(@"Error reading hCard template file at %@\n%@", path, [error localizedFailureReason]);
	}
	return self;
}

//
//
//
- (void)export
{
	if ([contactsList count] > 0) {
		for (ABPerson *person in contactsList) {
			hCardTemplate = [hCardTemplate stringByAppendingString:@"<div class=\"vcard\">\n"];
			NSString *firstName = [person valueForProperty:kABFirstNameProperty];
			NSString *lastName = [person valueForProperty:kABLastNameProperty];
			NSString *company = [person valueForProperty:kABOrganizationProperty];
			NSString *nickname = [person valueForProperty:kABNicknameProperty];
			NSString *note = [person valueForProperty:kABNoteProperty];
			ABMultiValue *addresses = [person valueForProperty:kABAddressProperty];
			ABMultiValue *mails = [person valueForProperty:kABEmailProperty];
			ABMultiValue *URLs = [person valueForProperty:kABURLsProperty];
			ABMultiValue *phones = [person valueForProperty:kABPhoneProperty];
			NSCalendarDate *birthday = [person valueForProperty:kABBirthdayProperty];
			NSString *nameField = @"";
			NSString *fullName = @"";
			
			if (firstName) {		
				nameField = [nameField stringByAppendingString:[self addHTMLEntity:firstName withKey:@"given-name"]];
				fullName = [fullName stringByAppendingString:firstName];
			}
			if (lastName) {
				nameField = [nameField stringByAppendingString:[self addHTMLEntity:lastName withKey:@"family-name"]];
				fullName = [fullName stringByAppendingString:@" "];
				fullName = [fullName stringByAppendingString:lastName];
			}			
			if (firstName || lastName) {
				hCardTemplate = [hCardTemplate stringByAppendingString: [self addHTMLEntity:nameField withKey:@"n fn"]];	
				hCardTemplate = [hCardTemplate stringByAppendingString:@"<br />"];
			}
			
			if(company) {
				hCardTemplate = [hCardTemplate stringByAppendingString: [self addHTMLEntity:company withKey:@"org"]];		
				hCardTemplate = [hCardTemplate stringByAppendingString:@"<br />"];
			}
			if(nickname) {
				hCardTemplate = [hCardTemplate stringByAppendingString: [self addHTMLEntity:nickname withKey:@"nickname"]];
			}			
			if (mails) {
				hCardTemplate = [hCardTemplate stringByAppendingString:[self addMails:mails]];
				hCardTemplate = [hCardTemplate stringByAppendingString:@"<br />"];
			}		
			if(phones) {
				for (int i = 0; i < [phones count]; i++) {
					NSString *subEntry = [self addPhone:phones forIndex:i];
					NSString *phoneEntry = [self addHTMLEntity:subEntry withKey:@"tel"];
					hCardTemplate = [hCardTemplate stringByAppendingString:phoneEntry];
				}
				hCardTemplate = [hCardTemplate stringByAppendingString:@"<br />"];
			}	
			if (addresses) {
				for (int i = 0; i < [addresses count]; i++) {
					hCardTemplate = [hCardTemplate stringByAppendingString:[self addHTMLEntity:[self addAddress:addresses forIndex:i] withKey:@"adr"]];
				}
				hCardTemplate = [hCardTemplate stringByAppendingString:@"<br />"];
			}	
			if (URLs) {
				hCardTemplate = [hCardTemplate stringByAppendingString:[self addURLs:URLs]];
				hCardTemplate = [hCardTemplate stringByAppendingString:@"<br />"];
			}
			if (birthday) {
				NSString *birthdateFormatted = [birthday descriptionWithCalendarFormat:@"%Y-%m-%d"];
				hCardTemplate = [hCardTemplate stringByAppendingString: [self addHTMLEntity:birthdateFormatted withKey:@"bday" withTitle:birthdateFormatted]];	
				hCardTemplate = [hCardTemplate stringByAppendingString:@"<br />"];
			}			
			if (note) {
				hCardTemplate = [hCardTemplate stringByAppendingString: [self addHTMLEntity:note withKey:@"note"]];	
			}	
			hCardTemplate = [hCardTemplate stringByAppendingString:@"</div>\n\n"];
		}
		hCardTemplate = [hCardTemplate stringByAppendingString:@"\n</body>\n</html>\n"];
	}
}

- (NSString *)addHTMLEntity:(NSString *)value withKey:(NSString *)key
{
	NSString *entity = @"";
	entity = [entity stringByAppendingString:@"<span class=\""];
	entity = [entity stringByAppendingString:key];
	entity = [entity stringByAppendingString:@"\">"];
	entity = [entity stringByAppendingString:value];
	entity = [entity stringByAppendingString:@"</span>\n"];
	return entity;
}
- (NSString *)addHTMLEntity:(NSString *)value withKey:(NSString *)key withTitle:(NSString *)title
{
	NSString *entity = @"";
	entity = [entity stringByAppendingString:@"<abbr class=\""];
	entity = [entity stringByAppendingString:key];
	entity = [entity stringByAppendingString:@"\" title=\""];
	entity = [entity stringByAppendingString:title];	
	entity = [entity stringByAppendingString:@"\">"];
	entity = [entity stringByAppendingString:value];
	entity = [entity stringByAppendingString:@"</abbr>\n"];
	return entity;
}

- (NSString *)addPhone:(ABMultiValue *)phones forIndex:(int)index
{
	NSString *entity = @"";	
	NSString *label = [phones labelAtIndex:index];
	NSString *value = [phones valueAtIndex:index];
	label = [self cleanLabel:label];
	entity = [entity stringByAppendingString:[self addHTMLEntity:label withKey:@"type"]];
	entity = [entity stringByAppendingString:[self addHTMLEntity:value withKey:@"value"]];
	return entity;
}

- (NSString *)addAddress:(ABMultiValue *)addresses forIndex:(int)index
{
	NSString *addressOutput = @"";
	NSString *label = [addresses labelAtIndex:index];
	NSDictionary *address = [addresses valueAtIndex:index];
	label = [self cleanLabel:label];
	addressOutput = [addressOutput stringByAppendingString:[self addHTMLEntity:label withKey:@"type"] ];
	if ([address objectForKey:@"Street"]) {
		addressOutput = [addressOutput stringByAppendingString:[self addHTMLEntity:[address objectForKey:@"Street"] withKey:@"street-address"]];	
	}
	if ([address objectForKey:@"City"]) {
		addressOutput = [addressOutput stringByAppendingString: [self addHTMLEntity:[address objectForKey:@"City"] withKey:@"locality"] ];
	}
	if ([address objectForKey:@"ZIP"]) {
		addressOutput = [addressOutput stringByAppendingString: [self addHTMLEntity:[address objectForKey:@"ZIP"] withKey:@"postal-code"] ];
	}	
	if ([address objectForKey:@"region"]) {
		addressOutput = [addressOutput stringByAppendingString: [self addHTMLEntity:[address objectForKey:@"Province"] withKey:@"region"] ];
	}			
	if ([address objectForKey:@"Country"]) {
		addressOutput = [addressOutput stringByAppendingString: [self addHTMLEntity:[address objectForKey:@"Country"] withKey:@"country-name"] ];
	}
	return addressOutput;
}

- (NSString *)addMails:(ABMultiValue *)mails
{
	NSString *mailAddresses = @"";
	for (int i = 0; i < [mails count]; i++) {
		NSString *label = [mails labelAtIndex:i];
		NSString *mail = [mails valueAtIndex:i];
		mailAddresses = [mailAddresses stringByAppendingString:@"<a class=\"email\" href=\"mailto:"];
		mailAddresses = [mailAddresses stringByAppendingString:mail];
		mailAddresses = [mailAddresses stringByAppendingString:@"\">"];
		mailAddresses = [mailAddresses stringByAppendingString:mail];
		label = [self cleanLabel:label];
		mailAddresses = [mailAddresses stringByAppendingString:[self addHTMLEntity:label withKey:@"type"]];
		mailAddresses = [mailAddresses stringByAppendingString:@"</a>\n"];
	}
	return mailAddresses;
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
		label = [self cleanLabel:label];
		URLsOutput = [URLsOutput stringByAppendingString:[self addHTMLEntity:label withKey:@"type"]];
		URLsOutput = [URLsOutput stringByAppendingString:@"</a>\n"];
	}
	return URLsOutput;
}

@end
