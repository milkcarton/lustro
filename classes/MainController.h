//
//  MainController.h
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 20/04/08.
//  Copyright 2008 eggnog. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AddressBook/AddressBook.h>
#import "ExportController.h"
#import "ExporthCard.h"
#import "ExportGoogle.h"

@interface MainController : NSObject {
	NSMutableDictionary *indicators;
}

- (NSMutableDictionary *)indicators;

- (IBAction)export:(id)sender;
- (void)invocateExport;

@end