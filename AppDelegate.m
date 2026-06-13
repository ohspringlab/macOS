//
//  AppDelegate.m
//  iHungryMacNonDoc
//
//  Created by Mark on 3/10/11.
//  Copyright __MyCompanyName__ 2011 . All rights reserved.
//
/// If your application tracks the resource being located by its identity so
// that it can be found if the user moves the file, then you should
// explicitly write the NSURL's bookmark data or encode a file reference URL
#import "AppDelegate.h"
#import "CategoryRx.h"
#import "Recipe.h"
#import "VersionXML.h"
#import "RecipeXML.h"
#import "sqlite3.h"
#import "RecipeWindowController.h"
//#import  "RecipeWindow.h"
#import "Constants.h"
#import "MyAppController.h"
#import "XmlListReader.h"
#import "RxFilteredArrayController.h"
#import "Constants.h"
#import "NSFileManager+DirectoryLocations.h"

#import "NSSplitView+CCD_LayoutAdditions.h"
//#import <SenTestingKit/SenTestingKit.h>

@implementation AppDelegate

@synthesize predicateAllButBrowseAll;
@synthesize  myAppController;
//@synthesize recipeWindowControllerSet;
@synthesize  sortDescriptorNameAscInsen;
@synthesize sortedRecipeArray;
@synthesize window;

@synthesize persistentStoreCoordinator;
@synthesize managedObjectContext;
@synthesize managedObjectModel;
//@synthesize persistentStoreCoordinator2;
//@synthesize managedObjectContext2;
//@synthesize managedObjectModel2;

@synthesize recipeArray;
@synthesize categoryArray;
@synthesize activeRecipe,activeCategory;

@synthesize xmlListReader;
@synthesize versionXML;
@synthesize versionXMLString;
@synthesize installDateXMLString,editDateXMLString;
@synthesize isXmlFileVersionNewer;
@synthesize maxRecipeIdDb;
@synthesize maxRecipeIdXml;
//@synthesize fullPathSqlite,fullPathXML;
@synthesize doesDbExistAtLoad;
@synthesize selectedCategoryObjs;
@synthesize fileManager;

@synthesize localStoreURL;
@synthesize tempLocalStoreURL;
@synthesize categorySortDescriptorsNameAndSortIndex;
@synthesize selectedPredicate;



//IHUNGRYMAC
- (NSURL*) localStoreURL {
   if (localStoreURL) {
      return localStoreURL;
   }
   localStoreURL = [[self applicationFilesDirectory] URLByAppendingPathComponent:@"HM_Mac_Recipes.sqlite"];
   return localStoreURL;
}

- (NSURL*) tempLocalStoreURL {
   if (tempLocalStoreURL) {
      return tempLocalStoreURL;
   }
   tempLocalStoreURL = [[self applicationFilesDirectory] URLByAppendingPathComponent:@"tempRecipes.sqlite"];
   return tempLocalStoreURL;
}


- (NSPredicate*) selectedPredicate{
    if(!selectedPredicate)
        selectedPredicate = [NSPredicate predicateWithFormat:@"selected == YES"];
    return selectedPredicate;
}

- (NSPredicate*) predicateAllButBrowseAll{
    if(!predicateAllButBrowseAll)
        predicateAllButBrowseAll = [NSPredicate predicateWithFormat:@"sortIndex != -1"];
    return predicateAllButBrowseAll;
}

- (NSArray*) categorySortDescriptorsNameAndSortIndex {
    if (categorySortDescriptorsNameAndSortIndex) {
        return categorySortDescriptorsNameAndSortIndex;
    }
    categorySortDescriptorsNameAndSortIndex =
    [NSArray arrayWithObjects:
     [[NSSortDescriptor alloc] initWithKey:@"sortIndex" ascending:YES
                                  selector:@selector(compare:)]
     , [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES
                                    selector:@selector(localizedCaseInsensitiveCompare:)],nil];
    return categorySortDescriptorsNameAndSortIndex  ;
}

/*
- (void) setRecipeWindowControllerSet:(NSMutableSet *)rWCS{
   recipeWindowControllerSet = rWCS;
}

- (NSMutableSet*) recipeWindowControllerSet {
   
   if(!recipeWindowControllerSet){
      recipeWindowControllerSet = [[NSMutableSet alloc] init ];
   }
   //DLog(@"recipeWindowControllerSet=%@",self.recipeWindowControllerSet);
   return recipeWindowControllerSet;
}
*/

#pragma mark -
#pragma mark Application's documents directory
/**
 Returns the path to the application's documents directory.
 */
- (NSURL*) applicationFilesDirectory {
   
   NSFileManager *fm = [NSFileManager defaultManager];
   DLog(@"[[fm URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject]=%@",[[fm URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject]);
   NSURL *appFilesDir = [[fm URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject] ;
 //  NSURL *editAppFilesDir = [appFilesDir URLByAppendingPathComponent:@"com.DrummingGrouse.HungryMe"];
   NSURL *editAppFilesDir = [appFilesDir URLByAppendingPathComponent:@"HungryMe"];
   DLog(@"editAppFilesDir =%@",editAppFilesDir);
   BOOL isDir;
   if (![fm fileExistsAtPath:[editAppFilesDir path] isDirectory:&isDir]) {
      NSError *error = nil;
      if (![fm createDirectoryAtURL:editAppFilesDir withIntermediateDirectories:NO attributes:nil error:&error]) {
         DLog(@"Could not create appFilesDirectory. Error=%@",error);
      }
   }
   // 1 : file:///Users/mbarron/Library/Containers/com.DrummingGrouse.HungryMe/Data/Library/Application%20Support/com.DrummingGrouse.HungryMe/
   // 2 :file:///Users/mbarron/Library/Application%20Support/com.DrummingGrouse.HungryMe/
   
   return editAppFilesDir;
}


#pragma mark -
#pragma mark Application's Files directory
/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
   return basePath;
}

/**
    Creates, retains, and returns the managed object model for the application 
    by merging all of the models found in the application bundle.
 */
 
- (NSManagedObjectModel *)managedObjectModel { ///GTG
   
   if (managedObjectModel)
      return managedObjectModel;
   
   //managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain]; //xxxxX
   NSString *path = [[NSBundle mainBundle] pathForResource:@"iHungryMac_ND" ofType:@"momd"];
   NSURL *momURL = [NSURL fileURLWithPath:path];
   managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
   
   return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.  This
 implementation will create and return a coordinator, having added the
 store for the application to it.  (The directory for the store is created,
 if necessary.)
 */

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
   
   if (persistentStoreCoordinator)
      return persistentStoreCoordinator;
   
   NSDictionary *options = @{
                             NSSQLitePragmasOption : @{@"journal_mode" : @"DELETE"  },
                             NSMigratePersistentStoresAutomaticallyOption:@YES,
                             NSInferMappingModelAutomaticallyOption:@YES
                             };
   
   NSError *error = nil;
   persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  
   //UNUSED
   self.localStoreURL = [[self applicationFilesDirectory] URLByAppendingPathComponent:@"HM_Mac_Recipes.sqlite"];
   
   if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:localStoreURL options:options error:&error]) {
      DLog(@"PSC:Unresolved error %@, %@", error, [error userInfo]);
      abort();
   }
   
   return persistentStoreCoordinator;
}

