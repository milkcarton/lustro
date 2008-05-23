//
//  main.m
//  lustro
//
//  Created by Simon Schoeters on 20/04/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AddressBook/AddressBook.h>
#import "AddressBookExport.h"
#import "DelimitedExport.h"

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	DelimitedExport *abExport = [[DelimitedExport alloc] init];
	[abExport export];
	[abExport release];
	
	[pool release];
	return 1;
	//return NSApplicationMain(argc,  (const char **) argv);
}
