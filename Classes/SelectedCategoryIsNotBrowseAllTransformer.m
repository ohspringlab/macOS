//
//  SelectedCategoryIsNotBrowseAllTransformer.m
//  iHungryMac386
//
//  Created by Apple  User on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectedCategoryIsNotBrowseAllTransformer.h"
#import "CategoryRx.h"
@implementation SelectedCategoryIsNotBrowseAllTransformer

+ (Class)transformedValueClass

{
   
   return [NSNumber  class];
   
}


+ (BOOL)allowsReverseTransformation

{
   return NO;
}

- (id)transformedValue:(id)value // value is array of Categories

{
   // Transformer USED FOR catEditButton.enabled
   
   //NSArray* categoryArray = (NSArray*)value;
   //CategoryRx* category = [categoryArray objectAtIndex:0];
  // value is : NSArray *arraySelectedCategories in CategoryArrayController; // Does the category have recipes
   if (value == nil) {
      return [NSNumber numberWithBool:NO];
   }
   
   NSArray *arrayOfSelectedObjs = (NSArray*) value;
   NSNumber *retNumber  ;
   
   if ([arrayOfSelectedObjs count] > 0) {
      CategoryRx* aCategory = (CategoryRx*)[arrayOfSelectedObjs objectAtIndex:0] ;
      NSComparisonResult result = [[aCategory name] compare:@"Browse All"];
      retNumber = 
         (result == NSOrderedSame) ?
            [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES];
      // Can edit Category only if it  NOT BrowseAll
   } else {
      //[NSException raise: NSInternalInconsistencyException
      //            format: @"Value (%@) does not respond to recipes.",  [value class]];
      retNumber = [NSNumber numberWithBool:NO];//[NSNumber numberWithInt:-1 ];
   }
   //DLog(@"result=%ld retNumber=%@",result ,retNumber);
   return retNumber;   
}



@end
