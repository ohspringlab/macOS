//
//  Recipe.h
//  iHungryMacNonDoc
//
//  Created by Mark on 3/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class CategoryRx;
@class Photo;

@interface Recipe : NSManagedObject {

   NSNumber * sortIndex;
   NSNumber * ctime;
   NSString * ingredients;
   NSNumber * ptime;
   NSString * comments;
   NSNumber * recipeID;
   NSString * name;
   NSString * nameShort;
   NSString * directions;
   
      //   NSSet* photos;
   NSSet* categories;
   BOOL selected;
@private
}

@property (nonatomic, strong) NSString * ingredients;
@property (nonatomic, strong) NSString * directions;
@property (nonatomic, strong) NSString * comments;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) NSNumber * sortIndex;
@property (nonatomic, strong) NSNumber * ctime;
@property (nonatomic, strong) NSNumber * ptime;
@property (nonatomic, strong) NSNumber * recipeID;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * nameShort;
@property (nonatomic, strong) NSSet* photos;
@property (nonatomic, strong) NSSet* categories;

- (NSComparisonResult)compareRecipeNames:(Recipe *)recipe;
- (NSComparisonResult) sortByName:(Recipe *)recipe;
- (NSString *) commentsAsString;

@end


@interface Recipe (CoreDataGeneratedAccessors)
- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)value;
- (void)removePhotos:(NSSet *)value;

- (void)addCategoriesObject:(CategoryRx *)value;
- (void)removeCategoriesObject:(CategoryRx *)value;
- (void)addCategories:(NSSet *)value;
- (void)removeCategories:(NSSet *)value;

@end
