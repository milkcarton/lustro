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
 
 Created by Simon Schoeters on 2008.05.23.
*/

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

@property (retain) NSString *filename;
@property (retain) NSString *path;
@property (retain) NSData *data;
@end
