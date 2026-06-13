//
//  DgxDropZone.m
//  
//
//  Created by Apple  User on 12/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "ImportExportDefines.h"
#import "DgxDropZoneView.h"
#import "AppDelegate.h"
#import "Recipe.h"
#import "CategoryRx.h"
#import "MyAppController.h"

@implementation DgxDropZoneView

@synthesize isHidden,fileContents,myAppController;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
       [self registerForDraggedTypes:[NSArray arrayWithObjects: 
               NSFilenamesPboardType, nil]];
       
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
   if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) 
       == NSDragOperationGeneric)
   {
      //this means that the sender is offering the type of operation we want
      //return that we want the NSDragOperationGeneric operation that they 
      //are offering
      return NSDragOperationCopy;
   }
   else
   {
      //since they aren't offering the type of operation we want, we have 
      //to tell them we aren't interested
      return NSDragOperationNone;
   }
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
   //we aren't particularily interested in this so we will do nothing
   //this is one of the methods that we do not have to implement
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender
{
   if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) 
       == NSDragOperationGeneric)
   {
      //this means that the sender is offering the type of operation we want
      //return that we want the NSDragOperationGeneric operation that they 
      //are offering
      return NSDragOperationGeneric;
   }
   else
   {
      //since they aren't offering the type of operation we want, we have 
      //to tell them we aren't interested
      return NSDragOperationNone;
   }
}

- (void)draggingEnded:(id <NSDraggingInfo>)sender
{
   //we don't do anything in our implementation
   //this could be ommitted since NSDraggingDestination is an infomal
   //protocol and returns nothing
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
   return YES;
}


- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
   NSPasteboard *paste = [sender draggingPasteboard];
   //gets the dragging-specific pasteboard from the sender
   NSArray *types = [NSArray arrayWithObjects://NSTIFFPboardType, 
                     NSFilenamesPboardType, nil];
   //a list of types that we can accept
   NSString *desiredType = [paste availableTypeFromArray:types];
   NSData *carriedData = [paste dataForType:desiredType];
   
   if (nil == carriedData)
   {
      //the operation failed for some reason
      NSRunAlertPanel(@"Paste Error", @"Sorry, but the past operation failed", 
                      nil, nil, nil);
      return NO;
   }
   else
   {
      //the pasteboard was able to give us some meaningful data
     /* if ([desiredType isEqualToString:NSTIFFPboardType])
      {
         //we have TIFF bitmap data in the NSData object
         NSImage *newImage = [[NSImage alloc] initWithData:carriedData];
         [self setImage:newImage];
         [newImage release];    
         //we are no longer interested in this so we need to release it
      }
      else */ if ([desiredType isEqualToString:NSFilenamesPboardType])
      {
         //we have a list of file names in an NSData object
         NSArray *fileArray = 
            [paste propertyListForType:@"NSFilenamesPboardType"];
         //be caseful since this method returns id.  
         //We just happen to know that it will be an array.
         if ([fileArray count] == 0) {
            NSRunAlertPanel(@"File Reading Error",
                            @"No DGX file was found in the drag operation.",
                            nil, nil, nil);
            return NO;
         }
         NSString *path = [fileArray objectAtIndex:0];
         if (![[[path pathExtension] lowercaseString] isEqualToString:@"dgx"]) {
            NSRunAlertPanel(@"File Reading Error",
                            @"Please drop a .dgx recipe file.",
                            nil, nil, nil);
            return NO;
         }
         //assume that we can ignore all but the first path in the list
         //NSImage *newImage = [[NSImage alloc] initWithContentsOfFile:path];
         NSError *error99 = nil;
         NSStringEncoding theEncoding = NSUTF8StringEncoding;
         NSString *dgxText = [NSString stringWithContentsOfFile:path usedEncoding:&theEncoding  error:&error99];
         
         if (nil == dgxText)
         {
            //we failed for some reason
            NSRunAlertPanel(@"File Reading Error", 
                            [NSString stringWithFormat:
                             @"Sorry, but I failed to open the file at \"%@\"",
                             path], nil, nil, nil);
            return NO;
         }
         else
         {
            //newImage is now a new valid image
            [self setFileContents:dgxText];
         }
         //[newImage release];
      }
      else
      {
         //this can't happen
         NSAssert(NO, @"This can't happen");
         return NO;
      }
   }
   [self setNeedsDisplay:YES];    //redraw us with the new image
   return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
   //re-draw the view with our new data
   [self setNeedsDisplay:YES];
   [self importRecipes];
   
}

