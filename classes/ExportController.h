//
//  ExportController.h
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 21/04/08.
//  Copyright 2008 eggnog. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ExportController : NSObject {
	NSArray *contactsList;
}

- (id)initWithContacts:(NSArray *)contacts;
- (void)export;
- (NSString *)cleanLabel:(NSString *)label;

@end
