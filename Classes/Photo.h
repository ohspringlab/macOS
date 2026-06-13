//
//  Photo.h
//  iHungryMacNonDoc
//
//  Created by Mark on 3/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//#import "Recipe.h"
@class Recipe;

@interface Photo : NSManagedObject {
   NSNumber * iPhoneContentMode;
   NSString * path;
   NSNumber * photoID;
   NSString * photoName;
   NSNumber * sortIndex;
   NSNumber * iPadContentMode;
   NSString * filename;
   NSData * image;
   
   NSSet* recipes;
@private
}
@property (nonatomic, strong) NSNumber * iPhoneContentMode;
@property (nonatomic, strong) NSString * path;
@property (nonatomic, strong) NSNumber * photoID;
@property (nonatomic, strong) NSString * photoName;
@property (nonatomic, strong) NSNumber * sortIndex;
@property (nonatomic, strong) NSNumber * iPadContentMode;
@property (nonatomic, strong) NSString * filename;
@property (nonatomic, strong) NSData * image;

@property (nonatomic, strong) NSSet* recipes;
@end

@interface Photo (CoreDataGeneratedAccessors)
- (void)addRecipesObject:(Recipe *)value;
- (void)removeRecipesObject:(Recipe *)value;
- (void)addRecipes:(NSSet *)value;
- (void)removeRecipes:(NSSet *)value;
@end
