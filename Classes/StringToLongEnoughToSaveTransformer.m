//
//  StringToLongEnoughToSaveTransformer.m
//  iHungryMac386
//
//  Created by Apple  User on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StringToLongEnoughToSaveTransformer.h"
#import "CategoryRx.h"
@implementation StringToLongEnoughToSaveTransformer

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
   if (value == nil) return nil;
   
   NSString *recipeName;
   NSTextField *recipeNameTextField;
   if ([value respondsToSelector: @selector(stringValue)]) {
      recipeNameTextField = (NSTextField*)value;
      recipeName = (NSString*)[recipeNameTextField stringValue];
      DLog(@"recipeName=%@\nrecipeNameTextField=%@",(NSString*)[recipeNameTextField stringValue],recipeNameTextField );
      BOOL isGoodLength = (recipeName && [recipeName length] > 1) ? YES : NO;
      return [NSNumber numberWithBool:isGoodLength];
   }
   return nil;
}



@end
