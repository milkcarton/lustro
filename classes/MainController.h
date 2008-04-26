//
//  MainController.h
//  lustro
//
//  Created by Jelle Vandebeeck & Simon Schoeters on 20/04/08.
//  Copyright 2008 eggnog. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AddressBook/AddressBook.h>
#import "StatusValueTransformer.h"
#import "ProgressValueTransformer.h"
#import "AuthenticateValueTransformer.h"
#import "ExportController.h"
#import "ExporthCard.h"
#import "ExportGoogle.h"

@interface MainController : NSObject {
	NSMutableDictionary *indicators;
	
	IBOutlet id authSheet;			// The authentication sheet.
	IBOutlet id window;				// The main Lustro window.
	IBOutlet id usernameField;		// The username textfield from the auth sheet.
	IBOutlet id passwordField;		// The password textfield from the auth sheet.
}

- (NSMutableDictionary *)indicators;

- (IBAction)export:(id)sender;
- (IBAction)authenticate:(id)sender;
- (IBAction)callSheet:(id)sender;
   
- (void)invocateExport;

@end