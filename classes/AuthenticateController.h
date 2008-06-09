//
//  AuthenticateController.h
//  lustro
//
//  Created by Simon Schoeters on 09/06/08.
//  Copyright 2008 IMEC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AuthenticateController : NSObject {
	IBOutlet id panel;
}

- (IBAction)closeLogPanel:(id)sender;

@property (retain, readonly) id panel;
@end
