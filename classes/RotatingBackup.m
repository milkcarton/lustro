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

#import "RotatingBackup.h"

#define ROTATE_DAYS 31
#define BACKUP_PATH @"Library/Application Support/Lustro/Backups"

@implementation RotatingBackup

+ (int)random
{
	return ([NSDate timeIntervalSinceReferenceDate] - (int)[NSDate timeIntervalSinceReferenceDate]) * 100000;
}

- (id)initWithFilename:(NSString *)filenameIn data:(NSData *)dataIn
{
	self = [super init];
	filename = filenameIn;
	path = [NSHomeDirectory() stringByAppendingPathComponent:BACKUP_PATH];
	data = dataIn;
	return self;
}

- (void)createBackupFolder
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *folder =[NSHomeDirectory() stringByAppendingPathComponent:BACKUP_PATH];

	
	if ([fileManager fileExistsAtPath:folder] == NO)
	{
		[fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
	}
}

- (void)removeOldFilesInFolder
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSTimeInterval month = 24 * 60 * 60 * ROTATE_DAYS;
	NSDate *refDate = [[NSDate date] addTimeInterval:-month];

	NSString *file;
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:path];
    while (file = [dirEnum nextObject])
    {
		NSString *filePath = [NSString stringWithFormat:@"%@/%@", path, [file stringByStandardizingPath]];
		NSDictionary *dict = [fileManager fileAttributesAtPath:filePath traverseLink:YES];
		NSDate *fileCreationDate = [dict objectForKey:NSFileCreationDate];
		if([fileCreationDate compare:refDate] == NSOrderedAscending) {
			[fileManager removeFileAtPath:filePath handler:nil];
		}
    }
}

- (void)save
{
	NSString *ext = [filename pathExtension];
	NSString *name = [filename stringByDeletingPathExtension];
	NSString *saveFile = [NSString stringWithFormat:@"%@/%@_%i.%@", path, name, [RotatingBackup random], ext];
	[data writeToFile:saveFile atomically:YES];	
}

- (void)dealloc
{
	filename = nil;
	path = nil;
	data = nil;
	[super dealloc];
}

@synthesize filename;
@synthesize path;
@synthesize data;
@end
