//
//  ResourcePathTransformer.m
//  iHungryMac386
//
//  Created by Apple  User on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResourcePathTransformer.h"


@implementation ResourcePathTransformer


+ (Class)transformedValueClass
{
   return [NSString self];
}

+ (BOOL)allowsReverseTransformation
{
   return NO;
}

- (id)transformedValue:(id)beforeObject
{
   if (beforeObject == nil) return nil;
   id resourcePath = [[NSBundle mainBundle] resourcePath];
   return [resourcePath stringByAppendingPathComponent:beforeObject];
}
@end
