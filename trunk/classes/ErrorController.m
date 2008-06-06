//
//  ErrorController.m
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 04/05/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import "ErrorController.h"

@implementation ErrorController
- (id)init
{
	self = [super init];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *path = [[self applicationSupportFolder] stringByAppendingPathComponent:@"log.xml"];
	NSError *error;
	[fileManager removeItemAtPath:path error:&error];
	return self;
}

- (void)addSuccessMessage:(NSString *)msg className:(NSString *)className
{
	[self addMessage:msg className:className status:@"0"];
}

- (void)addFailedMessage:(NSString *)msg className:(NSString *)className
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

- (void)copyLog
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *path = [[self applicationSupportFolder] stringByAppendingPathComponent:@"log.xml"];
	NSString *desktopPath = [[self desktopFolder] stringByAppendingPathComponent:@"lustro-log.xml"];
	NSError *error;
	[fileManager copyItemAtPath:path toPath:desktopPath error:&error];
	if (!error)
		[[NSApplication sharedApplication] presentError:error];
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

- (void) dealloc
{	
    [managedObjectContext release], managedObjectContext = nil;
    [persistentStoreCoordinator release], persistentStoreCoordinator = nil;
    [managedObjectModel release], managedObjectModel = nil;
    [super dealloc];
}
@end