/**
 Returns the managed object context for the application (which is already
 bound to the persistent store coordinator for the application.)
 */

- (NSManagedObjectContext *) managedObjectContext {
   if (managedObjectContext)
      return managedObjectContext;
   
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
   [managedObjectContext setPersistentStoreCoordinator: coordinator];
   
   return managedObjectContext;
}
/*
#pragma mark CoreDataStack 2

- (NSManagedObjectContext *) managedObjectContext2 {
   if (managedObjectContext2)
      return managedObjectContext2;
   
   NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
   if (!coordinator) {
      NSMutableDictionary *dict = [NSMutableDictionary dictionary];
      [dict setValue:@"Coord2: Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
      [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
      NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
      [[NSApplication sharedApplication] presentError:error];
      return nil;
   }
   managedObjectContext2 = [[NSManagedObjectContext alloc] init];
   [managedObjectContext2 setPersistentStoreCoordinator: coordinator];
   
   return managedObjectContext2;
}
*/

/*
 - (NSManagedObjectModel *)managedObjectModel2 {
 if (__managedObjectModel != nil) {
 return __managedObjectModel;
 }
 NSString *path = [[NSBundle mainBundle] pathForResource:@"iHungryMac_ND" ofType:@"momd"];// both this and line above work
 NSURL *momURL = [NSURL fileURLWithPath:path];
 __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
 DLog(@"momURL=%@",momURL);
 DLog(@"__managedObjectModel exists=%d",__managedObjectModel != nil);
 
 return __managedObjectModel;
 } */
/*
#pragma mark  NSPersistentStoreCoordinator2

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator2 {
   
   if (persistentStoreCoordinator2 != nil)
   {
      return persistentStoreCoordinator2;
   }
   persistentStoreCoordinator2 = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
   
   NSPersistentStoreCoordinator *psc = persistentStoreCoordinator2;
   //NSURL *localStore =self.localStoreURL;
   NSMutableDictionary *options = [NSMutableDictionary dictionary];
   [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
   [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
   
   [psc addPersistentStoreWithType:NSSQLiteStoreType
                     configuration:nil
                               URL:self.tempLocalStoreURL
                           options:options
                             error:nil]; // store is in appSupport area of sandbox
   return persistentStoreCoordinator2;
   
}
*/


#pragma mark FileManagerDelegate

- (BOOL)fileManager:(NSFileManager *)fileManager
shouldProceedAfterError:(NSError *)error
  copyingItemAtPath:(NSString *)srcPath
             toPath:(NSString *)dstPath {
    return YES;
}

/**
    Returns the NSUndoManager for the application.  In this case, the manager
    returned is that of the managed object context for the application.
 */
 
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return [[self managedObjectContext] undoManager];
}


- (NSSortDescriptor*) sortDescriptorNameAscInsen{
   if(sortDescriptorNameAscInsen == nil)
      sortDescriptorNameAscInsen = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
   return sortDescriptorNameAscInsen;
} 



- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
   return YES;
}

/**
    Implementation of the applicationShouldTerminate: method, used here to
    handle the saving of changes in the application managed object context
    before the application terminates.
 */
 
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {

   [self.myAppController.splitView storeLayoutWithName:SplitView_Layout_DefaultName];
      
   
    if (!managedObjectContext)
       return NSTerminateNow;

    if (![managedObjectContext commitEditing]) {
        DLog(@"%@:%@ unable to commit editing to terminate", [self class],NSStringFromSelector(_cmd) );
        return NSTerminateCancel;
    }

    if (![managedObjectContext hasChanges])
       return NSTerminateNow;

    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
    
        // This error handling simply presents error information in a panel with an 
        // "Ok" button, which does not include any attempt at error recovery (meaning, 
        // attempting to fix the error.)  As a result, this implementation will 
        // present the information to the user and then follow up with a panel asking 
        // if the user wishes to "Quit Anyway", without saving the changes.

        // Typically, this process should be altered to include application-specific 
        // recovery steps.  
                
        BOOL result = [sender presentError:error];
        if (result) return NSTerminateCancel;

        NSString *question = NSLocalizedString(@"Could not save changes while quitting.  Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];// cancel button should be String

        NSInteger answer = [alert runModal];
       
        alert = nil;
        
        if (answer == NSAlertAlternateReturn) return NSTerminateCancel;

    }

    return NSTerminateNow;
}

/**
    Implementation of dealloc, to release the retained variables.
 */




- (void) updateGlobalCategoryArray{

   NSError* error = nil;
   NSEntityDescription *entityDescCategory = [NSEntityDescription entityForName:@"CategoryRx"
                  inManagedObjectContext:[self managedObjectContext]];
   //[self setCategoryArray: nil];
   NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
   [fetchRequest setEntity:entityDescCategory];
   NSArray *array = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
   if(error){
      DLog(@"error = %@ info = %@",error , [error userInfo]);
      exit(-333);
   }
   
   NSArray* sortedArray = [array  sortedArrayUsingSelector:@selector(compareCategoryNames:)];
   //[self setCategoryArray:sortedArray];
    // RESTORE THE sortIndeces ///////////
   NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:[sortedArray count]] ;
   
   NSEnumerator *enumerator = 
   [sortedArray objectEnumerator];
	NSComparisonResult result;
	CategoryRx* aCategory;
  // int j = 0;
   
	while (aCategory = [enumerator nextObject]) {//sortIndex NSNumber
      result = [aCategory.name compare:@"Browse All"];
      if(result == NSOrderedSame){
         [aCategory setSortIndex:[NSNumber numberWithInt:-1]];
         [aCategory setIsBrowseAll:YES];
         //[mutArray addObject:aCategory];
      }
      [mutArray addObject:aCategory];
      /*else{
         DLog(@"Exiting : setting sortIndex for Category to > 0"); //exit(911911);
         //[aCategory setSortIndex:[NSNumber numberWithInt:j++]];//CHECK 5/20/15
      }*/
   }
    // now sorted by name ASC and sortIndeces are correct
    
    NSArray *sortedArray2 = [sortedArray sortedArrayUsingDescriptors:self.categorySortDescriptorsNameAndSortIndex];
    
    [self setCategoryArray:sortedArray2];

   //[self setCategoryArray:mutArray];
   //DLog(@"categories are:%@",[self categoryArray]);
   
 
} //end updateGlobalCategoryArray

