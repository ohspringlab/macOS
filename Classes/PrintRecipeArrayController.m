//
//  RxFilteredArrayController.m
//  iHungryMac386
//
//  Created by Apple  User on 12/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PrintRecipeArrayController.h"
#import "MyAppController.h"
#import "PrintWindowController.h"


@implementation PrintRecipeArrayController 
   
@synthesize printWindowController;
@synthesize appDel;

+ (void)initialize {
   
}
/*
- (id) initWithCoder:(NSCoder *)aDecoder{
   
}

- (id)init
{
   self = [super init];
   if (self) {
      // Initialization code here.
   }
   
   return self;
}
*/


- (void)awakeFromNib{
   [super awakeFromNib];// must be called, may be anytime in this method
   // pWC needs to know pRAC, but outlet is not working in pWC
   //[[self printWindowController] setPrintRecipeArrayController: self];
   [self setAppDel:(AppDelegate*)[[NSApplication sharedApplication] delegate]];
   [[self arrangedObjects] setValue:[NSNumber numberWithBool: NO] forKey:@"selected"];
   [self rearrangeObjects];
}



@end
