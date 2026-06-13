//
//  SelectedCatLenIsInRangeTransformer.m
//  iHungryMac386
//
//  Created by Apple  User on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectedCatLenIsInRangeTransformer.h"
#import "Category.h"
#import "RecipeDefines.h"
//@implementation SelectedCatToRxNonZeroCountTransformer
@implementation SelectedCatLenIsInRangeTransformer

+ (Class)transformedValueClass

{
   
   return [NSTextView  class];
   
}


+ (BOOL)allowsReverseTransformation

{
   
   return NO;
   
}

- (id)transformedValue:(id)value

{
   if (value == nil)
      return NO;
   DLog(@"value=%@",value);
   NSString *categoryName;
   NSTextField *categoryNameTextField;
   if ([value respondsToSelector: @selector(stringValue)]) {
      categoryNameTextField = (NSTextField*)value;
      categoryName = (NSString*)[categoryNameTextField stringValue];
      DLog(@"categoryName=%@\ncategoryNameTextField=%@",(NSString*)[categoryNameTextField stringValue],categoryNameTextField );
      BOOL isGoodLength = ((categoryName && [categoryName length] >= MIN_CATEGORY_NAME_LENGTH)
                           &&
         (categoryName && [categoryName length] <= MAX_CATEGORY_NAME_LENGTH)) ? YES : NO;
      return [NSNumber numberWithBool:isGoodLength];
   }
   return NO;
}



@end
