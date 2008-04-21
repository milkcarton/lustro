//
//  MainController.m
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 20/04/08.
//  Copyright 2008 eggnog. All rights reserved.
//

#import "MainController.h"

@implementation MainController
//
// Called when the export button is pressed.
//
- (IBAction)export:(id)sender
{
	ABAddressBook *book = [ABAddressBook sharedAddressBook];
	ExportController *controller = [[ExporthCard alloc] initWithContacts:[book people]];
	[controller export];
	[controller release];
}
@end