//
//  ExportController.m
//  lustro
//
//  Created by Jelle Vandebeeck on 21/04/08.
//  Copyright 2008 KBC. All rights reserved.
//

#import "ExportController.h"

@implementation ExportController
//
//
//
- (id)initWithContacts:(NSArray *)contacts
{
	self = [super init];
	contactsList = contacts;
	return self;
}

//
//
//
- (void)export
{
	NSLog(@"Method not overridden");
}
@end