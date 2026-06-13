//
//  Recipe.m
//  iHungryMacNonDoc
//
//  Created by Mark on 3/14/11.
// in sync with iHungryMe as of 3/30/11
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Recipe.h"
#import "CategoryRx.h"
#import "Photo.h"
@class Photo;

@implementation Recipe

@dynamic  sortIndex;
@dynamic ctime;
@dynamic ingredients;
@dynamic ptime;
@dynamic comments;
@dynamic recipeID;
@dynamic name;
@dynamic nameShort;
@dynamic directions;
@dynamic photos;
@dynamic categories;
@dynamic  selected;
   //@dynamic selected;



- (NSString *) commentsAsString{
   return comments;
}

- (NSString *) name{
   return name;
}

/*
 - (void) setSortedPhotoArray:(NSArray*) ray{
 if(ray != sortedPhotoArray)
 [ray retain];
 [sortedPhotoArray release];
 sortedPhotoArray = ray;
 }*/

/*
 - (NSArray*)sortedCategoryArray 
 {
 NSArray* tmpValue;
 
 [self willAccessValueForKey:@"sortedCategoryArray"];
 tmpValue = [self primitiveValueForKey:@"sortedCategoryArray"];
 [self didAccessValueForKey:@"sortedCategoryArray"];
 
 return tmpValue;
 }
 
 - (void)setSortedCategoryArray:(NSArray*)value 
 {
 [self willChangeValueForKey:@"sortedCategoryArray"];
 [self setPrimitiveValue:value forKey:@"sortedCategoryArray"];
 [self didChangeValueForKey:@"sortedCategoryArray"];
 }
 
 - (NSArray*)sortedPhotoArray 
 {
 NSArray* tmpValue;
 
 [self willAccessValueForKey:@"sortedPhotoArray"];
 tmpValue = [self primitiveValueForKey:@"sortedPhotoArray"];
 [self didAccessValueForKey:@"sortedPhotoArray"];
 
 return tmpValue;
 }
 
 - (void)setSortedPhotoArray:(NSArray*)value 
 {
 [self willChangeValueForKey:@"sortedPhotoArray"];
 [self setPrimitiveValue:value forKey:@"sortedPhotoArray"];
 [self didChangeValueForKey:@"sortedPhotoArray"];
 }
 */

/**
- (id)init{
	
	[super init];
	
	//[sortDescriptors release];
	return self;
} **/

/*
 - (BOOL)isEqual:(Recipe*)anObject{
 //return (name compare:[anObject name] == NSOrderedSame	);
 return [self compareRecipeNames:anObject] == NSOrderedSame;
 }*/


 - (NSComparisonResult) sortByName:(Recipe *)recipe  {
 // Compare nodes to each other by comparing the data part.
 return [self.name compare:[recipe name]];
 }





- (void)addCategoriesObject:(CategoryRx *)value
{    
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
	
	[self willChangeValueForKey:@"categories" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
	[[self primitiveValueForKey:@"categories"] addObject:value];
	[self didChangeValueForKey:@"categories" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
	
	//[self updateSortedCategoryArray];
	
}

- (void)removeCategoriesObject:(CategoryRx *)value 
{
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
	
	[self willChangeValueForKey:@"categories" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	[[self primitiveValueForKey:@"categories"] removeObject:value];
	[self didChangeValueForKey:@"categories" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	
	//[self updateSortedCategoryArray];
	
}

- (void)addPhotosObject:(Photo*)value 
{    
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
	
	[self willChangeValueForKey:@"photos" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
	[[self primitiveValueForKey:@"photos"] addObject:value];
	[self didChangeValueForKey:@"photos" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
	
	//[self updateSortedPhotoArray];
	
}

- (void)removePhotosObject:(Photo *)value 
{
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
	
	[self willChangeValueForKey:@"photos" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	[[self primitiveValueForKey:@"photos"] removeObject:value];
	[self didChangeValueForKey:@"photos" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	
	//[self updateSortedPhotoArray];
	
}

/*
- (void) updateSortedPhotoArray{
	
	NSArray* sortDescriptors =	[NSArray arrayWithObject:[[[NSSortDescriptor alloc] 
         initWithKey:@"sortIndex" ascending:YES 
            selector:@selector(compare:)] autorelease]];
	sortedPhotoArray =  [[[self photos] allObjects] 
                        sortedArrayUsingDescriptors:sortDescriptors];
	int i = 0; // here sorted, but could have sortedIndeces 0,1,3,4 need : 0,1,2,3
	for(Photo* thePhoto in [self sortedPhotoArray]) 
		thePhoto.sortIndex = [NSNumber numberWithInt: i++];
}

- (void) updateSortedCategoryArray {
	
	NSArray* sortDescriptors =	[NSArray arrayWithObject:[[[NSSortDescriptor alloc] 
																			initWithKey:@"sortIndex" ascending:YES 
																			selector:@selector(compare:)] autorelease]];
	sortedCategoryArray =  [[[self categories] allObjects] 
                           sortedArrayUsingDescriptors:sortDescriptors];
	int i = 0; // here sorted, but could have sortedIndeces 0,1,3,4 need : 0,1,2,3
	for(Category* theCategory in [self sortedCategoryArray]) {
		theCategory.sortIndex = [NSNumber numberWithInt: i++];
	}
}
 **/

- (NSComparisonResult)compareRecipeNames:(Recipe *)recipe  {
	// Compare nodes to each other by comparing the data part.
	return [self.name compare:[recipe name] options:NSCaseInsensitiveSearch];
}

/***
- (BOOL)validateSortedPhotoArray:(id *)valueRef error:(NSError **)outError 
{
	// Insert custom validation logic here.
	return YES;
}
- (BOOL)validateSortedCategoryArray:(id *)valueRef error:(NSError **)outError 
{
	// Insert custom validation logic here.
	return YES;
}
***/


@end
