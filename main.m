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
#import "HTMLExport.h"
#import "RotatingBackup.h"
#import "GoogleExport.h"

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	/* Test: Create rotating backups
	NSData *dataIn = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.google.be"]];
	RotatingBackup *backup = [[RotatingBackup alloc] initWithFilename:@"metest.xml" data:dataIn];
	[backup createBackupFolder];
	[backup removeOldFilesInFolder];
	[backup save];
	[backup release];
	*/
	
	/* Test: Export Google Contacts with backup */
	GoogleExport *gExport = [[GoogleExport alloc] initWithUsername:@"lustroapp" password:@"jellesimon"];
	[gExport export];
	[gExport release];
		
	[pool release];
	return 1;
	//return NSApplicationMain(argc,  (const char **) argv);
}
