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
// Initialize the controller.
//
- (id)init
{
	self = [super init];
	NSArray *keys   = [NSArray arrayWithObjects:@"comma", nil];
    NSArray *values = [NSArray arrayWithObjects:@"NO", nil];
    
    indicators = [[NSMutableDictionary alloc] initWithObjects:values forKeys:keys];
	return self;
}

- (NSMutableDictionary *)indicators
{
	return indicators;
}


//
// Called when the export button is pressed.
//
- (IBAction)export:(id)sender
{
	[indicators setValue:@"YES" forKey:@"comma"];
	//[self performSelectorInBackground:@selector(invocateExport) withObject:nil];
}

//
// Method that is called in the background.
//
- (void)invocateExport
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
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
	[pool release];
}
@end