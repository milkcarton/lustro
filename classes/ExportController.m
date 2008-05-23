//
//  ExportController.m
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 21/04/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import "ExportController.h"

@implementation ExportController
//
// Initializes the controller with the contactlist.
//
- (id)initWithAddressBook:(ABAddressBook *)addressBook target:(id)errorCtrl
{
	self = [super init];
	contactsList = [addressBook people];
	target = errorCtrl;
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

- (void)addSuccessMessage:(NSString *)successMsg
{
	[target performSelector:@selector(addSuccessMessage:className:) withObject:successMsg withObject:[self className]];
}

- (void)addFailedMessage:(NSString *)failedMsg
{
	[target performSelector:@selector(addFailedMessage:className:) withObject:failedMsg withObject:[self className]];
}

- (void)addErrorMessage:(NSString *)errorMsg
{
	[target performSelector:@selector(addErrorMessage:className:) withObject:errorMsg withObject:[self className]];
}

- (int)export
{
	return 1;
}

@synthesize message;
@synthesize contactsList;
@synthesize target;
@end