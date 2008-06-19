/*
 Copyright (c) 2008 Jelle Vandebeeck, Simon Schoeters
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 Created by Simon Schoeters on 2008.06.09.
*/

#import "LogController.h"


@implementation LogController

- (id)init
{
	self = [super init];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *path = [[self applicationSupportFolder] stringByAppendingPathComponent:@"log.xml"];
	NSError *error;
	hasContents = NO;
	[fileManager removeItemAtPath:path error:&error];
	return self;
}

- (NSString *)desktopFolder
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return basePath;
}

- (NSString *)applicationSupportFolder
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:@"Lustro"];
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }	
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSFileManager *fileManager;
    NSString *applicationSupportFolder = nil;
    NSURL *url;
    NSError *error;
    fileManager = [NSFileManager defaultManager];
    applicationSupportFolder = [self applicationSupportFolder];
    if ( ![fileManager fileExistsAtPath:applicationSupportFolder isDirectory:NULL] ) {
        [fileManager createDirectoryAtPath:applicationSupportFolder attributes:nil];
    }
    url = [NSURL fileURLWithPath: [applicationSupportFolder stringByAppendingPathComponent: @"log.xml"]];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
		[[NSApplication sharedApplication] presentError:error];
    }    
    return persistentStoreCoordinator;
}

- (NSManagedObjectContext *) managedObjectContext
{	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}

- (void)addSuccessMessage:(NSString *)msg className:(NSString *)className
{
	[self addMessage:msg className:className status:@"0"];
}

- (void)addWarningMessage:(NSString *)msg className:(NSString *)className
{
	[self addMessage:msg className:className status:@"1"];
}

- (void)addErrorMessage:(NSString *)msg className:(NSString *)className
{
	[self addMessage:msg className:className status:@"2"];
}

- (void)addMessage:(NSString *)msg className:(NSString *)className status:(NSString *)status
{
	NSManagedObject *message = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:[self managedObjectContext]];
	[message setValue:msg forKey:@"specification"];
	[message setValue:className forKey:@"position"];
	[message setValue:status forKey:@"status"];
	[message setValue:[NSDate date] forKey:@"date"];
	[[self managedObjectContext] insertObject:message];
	[[self managedObjectContext] save:nil];
	hasContents = YES;
}

- (IBAction)closeLogPanel:(id)sender
{
	[panel orderOut:nil];
	[NSApp endSheet:panel];
}

- (IBAction)copyLogToDesktop:(id)sender
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *path = [[self applicationSupportFolder] stringByAppendingPathComponent:@"log.xml"];
	NSString *desktopPath = [[self desktopFolder] stringByAppendingPathComponent:@"lustro-log.xml"];
	NSError *error;
	[fileManager copyItemAtPath:path toPath:desktopPath error:&error];
	if (!error)
		[[NSApplication sharedApplication] presentError:error];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
	if ([menuItem tag] == 2 && !hasContents) {  // Tag 2 is the Save log menu item
		return NO;
	}
 	return YES; // Return YES here so all other menu items are displayed
}

- (void) dealloc
{	
    [managedObjectContext release], managedObjectContext = nil;
    [persistentStoreCoordinator release], persistentStoreCoordinator = nil;
    [managedObjectModel release], managedObjectModel = nil;
    [super dealloc];
}

@synthesize panel;
@end
