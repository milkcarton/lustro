//
//  RotatingBackup.h
//  lustro
//
//  Created by Simon Schoeters on 23/05/08.
//  Copyright 2008 milkcarton. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface RotatingBackup : NSObject {
	NSString *filename;
	NSString *path;
	NSData *data;
}

+ (int)random;															// Returns a small random number

- (id)initWithFilename:(NSString *)filenameIn data:(NSData *)dataIn;
- (void)createBackupFolder;												// Creates a Backup folder in the user's Application Support folder if none found
- (void)removeOldFilesInFolder;											// Remove backup files older then the ROTATE_DAYS variable
- (void)save;															// Saves the file to disk

@end