#define TOP_IMPORT_MSG  @"\n If the dated message below is the final entry in this DGX import log file, that is, \nif no recipe names are found below in this log file, you have not used '[[' to begin the recipe names.\n If the first recipe name in this log file is not the first recipe name in the DG_Recipes_Import.dgx file,\n you have not correctly used '[[' to signal the begin of some recipe names. These names which are missing from the LOG file,  will be found in the DGX file.\n These recipe names will be found there above first recipe name in this log file."

- (void) importRecipes {
   
   BOOL okLog;
   NSString *outString = [NSString stringWithFormat:@"%@\n\nBegin Recipes Import: %@",TOP_IMPORT_MSG,[[NSDate date] description] ];
   NSString *tempFinalImportedRecipe ;
   NSString *recipesLogFilename = [NSString stringWithFormat: @"%@.%@",BASE_RECIPES_FILENAME_IMPORT,@"log"];
   int nRecipeWrittenCount = 0, nRecipeCount = 0;
   NSString *finalImportedRecipe = @"No Recipe";
   NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   NSString *documentsDir = [documentPaths objectAtIndex:0];
   NSString *recipesLogFilespec = [documentsDir stringByAppendingPathComponent:recipesLogFilename];
   NSError *error99 = nil;
   NSError *errorLog = nil;
   NSStringEncoding theEncoding = NSUTF8StringEncoding;
   AppDelegate * appDel = [ [NSApplication sharedApplication] delegate ];
   NSString *myText = [[self fileContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   
   BOOL isFormatErrorFound = NO;
   BOOL isSaveError = NO;
   if (myText && [myText length] > 0) {
      NSRange rangeNameStartTag = [myText rangeOfString:BEGIN_RECIPE_NAME];
      if(rangeNameStartTag.location == NSNotFound){
         outString = [outString stringByAppendingFormat:@"\nThe input file is missing the '[[' tag before the first recipe name."];
      }
      if([myText rangeOfString:START_CATEGORY_TAG].location == NSNotFound){
         outString = [outString stringByAppendingFormat:@"\nNo category marker '::' was found. The recipe will be imported into Browse All only."];
      }
      while (rangeNameStartTag.location != NSNotFound && !isFormatErrorFound && !isSaveError) {
         NSRange nameEndSearchRange = NSMakeRange(rangeNameStartTag.location + [BEGIN_RECIPE_NAME length],
                                                  [myText length] - (rangeNameStartTag.location + [BEGIN_RECIPE_NAME length]));
         NSRange rangeNameEndTag = [myText rangeOfString:END_RECIPE_NAME options:0 range:nameEndSearchRange];
         if (rangeNameEndTag.location == NSNotFound) {
            outString = [outString stringByAppendingFormat:@"\nThe end of name tag, ']]', is missing from the final recipe name."];
            isFormatErrorFound = YES;
            continue;
         }
         NSRange rangeBetweenBrackets = NSMakeRange(rangeNameStartTag.location + [BEGIN_RECIPE_NAME length],
                                                    rangeNameEndTag.location - rangeNameStartTag.location - [BEGIN_RECIPE_NAME length]);
         NSString *recipeNameAndCats = [[myText substringWithRange:rangeBetweenBrackets] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
         NSArray *listItems = [recipeNameAndCats componentsSeparatedByString:START_CATEGORY_TAG];
         NSString *recipeName = [[listItems objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
         tempFinalImportedRecipe = recipeName;
         
         NSUInteger bodyStart = rangeNameEndTag.location + [END_RECIPE_NAME length];
         NSString *bodyAndRest = [myText substringFromIndex:bodyStart];
         NSRange rangeNextNameStartTag = [bodyAndRest rangeOfString:BEGIN_RECIPE_NAME];
         NSString *recipeBody = (rangeNextNameStartTag.location == NSNotFound) ? bodyAndRest : [bodyAndRest substringToIndex:rangeNextNameStartTag.location];
         
         NSRange rangeDirectionsTag = [recipeBody rangeOfString:DIRECTIONS_TAG_STRING];
         NSRange rangeCommentsTag = [recipeBody rangeOfString:COMMENTS_TAG_STRING];
         BOOL isMissingDirectionsTag = (rangeDirectionsTag.location == NSNotFound);
         BOOL isMissingCommentsTag = (rangeCommentsTag.location == NSNotFound);
         BOOL isTagOrderIncorrect = (!isMissingDirectionsTag && !isMissingCommentsTag && rangeDirectionsTag.location > rangeCommentsTag.location);
         
         if(isTagOrderIncorrect || isMissingDirectionsTag || isMissingCommentsTag ) {
            if(isTagOrderIncorrect){
               outString = [outString stringByAppendingFormat:@"\n'Directions@' and 'Comments@' tags out of order for: %@",recipeName];
            }
            if(isMissingDirectionsTag){
               outString = [outString stringByAppendingFormat:@"\n'Directions@' tag is missing for: %@",recipeName];
            }
            if(isMissingCommentsTag){
               outString = [outString stringByAppendingFormat:@"\n'Comments@' tag is missing for: %@",recipeName];
            }
            outString = [outString stringByAppendingFormat:@"\n\nPlease edit the %@ file and try importing it again.",recipesLogFilename];
            isFormatErrorFound = YES;
            continue;
         }
         
         NSUInteger directionsStart = rangeDirectionsTag.location + [DIRECTIONS_TAG_STRING length];
         if (directionsStart < [recipeBody length] && [recipeBody characterAtIndex:directionsStart] == '.') {
            directionsStart++;
         }
         NSUInteger commentsStart = rangeCommentsTag.location + [COMMENTS_TAG_STRING length];
         if (commentsStart < [recipeBody length] && [recipeBody characterAtIndex:commentsStart] == '.') {
            commentsStart++;
         }
         NSString *recipeIngredients = [[recipeBody substringToIndex:rangeDirectionsTag.location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
         NSString *recipeDirections = [[recipeBody substringWithRange:NSMakeRange(directionsStart, rangeCommentsTag.location - directionsStart)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
         NSString *recipeComments = [[recipeBody substringFromIndex:commentsStart] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
         
         NSMutableArray *categoryArrayWithList = [NSMutableArray array];
         if ([listItems count] > 1) {
            NSArray *categoryArrayFromFile = [appDel getCategoriesFromList:listItems];
            if (categoryArrayFromFile) {
               [categoryArrayWithList addObjectsFromArray:categoryArrayFromFile];
            }
         }
         CategoryRx *catBrowseAll = [appDel fetchCategoryBrowseAll];
         if (catBrowseAll) {
            [categoryArrayWithList addObject:catBrowseAll];
         }
         
         nRecipeCount++;
         
         /*** check if recipe already present ***/
         
         NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];//autorelease add 10/12/11         // Edit the entity name as appropriate.
         NSEntityDescription *entityRx = [NSEntityDescription entityForName:@"Recipe"	
                                                     inManagedObjectContext:[appDel managedObjectContext]];
         [fetchRequest setEntity:entityRx];
         
         NSString *attributeName = @"name";
         
         NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                   @"%K LIKE [cd] %@",attributeName, recipeName ];
         [fetchRequest setPredicate:predicate];
         NSError *error = nil;
         
         NSArray *rxArray = [[appDel managedObjectContext] executeFetchRequest:fetchRequest error:&error]; 
         if(error){
            DLog(@"Error fetching recipe");
         }
         //DLog(@"[rxArray count]=%d",[rxArray count]);
         
         if([rxArray count] == 0){ // Rx not yet present. Go ahead and insert new Rx
            // Now insert RecipeName, I,D and C into DB
            NSManagedObject *newManagedObject = 
            [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" 
                                          inManagedObjectContext:[appDel managedObjectContext]]; //INSERT MO
            [newManagedObject setValue:recipeName forKey:@"name"];
            [newManagedObject setValue:recipeIngredients forKey:@"ingredients"];
            [newManagedObject setValue:recipeDirections forKey:@"directions"];
            [newManagedObject setValue:recipeComments forKey:@"comments"];
            
            Recipe* theRecipe = (Recipe *) newManagedObject;
            if ([categoryArrayWithList count] > 0) {
               [theRecipe addCategories:[NSSet setWithArray:categoryArrayWithList]];
            }            
            
            for(CategoryRx *categ in categoryArrayWithList){
               [categ addRecipesObject:theRecipe];
            }
            //DLog(@"theRecipe=%@ \ncategoryArrayWithList=%@",theRecipe,categoryArrayWithList);
            
            outString = [outString stringByAppendingFormat:@"\nAbout to save recipe:%@",recipeName];
            
            NSError *error91 = nil;
            if (![[appDel managedObjectContext] save:&error91]) {
               outString = [outString stringByAppendingFormat:@"\nTerminating.\n Could not save recipe #%d :\n'%@'\n to database.",nRecipeCount,recipeName];
               [[appDel managedObjectContext] deleteObject:newManagedObject ];///check uncommented 12/5/11
               // Update to handle the error appropriately.
               int nErrorCode = [error91 code];
               if(nErrorCode == 1660)
                  outString = [outString stringByAppendingFormat:@"\nThe Recipe Name exceeds the maximum length of %d characters.",MAX_RECIPE_NAME_LENGTH];
               //DLog(@"Perhaps Recipe Name Length:Unresolved error %@, %@", error91, [error91 userInfo]);
               isSaveError = YES;
            }else {
               nRecipeWrittenCount++;
               finalImportedRecipe = tempFinalImportedRecipe;
               outString = [outString stringByAppendingFormat:@"\nDid save recipe #%d :\n'%@'\nto database.\n",nRecipeCount,recipeName];
            }
         }else{ // don't try to put in DB, Log it.
            
            outString = [outString stringByAppendingFormat:@"\nDid not save recipe #%d :\n'%@'\nto database. It was already present.\n",nRecipeCount,recipeName];
         }
         /*** end check for recipe existence ***/
         if (rangeNextNameStartTag.location == NSNotFound) {
            myText = @"";
            rangeNameStartTag = NSMakeRange(NSNotFound, 0);
         } else {
            myText = [[bodyAndRest substringFromIndex:rangeNextNameStartTag.location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            rangeNameStartTag = [myText rangeOfString:BEGIN_RECIPE_NAME];
         }
         
      } //end while loop
      
      okLog = [outString writeToFile:recipesLogFilespec atomically:YES
                            encoding:theEncoding error:&errorLog];
      if (!okLog) {
         // an error occurred
         DLog(@"Outstring:Error writing file at %@\n%@",
              recipesLogFilespec, [errorLog localizedFailureReason]);
      }
      /***     
       if (nRecipeWrittenCount > MAX_RECIPE_COUNT_FOR_NO_DGX_DELETE && !isSaveError) {
       // delete recipesFilespec
       NSError *errorRemove=nil;
       if(![[NSFileManager defaultManager] removeItemAtPath:recipesFilespec error:&errorRemove ]){
       DLog(@"Error deleting %@ file.Error:%@", RECIPES_FILE_EXTENSION_UPPERCASE,[errorRemove localizedFailureReason] );
       //NSLog(@"Use iTunes->Your Device->Apps->File Sharing to access the log file on your device. File Name: %@",
       //recipesLogFilespec);
       }else{
       DLog(@"Recipe file was deleted.");
       }
       }
       ***/
      // Show Alert notifying of recipe additions.
 /**     IMPLEMENT ALERT
      [self importRecipesAlertAction:nRecipeWrittenCount finalRecipe:finalImportedRecipe logfile:outString ];
  **/
   } else {
      DLog(@"error reading recipesFile =\n%@",error99);
   }
   /*****************/
   NSString *informString = [NSString stringWithFormat:@"%d recipe(s) inserted into DB.",nRecipeWrittenCount];
   NSAlert *alert = [[NSAlert alloc] init];
   [alert setAlertStyle:NSInformationalAlertStyle];
   [alert setMessageText:@"Import Recipe Info"];
   [alert setInformativeText:informString];
    
    [alert beginSheetModalForWindow:[self window]
         modalDelegate:self
            didEndSelector:@selector(importRecipeAlertDidEnd:returnCode:
                                              contextInfo:)
               contextInfo:nil];
   
   /****************/
   
   [[myAppController appDelegate] updateGlobalCategoryArray];//namely [appDel recipeArray]
   //[[myAppController appDelegate] updateLocalCategoryArray];
   
   [[myAppController tableViewCat] reloadData];
 
  
   
}// end importRecipes

- (void)importRecipeAlertDidEnd:(NSAlert *)alert
                          returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
   NSLog(@"clicked %d button\n", returnCode);
   
   [alert release];
}

- (void) dealloc {
   [self unregisterDraggedTypes];
   [super dealloc];
}

@end
