//
//  ErrorController.h
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 04/05/08.
//  Copyright 2008 eggnog. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ErrorController : NSObject {
	NSString *logText;
	id target;
	SEL showError;
}

- (id)initWithTarget:(id)mainCtrl selector:(SEL)method;
- (BOOL)writeToLog;											// Write the log file.

@end