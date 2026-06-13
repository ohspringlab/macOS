//
//  MyCatArrayController.h
//  iHungryMac386
//
//  Created by Mark on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface MyCatArrayController : NSArrayController {
    
    AppDelegate* appDelegate;
    IBOutlet MyAppController* myAppController;
@private
    
}
@property   (nonatomic, strong) AppDelegate* appDelegate;
@property   (nonatomic, strong) MyAppController* myAppController;
@end
