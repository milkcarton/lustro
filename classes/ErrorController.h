//
//  ErrorController.h
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 04/05/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ErrorController : NSObject {
	NSManagedObjectModel *managedObjectModel;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSManagedObjectContext *managedObjectContext;
}

- (void)addSuccessMessage:(NSString *)msg className:(NSString *)className;
- (void)addFailedMessage:(NSString *)msg className:(NSString *)className;
- (void)addErrorMessage:(NSString *)msg className:(NSString *)className;
- (void)addMessage:(NSString *)msg className:(NSString *)className status:(NSString *)status;
- (void)copyLog;
- (NSString *)desktopFolder;
- (NSString *)applicationSupportFolder;
- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *) persistentStoreCoordinator;
- (NSManagedObjectContext *) managedObjectContext;
@end