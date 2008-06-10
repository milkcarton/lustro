//
//  LogController.m
//  lustro
//
//  Created by Simon Schoeters on 09/06/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import "LogController.h"


@implementation LogController

- (id)init
{
	self = [super init];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *path = [[self applicationSupportFolder] stringByAppendingPathComponent:@"log.xml"];
	NSError *error;
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
}

- (IBAction)closeLogPanel:(id)sender
{
	[panel orderOut:nil];
	[NSApp endSheet:panel];
}

- (IBAction)copyLogToDesktop:(id)sender
{
	NSLog(@"prt");
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *path = [[self applicationSupportFolder] stringByAppendingPathComponent:@"log.xml"];
	NSString *desktopPath = [[self desktopFolder] stringByAppendingPathComponent:@"lustro-log.xml"];
	NSError *error;
	[fileManager copyItemAtPath:path toPath:desktopPath error:&error];
	if (!error)
		[[NSApplication sharedApplication] presentError:error];
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
