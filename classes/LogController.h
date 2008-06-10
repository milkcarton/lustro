//
//  LogController.h
//  lustro
//
//  Created by Simon Schoeters on 09/06/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LogController : NSObject {
	NSManagedObjectModel *managedObjectModel;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSManagedObjectContext *managedObjectContext;
	
	IBOutlet id panel;
}

- (NSString *)desktopFolder;																	// Returns the path to the desktop.
- (NSString *)applicationSupportFolder;															// Returns the path to the application support folder.
- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *) persistentStoreCoordinator;
- (NSManagedObjectContext *) managedObjectContext;
- (void)addSuccessMessage:(NSString *)msg className:(NSString *)className;						// Adds a success message.
- (void)addWarningMessage:(NSString *)msg className:(NSString *)className;						// Adds a warning message.
- (void)addErrorMessage:(NSString *)msg className:(NSString *)className;						// Adds an error message.
- (void)addMessage:(NSString *)msg className:(NSString *)className status:(NSString *)status;	// Adds a message.

- (IBAction)closeLogPanel:(id)sender;															// Closes the panel.
- (IBAction)copyLogToDesktop:(id)sender;														// Copies the log to a file on the desktop.

@property (retain, readonly) id panel;
@end
