//
//  Category.m
//  iHungryMacNonDoc
//
//  Created by Mark on 3/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoryRx.h"
#import "Recipe.h"

@implementation CategoryRx;
@dynamic sortIndex;
@dynamic   name;
@dynamic recipes;
@dynamic isEditable; // used in NSTableView
@synthesize  selected;
@dynamic isBrowseAll;
@synthesize noRecipes;

/*
- (NSString *) recipesAsString {
   
   // Return a string of the cuisine names separated by commas
   NSArray *theRecipes = [self recipeArray];
   if ( theRecipes && [theRecipes count] > 0 ) {
      return [[theRecipes valueForKey: @"name"] componentsJoinedByString: @", "];
   }
   
   // no recipes -- return nothing
   return nil;
}
*/

/**
 Returns the contents of the "cuisines" relationship in array format, rather
 than the Core Data standard set format.  This is a convenience accessor that
 is dependently bound to the "cuisines" relationship.
 */
/*
- (NSArray *)recipeArray {
   return [[self valueForKey:@"recipes"] allObjects];       
}
 */

- (void) setNoRecipes:(BOOL)value{
   noRecipes = value;
}

- (BOOL)noRecipes {
   // YES: if category is used by 1 or more recipes
  NSComparisonResult result = [self.name compare:@"Browse All"];
//   DLog(@"catName=%@",[self name]);
   NSArray *array = [[self recipes] allObjects];
   
   return (BOOL)( (result != NSOrderedSame) && [array count] == 0  );
}

/*
- (BOOL)isBrowseAll{
   NSComparisonResult result = [self.name compare:@"Browse All"];
   return (BOOL)( (result == NSOrderedSame)  );
}*/
 

- (NSComparisonResult) compareCategoryNames:(CategoryRx* )category
{
	return [[self name] localizedCaseInsensitiveCompare: [category name]];
}


- (NSComparisonResult) compareCategorySortIndeces:(CategoryRx* )category
{
	return [[self sortIndex] compare: [category sortIndex]];
} 



- (void)addRecipesObject:(Recipe *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"recipes" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"recipes"] addObject:value];
    [self didChangeValueForKey:@"recipes" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    //[changedObjects release];
}

- (void)removeRecipesObject:(Recipe *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"recipes" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"recipes"] removeObject:value];
    [self didChangeValueForKey:@"recipes" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
}

- (void)addRecipes:(NSSet *)value {    
    [self willChangeValueForKey:@"recipes" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"recipes"] unionSet:value];
    [self didChangeValueForKey:@"recipes" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeRecipes:(NSSet *)value {
    [self willChangeValueForKey:@"recipes" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"recipes"] minusSet:value];
    [self didChangeValueForKey:@"recipes" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
