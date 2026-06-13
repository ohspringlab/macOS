//
//  ObjectsToTitleTransformer.m
//  HungryMe
//
//  Created by Mark Barron on 11/22/14.
//
//

#import "ObjectsToTitleTransformer.h"
#define TITLE = @"HungryMe";

@implementation ObjectsToTitleTransformer

+ (Class)transformedValueClass
{
   return [NSString self];
}

+ (BOOL)allowsReverseTransformation
{
   return NO;
}

- (id)transformedValue:(id)value
{
   if (value == nil) {
      return [NSString stringWithFormat:@"HungryMe"];
   }
   NSArray *arrayOfObjs = (NSArray*) value;
   NSUInteger j = arrayOfObjs.count;
   
   NSString* title ;
   if (j > 0) {
      title = [NSString stringWithFormat:@"HungryMe (%lu)",j];
   }else
      title = [NSString stringWithFormat:@"HungryMe"];
   return title;
}


@end
