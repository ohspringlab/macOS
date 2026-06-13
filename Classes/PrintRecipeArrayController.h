//
//  PrintRecipeArrayController.h
//  iHungryMac386
//
//  Created by Apple  User on 12/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
@class PrintWindowController ;

@interface PrintRecipeArrayController : NSArrayController{
 IBOutlet PrintWindowController *printWindowController;
 AppDelegate   *appDel;
}
@property (nonatomic,strong)  AppDelegate   *appDel;
@property (nonatomic,strong) PrintWindowController *printWindowController;
// used because the IBOutlet in printRecipeArrayController not being connected
//   in PrintWindowController


@end
