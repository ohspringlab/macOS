//
//  Photo.m
//  iHungryMacNonDoc
//
//  Created by Mark on 3/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Photo.h"
#import "Recipe.h"

@implementation Photo

@dynamic iPhoneContentMode;
@dynamic path;
@dynamic  photoID;
@dynamic photoName;
@dynamic sortIndex;
@dynamic iPadContentMode;
@dynamic filename;
@dynamic image;

@dynamic recipes;

-(void) setPhotoID:(NSNumber *)pID{
   photoID = pID;
}

- (void)addRecipesObject:(Recipe *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"recipes" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"recipes"] addObject:value];
    [self didChangeValueForKey:@"recipes" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
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
