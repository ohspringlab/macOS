//
//  AppDelegate.m
//                   SqliteFromXml
//
//  Created by Apple  User on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
   //#import "XmlListReader.h"
   //#import "XmlListReader4.h"
#import "XmlListReader5.h"
#import "Category.h"
#import "Recipe.h"
#import "Photo.h"
#import "VersionXML.h"
#import "RecipeXML.h"
#import "sqlite3.h"
#import "DebugMacros.h"

@implementation AppDelegate

@synthesize persistentStoreCoordinator ;
@synthesize managedObjectModel ;
@synthesize managedObjectContext ;
@synthesize persistentStore ;

   //@synthesize window;
@synthesize myWindowController ;
@synthesize xmlListReader ;
@synthesize versionXML ;
@synthesize versionXMLString  ;
@synthesize installDateXMLString ;
@synthesize editDateXMLString;
@synthesize databaseURL;
@synthesize dictionaryCodeDisplayCategory;

@synthesize categoryArray;


   //called from - (IBAction) goBuildSqlite :(id)sender
   // inside SqliteFromXml

- (NSDictionary*) dictionaryCodeDisplayCategory{
   
	if (!dictionaryCodeDisplayCategory) {
      
		[self setDictionaryCodeDisplayCategory :
       [[NSDictionary alloc]
         initWithObjects:[NSArray arrayWithObjects:@"Snacks", @"Treats", @"Desserts",
                          @"Veggies", @"Entrees",@"Vegan", @"Soups", @"Sauces", @"Browse All" ,nil]
         forKeys:[NSArray arrayWithObjects:@"snack", @"treat", @"dessert",
                  @"veggie", @"entree", @"vegan", @"soup", @"sauce", @"browse_all" ,nil] ]];
	}
	return	dictionaryCodeDisplayCategory;
}

- (BOOL) populateDbFromXmlString:(NSString*)xmlFilePath{
   
   BOOL isPopulated = NO;
   
   NSManagedObjectContext *moc =
      //#ifdef SQLITE_FROM_XML
      [self managedObjectContext]; //INSERT MO
                                   //#else
                                   //[[self cdh] context]; //INSERT MO IHMP
                            //#endif
    // INSERT all XMLCategories into MOC  ***********

   for (NSString* displayName in [[self dictionaryCodeDisplayCategory] allValues] ) {
      NSManagedObject *newManagedObject =
         [NSEntityDescription insertNewObjectForEntityForName:@"Category"
                                       inManagedObjectContext:moc];
      Category* newCategory = (Category*)newManagedObject;
      [newCategory setName:displayName];///CATEG
      /// if cat == Browse_All set sortIndex to '-1'
      NSComparisonResult result = [displayName compare:@"Browse All"];
      if(result == NSOrderedSame){
         newCategory.sortIndex = [NSNumber numberWithInt: -1];
            //#ifdef DATAMODEL_5
            //newCategory.sectionName = @"A";// 7/24/14
         newCategory.firstLetter =@"A";//5/18/14
            //#endif
      }else{
            //out of use[newCategory setSectionName:displayName];///CATEG 4/29/14 //DM >= 5
         NSRange r;
         r.location = 0;
         r.length = 1;
         newCategory.firstLetter = [[newCategory.name capitalizedString] substringToIndex:1]; 
            //newCategory.sortindex = 0; //default
      }
      
      newCategory.modified = [NSDate date];
      
      [newCategory setModified:[NSDate date]];//2/24/14
      
      DLog(@"createUID for Cat:%@",newCategory.name);
      [newCategory setUid:[Photo calculateNewUniqueID]];
         //categoryInsertionCount++;
   }//for
 
   if (![moc hasChanges] ) {
      DLog(@"No Categories Inserted.");
      //abort();
   }else{
      // insert all Categories into datastore  ***********
      NSError* error2 = nil;
      if (![moc save:&error2]) { //SAVE BROWSE_ALL
         // Update to handle the error appropriately.
         //DLog(@"XMLLR:init:Unresolved error93:categDisp=%@ %@, %@",displayName, error2, [error2 userInfo]);
         exit(-123);  // Fail
      }
      NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
      NSEntityDescription *entityCat = [NSEntityDescription entityForName:@"Category"
      inManagedObjectContext:moc];
      [fetchRequest setEntity:entityCat];
      NSError *error = nil;
      
      self.categoryArray =
            [moc executeFetchRequest:fetchRequest error:&error];
      
      if(error){
         DLog(@"fetch error = %@\n[error userInfo]=%@",error, [error userInfo]);
         exit(-77);
      }
   }

   self.xmlListReader = [[XmlListReader alloc] init] ;//XmlListReader5
   [self.xmlListReader setTheAppDelegate:(AppDelegate*)[[NSApplication sharedApplication] delegate] ];
   NSError *parseError = nil;
   
   NSURL *xmlURL = [NSURL fileURLWithPath:xmlFilePath];
   
   [self.myWindowController.outputMessage setStringValue:@"XML Parse has begun."];
      
   [self.xmlListReader	parseXMLFileAtURL: xmlURL   parseError:&parseError] ;
   
   if (parseError) {
      DLog(@"Parse error=%@ [parseError userInfo=%@",parseError, [parseError userInfo]);
      [self.myWindowController.outputMessage setStringValue:[parseError localizedDescription] ];
      exit(-8);
   }
     // create VersionXML object in MO
   VersionXML* theCurrentVersionInDataBase = nil; // a registered ManagedObject
   
   NSManagedObject *newManagedObject =
      [NSEntityDescription insertNewObjectForEntityForName:@"VersionXML"
                                 inManagedObjectContext:[self managedObjectContext]]; //INSERT MO
   theCurrentVersionInDataBase = (VersionXML *) newManagedObject;
   ////}
   /// update Data
   theCurrentVersionInDataBase.editDate = [NSDate date];
   theCurrentVersionInDataBase.uid = [Photo calculateNewUniqueID ];
   theCurrentVersionInDataBase.modified = [NSDate date];
   NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
   [f setNumberStyle:NSNumberFormatterDecimalStyle];
   theCurrentVersionInDataBase.number =
      [f numberFromString:self.versionXMLString];//VERSION CHECK
   //NSLog(@"createUID for VersionXML:%@",theCurrentVersionInDataBase);
   
   NSError *error = nil;
   if (![[self managedObjectContext] save:&error]) {
      [[NSApplication sharedApplication] presentError:error];
   }
   
	self.xmlListReader = nil;

   isPopulated = YES;
   [self.myWindowController.outputMessage setStringValue:@"XML parsing has finished."];
   return isPopulated;
}


// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "com.DrummingGrouse.SqliteFromXml" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
   NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.DrummingGrouse.SqliteFromXml"];
}

#pragma mark CoreData Stack

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel) {
        return managedObjectModel;
    }
   // CDH has :  _model = [NSManagedObjectModel mergedModelFromBundles:nil];
   managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil]; // no entities uncommented 08/11/14
      //LaMarche USED
      //NSString *path = [[NSBundle mainBundle] pathForResource:@"SqliteFromXml" ofType:@"momd"];
   
   /* commented 8/11/14
   NSString *path = [[NSBundle mainBundle] pathForResource:@"IHM_Recipes" ofType:@"momd"];
   NSURL *momdURL = [NSURL fileURLWithPath:path];
   managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momdURL];
   NSLog(@"path=%@\nDataModel=%@\nEntities in DM=%@",path,managedObjectModel,[managedObjectModel entities]);
   */
   /*
    //WORKS
   NSURL *momURL = [NSURL fileURLWithPath:fullPath];
   managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
   */
     return managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator) {
        return persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        DLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }

    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom] ;
   
   NSError *error = nil;
   
      //NSDictionary *options = nil;
   NSDictionary *options = @{ //BEST FORM
                             NSSQLitePragmasOption : @{@"journal_mode" : @"DELETE"},
                             //NSReadOnlyPersistentStoreOption:@YES,
                            /// NSMigratePersistentStoresAutomaticallyOption : @YES,
                            /// NSInferMappingModelAutomaticallyOption : @YES
                             };

   
   persistentStore = [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:databaseURL options:options        error:&error];
   if (!persistentStore) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }

    persistentStoreCoordinator = coordinator;
    
    return persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 

- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator:coordinator];

    return managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save : message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        DLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
   DLog(@"context autosaved.");
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        DLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end
