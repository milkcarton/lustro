//
//  ExportSeparatedFile.m
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 16/05/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import "ExportSeparatedFile.h"

@implementation ExportSeparatedFile
- (id)initWithAddressBook:(ABAddressBook *)addressBook target:(id)errorCtrl separator:(NSString *)separatorItem extention:(NSString *)extentionItem
{
	separator = separatorItem;
	extention = extentionItem;
	return [self initWithAddressBook:addressBook target:errorCtrl];
}

- (id)initWithAddressBook:(ABAddressBook *)addressBook target:(id)errorCtrl
{
	self = [super initWithAddressBook:addressBook target:errorCtrl];
	
	// Create username to use in filename.
	userName = @"";
	ABPerson *me = [addressBook me];
	if (me) {
		NSString *firstName = [me valueForProperty:kABFirstNameProperty];
		NSString *lastName = [me valueForProperty:kABLastNameProperty];
		if (firstName) userName = [userName stringByAppendingString:firstName];
		if (lastName) {
			if (firstName) userName = [userName stringByAppendingString:@" "];
			userName = [userName stringByAppendingString:lastName];
		}
		if (firstName || lastName) userName = [userName stringByAppendingString:@"'s "];
		userName = [userName stringByAppendingString:@"contacts"];
	} else userName = @"contacts";
	
	return self;
}

