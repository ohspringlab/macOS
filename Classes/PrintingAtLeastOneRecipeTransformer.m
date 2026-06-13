//
//  PrintingAtLeastOneRecipeTransformer.m
//  iHungryMac386
//
//  Created by Apple  User on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrintingAtLeastOneRecipeTransformer.h"
#import "Recipe.h"
@implementation PrintingAtLeastOneRecipeTransformer

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
  // value is : NSArray *arraySelectedCategories in RecipeArrayController; // Does the category have recipes
   if (value == nil) {
      return [NSNumber numberWithBool:NO];
   }
   NSNumber *retNumber = [NSNumber numberWithBool:NO];
   
   NSArray *arrayOfSelectedObjs = (NSArray*) value;

   NSEnumerator *enumerator = [arrayOfSelectedObjs objectEnumerator];
   Recipe * aRecipe;
   while( aRecipe = [enumerator nextObject]){
      if (aRecipe.selected == 1) {
         retNumber = [NSNumber numberWithBool:YES];
         break;
      }
   }
   
   return retNumber;   
}



@end
