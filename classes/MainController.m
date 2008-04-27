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
	NSArray *keys   = [NSArray arrayWithObjects:@"comma",@"tab", @"html", @"google", @"authenticate", nil];
    NSArray *values = [NSArray arrayWithObjects:@"0" ,@"0", @"0", @"0", @"YES", nil];
    
	///Initialize the value transformers used throughout the application bindings
	NSValueTransformer *statusValueTransformer = [[StatusValueTransformer alloc] init];
    [NSValueTransformer setValueTransformer:statusValueTransformer forName:@"StatusValueTransformer"];
	NSValueTransformer *progressValueTransformer = [[ProgressValueTransformer alloc] init];
    [NSValueTransformer setValueTransformer:progressValueTransformer forName:@"ProgressValueTransformer"];
	
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
	[indicators setValue:@"0" forKey:@"comma"];
	[indicators setValue:@"0" forKey:@"tab"];
	[indicators setValue:@"0" forKey:@"html"];
	[indicators setValue:@"0" forKey:@"google"];
	//[self performSelectorInBackground:@selector(invocateExport) withObject:nil];
	[self invocateExport];
}

//
// Called when the authenticate button is pressed.
//
- (IBAction)authenticate:(id)sender
{
	[authSheet orderOut:nil];
    [NSApp endSheet:authSheet];
}

//
// Show the authentication sheet.
//
- (IBAction)callSheet:(id)sender
{
	[NSApp beginSheet:authSheet modalForWindow:window modalDelegate:self didEndSelector:NULL contextInfo:nil];
}

//
// Method that is called in the background.
//
- (void)invocateExport
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	ABAddressBook *book = [ABAddressBook sharedAddressBook];
	[indicators setValue:@"NO" forKey:@"authenticate"];
	
	// If comma separated is checked
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"CommaChecked"]) {
		[indicators setValue:@"1" forKey:@"comma"];
		[indicators setValue:@"2" forKey:@"comma"];
	}
	
	// If tab separated is checked
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TabChecked"]) {
		[indicators setValue:@"1" forKey:@"tab"];
		[indicators setValue:@"2" forKey:@"tab"];
	}
	
	// If Html is checked
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HtmlChecked"]) {
		[indicators setValue:@"1" forKey:@"html"];
		ExporthCard *controller = [[ExporthCard alloc] initWithAddressBook:book];
		[controller export];
		[controller release];
		[indicators setValue:@"2" forKey:@"html"];
	}
	
	// If Google is checked
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"GoogleChecked"]) {
		[indicators setValue:@"1" forKey:@"google"];
		ExportGoogle *controller = [[ExportGoogle alloc] initWithAddressBook:book];
		[controller export];
		[controller release];
		[indicators setValue:@"2" forKey:@"google"];
	}
	
	[indicators setValue:@"YES" forKey:@"authenticate"];
	[pool release];
}
@end