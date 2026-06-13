//
//  SelectedCatToRxNonZeroCountTransformer.m
//  iHungryMac386
//
//  Created by Apple  User on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//#import "SelectedCatToRxNonZeroCountTransformer.h"
#import "SelectedCatNotBrowseAllAndHasNoRxsTransformer.h"
#import "CategoryRx.h"
@implementation SelectedCatNotBrowseAllAndHasNoRxsTransformer

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
   //Transformer used to enable both Cat '-' and Cat Edit button if selected is neither
   // Browse_All nor a Cat that has Rxs.
  // NSArray *arraySelectedCategories; // only one
  // Transformer must be passed array of selected Categories, i.e. , selectedObjects
   // return NO if (Category.name=="Browse All" ||
      //           category.recipes.allObjects.count > 0 )
   if (value == nil) {
      return [NSNumber numberWithBool:NO];  // not NonZero -> disable
   }
   NSArray *arrayOfSelectedObjs = (NSArray*) value;
   NSNumber *retNumber  ;
   
   CategoryRx *aCategory;
   NSComparisonResult result;
   BOOL hasRecipes = NO;
   
   if ([arrayOfSelectedObjs count] > 0) { 
      aCategory = [arrayOfSelectedObjs objectAtIndex:0];
      hasRecipes = 
         ( [[[aCategory recipes] allObjects ]count] > 0) ?   YES : NO ;
      result = [[aCategory name] compare:@"Browse All"];
   } else {
      return [NSNumber numberWithBool: NO];
   }
   
   // return NO if category.name=="BrowseAll" OR category has recipes
   retNumber = (result == NSOrderedSame || hasRecipes == YES ) 
      ? [NSNumber numberWithBool: NO] : [NSNumber numberWithBool: YES] ;
   
   return retNumber;   
}



@end
