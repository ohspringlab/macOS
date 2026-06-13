//
//  RecipeWindow.m
//  iHungryMac386
//
//  Created by Mark on 9/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RecipeWindow.h"
   //#import "Recipe.h"
@implementation RecipeWindow


-(BOOL)canBecomeKeyWindow{
   return YES;
}
/*
@synthesize recipe;
@synthesize speechButton;
@synthesize stopButton;
@synthesize textViewID;
@synthesize textViewI;
@synthesize textViewD;
@synthesize textViewC;
*/
 
 
/*
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}*/


- (void)dealloc
{
   NSNotificationCenter *center;
   center = [NSNotificationCenter defaultCenter];
   [center removeObserver: self] ;
      
}


@end
