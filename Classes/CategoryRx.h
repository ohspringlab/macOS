//
//  Category.h
//  HungryMe
//
//  Created by Mark on 3/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Recipe;

@interface CategoryRx : NSManagedObject {
 
   NSNumber * sortIndex;
   NSString * name;
   BOOL isBrowseAll;
   NSNumber* isEditable;
   BOOL selected;
   BOOL noRecipes;
   NSSet *recipes;
@private
}
@property (nonatomic, strong) NSNumber * sortIndex;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) BOOL isBrowseAll;
@property (nonatomic, strong) NSNumber* isEditable;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL noRecipes;
@property (nonatomic, strong) NSSet *recipes;

- (NSComparisonResult) compareCategorySortIndeces:(CategoryRx* )category; 
- (NSComparisonResult) compareCategoryNames:(CategoryRx* )category ;
//- (BOOL)isBrowseAll;
@end

@interface CategoryRx (CoreDataGeneratedAccessors)
- (void)addRecipesObject:(Recipe *)value;
- (void)removeRecipesObject:(Recipe *)value;
- (void)addRecipes:(NSSet *)value;
- (void)removeRecipes:(NSSet *)value;

@end
