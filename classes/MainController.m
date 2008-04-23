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
	
	// If comma separated is checked
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"CommaChecked"]) {
	}
	
	// If tab separated is checked
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TabChecked"]) {
	}
	
	// If Html is checked
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HtmlChecked"]) {
		ExporthCard *controller = [[ExporthCard alloc] initWithAddressBook:book];
		[controller export];
		[controller release];
	}
	
	// If Google is checked
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleChecked"]) {
		ExportGoogle *controller = [[ExportGoogle alloc] initWithAddressBook:book];
		[controller export];
		[controller release];
	}
}
@end