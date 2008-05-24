//
//  RotatingBackup.m
//  lustro
//
//  Created by Simon Schoeters on 23/05/08.
//  Copyright 2008. All rights reserved.
//

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

@end
