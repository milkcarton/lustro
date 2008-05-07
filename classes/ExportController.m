//
//  ExportController.m
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 21/04/08.
//  Copyright 2008 eggnog. All rights reserved.
//

#import "ExportController.h"

@implementation ExportController
//
// Initializes the controller with the contactlist.
//
- (id)initWithAddressBook:(ABAddressBook *)addressBook target:(id)errorCtrl selector:(SEL)msg
{
	self = [super init];
	contactsList = [addressBook people];
	target = errorCtrl;
	addMessage = msg;
	return self;
}

// Cleans mail labels like work, private, etc. as Address Book adds strange symbols before and after the labels.
- (NSString *)cleanLabel:(NSString *)label
{
	if ([label compare:@"_$!<" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 4)] == NSOrderedSame) {
		int end = [label length]-8;
		return [label substringWithRange:NSMakeRange(4, end)];
	}
	return label;
}

- (void)addError:(NSString *)errorMsg
{
	[target performSelector:addMessage withObject:errorMsg withObject:[self className]];
}

@synthesize message;
@end