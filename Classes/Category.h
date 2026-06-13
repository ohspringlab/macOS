//
//  Category.h
//  iHungryMacNonDoc
//
//  Created by Mark on 3/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recipe;

@interface Category : NSManagedObject {
   NSNumber * sortIndex;
   NSString * name;
   NSSet* recipes;
   NSNumber* isEditable;
   BOOL noRecipes;
   BOOL selected;
   BOOL isBrowseAll;
@private
}
@property (nonatomic, assign) BOOL isBrowseAll;
@property (nonatomic, strong) NSNumber* isEditable;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) BOOL noRecipes;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) NSNumber * sortIndex;

@property (nonatomic, strong) NSSet* recipes;


- (NSComparisonResult) compareCategorySortIndeces:(Category *)category; 
- (NSComparisonResult) compareCategoryNames:(Category *)category ;
- (BOOL)isBrowseAll;
//- (BOOL)noRecipes;
// Returns the array of cuisines

// Return a comma-separated string of the cuisines names
//- (NSString *)recipesAsString;

//- (void)setEditable:(NSNumber *)edit;
//- (BOOL)editable;
@end

@interface Category (CoreDataGeneratedAccessors)
- (void)addRecipesObject:(Recipe *)value;
- (void)removeRecipesObject:(Recipe *)value;
- (void)addRecipes:(NSSet *)value;
- (void)removeRecipes:(NSSet *)value;

@end