//UNUSED
- (BOOL)migrateUsingPSC:(NSURL*)sourceStore {//tempLocalStoreURL
   DLog(@"sourceStore=%@",sourceStore);
   //BOOL success = NO;
   NSError *error = nil;
   //iHungry_MeAppDelegate *appDel = (iHungry_MeAppDelegate*)[[UIApplication sharedApplication] delegate];
   //NSFileManager *fileManager = [NSFileManager defaultManager];
   ///var/mobile/Applications/9F9F8C4E-20B8-469D-AC28-96BB06BCE380/Documents/IHM_Recipes.sqlite
  // NSURL *docsDataURL = [[self applicationDocumentsDirectoryURL] URLByAppendingPathComponent:DATA_FILENAME_EXT];
   /*NSString *walTargetPath = [[[appDel storeURL] path] stringByAppendingString:@"-wal"];
   NSString *shmTargetPath = [[[appDel storeURL] path] stringByAppendingString:@"-shm"];
   NSURL *walTargetURL = [NSURL fileURLWithPath:walTargetPath];
   NSURL *shmTargetURL = [NSURL fileURLWithPath:shmTargetPath];
   NSString *walOriginPath = [[[appDel applicationDocumentsDirectoryURL ] path] stringByAppendingPathComponent:@"IHM_Recipes.sqlite-wal"];
   NSString *shmOriginPath = [[[appDel applicationDocumentsDirectoryURL ] path] stringByAppendingPathComponent: @"IHM_Recipes.sqlite-shm"];
   NSURL *walOriginURL = [NSURL fileURLWithPath:walOriginPath];
   NSURL *shmOriginURL = [NSURL fileURLWithPath:shmOriginPath];*/
   //HERE IS MIGRATION CODE BEGIN
   /// CREATE FOLDER FOR self.storeURL IF DOES NOT EXIST
   NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
   NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
   error = nil;
   //NSDictionary *options = @{ NSSQLitePragmasOption : @{@"journal_mode" : @"DELETE"}};
   NSMutableDictionary *options = [NSMutableDictionary dictionary];
   [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
   [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
   NSDictionary *pragmaOptions = @{ @"journal_mode": @"DELETE" };
     //NSDictionary *storeOptions = @{ NSSQLitePragmasOption: pragmaOptions };
   [options setObject:pragmaOptions forKey:NSSQLitePragmasOption];
   
   NSPersistentStore *persistentStore = [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sourceStore options:options       error:&error] ;
   if (!persistentStore) {
      DLog(@"CAN NOT ADD STORE.");
      abort();
   }
   error=nil;
   NSPersistentStore *persistentStoreTarget =
       [coordinator migratePersistentStore:persistentStore toURL:self.localStoreURL  options:options withType:NSSQLiteStoreType error:&error];
   if (!persistentStoreTarget) {
      DLog(@"migration failed. [error userInfo]=%@",[error userInfo]);
      abort()  ;
   }else{
      BOOL doesDbFileExist = [[NSFileManager defaultManager] fileExistsAtPath:self.localStoreURL.path];
      DLog(@"Success in migration of Documents/DBFile.\n doesDbFileExist=%d",doesDbFileExist);
      //@"HM_Mac_Recipes.sqlite"
   }
   
   ////HERE IS MIGRATION CODE END
   
   return YES;
}

#pragma mark AppDidFinLaunch from recent iHungryMac386Old

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
   
   DLog(@"begin applicationDidFinishLaunching");
   
   if(
      getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")
      ) {
      DLog(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
   }
   /////  FONT  WORKING
   
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   

#ifdef VIRGIN
   NSFileManager *fm = [NSFileManager defaultManager];
   NSError *error;
   // EMPTY DEFAULTS AND DELETE DB
   // "DG_DefaultsAppVersionNumber" = "1.1";
   //"DG_DefaultsDataVersionNumber" = "1.50";
   //"DG_HM_AppSupportDbPresentAtLoad" = 1;
   [defaults setObject:nil forKey:DG_DEFAULTS_HM_APP_VERSION_KEY ];//@"DG_HM_App_Version";
   /// 5/31/15[defaults setObject:nil forKey:DG_DEFAULTS_HM_DATA_VERSION_KEY];//@"DG_HM_DataVersion";//Never Read
   [defaults synchronize];
   if(![fm removeItemAtPath:self.localStoreURL.path  error:&error ]){
      //file:///Users/mbarron/Library/Containers/com.DrummingGrouse.HungryMe/Data/Library/Application%20Support/HungryMe/HM_Mac_Recipes.sqlite
      DLog(@"Error removing appSupportDb:%@",[error userInfo]);
   }
   if(![fm removeItemAtPath:self.tempLocalStoreURL.path  error:&error ]){// if it exists
      // /Users/mbarron/Library/Containers/com.DrummingGrouse.HungryMe/Data/Library/Application Support/HungryMe/tempRecipes.sqlite
      DLog(@"Error removing tempDb:%@",[error userInfo]);
      //Error removing tempDb:{
     // NSFilePath = "/Users/mbarron/Library/Containers/com.DrummingGrouse.HungryMe/Data/Library/Application Support/HungryMe/tempRecipes.sqlite";
   }
   //NSURL *storeUrl = [[self.applicationSupportURL URLByAppendingPathComponent:@"HungryMe" ] URLByAppendingPathComponent:DATA_FILENAME_EXT];
   /*
   NSURL *walURL = [self.applicationFilesDirectory  URLByAppendingPathComponent:WAL_DATA_FILENAME_EXT];
   NSURL *shmURL = [self.applicationFilesDirectory  URLByAppendingPathComponent:SHM_DATA_FILENAME_EXT];
   */
   abort();
#endif

   NSDictionary *fontAttributes = [defaults objectForKey:DG_TableFontAttributesKey ];
   NSNumber *fontSize;
   NSString *fontName;
   DLog(@"fontAttributes=%@",fontAttributes);
   NSAssert(fontAttributes , @"fontAttributes == nil");
   if(!fontAttributes){
      //NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
      //@"value1", @"key1", @"value2", @"key2", nil];
      ALog(@"This Will never happen. fontAttributes = %@",fontAttributes);
   }
   fontSize = [fontAttributes valueForKey:NSFontSizeAttribute];
   fontName = [fontAttributes valueForKey:NSFontNameAttribute];
   NSAssert((fontAttributes != nil ),@"fontAttributes == nil!");
   NSFont *aFont = [NSFont fontWithName:fontName size:[fontSize floatValue ] ];
   [self setTableFont:aFont];
   /////  FONT  END  WORKING
   NSArray *versionArray=nil;
   NSError* error3 = nil;
   NSString* verStringAppDefaults = nil;
   NSString* verStringAppNew = nil;
   //VersionXML* theCurrentVersionXmlInDataBase = nil;
   NSNumberFormatter* numFormater = [[NSNumberFormatter alloc] init];
   NSComparisonResult  resultAppVersion = -2; //asc -1, same 0, desc 1
   NSComparisonResult  resultDataVersion = -2;
   
   XmlListReader* xmlReaderVersionOnly ;// fetch version only
   XmlListReader* xmlListReader2; // create entire DB.
   NSURL *xmlURL;
   NSError *parseError=nil;
   NSNumber* verNumDataExisting = nil;// from DB existing at load
   ///NSNumber* verNumDataNewDefined = nil;  // used for New when DB !existing at load , i.e. from constants.h
   NSNumber* verNumDataResXml = nil; //used for NEW from XmlFile in Res/ when DB !existing at load
   NSString *DG_XmlRecipeFile;
   DG_XmlRecipeFile = [[NSBundle mainBundle] pathForResource:XML_FILENAME ofType:@"xml"];//IHM_Recipes
   xmlURL = [NSURL fileURLWithPath:DG_XmlRecipeFile]; //check
   self.doesDbExistAtLoad = [defaults boolForKey:DG_HM_APPSUPPORT_DB_PRESENT_AT_LOAD];
   //file:///Users/mbarron/Library/Containers/com.DrummingGrouse.HungryMe/Data/Library/Application%20Support/com.DrummingGrouse.HungryMe/HM_Mac_Recipes.sqlite
   DLog(@"self.doesDbExistAtLoad=%d",self.doesDbExistAtLoad);
   self.versionXMLString = nil;
   self.versionXML = nil;
   BOOL bAppVersionUpgrade=NO; //VIRGIN or Normal Run
   BOOL bDataVersionUpgrade=NO; // used circa #740
   ///////
   //     LATER UPDATE EXISTING VersionXML if bDataVersionUpgrade
   //////
   // 2. Get Existing Version of App from Bundle and from Defaults.
   verStringAppNew = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
   verStringAppDefaults = [defaults valueForKey:DG_DEFAULTS_HM_APP_VERSION_KEY];//NEEDED @"DG_HM_App_Version"
   if (!verStringAppDefaults) { // remove this if
      verStringAppDefaults = verStringAppNew;  //for VIRGIN INSTALL causes NSOrderedSame
   }
   // CHECK HERE FOR APP VERSIONS > 1.1. 1 INSTALLATION   !!!!       /// MIGHT BE VERSION UPGRADE
   //verStringAppNew = DG_HM_APP_VERSION_NEW; //
   DLog(@"verStringAppNew=%@\nverStringAppDefaults=%@",verStringAppNew,verStringAppDefaults);
   ////
   // DETERMINE THE VERISION OF XML DATA BY READING FILE IN Resources/
   ////
   xmlReaderVersionOnly = [[XmlListReader alloc] initForVersionOnly:YES  catArray:nil minimumRecipeId:-1 context:self.managedObjectContext ];
   parseError=nil;
   // HERE BRING IN versionXMLString from XML
   [xmlReaderVersionOnly	parseXMLFileAtURL:xmlURL   parseError:&parseError];
   xmlReaderVersionOnly = nil;
   // HAS  XML versionString currently in DB : versionXMLString
   // self.versionXMLString has been set by the Parser // "1.50' - Checked
   [self setMaxRecipeIdXml:[NSNumber numberWithInt:-1]];//i.e., MOVE ALL Rxs into DB using xmlListReader2 below
   //STORE MaxRecipeIdXml as NSNumber STRING CAN ONLY have two numbers E.G, 1.51 , not 1.2.3
   verNumDataResXml = [numFormater numberFromString:(NSString*)[self versionXMLString]]; //versionXMLString via xmlReadVOnly
   DLog(@"verNumDataResXml=%@",verNumDataResXml);
   ////
   //   XmlListReader puts DATA VERSION STRING in self.versionXMLString for both Runs,xmlReaderVersionOnly and xmlListRead2
   ////
   /// PERHAPS WANT TO NIL versionXMLString now
   if(!self.doesDbExistAtLoad){ //if !existed at start of run
      //    GET VERSIONXML DATA from XmlFile >>>> VIRGIN INSTALL<<<<
      //
      /////////////  DB DOES NOT EXIST. NEED TO >>>> VIRGIN <<<< CREATE IT FROM XML ***************************
      parseError = nil;
      // XmlListReader2 creation Nils versionXMLString // !!!!!!!
      xmlListReader2 = [[XmlListReader alloc] initForVersionOnly:NO  catArray:nil minimumRecipeId:-1 context:self.managedObjectContext];
      // insert all Cats and All Rxs since this is a Virgin install run.   minRxId == (maxIdInOldDb +1)
      [self updateGlobalCategoryArray]; /// NEEDED FOR PARSER   ///                                         //// CategoryArray  ****
      // XmlListRead2 resets versionXMLString to "1.50"
      [xmlListReader2	parseXMLFileAtURL:xmlURL parseError:&parseError]; //CHECKED. VIRGIN INSTALL DOES NOT SET self.versionXML
      DLog(@"versionXMLString=%@",versionXMLString);
      if (parseError) {
         DLog(@"XmlListReader Pass 2 parseError");
         exit(224);
      }
      xmlListReader2 = nil;  ////  VIRGIN  ////
            //// Virgin DB HAS BEEN CREATED FROM XML, BUT NOT YET SAVED    ////
   } else { //                         END IF VIRGIN (DB !EXIST AT LOAD)
      // else  DB   *** DOES EXIST ***  AT LOAD --     ***  NOT  VIRGIN  ***  !!!!
      /// MIGHT BE APPVERSION UPGRADE, And Even bDataVersionUpgrade - The latter implies the former!
      // COULD BE NORMAL (1)RUN,
      //                 (2)APPVERSION UPGRADE (W/NEWDAT) OR
      //                 (3)APPVERSION UPGRADE (W/O NEWDATA) =============   ========
      // An Old DB is present in AppSupport
      //
      // 1. Check existing XML Data Version in OLD DB
      /// Get Current Version Info from the Res/Sqlite DB       /// MIGHT BE DATA VERSION UPGRADE
      ////
      // IF DB WHICH EXISTS IS FOUND THEN MUST FETCH VersionXml MO. exists and has 1.50
      //
      // THIS IS NOT -- VIRGIN - IF INSTALL RUN, THEN NEED TO SAVE EDITED VersionXml with new data at ~ 786
      // WE MAY OR MAY NOT HAVE TO save: NEW DATA IN VersionXml MO
      ZAssert(self.versionXML == nil, @"self.versionXML != nil");
      //ZAssert(self.versionXMLString == nil, @"self.versionXMLString != nil");
      
      NSFetchRequest *fetchRequest3 = [[NSFetchRequest alloc] init];
      // Edit the entity name as appropriate.      // else DB   *** DOES ***   EXIST AT LOAD
      NSEntityDescription *entity3 = [NSEntityDescription
                                      entityForName:@"VersionXML" inManagedObjectContext:[self managedObjectContext]];
      [fetchRequest3 setEntity:entity3];
      versionArray = [self.managedObjectContext executeFetchRequest:fetchRequest3 error:&error3];
      if (error3) {
         DLog(@"iHMdidLaunch:Version Fetch error. Need to delete DB file in this case?");///check
         //abort()  ;
      }
      //self.versionXMLString == nil == self.versionXML     // XXXXXXXX     /// MIGHT BE VERSION UPGRADE
      if(versionArray && [versionArray count]){
         self.versionXML = [versionArray objectAtIndex:0];
         verNumDataExisting = self.versionXML.number; //DATA VERSION - NOT VIRGIN
         DLog(@"NewData:self.versionXML.number=%@",self.versionXML.number );
      } else {
         DLog(@"No VersionXML found after fetch. Does DB exist? Abort."); // X X X  check this for next version 1.2
         //abort because this is non-Virgin. DB does exist
         abort();
      }
     
      NSFetchRequest *fetchRequestCat = [[NSFetchRequest alloc] init];
      // Edit the entity name as appropriate.
      NSEntityDescription *entityCat = [NSEntityDescription entityForName:@"CategoryRx"
                                                   inManagedObjectContext:[self managedObjectContext]];
      [fetchRequestCat setEntity:entityCat];
      NSError *errorCat=nil;
      self.categoryArray = [self.managedObjectContext executeFetchRequest:fetchRequestCat error:&errorCat];
      if (errorCat) {
         DLog(@"Cat Fetch");   //// CategoryArray  ****
         abort();
      }
   } //end else DB DOES Exist i.e., NON-VIRGIN
   
   /// DONE EACH RUN TYPES: 1, 2 AND 3
   NSError *error5=nil;
   NSFetchRequest *fetchRequest5 = [[NSFetchRequest alloc] init];
   NSEntityDescription *entity5 = [NSEntityDescription entityForName:@"Recipe"
                                              inManagedObjectContext:[self managedObjectContext]];
   [fetchRequest5 setEntity:entity5];
   NSArray* allRecipesArray =  [managedObjectContext executeFetchRequest:fetchRequest5 error:&error5];
   if(error5){
      DLog(@"AppDelegateDidFin:Fetch error=%@",error3);
      exit(-17);
   }
   // FETCH RECIPES BOTH FOR doesDbExistAtLoad==NO AND ==YES
   [self setRecipeArray:allRecipesArray];     /// RecipeArray  *****
   /**** BOTH categoryArray and recipesArray are set   ***/
   //for VIRGIN (resultAppVersion == -2){
   resultAppVersion = [verStringAppNew compare:verStringAppDefaults]; //AppVersion could be 1.1.3 -> use string compare
   bAppVersionUpgrade = (resultAppVersion == NSOrderedDescending) ? YES : NO ;
   // NEWER APP Version > Existing APP Version - NSOrderedSame for VIRGIN
   // verNumDataExisting==nil (IF VIRGIN)
   resultDataVersion = (verNumDataExisting) ?
      [verNumDataResXml compare:verNumDataExisting] : NSOrderedSame; // resultDV != Desc  for Virgin
   bDataVersionUpgrade = (resultDataVersion == NSOrderedDescending) ? YES : NO ;
   DLog(@"bAppVersionUpgrade=%d\nbDataVersionUpgrade=%d\n NO means VIRGIN OR Normal run",bAppVersionUpgrade,bDataVersionUpgrade);
   BOOL bInstallRun = (!self.doesDbExistAtLoad || bAppVersionUpgrade ); //VIRGIN || bAppVersionUpgrade
   if (bInstallRun) { // BUT MAYBE NO save: DATA ADDED TO DB if (AppVersionUpgrade && !dataVersionUpgrade) and not VERSION
      if (!self.doesDbExistAtLoad ) {
         //verNumDataExisting has a value ONLY if DbExistsAtLoad
         //resultAppVersion = NSOrderedDescending; // need save:
         // Create New Version MO               // HAVE VERIFIED NO VERSIONXML EXISTS ////   >>>> VIRGIN <<<<   NEW DATA ADDED TO DB
         NSManagedObject *newManagedObject =
         [NSEntityDescription insertNewObjectForEntityForName:@"VersionXML" inManagedObjectContext:[self managedObjectContext]]; //INSERT Virgin MO
         ZAssert(self.versionXML == nil, @"self.versionXML != nil");
         self.versionXML = (VersionXML*)newManagedObject;            /// created versionXML  >>>> VIRGIN <<<<
         if ( self.versionXML == nil) {
            DLog(@"iHMe:No New VersionXML Object Exists");
            exit(225);
         }// self.versionXML == nil
         DLog(@"Virgin Install run. VersionXml MO ready for writing.");
         // ***
         // DB is newly created for this virgin run above ~ #660 !!!!
         [self setMaxRecipeIdDb:[self fetchMaxRecipeIdNum:self.managedObjectContext]];    /// VIRGIN in Progress
         DLog(@"self.maxRecipeIdDb=%@",self.maxRecipeIdDb);
         if(!self.maxRecipeIdDb){
            DLog(@"No maxRecipeIdDb found");
            exit(-765);
         }
         self.maxRecipeIdDb = [numFormater numberFromString:DG_HM_GREATEST_RX_ID_FOR_APP_VERSION_ONE];
          // **** /
         parseError = nil;    // BOTH APPVERSION AND DATAVERSION UPGRADES
         // NEW DATA ADDED TO DB BY PARSER - store data in VersionXML for save: and future runs
         self.versionXML.maxRecipeId = self.maxRecipeIdDb;// ADD RXs IF XML HAS GREATER RxId's
         self.versionXML.number = verNumDataResXml;
         ////end VIRGIN  - VersionXML ready for saving at ~ #638      /// INSTALL RUN  >>>> VIRGIN <<<<
      }else if (bDataVersionUpgrade){ // might be New App Version shipped with Old DatD. /// INSTALL RUN
         // resultDataVersion = ([resourcesDataVersion compare:presentDataVersion options:NSNumericSearch] == NSOrderedDescending)
         // CHECK FOR ANOMOLY COMPARE WITH 1.0 compare:1.0.0
         // NEW DATA PRESENT  -- FETCHED GREATEST RxNum from EXISTING DB
         [self setMaxRecipeIdDb:[self fetchMaxRecipeIdNum:self.managedObjectContext]];         /// DATAVERSION UPGRADE
         DLog(@"self.maxRecipeIdDb=%@",self.maxRecipeIdDb);
         
         //PROBlem if USER is installing over 1.0 //guessing that MaxId==84 Myrtle Allen
         if(!self.maxRecipeIdDb)
            self.maxRecipeIdDb = [numFormater numberFromString:
                                  DG_HM_GREATEST_RX_ID_FOR_APP_VERSION_ONE];
         parseError = nil;    // BOTH APPVERSION AND DATAVERSION UPGRADES
         DLog(@"Check the + 1 below. Actually minimumRecipeId: is not used in call below");  // NEW DATA ADDED TO DB
         //WRONG
         
         self.versionXML.maxRecipeId = self.maxRecipeIdDb;// ADD Rxs IF XML HAS GREATER RxId's // "VersionXML"
         
         XmlListReader* xmlListReader2 = [[XmlListReader alloc] initForVersionOnly:NO catArray:self.categoryArray minimumRecipeId:self.maxRecipeIdDb.intValue + 1 context:self.managedObjectContext];
         // insert if (nRidXml >= minimumRecipeId).
         // If oldDB found, then minRxId == (maxIdInOldDb +1) for this install run
         [xmlListReader2	parseXMLFileAtURL:xmlURL parseError:&parseError];        /// INSTALL RUN - CREATE DB
         if (parseError) {
            DLog(@"XmlListReader New Rx Pass 2 DataVersion upgrade. parseError=%@",parseError);
            exit(224);
         }
         // VersionXML MO already fetched and stored in self.versionXML   above ~ #679
         else { // GOOD PARSE XML RUN 2 to make TEMP DB  == NON VIRGIN INSTALL -- /// DATA VERSION UPGRADE
            // this is A NON-VIRGIN DATA VERSION UPGRADE
            // IF VERSIONXML COULD BE USED INSTEAD OF USING #DEFINE
            // LET'S USE #DEFINE FOR VERSION 1.1 INSTALL
            //if ( self.versionXML != nil) {     /////// LOAD VersionXML NON-VIrgin         /// INSTALL RUN +  // NEW DATA ADDED TO DB
            ZAssert(self.versionXML != nil, @"self.versionXML == nil");
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];               /// DATA VERSION UPGRADE
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            self.versionXML.number = verNumDataResXml; // storing for save:
               //[f numberFromString:self.versionXMLString];// @"1.50"//DG_RES_DATA_VERSION_NUMBER_ABOUT_WINDOW
            self.versionXML.maxRecipeId = [self fetchMaxRecipeIdNum:self.managedObjectContext];
            //DLog(@"self.versionXML.maxRecipeId=%@\n this appears to duplicate code near #727",self.versionXML.maxRecipeId);
            //verNumApp derived from DG_DEFAULTS_HM_APP_VERSION_KEY, ONLY for Non-Virgin Install runs
            NSComparisonResult resultAppVersionOne = [verStringAppNew compare:[NSString stringWithFormat:@"1.0"]];//Unnecessary? DataUpgrade implies VersionUpgrade?
            BOOL isVersionOnePtZero = (resultAppVersionOne == NSOrderedSame) ? YES : NO;
            if (isVersionOnePtZero) {
               // TIME TO ADD BROWSE_ALL TO ALL NEWLY INSERTED RECIPES for V:1.0
               NSNumber* numAdded =
                  [self addBrowseAllCategoryAsNeededToRxs:managedObjectContext];
               DLog(@"Browse All add %@ times.",numAdded);
               // numAdded is 0 for Virgin install,
            }
         }
         xmlListReader2 = nil;
         // end if (resultDataVersion == NSOrderedDescending)
      } // end else if (bDataVersionUpgrade)
      
      // SAVE VersionXML - Virgin(#628) NON-Virgin (#657)
      NSError *error6=nil;
      // END OF INSTALL RUN STORE VersionXML , Rxs and Cats
      // SAVE IF VIRGIN OR DataVersionUpdate
      DLog(@"Check if this save: made for 'normal' run .");
      if(!self.doesDbExistAtLoad || bDataVersionUpgrade){// correct!
         self.versionXML.editDate =  [NSDate date];
         if (![[self managedObjectContext] save:&error6]) { // save the "VersionXML"
            // Update to handle the error appropriately.
            DLog(@"iHMADel:AppDidFinish:Unresolved error -16 %@, %@", error6, [error6 userInfo]);
            exit(-16);  // Fail
         }
      }
      DLog(@"Saved New VersionXML MO. self.versionXML.number=%@ ",self.versionXML.number);
      [defaults setObject:verStringAppNew forKey:DG_DEFAULTS_HM_APP_VERSION_KEY];
      /// 5/31/15[defaults setObject:verNumDataResXml forKey:DG_DEFAULTS_HM_DATA_VERSION_KEY];//virg:nil
      [defaults synchronize];
   }// end bInstallRun
      //////////////////////
   //RECIPE OBJS are sorted in a List in AppDelegate
   // PRODUCE A SORTED ARRAY OF STRINGS WITH RECIPE NAMES
   //NSArray* sortedArray = [[[self recipeArray] valueForKey:@"name"]  sortedArrayUsingSelector:@selector(compareRecipeNames:)];
   //PRODUCE A SORTED ARRAY OF OBJS SORTED ON NAME
   DLog(@"appDelegate=%@", self);
   [myAppController setAppDelegate:self];

   NSMenu *mainMenu = [[NSApplication sharedApplication] mainMenu];
   NSMenuItem *menuItemFile = [mainMenu itemWithTitle:@"File"];
   NSMenu *menuFile = [menuItemFile submenu];
   NSMenuItem *menuItemExportDgx = [menuFile itemAtIndex:0];
   [menuItemExportDgx setTarget:[self myAppController] ];
   [menuItemExportDgx setAction:@selector(exportDgxFileMenuAction:)];
   [menuItemExportDgx setEnabled:YES];
   NSMenuItem *menuItemImportDgx = [menuFile itemAtIndex:1];
   [menuItemImportDgx setTarget:[self myAppController] ];
   [menuItemImportDgx setAction:@selector(importDgxFileMenuAction:)];
   [menuItemImportDgx setEnabled:YES];
   /*
   NSMenuItem *menuItemEdit = [mainMenu itemWithTitle:@"Edit"];
   NSMenu *menuEdit = [menuItemEdit submenu];
   NSMenuItem *menuItemEditUndo = [menuEdit itemAtIndex:[menuEdit indexOfItemWithTitle:@"Undo"]];
   [menuItemEditUndo setEnabled:YES];
   //int index = [menuEdit indexOfItemWithTitle:@"Start Dictation"];
   NSMenuItem *menuItemStartDictation = [menuEdit itemAtIndex:10];
   //[menuEdit itemAtIndex:[menuEdit indexOfItemWithTitle:@"Start Dictation"]];
   [menuEdit removeItem:menuItemStartDictation ];
   //[menuItemImportDgx bind:@"enabled" toObject:self withKeyPath:@"enablePrint" options:nil];
    */
   DLog(@"Reached end of applicationDidFinishLaunching.*******************");
} // end applicationDidFinishLaunching

                                      
- (NSNumber*) addBrowseAllCategoryAsNeededToRxs:(NSManagedObjectContext *)moc {

   NSFetchRequest *fetchRequestRecipe = [[NSFetchRequest alloc] init];
   NSEntityDescription *entityRecipe = [NSEntityDescription entityForName:@"Recipe"inManagedObjectContext:moc];
   [fetchRequestRecipe setEntity:entityRecipe];
   NSError* error = nil;
   
   NSArray *allRecipes =
   [moc executeFetchRequest:fetchRequestRecipe error:&error];
   if(error){
      DLog(@" Fetch allRecipe error=%@",error);
      exit(-278);
   }
   int nAdditionsBA = 0;
   NSEnumerator *enumerator = [allRecipes objectEnumerator];
   Recipe *recipe;
   CategoryRx *baCategory = [self fetchCategoryBrowseAll];
   if(baCategory){
      while((recipe = enumerator.nextObject)){
         if (![recipe.categories containsObject:baCategory]) {
            [recipe addCategoriesObject:baCategory];
            nAdditionsBA++;
         }
      }
   }else{
      DLog(@"Could not fetch Browse_All");
      abort();
   }
   
   return [NSNumber numberWithInt:nAdditionsBA];

}

- (NSNumber*)  fetchMaxRecipeIdNum:(NSManagedObjectContext *)moc{
   //int mxRecipeId = 0;
   NSFetchRequest *fetchRequestRecipe = [[NSFetchRequest alloc] init];
   NSEntityDescription *entityRecipe = [NSEntityDescription entityForName:@"Recipe"inManagedObjectContext:moc];
   [fetchRequestRecipe setEntity:entityRecipe];
   NSError* error = nil;
   
   NSArray *allRecipes =
   [moc executeFetchRequest:fetchRequestRecipe error:&error];
   if(error){
      DLog(@" Fetch allRecipe error=%@",error);
      exit(-178);
   }
   NSNumber *mxRecipeIdNum = (NSNumber*)[allRecipes valueForKeyPath:@"@max.recipeID"];
   
   return mxRecipeIdNum;
}


- (NSArray *)fetchCategoryAllButBrowseAll{
    
    NSFetchRequest *fetchRequestBrowseAll = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityBA = [NSEntityDescription entityForName:@"CategoryRx"inManagedObjectContext:[self managedObjectContext]];
    [fetchRequestBrowseAll setEntity:entityBA];
    NSError* error10 = nil;
    
    NSPredicate* predBrowse = [NSPredicate predicateWithFormat:@"sortIndex != -1"];
    [fetchRequestBrowseAll setPredicate:predBrowse];
    
    NSArray *arrayWithAllButBrowseAll =
    [managedObjectContext executeFetchRequest:fetchRequestBrowseAll error:&error10];
    if(error10){
        DLog(@" AllButBrowseAll Fetch error=%@",error10);
        exit(-178);
    }
    
    return arrayWithAllButBrowseAll;
}


- (CategoryRx *)fetchCategoryBrowseAll{
   
   NSFetchRequest *fetchRequestBrowseAll = [[NSFetchRequest alloc] init];
   NSEntityDescription *entityBA = [NSEntityDescription entityForName:@"CategoryRx"inManagedObjectContext:[self managedObjectContext]];
   [fetchRequestBrowseAll setEntity:entityBA];
   NSError* error10 = nil;
   NSPredicate *predBrowse = [NSPredicate predicateWithFormat:
                             @"name like %@", @"Browse All"];
   [fetchRequestBrowseAll setPredicate:predBrowse];
   
   NSArray *arrayWithOnlyCatBrowseAll =
         [managedObjectContext executeFetchRequest:fetchRequestBrowseAll error:&error10];
   if(error10){
      DLog(@" BrowseAll Fetch error=%@",error10);
      exit(-178);
   }
   CategoryRx *catBA = [arrayWithOnlyCatBrowseAll objectAtIndex:0];
   [catBA setIsBrowseAll:YES]; // probably should be removed
   [catBA setSortIndex:[NSNumber numberWithInt:-1]];
   return catBA; 
}



- (void)handleRecipeDeactivationNotification:(NSNotification *)notification
{
   //RecipeWindowController *controller = [notification object];
   //DLog(@"DeactivateRecipe Name = %@",[[controller recipe] name]);
      // [self setActiveRecipeWindowController: nil];
   [[self window] setTitle:@"HungryMe"];
  // [self setEnablePrint:NO];
} 

- (void)handleRecipeActivationNotification:(NSNotification *)notification
{
   RecipeWindowController *controller = [notification object];
   DLog(@"ActiveRecipe Name = %@ \nRWController=%@ ",[[controller recipe] name],controller);
   [[self window] setTitle:[[controller recipe] name]];
      //  [self setActiveRecipeWindowController:controller];
  // [self setEnablePrint:YES];
}


+ (void) initialize {
   
   [[NSFontManager sharedFontManager] setAction:@selector(changeMyFont:)]; 
   
   NSString *userDefaultsValuesPath;
   NSDictionary *userDefaultsValuesDict;
   ////NSDictionary *initialValuesDict;
   //NSArray *resettableUserDefaultsKeys;
   
   // load the default values for the user defaults
   userDefaultsValuesPath=[[NSBundle mainBundle] pathForResource:@"Defaults"
                                                          ofType:@"plist"];
   userDefaultsValuesDict=[NSDictionary dictionaryWithContentsOfFile:userDefaultsValuesPath];
   
   // set them in the standard user defaults
   [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsValuesDict];
   
}

- (void)awakeFromNib
{
   [super awakeFromNib];// must be called, may be anytime in this method
}//end - (void)awakeFromNib

- (void)fontPanelUpdate
{
   NSFont* font = [self tableFont];
   NSFontManager* mngr = [NSFontManager sharedFontManager];
   
   [mngr setSelectedFont:font isMultiple:NO];
   
      //[[self myAppController] updateSmallPanelFont];//1/22/13
   return;
}

-(void)setTableFont:(NSFont*)font
{
   if (!font) 
      return;
   
      
   tableFont = font;
   
   [self fontPanelUpdate];
   
   //DLog(@"new font size=%@",[NSNumber numberWithFloat:[font pointSize] ]);
   //DLog(@"new fontName=%@",[font fontName]);
   //[self fontHasChanged];
}


-(NSFont*)tableFont
{
   if (tableFont){ 
     // DLog(@"existing font size=%@",[NSNumber numberWithFloat:[tableFont pointSize] ]);
      //DLog(@"existing fontName=%@",[tableFont fontName]);
      return tableFont;
	}
   //NSUserDefaults
   tableFont = [NSFont systemFontOfSize:13.0]; //xxxxX
   
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   NSDictionary *fontAttributes = [defaults objectForKey:DG_TableFontAttributesKey ];//@"TableFontAttributes"
   //NSString *fontName = [fontAttributes objectForKey:NSFontNameAttribute];
   NSFontDescriptor *fontDescriptor=nil;
      //NSNumber *fontSize;
   NSAssert(fontAttributes , @"fontAttributes == nil");
   if(!fontAttributes){
      //NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
      //@"value1", @"key1", @"value2", @"key2", nil];
      ALog(@"This Will never happen. fontAttributes = %@",fontAttributes);
   }
   fontDescriptor = [NSFontDescriptor fontDescriptorWithFontAttributes:fontAttributes];
      //fontSize = [NSNumber numberWithFloat:[fontDescriptor pointSize]];
      //DLog(@"fontDescriptor=%@",fontDescriptor);
      //DLog(@"fontSize=%@",fontSize);
   NSFont *font = nil;
    //+ (NSFont *)fontWithDescriptor:(NSFontDescriptor *)fontDescriptor size:(CGFloat)fontSize
   font = [NSFont fontWithDescriptor:fontDescriptor size:[fontDescriptor pointSize]];
   [self  setTableFont:font];
   return tableFont;
} // end tableFont

- (void) resizeBothTableViewRowHeights{
   
   //[[myAppController tableViewRx] setRowHeight:11.0 + (0.75 * [[self tableFont] pointSize])];
   //[[myAppController tableViewCat] setRowHeight:11.0 + (0.75 * [[self tableFont] pointSize])];
   [[myAppController tableViewRx] setRowHeight:4.0 + (1.0 * [[self tableFont] pointSize])];
   [[myAppController tableViewCat] setRowHeight:4.0 + (1.0 * [[self tableFont] pointSize])];
   [[myAppController tableViewRx] reloadData];
   [[myAppController tableViewCat] reloadData];
   
}

-(void)changeMyFont:(id)sender
{
   NSFont* font = [self tableFont];
   NSFontManager* mngr = sender;
   //DLog(@"old font size=%@",[NSNumber numberWithFloat:[font pointSize]]);
  
   //NSAssert (mngr && [mngr isKindOfClass:[NSFontManager class]],@"sender is not a FontManager.");
   if (sender == [NSFontManager sharedFontManager]) {
      font = [mngr convertFont:font];// the font newly chosen
      [self setTableFont:font];
      //DLog(@"new font size=%@",[NSNumber numberWithFloat:[font pointSize] ]);
      //DLog(@"new fontName=%@",[font fontName]);
      NSDictionary *fontDict = [[font fontDescriptor] fontAttributes];
      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      
      [defaults setObject:fontDict forKey:DG_TableFontAttributesKey ];
      [defaults synchronize];
   }
   [self resizeBothTableViewRowHeights];
   
      
}


/**
 Saves the selected recipe in the table view as RTF.  This implementation
 uses an NSSavePanel to allow the developer to select where the recipe is to
 be saved and the name (though the extension is fixed), and saves the file
 using the RecipeUtilities class methods.
 */

- (NSArray *)  getCategoriesFromList:(NSArray *) listCatNames {
   // create and insert Category in MOC if necessary
   // item[0] is Recipe Name
   NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
   // Edit the entity name as appropriate.
   NSEntityDescription *entityCat = [NSEntityDescription entityForName:@"CategoryRx"	
                                                inManagedObjectContext:[self managedObjectContext]];
   [fetchRequest setEntity:entityCat];
   NSError *error = nil;
   
   //BOOL isFound;
   NSMutableArray *mutCatArray = [NSMutableArray arrayWithCapacity:listCatNames.count];
   CategoryRx  *aCategory;
   
   NSError *error2 = nil;
   for (int i=1; i < listCatNames.count ; i++){ // skip over RecipeName
      NSString *theSearchCatName = [[listCatNames objectAtIndex:i] stringByTrimmingCharactersInSet:
                                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
      NSComparisonResult result;
      result = [theSearchCatName caseInsensitiveCompare:@"Browse All"]; // insensitive
      if (result == NSOrderedSame) {
         continue; //  DO NOT ACCEPT "BROWSE ALL" FROM DGX FILE
      }
      
      NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                @"name like %@", [theSearchCatName capitalizedString]];
      //DLog(@"theSearchCatName=%@",theSearchCatName);
      [fetchRequest setPredicate:predicate];
      NSArray *catArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error]; 
      if([catArray count] == 0){
            //aCategoryName = [theSearchCatName capitalizedString];
         NSManagedObject *newManagedObject = 
         [NSEntityDescription insertNewObjectForEntityForName:@"CategoryRx"
                                       inManagedObjectContext:[self managedObjectContext]]; //INSERT MO
         [newManagedObject setValue:[theSearchCatName capitalizedString] forKey:@"name"];
         aCategory = (CategoryRx*) newManagedObject;
         //DLog(@"theSearchCatName=_%@_ ",theSearchCatName,aCategoryName);
         [managedObjectContext save:&error2];
         if(error2)
            DLog(@"error saving category.");
         /////
         // Log that new Cat was added
         ///
      } else { //found existing Category
         aCategory = [catArray objectAtIndex:0];
      }
      
      [mutCatArray addObject:aCategory];
      
      // add this new or old Category to the array of Cats for current Recipe
      
   }
   NSArray *regArray = [NSArray arrayWithArray:mutCatArray];
   
   return regArray;
}




/// - (void)saveSelectedRecipeAs:(id)sender { ///
/***   
   // get the recipe from the selection
   id recipe = [[rxArrayController selectedObjects] lastObject];
   if (recipe != nil) {
      
      // the result
      int result;
      NSString *fileName = [NSString stringWithFormat: @"%@.rtf", [(Recipe *)recipe name]];
      
      // run the save panel to ask where to save
      NSSavePanel *savePanel = [NSSavePanel savePanel];
      [savePanel setRequiredFileType: @"rtf"];
      result = [savePanel runModalForDirectory: [NSHomeDirectory() stringByAppendingPathComponent: @"Desktop"] file:fileName];
      
      // if the user clicked OK
      if ( result == NSOKButton ) {
         
         // create a URL for the file
         NSURL *url = [NSURL fileURLWithPath:[savePanel filename]];
         BOOL didSave = [RecipeUtilities writeRTFDataForRecipe:recipe toFileURL:url];
         
         // if we didn't save, beep
         if ( !didSave ) {
            NSBeep();
         }
      }        
   }
}
***///



@end