- (BOOL)writeToFileWithText:(NSString *)text
{
	if ([text length] > 0) {		
		NSString *fileName = userName;
		NSString *filePath = @"~/Desktop/";
		filePath = [filePath stringByAppendingString:fileName]; 
		filePath = [filePath stringByAppendingString:@"."]; 
		filePath = [filePath stringByAppendingString:extention]; 
		filePath = [filePath stringByStandardizingPath];
		NSError *error;
		BOOL written =  [text writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
		if (!written && error) {
			NSLog(@"%@", error);
			[super addErrorMessage:[error localizedDescription]];
			return NO;
		}
		return written;
	} else [super addErrorMessage:@"There was no content available to write the file."];
	
	return NO;
}

- (int)export
{
	NSString *text = @"";
	if ([contactsList count] > 0) {
		@try {
			for (ABPerson *person in contactsList) {
				NSString *firstName = [person valueForProperty:kABFirstNameProperty];
				NSString *lastName = [person valueForProperty:kABLastNameProperty];
				NSString *suffix = [person valueForProperty:kABSuffixProperty];
				NSString *nickname = [person valueForProperty:kABNicknameProperty];
				NSString *middleName = [person valueForProperty:kABMiddleNameProperty];
				NSString *company = [person valueForProperty:kABOrganizationProperty];
				NSString *jobTitle = [person valueForProperty:kABJobTitleProperty];
				NSString *department = [person valueForProperty:kABDepartmentProperty];
				NSString *note = [person valueForProperty:kABNoteProperty];
				ABMultiValue *addresses = [person valueForProperty:kABAddressProperty];
				ABMultiValue *mails = [person valueForProperty:kABEmailProperty];
				ABMultiValue *URLs = [person valueForProperty:kABURLsProperty];
				ABMultiValue *phones = [person valueForProperty:kABPhoneProperty];
				NSCalendarDate *birthday = [person valueForProperty:kABBirthdayProperty];
				
				if (firstName) text = [text stringByAppendingString:[self addEntity:firstName]];
				else text = [text stringByAppendingString:[self addEntity:@""]];
				
				if (lastName) text = [text stringByAppendingString:[self addEntity:lastName]];
				else text = [text stringByAppendingString:[self addEntity:@""]];
				
				if (suffix) text = [text stringByAppendingString:[self addEntity:suffix]];
				else text = [text stringByAppendingString:[self addEntity:@""]];
				
				if (nickname) text = [text stringByAppendingString:[self addEntity:nickname]];
				else text = [text stringByAppendingString:[self addEntity:@""]];
				
				if (middleName) text = [text stringByAppendingString:[self addEntity:middleName]];
				else text = [text stringByAppendingString:[self addEntity:@""]];
				
				if (jobTitle) text = [text stringByAppendingString:[self addEntity:jobTitle]];
				else text = [text stringByAppendingString:[self addEntity:@""]];
				
				text = [text stringByAppendingString:[self addOrganizationWithName:company unit:department]];
				
				text = [text stringByAppendingString:[self addMails:mails]];
				
				if(phones) {
					for (int i = 0; i < [phones count]; i++) {
						NSString *phone = [phones valueAtIndex:i];
						text = [text stringByAppendingString:[self addEntity:phone]];
					}
					for (int e = 0; ([phones count] < 3) && e < (3 - [phones count]); e++) {
						text = [text stringByAppendingString:[self addEntity:@""]];
					}
				} else {
					for (int e = 0; e < 3; e++) {
						text = [text stringByAppendingString:[self addEntity:@""]];
					}
				}
				
				if (addresses) {
					for (int i = 0; i < [addresses count]; i++) {
						text = [text stringByAppendingString:[self addAddress:addresses forIndex:i]];
					}
					for (int e = 0; ([addresses count] < 3) && e < (3 - [addresses count]); e++) {
						text = [text stringByAppendingString:[self addEntity:@""]];
					}
				} else {
					for (int e = 0; e < 3; e++) {
						text = [text stringByAppendingString:[self addEntity:@""]];
					}
				}
				
				text = [text stringByAppendingString:[self addURLs:URLs]];
				
				if (birthday) {
					NSString *birthdateFormatted = [birthday descriptionWithCalendarFormat:@"%Y-%m-%d"];
					text = [text stringByAppendingString: [self addEntity:birthdateFormatted]];	
				} else text = [text stringByAppendingString:[self addEntity:@""]];	
				
				if (note) text = [text stringByAppendingString: [self addEntity:note]];	
				else text = [text stringByAppendingString:[self addEntity:@""]];
				
				text = [text stringByAppendingString:@"\n"];
			}
		}
		@catch (NSException *exception) {
			[super addErrorMessage:[exception reason]];
			return kExportError;
		}
		if (![self writeToFileWithText:text]) {
			return kExportError;
		}
	} else {
		[super addErrorMessage:@"There were no contacts to export."];
		return kExportWarning;
	}
	return kExportSuccess;
}

- (NSString *)addEntity:(NSString *)value
{
	NSString *entity = separator;
	entity = [entity stringByAppendingString:value];
	return entity;
}

- (NSString *)addAddress:(ABMultiValue *)addresses forIndex:(int)index
{
	NSString *addressOutput = @"";
	NSDictionary *address = [addresses valueAtIndex:index];
	if ([address objectForKey:@"Street"]) {
		addressOutput = [addressOutput stringByAppendingString:[address objectForKey:@"Street"]];	
	}
	addressOutput = [addressOutput stringByAppendingString:@" "];
	if ([address objectForKey:@"City"]) {
		addressOutput = [addressOutput stringByAppendingString:[address objectForKey:@"City"]];
	}
	addressOutput = [addressOutput stringByAppendingString:@" "];
	if ([address objectForKey:@"ZIP"]) {
		addressOutput = [addressOutput stringByAppendingString:[address objectForKey:@"ZIP"]];
	}
	addressOutput = [addressOutput stringByAppendingString:@" "];
	if ([address objectForKey:@"region"]) {
		addressOutput = [addressOutput stringByAppendingString:[address objectForKey:@"Province"]];
	}
	addressOutput = [addressOutput stringByAppendingString:@" "];
	if ([address objectForKey:@"Country"]) {
		addressOutput = [addressOutput stringByAppendingString:[address objectForKey:@"Country"]];
	}
	return [self addEntity:addressOutput];
}

- (NSString *)addMails:(ABMultiValue *)mails
{
	NSString *mailAddresses = @"";
	if (mails) {
		for (int i = 0; i < [mails count]; i++) {
			NSString *mail = [mails valueAtIndex:i];
			mailAddresses = [self addEntity:[mailAddresses stringByAppendingString:mail]];
		}
		for (int e = 0; ([mails count] < 3) && e < (3 - [mails count]); e++) {
			mailAddresses = [self addEntity:@""];
		}
	} else {
		for (int e = 0; e < 3; e++) {
			mailAddresses = [self addEntity:@""];
		}
	}
	return mailAddresses;
}

- (NSString *)addURLs:(ABMultiValue *)URLs
{
	NSString *URLsOutput = @"";
	if (URLs) {
		for (int i = 0; i < [URLs count]; i++) {
			NSString *URL = [URLs valueAtIndex:i];
			URLsOutput = [self addEntity:[URLsOutput stringByAppendingString:URL]];
		}
		for (int e = 0; ([URLs count] < 3) && e < (3 - [URLs count]); e++) {
			URLsOutput = [self addEntity:@""];
		}
	} else {
		for (int e = 0; e < 3; e++) {
			URLsOutput = [self addEntity:@""];
		}
	}
	return URLsOutput;
}

- (NSString *)addOrganizationWithName:(NSString *)name unit:(NSString *)unit
{
	NSString *orgOutput = @"";
	if (name) {
		orgOutput = [orgOutput stringByAppendingString:[self addEntity:name]];
	} else orgOutput = [orgOutput stringByAppendingString:[self addEntity:@""]];
	if (unit) {
		orgOutput = [orgOutput stringByAppendingString:[self addEntity:unit]];
	} else orgOutput = [orgOutput stringByAppendingString:[self addEntity:@""]];
	return orgOutput;
}
@end
