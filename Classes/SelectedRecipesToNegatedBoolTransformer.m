//
//  SelectedCatToRxNonZeroCountTransformer.m
//  iHungryMac386
//
//  Created by Apple  User on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectedRecipesToNegatedBoolTransformer.h"
#import "CategoryRx.h"
@implementation SelectedRecipesToNegatedBoolTransformer

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
  // value is : NSArray *arraySelectedCategories in CategoryArrayController; // only one
   if (value == nil) {
      return [NSNumber numberWithBool:NO];
   }
   
   NSArray *arrayOfSelectedObjs = (NSArray*) value;
   NSNumber *retNumber  ;
   
   if ([arrayOfSelectedObjs count] > 0) {
      CategoryRx* aCategory = (CategoryRx*)[arrayOfSelectedObjs objectAtIndex:0] ;
      NSComparisonResult result;
      result = [[aCategory name] compare:@"Browse All"];
      //arraySelectedCategories = [NSArray arrayWithArray:value];
      retNumber = 
      ( result == NSOrderedSame || [[[aCategory recipes] allObjects ]count] > 0) ?
      
      [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES]
      ; // Can delete Category only if it has NO recipes and is NOT BrowseAll
   } else {
      //[NSException raise: NSInternalInconsistencyException
      //            format: @"Value (%@) does not respond to recipes.",  [value class]];
      retNumber = [NSNumber numberWithBool:NO];//[NSNumber numberWithInt:-1 ];
   }
 
   return retNumber;   
}



@end
