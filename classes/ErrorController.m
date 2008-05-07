//
//  ErrorController.m
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 04/05/08.
//  Copyright 2008 eggnog. All rights reserved.
//

#import "ErrorController.h"

#define FILENAME @"log.txt"

@implementation ErrorController
- (id)initWithTarget:(id)mainCtrl selector:(SEL)method
{
	self = [super init];
	target = mainCtrl;
	showError = method;
	logText = @"No log message\n";
	[target performSelector:showError withObject:logText];
	[self writeToLog];
	return self;
}

- (BOOL)writeToLog
{
	if ([logText length] > 0) {
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *folder = @"~/Library/Application Support/Lustro/";
		folder = [folder stringByExpandingTildeInPath];
		if ([fileManager fileExistsAtPath: folder] == NO)
		{
			[fileManager createDirectoryAtPath:folder attributes:nil];
		}
		NSString *path = [folder stringByAppendingPathComponent:FILENAME];
		NSError *error;
		[logText writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:&error];
		if (error)
			return NO;
		return YES;
	}
	return NO;
}

- (void)addMessage:(NSString *)msg className:(NSString *)className
{
	NSLog(@"%@", [self className]);
	logText = [logText stringByAppendingString:[[NSDate date] description]];
	logText = [logText stringByAppendingString:@" ["];
	logText = [logText stringByAppendingString:className];
	logText = [logText stringByAppendingString:@"] "];
	logText = [logText stringByAppendingString:msg];
	[target performSelector:showError withObject:logText];
	[self writeToLog];
}
@end