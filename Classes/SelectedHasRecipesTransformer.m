//
//  SelectedHasRecipesTransformer.m
//  iHungryMac386
//
//  Created by Apple  User on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectedHasRecipesTransformer.h"
#import "CategoryRx.h"
@implementation SelectedHasRecipesTransformer

+ (Class)transformedValueClass

{
   return [NSNumber  class];
}


+ (BOOL)allowsReverseTransformation

{
   return NO;
}

- (id)transformedValue:(id)value

{
  // value is : NSArray *arraySelectedCategories in CategoryArrayController; // Does the category have recipes
   if (value == nil) {
      return [NSNumber numberWithBool:NO];
   }
   
   NSArray *arrayOfSelectedObjs = (NSArray*) value;
   NSNumber *retNumber  ;
   

   if ([arrayOfSelectedObjs count] > 0) {
      CategoryRx* aCategory = (CategoryRx*)[arrayOfSelectedObjs objectAtIndex:0] ;
     
      retNumber = 
      ([[[aCategory recipes] allObjects ]count] > 0) ?
      
      [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO]
      ; // Can delete Category only if it has NO recipes and is NOT BrowseAll
   } else {
      //[NSException raise: NSInternalInconsistencyException
      //            format: @"Value (%@) does not respond to recipes.",  [value class]];
      retNumber = [NSNumber numberWithBool:NO];//[NSNumber numberWithInt:-1 ];
   }
 
   return retNumber;   
}



@end
