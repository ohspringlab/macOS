//
//  NSArrayController+NameCheck.m
//  
//
//  Created by Mark on 1/7/13.
//
//

#import "NSArrayController+NameCheck.h" 
#import "CategoryRx.h"
#import "Recipe.h"
#import "RecipeDefines.h"
   //#import "MyAppController.h"
#import "AppDelegate.h"

@implementation NSArrayController (NameCheck)

- (BOOL) isNameLengthOK_DG:(NSString*)name{
   BOOL retVal;
   
   if (!name || name.length == 0) {
      return NO;
   }
   
   int nameLen = (int)name.length;
   
   NSComparisonResult result = [self.entityName compare:@"CategoryRx" options:NSCaseInsensitiveSearch];
   if (result == NSOrderedSame) {
      retVal = (nameLen >= MIN_CATEGORY_NAME_LENGTH && nameLen <= MAX_CATEGORY_NAME_LENGTH);
      
   } else {
      retVal = (nameLen >= MIN_RECIPE_NAME_LENGTH && nameLen <= MAX_RECIPE_NAME_LENGTH);
   }
   
   return retVal;
   
}

- (BOOL) isNameUnique_DG:(NSString*)name {

   NSString *nameTrimmed = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   //may need to make unique if len < MIN , i.e. 0 or 1
   
   
      //MyAppController *myAppController = [(AppDelegate*)[NSApp delegate] myAppController];
   NSArray *nameSearchArray;
   NSComparisonResult result = [self.entityName compare:@"CategoryRx"];
   if (result == NSOrderedSame) {
      if (!name|| nameTrimmed.length < MIN_CATEGORY_NAME_LENGTH) {
         //DLog(@"Short Category name=%@",name);
         return NO;
      }
      nameSearchArray = [[self arrangedObjects] valueForKey:@"name"];
      
   } else { //"Recipe"
      if (!name|| nameTrimmed.length < MIN_RECIPE_NAME_LENGTH) {
         DLog(@"Short Recipe name=%@",name);
         return NO;
      }
      NSFetchRequest *fetchRequest3 = [[NSFetchRequest alloc] init];
      NSEntityDescription *entity3 = [NSEntityDescription entityForName:@"Recipe"
                                                 inManagedObjectContext:[(AppDelegate*)[[NSApplication sharedApplication] delegate] managedObjectContext]];
      [fetchRequest3 setEntity:entity3];
      NSError *error3 = nil;
      NSArray *recipeArray = [[(AppDelegate*)[[NSApplication sharedApplication] delegate] managedObjectContext] executeFetchRequest:fetchRequest3 error:&error3];
      if (!recipeArray) {
         return NO;
      }
      if (error3) {
         DLog(@"iHMdidLaunch:Version Fetch error. Normal until fixed");
      }
      
      nameSearchArray = [recipeArray valueForKey:@"name"];
   }
   
   NSEnumerator *enumerator = [nameSearchArray objectEnumerator];
   BOOL isNameUnique = YES;
   NSString *aName;
   DLog(@"nameTrimmed=%@",nameTrimmed);
   while (aName = [enumerator nextObject]) {
      //DLog(@"aName=%@",aName);
      //result = [aName localizedCaseInsensitiveCompare:nameTrimmed];
      result = [aName compare:nameTrimmed];
      if (result == NSOrderedSame) {
         isNameUnique = NO;
         break;
      }
   }
   return isNameUnique;
}

@end