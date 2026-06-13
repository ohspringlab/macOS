//
//  iHungryMacNonDoc_AppDelegate.h
//  iHungryMacNonDoc
//
//  Created by Mark on 3/10/11.
//  Copyright __MyCompanyName__ 2011 . All rights reserved. //
//
//#import "Reachability.h"
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "XmlListReader.h"
#import "MyAppController.h"


@class VersionXML;
@class RecipeXML;
@class IngredXML ;
@class RecipeWindowController;
@class MyAppController;
   //@class HelpWindowController;

@interface AppDelegate : NSObject <NSApplicationDelegate,NSFileManagerDelegate>
{
   IBOutlet NSWindow *window;
   NSPersistentStoreCoordinator *persistentStoreCoordinator;
   NSManagedObjectModel *managedObjectModel;
   NSManagedObjectContext *managedObjectContext;
   
   NSMutableArray* sortedRecipeArray;
   NSArray *recipeArray;
  NSArray *categoryArray;
   CategoryRx* activeCategory;
   Recipe *activeRecipe; // check there are two instance
   XmlListReader *xmlListReader;
   VersionXML* versionXML;
   NSString* versionXMLString;
   NSString* installDateXMLString;
   NSString* editDateXMLString;
   BOOL isXmlFileVersionNewer;
   //NSNumber* maxRecipeId;
   //NSString * fullPathXML;
  // NSString * fullPathSqlite;
   BOOL doesDbExistAtLoad;
   NSArray* selectedCategoryObjs;
   NSFont* tableFont;
   NSArray *categorySortDescriptorsNameAndSortIndex;
   NSPredicate *predicateAllButBrowseAll;
   NSSortDescriptor *sortDescriptorNameAscInsen;
   //NSMutableSet * recipeWindowControllerSet;
   IBOutlet MyAppController *myAppController; //TEMP
    NSPredicate *selectedPredicate;
@private
}
@property   (nonatomic,strong)  NSNumber* maxRecipeIdDb;
@property   (nonatomic,strong)  NSNumber* maxRecipeIdXml;
@property (nonatomic,strong) NSFileManager *fileManager;
@property (nonatomic,strong) MyAppController *myAppController;
//@property (nonatomic,strong) NSMutableSet * recipeWindowControllerSet;
@property (nonatomic,strong) NSSortDescriptor *sortDescriptorNameAscInsen;
@property (nonatomic,strong) NSWindow *window;
@property (nonatomic,strong) NSPredicate *predicateAllButBrowseAll;
@property (nonatomic, strong) NSArray *categorySortDescriptorsNameAndSortIndex;
@property (nonatomic, strong) NSPredicate *selectedPredicate;

@property (nonatomic,strong) NSFont* tableFont;// defined in *.m
@property (nonatomic, strong) NSArray* selectedCategoryObjs;

@property (nonatomic, strong) NSMutableArray* sortedRecipeArray;

@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

//@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator2;
//@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel2;
//@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext2;


@property (nonatomic, strong) NSArray *recipeArray;
@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) Recipe *activeRecipe;
@property (nonatomic, strong) CategoryRx *activeCategory;
@property (nonatomic, strong) XmlListReader	*xmlListReader;

@property (nonatomic, strong) VersionXML* versionXML;
@property (nonatomic, copy) NSString* versionXMLString;
@property (nonatomic, strong) NSString* installDateXMLString;
@property (nonatomic, strong) NSString* editDateXMLString;
@property (nonatomic, assign) BOOL isXmlFileVersionNewer;
//@property (nonatomic, copy) NSString* fullPathXML;
//@property (nonatomic, copy) NSString* fullPathSqlite;
@property (nonatomic, assign) BOOL doesDbExistAtLoad;

@property (nonatomic, strong) NSURL *localStoreURL;
@property (nonatomic, strong) NSURL *tempLocalStoreURL;

//- (NSArray *)getCategoryArrayMinusBrowseAll;

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectModel *)managedObjectModel;
- (NSManagedObjectContext *)managedObjectContext;
   // - (IBAction) print:(id)sender;
- (NSArray *)  getCategoriesFromList:(NSArray *) listCatNames;
- (void) updateGlobalCategoryArray;
- (void) resizeBothTableViewRowHeights;
- (CategoryRx *)fetchCategoryBrowseAll;
///- (NSArray *)categoryArray;
-(void)changeMyFont:(id)sender;
@end;
/* 
 NSVerticallCenteredTextFieldCell
 This source code is provided to you compliments of Red Sweater Software under the license as described below. NOTE: This is the MIT License.
 
 Copyright (c) 2006 Red Sweater Software
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 */
