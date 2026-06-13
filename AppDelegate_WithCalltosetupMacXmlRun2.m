//
//  AppDelegate.m
//  iHungryMacNonDoc
//
//  Created by Mark on 3/10/11.
//  Copyright __MyCompanyName__ 2011 . All rights reserved.
//
#import "AppDelegate.h"
//#import "IngredXML.h"
//#import "XmlListReader.h"
//#import "Constants.h"
//#import <Cocoa/Cocoa.h>
//#import <CoreData/CoreData.h>
#import "Category.h"
#import "Recipe.h"
#import "VersionXML.h"
#import "RecipeXML.h"
#import "/usr/include/sqlite3.h"
#import "RecipeWindowController.h"
//#include "sqlite3.h"
//#import "/usr/lib/libsqlite3.dylib"
@implementation AppDelegate 

/*
NSWindow *window;
NSPersistentStoreCoordinator *persistentStoreCoordinator;
NSManagedObjectModel *managedObjectModel;
NSManagedObjectContext *managedObjectContext;
NSArrayController *fetchedArrayController;

NSMutableArray* listXML;
NSArray *recipeArray;
NSArray *categoryArray;
Category* activeCategory;
Recipe *activeRecipe; // check there are two instance
XmlListReader *xmlListReader;

VersionXML* versionXML;
NSString* versionXMLString;
NSString* installDateXMLString;
NSString* editDateXMLString;
BOOL isXmlFileVersionNewer;
NSNumber* maxRecipeId;
NSString * fullPathXML;
NSString * fullPathSqlite;
BOOL doesDbExistAtLoad;
*/
@synthesize  sortDescriptorNameAsc;

@synthesize sortedRecipeArray;
@synthesize window;
@synthesize persistentStoreCoordinator;

@synthesize managedObjectContext;

@synthesize managedObjectModel;

@synthesize fetchedArrayController;

//@synthesize listXML;
@synthesize recipeArray,categoryArray;

@synthesize activeRecipe,activeCategory;

@synthesize xmlListReader;
@synthesize versionXML;
@synthesize versionXMLString;
@synthesize installDateXMLString,editDateXMLString;
@synthesize isXmlFileVersionNewer;
@synthesize maxRecipeId;
@synthesize fullPathSqlite,fullPathXML;
@synthesize doesDbExistAtLoad;

@synthesize selectedCategoryObjs;

NSString * const  XML_FILENAME  = @"IHM_Recipes";
NSString * const  DATA_FILENAME = @"IHM_Mac_Recipes";
NSString * const  DATA_FILENAME_EXT = @"IHM_Mac_Recipes.sqlite";

//IHUNGRYMAC
/**
    Returns the support directory for the application, used to store the Core Data
    store file.  This code uses a directory named "iHungryMacNonDoc" for
    the content, either in the NSApplicationSupportDirectory location or (if the
    former cannot be found), the system's temporary directory.
 

- (NSString *)applicationSupportDirectory {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:@"iHungryMacNonDoc"];
} */

#pragma mark -
#pragma mark Application's documents directory
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
 
- (NSManagedObjectModel *)managedObjectModel {

    if (managedObjectModel) 
       return managedObjectModel;
	
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain]; //xxxxX
   //NSArray *theEnts = [managedObjectModel entities];
   //DLog(@"entities =%@", [managedObjectModel entities] );
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
   // THE FOLLOWING IS EXECUTED ONCE, THE FIRST TIME METHOD CALLED
   
   NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: DATA_FILENAME_EXT ];
   NSFileManager *fileManager = [NSFileManager defaultManager];
   
   //NSError *error = nil;
   [self setDoesDbExistAtLoad:FALSE];
   if ( [fileManager fileExistsAtPath:storePath isDirectory:NULL] ) {
      [self setDoesDbExistAtLoad:TRUE];
      DLog(@"..... DBFile Existed at Load:\n%@",storePath);
   }

   DLog(@"doesDbExistAtLoad=%d\nstorePath=%@",doesDbExistAtLoad,storePath);
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, 
                            [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	persistentStoreCoordinator 
   = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	NSError *error = nil;
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType  configuration:nil URL:storeUrl options:options error:&error]) {
		DLog(@"No persistentStoreCoord %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	} else{
      if(!doesDbExistAtLoad){
		   DLog(@".....Created new DBFile:%@",storeUrl);
      }
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

/**
    Returns the NSUndoManager for the application.  In this case, the manager
    returned is that of the managed object context for the application.
 */
 
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return [[self managedObjectContext] undoManager];
}

- (NSSortDescriptor*) sortDescriptorNameAsc{
   if(sortDescriptorNameAsc == nil)
      sortDescriptorNameAsc = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
   return sortDescriptorNameAsc;
}   
/**
    Performs the save action for the application, which is to send the save:
    message to the application's managed object context.  Any encountered errors
    are presented to the user.
 */
- (IBAction) deleteCategoryAction:(id)sender {//meb
   
   NSError *error = nil;
   
   if (![[self managedObjectContext] commitEditing]) {
      DLog(@"%@:%@ unable to commit editing before saving", [self class], _cmd);
   }
   
   if (![[self managedObjectContext] save:&error]) {
      [[NSApplication sharedApplication] presentError:error];
   }
}

/***
- (IBAction) saveAction:(id)sender {

    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        DLog(@"%@:%@ unable to commit editing before saving", [self class], _cmd);
    }

    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}
***/

/**
    Implementation of the applicationShouldTerminate: method, used here to
    handle the saving of changes in the application managed object context
    before the application terminates.
 */
 
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {

    if (!managedObjectContext) return NSTerminateNow;

    if (![managedObjectContext commitEditing]) {
        DLog(@"%@:%@ unable to commit editing to terminate", [self class], _cmd);
        return NSTerminateCancel;
    }

    if (![managedObjectContext hasChanges]) return NSTerminateNow;

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
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        [alert release];
        alert = nil;
        
        if (answer == NSAlertAlternateReturn) return NSTerminateCancel;

    }

    return NSTerminateNow;
}


/**
    Implementation of dealloc, to release the retained variables.
 */

- (IBAction) newRecipeAction:(NSArray *)selectedObjects {
	//NSWindow* r = [[NSWindow alloc] init];
   id object = ((selectedObjects != nil) && ([selectedObjects count] > 0)) ? [selectedObjects objectAtIndex:0] : nil;
	Recipe* aRecipe = nil;
   if (object != nil) {		
      aRecipe = (Recipe*)object;
      DLog(@"Recipe.name=%@",[aRecipe name]);
      //[[NSApp sharedApplication] delegate] set
   }
//- (id)initWithWindowNibName:(NSString *)windowNibName
   RecipeWindowController* controller = 
     [[RecipeWindowController alloc] initWithWindowNibName:@"RecipeView" 
                     recipe:(Recipe*) aRecipe]; 
   [controller window ];
   [controller showWindow:nil ];         
   DLog(@"WindowController loaded.");                                       
   //Recipe* aRecipe = (Recipe*)sender;
	//if (![NSBundle loadNibNamed:@"RecipeView" owner:self]) {
	//	DLog(@"Error loading Nib for RecipeWindow!");
	//} else {
		//[d doSomething];
		//[_list_of_open_documents addObject:d];
	//}
}

 
- (void)dealloc {

    [window release];
    [managedObjectContext release];
    [persistentStoreCoordinator release];
    [managedObjectModel release];
   //[listXML release];
	[recipeArray release];
	[categoryArray release];
	[activeCategory release];
	[activeRecipe release]; // check there are two instance
	[xmlListReader release];
	[versionXML release];
   [versionXMLString release];
	[installDateXMLString release];
	[editDateXMLString release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
   /// DATABASE EXISTS NOW - PERHAPS EMPTY -CREATE PRIOR TO appDidFinLaunch
#ifdef DEBUG
   NSLog(@"aDFL:");
#endif
   DLog(@"appDel:applicationDidFinishLaunching");
   if(
		getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")
		) {
		DLog(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
	}
   
   NSEntityDescription *entityDescCategory;
   [self setFullPathXML:nil];
	fullPathXML = [[NSBundle mainBundle] pathForResource:XML_FILENAME ofType:@"xml"];//IHM_Mac_Recipes
   NSAssert( (fullPathXML != nil), @"fullPathXML==nil!\n");
   NSString *attachPath;
   NSRange range = NSMakeRange(0 ,[fullPathXML length] - 4);
   attachPath = [fullPathXML substringWithRange:range ];
   fullPathSqlite = [NSString stringWithFormat:@"%@/%@.sqlite",[self applicationDocumentsDirectory ],DATA_FILENAME];
   DLog(@"fullPathSqlite=%@",fullPathSqlite);
	/////////
	//
	// Parse XML even if Database exists already
	//	get the array with preloaded recipes. If a preload
	//	based on an currentRecipeXMLObject.rid > [[theAppDelegate maxRecipeId] intValue] is not present, add it to DB
	//
   NSError* error7 = nil;
   entityDescCategory = [NSEntityDescription entityForName:@"Category"	
            inManagedObjectContext:[self managedObjectContext]];
   // NOTE: doesDbExistAtLoad SET B4 appDidFinLaunch
	//if(doesDbExistAtLoad){ // 2/4/2011 all recipes including XML and User . Earlier was currentXmlRecipeArray
   [self setCategoryArray: nil];
   NSFetchRequest *fetchRequest7 = [[NSFetchRequest alloc] init];
   [fetchRequest7 setEntity:entityDescCategory];
   [self setCategoryArray:[managedObjectContext executeFetchRequest:fetchRequest7 error:&error7]];
NSLog(@"\nDEBUG:B4 reading XML, DB has %d categories\n",[[self categoryArray] count]);
   //DLog(@"selectedRXs=%@",[catArrayController selectedObjects ]);
      //////////// FETCHED the VERSION OBJECT
	//}else{
   //   DLog(@"DB Brand New and empty");
   //}
   //DLog(@"[self categoryArray]=%@ [[self categoryArray] count]=%@  doesDbExistAtLoad=%d",[self categoryArray],[[self categoryArray] count],doesDbExistAtLoad);
   //else{
		//doesDbExistAtLoad == NO;
		//}
	NSURL *xmlURL = [NSURL fileURLWithPath:fullPathXML];
	if(xmlURL == nil){
		DLog(@"AppDelegate: xmlURL is nil");
		return ;
	}
   ///NOTE:: DATABASE EXISTS NOW - PERHAPS EMPTY -CREATE PRIOR TO appDidFinLaunch
	NSError *parseError = nil;
	// FIRST XMLListReader ALWAY RUN TO GET XML VERSION IF (doesDbExistAtLoad==YES) i.e. BBBB || CCCC
   // RUN 1 NEEDED for AAAA or BBBB or CCCC 
   XmlListReader* xmlReaderVersionOnly = [[XmlListReader alloc] init ];
   [xmlReaderVersionOnly setGetVersionOnly:YES];
   [xmlReaderVersionOnly setDoesDatabaseExist:doesDbExistAtLoad];
   [xmlReaderVersionOnly setRecipeXMLCheckedCnt:0];
   [xmlReaderVersionOnly setRecipeInsertionCount:0];
   [xmlReaderVersionOnly setCategoryInsertionCount:0];
   [xmlReaderVersionOnly setTheAppDelegate:self];
   ////    CONSIDER ADDING xmlDataInsertionComplete to dataModel
   //- (id) initForVersionOnly:(BOOL)fetchVersionOnly doesDatabaseExist:(BOOL)doesDbExist  catArray:(NSArray*)catObjArray
   /// dbCatArray is nil if this is first time app Loads 
   /// dbCatArray exists if DB exists, but may be empty
         //catArray:[[self fetchedResultsController] fetchedObjects]];
   [xmlReaderVersionOnly	parseXMLFileAtURL:xmlURL   parseError:&parseError];
   [xmlReaderVersionOnly release];
   xmlReaderVersionOnly = nil;
	// [appDel version] has XML versionString currently in DB
	// Put New XML in DB if DB is empty or former XMLFile lacked a Version or  XMLFileVersion is newer
	NSNumber* verNumXml ;//= [NSNumber numberWithFloat:0.0];
	NSNumber* verNumDB ;
	NSNumberFormatter* numFormater = [[NSNumberFormatter alloc] init];
   ///
   // DB already existed at app Load. Get the Version info
   //
   /// Get Current Version Info from the Sqlite DB
   
   VersionXML* theCurrentVersionInDataBase = nil ;
   
   // AAAA:                           doesDbExistAtLoad==NO   Known(SET B4 appDidFinLaunch) Virgin
   // BBBB: verNumDB == verNumXml  && doesDbExistAtLoad==YES  Known(xmlReaderVersionOnly)
   // CCCC: verNumDB <  verNumXml  && doesDbExistAtLoad==YES  Known(xmlReaderVersionOnly)
   BOOL doesNewDbExistWithoutVersionInfo = NO;
   NSArray* versionArray=nil;

   if(doesDbExistAtLoad){//BBBB || CCCC
      NSFetchRequest *fetchRequest3 = [[NSFetchRequest alloc] init];
      // Edit the entity name as appropriate.
      NSEntityDescription *entity3 = [NSEntityDescription entityForName:@"VersionXML"inManagedObjectContext:[self managedObjectContext]];
      [fetchRequest3 setEntity:entity3];
      NSError* error3 = nil;
      /// TO FETCH VERSIONXML OK DB MUST EXIST
      // POSSIBILITIES A:JUSTCREATED B:OLD AND COMPLETELY LOADED
      versionArray = [managedObjectContext executeFetchRequest:fetchRequest3 error:&error3];
      [fetchRequest3 release];
      if (error3) {
         DLog(@"Version Fetch error.  ...............");
         exit(-474);
      }
      NSAssert((versionArray != nil),@"versionArray==nil !");
      /////
      // if(versionArray count]==> earlier loaded but not run through xmlLoad
      //   that is, DB is virgin. Need a Version created.
      ////
      DLog(@"versionArray=%@",versionArray);
      if(versionArray && [versionArray count]){
         theCurrentVersionInDataBase = (VersionXML*)[versionArray objectAtIndex:0];
      }else{
         theCurrentVersionInDataBase = nil;
         DLog(@"Fetched VersionXML in DB, found none. BBBB expecting existing VersionXML in DB" );
         doesNewDbExistWithoutVersionInfo = YES;//ASSUME NO CATS NOR RXS
      }
      //NSAssert(((versionArray !=nil) && (theCurrentVersionInDataBase != nil) ),@"versionArray or theCurrentVersionInDataBase == nil");
      //ABC
      //   
   }else{ //else doesDbExistAtLoad==NO   AAAA
     //virgin load LOAD ALL XML RECIPES WITHOUT EXCEPTION 
      theCurrentVersionInDataBase = nil;
      self.isXmlFileVersionNewer = YES; //LOAD XML RECIPES without expection
   }
   verNumXml = [numFormater numberFromString:(NSString*)[self versionXMLString] ]; // WILL BE MOVED INTO DB FOR AAAA AS WELL AS BBBB AND CCCC
   
   
   if(doesDbExistAtLoad){
      // BBBB || CCCC
      //NSComparisonResult result2 = [verNumXml compare:[NSNumber numberWithFloat:0.0]];
      //NSAssert( (result2 == NSOrderedDescending || result2 == NSOrderedSame),@"verNumXml=%@ Must be >= 1.0",verNumXml);
      //OK only after xmlParse1 line2:<recipes version="1.30" date="02/24/2011"> then abort
      //[numFormater release];
      if(theCurrentVersionInDataBase == nil ){
         verNumDB = [NSNumber numberWithFloat:0.0];
      }else{
         verNumDB = [theCurrentVersionInDataBase number];
      }
      // BBBB || CCCC
      
      self.isXmlFileVersionNewer = 
         ([verNumXml compare:verNumDB] == NSOrderedDescending) ? YES : NO ; // IF (NO && ), MEANS NSOrderedSame
   }
   //////
#ifdef IHUNGRY_MAC_LITE
/***
   if(!doesDbExistAtLoad){
      // 1st fetch of app and DB is empty - insert "Browse ALL"
		NSManagedObject *newManagedObject = 
		[NSEntityDescription insertNewObjectForEntityForName:[entityDescCategory name] 
												inManagedObjectContext:managedObjectContext]; //CATEGORY "BROWSE ALL"
		[newManagedObject setValue:@"Browse All" forKey:@"name"];
      		NSError *error4 = nil;
		if (![[self managedObjectContext] save:&error4]) { //PERSIST DATA       /// SAVE
			//save failed
			[[self managedObjectContext] deleteObject:newManagedObject];
			DLog(@"CTVC:Save 'BrowseAll' failed MO to DB So deleted from Context. Error -665:%@",error4);
         exit(-665);
		}
	}
 ***/
#endif
   //////// 
   //       DB NOW EXISTS, MAY BE EMPTY OF RXS ( has BROWSE_ALL only for IHUNGRY_MAC_LITE
   //          IF doesDbExistAtLoad==FALSE then DB has only 'Browse_All
   //////
   NSArray* allRecipesArrayPriorToRun2 = nil;
   [self setMaxRecipeId: [NSNumber numberWithInt:-1]]; // will  Zero if no DB at Load -> userrx id==0
   
   if ( doesDbExistAtLoad ) { // BBBB || CCCC
      if(self.isXmlFileVersionNewer){ // CCCC
         parseError = nil;
         //fetch all recipes Prior To XmlRun2 /////////////
         NSError *error5=nil;
         NSFetchRequest *fetchRequest5 = [[NSFetchRequest alloc] init];
         NSEntityDescription *entity5 = 
            [NSEntityDescription entityForName:@"Recipe"	inManagedObjectContext:[self managedObjectContext]];
         [fetchRequest5 setEntity:entity5];
         allRecipesArrayPriorToRun2 =  [managedObjectContext executeFetchRequest:fetchRequest5 error:&error5];
         [fetchRequest5 release];											
         if(error5){
            DLog(@"AppDelegateDidFin:Fetch error=%@",error5);
            exit(-17);
         }
         DLog(@"allRecipesArrayPriorToRun2 Length before XmlParse2 parse called=%d",[allRecipesArrayPriorToRun2 count]);
         for (Recipe* aRecipe in allRecipesArrayPriorToRun2 ) {
            if([[self maxRecipeId] compare: aRecipe.recipeID] == NSOrderedDescending){
               [self setMaxRecipeId:aRecipe.recipeID]; 
            }
         }
         DLog(@"doesDbExistAtLoad==YES and self.isXmlFileVersionNewer==Yes ------!!!!!\nThis should happen if this is an upgrade app load.");
      }else{ // BBBB i.e. verXML == verDB 
         DLog(@"doesDbExistAtLoad==YES and self.isXmlFileVersionNewer==NO ------!!!!!\nThis should happen if not the first app load.");
      }
   }else{
      DLog(@"Virgin Run!");
   }
  ///    [self setRecipeArray:allRecipesArrayPriorToRun2];
   /////
   // MERGE NEW XML or this is first Load of DB
   /////
   // ON 1ST RUN CATARRAY.LEN = 1 RXRAY EMPTY
   XmlListReader* xmlListReader2;
   /// if ((doesDbExistAtLoad==NO) || (doesDbExistAtLoad==YES && self.isXmlFileVersionNewer == YES ) ) {// AAAA || CCCC
      xmlListReader2 = [XmlListReader alloc] ;
      [xmlListReader2 setGetVersionOnly:NO];
      [xmlListReader2 setDoesDatabaseExist:doesDbExistAtLoad];                
      [self setVersionXMLString:nil];
      [xmlListReader2 setupMacXmlRun2];   ///rename Store Cats in MOC ///////// STORE ALL CATS IN MOC
   /// }
   /******
   NSFetchRequest *fetchRequestCat = [[NSFetchRequest alloc] init];
   // Edit the entity name as appropriate.
   NSEntityDescription *entityCat = [NSEntityDescription entityForName:@"Category"inManagedObjectContext:[self managedObjectContext]];
   [fetchRequestCat setEntity:entityCat];
   NSError* error8 = nil;
   /// TO FETCH VERSIONXML OK DB MUST EXIST
   // AT LOAD POSSIBILITIES AAAA:DB JUSTCREATED and app virgin  BBBB:DB OLD & XML IS SAME VERSION CCCC:DB OLD & XML IS NEWER(RARE==VERSION UPDATE
    // AAAA:                doesDbExistAtLoad==NO   Known(SET B4 appDidFinLaunch) virgin load
    // BBBB: dbV == xmlV && doesDbExistAtLoad==YES  Known(xmlReaderVersionOnly)
    // CCCC: dbV < xmlV  && doesDbExistAtLoad==YES  Known(xmlReaderVersionOnly)
    **/
   /////  if(doesDbExistAtLoad == YES){ //BBBB || CCCC
      /// Load array with all the Categories in MOC
      NSFetchRequest *fetchRequestCat = [[NSFetchRequest alloc] init];
      // Edit the entity name as appropriate.
      NSEntityDescription *entityCat = [NSEntityDescription entityForName:@"Category"inManagedObjectContext:[self managedObjectContext]];
      [fetchRequestCat setEntity:entityCat];
      NSError* error8 = nil;
      [self setCategoryArray:[managedObjectContext executeFetchRequest:fetchRequestCat error:&error8]];
      
      if( [self categoryArray] == nil)
      {
         DLog(@"Error fetching all categories");
         exit(-122);  // Fail
      }
      [fetchRequestCat release];
   /////  }
   /***/	
   // update all XMLCategories into datastore  ***********
   ////if ((doesDbExistAtLoad==NO) || (doesDbExistAtLoad==YES && self.isXmlFileVersionNewer == YES )){// AAAA || CCCC
      NSError* error2 = nil;
      [[self managedObjectContext] save:&error2];  //SAVE CATEGORIES IN MOC to DB
      if(error2){
         DLog(@"Can not save MOC. Error: %@ ErrorInfo %@", error2, [error2 userInfo]);
         exit(-123);  // Fail
      }
   ////}
   /***/	
   //DLog(@"XmlListReader:initForVersionOnly NO:Besides 'Browse ALL' Added %d categories to DB",categoryInsertionCount);
   //   NEED TO ADD if preloads not found in DB
   //- (void)parseXMLFileAtURL:(NSURL *)URL  getVersionOnly:(BOOL)versionOnly parseError:(NSError **)error;
   if((doesDbExistAtLoad==NO) || ((doesDbExistAtLoad==YES && self.isXmlFileVersionNewer == YES ) && !doesNewDbExistWithoutVersionInfo) ) {// AAAA || CCCC
      parseError = nil;
      DLog(@"B4 Parse 2 [self categoryArray] = %@",[self categoryArray]); 
      [xmlListReader2	parseXMLFileAtURL:xmlURL parseError:&parseError]; //NO Parse2 for BBBB only setupMacXmlRun2pMac
      
      if (parseError) {
         DLog(@"XmlListReader Pass 2 parseError");
         [xmlListReader2 release];
         exit(-224);
      } 
      //DLog(@" GOOD PARSE XML RUN 2\n[self recipeArray]=%@",[self recipeArray]);
      NSFetchRequest *fetchRequestCat = [[NSFetchRequest alloc] init];
      // Edit the entity name as appropriate.
      NSEntityDescription *entityCat = [NSEntityDescription entityForName:@"Category"inManagedObjectContext:[self managedObjectContext]];
      [fetchRequestCat setEntity:entityCat];
      NSError* error8 = nil;
      [self setCategoryArray:[managedObjectContext executeFetchRequest:fetchRequestCat error:&error8]];
   }
   
   [xmlListReader2 release];
   xmlListReader2 = nil;
   
   //DLog(@"selectedRXs=%@",[catArrayController selectedObjects ]);
     
   NSError* error9 = nil;
   NSFetchRequest *fetchRequestRx = [[NSFetchRequest alloc] init];
   NSEntityDescription *entityRx = [NSEntityDescription entityForName:@"Recipe"inManagedObjectContext:[self managedObjectContext]];
   [fetchRequestRx setEntity:entityRx];
   //NSArray* allRecipeArray = 
      [managedObjectContext executeFetchRequest:fetchRequestRx error:&error9];
   [self setRecipeArray:[managedObjectContext executeFetchRequest:fetchRequestRx error:&error9]];
   if(error9){
      DLog(@" allRecipes Fetch error=%@",error9);
      exit(-178);
   }
   if( [[self recipeArray] count] == 0)
   {
      DLog(@"zero recipes");
      //exit(-121);  // Fail
   }
   [fetchRequestRx release];
   //////
   ///  DLog(@" After RUN 2 and fetch from MOC\n[self recipeArray]=%@",[self recipeArray]);
   
   /////
   //// BROWSE_ALL Category MO
   NSFetchRequest *fetchRequestBrowseAll = [[NSFetchRequest alloc] init];
   NSEntityDescription *entityBA = [NSEntityDescription entityForName:@"Category"inManagedObjectContext:[self managedObjectContext]];
   [fetchRequestBrowseAll setEntity:entityBA];
   NSError* error10 = nil;
   NSString* browseAllStr = @"Browse All";
   //predicate = [NSPredicate
//predicateWithFormat:@"SELF like[c] %@*", prefix];
   NSPredicate* predBrowse = [NSPredicate predicateWithFormat:@"name like[c] %@",browseAllStr];
   [fetchRequestBrowseAll setPredicate:predBrowse];
   
   NSArray *arrayWithOnlyCatBrowseAll = 
      [managedObjectContext executeFetchRequest:fetchRequestBrowseAll error:&error10];
   if(error10){
      DLog(@" BrowseAll Fetch error=%@",error10);
      exit(-178);
   }
   //- (void)addRecipes:(NSSet *)value;
   //- (id)valueForKey:(NSString *)key
   Category* catBrowseAll = (Category*)[arrayWithOnlyCatBrowseAll objectAtIndex:0];
   //[catBrowseAll addRecipes:[NSSet setWithArray: allRecipeArray] ];
   NSSet* allRecipeSet = [NSSet setWithArray:[self recipeArray]]; 
   
       [catBrowseAll addRecipes:allRecipeSet ];
   
   
   if(!doesDbExistAtLoad){// AAAA ONLY
      DLog(@"Creating VersionXML MO. This MUST be the first app load.  AAAAA");
      // create MO of type Version because DB is brand new 
      NSManagedObject *newManagedObject = 
      [NSEntityDescription insertNewObjectForEntityForName:@"VersionXML" inManagedObjectContext:[self managedObjectContext]]; //INSERT MO
      theCurrentVersionInDataBase = (VersionXML*)newManagedObject;
      theCurrentVersionInDataBase.number = verNumXml;
      theCurrentVersionInDataBase.installDate = [NSDate date] ;
      NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
      [dateFormat setDateFormat:@"MM.dd.yyyy"];
      theCurrentVersionInDataBase.editDate = [dateFormat dateFromString: [self editDateXMLString]];  
      [dateFormat release];
   }
   NSError *error6=nil;
   if (![[self managedObjectContext] save:&error6]) { // save the VersionXML
      // Update to handle the error appropriately.
      DLog(@"iHMADel:AppDidFinish:Unresolved error -16 %@, %@", error6, [error6 userInfo]);
      exit(-16);  // Fail
   }	
      	
	   // PRODUCE A SORTED ARRAY OF STRINGS WITH RECIPE NAMES
   //NSArray* sortedArray = [[[self recipeArray] valueForKey:@"name"]  sortedArrayUsingSelector:@selector(compareRecipeNames:)];
   //PRODUCE A SORTED ARRAY OF OBJS SORTED ON NAME
   NSArray* sortedArray = [[self recipeArray]  sortedArrayUsingSelector:@selector(compareRecipeNames:)];
   [self setRecipeArray:sortedArray];
   
   //sortedArray = [[self categoryArray]  sortedArrayUsingSelector:@selector(compareCategoryNames:)];
  // DLog(@"catArrayController=%@", catArrayController);

   //DLog(@"didSetIndex=%d", didSetIndex);
   //NSUInteger index = 
   //DLog(@"Cat selectionIndex=%d",[catArrayController selectionIndex]);
   
    //DLog(@"catArrayController=%@", catArrayController);
   DLog(@"Reached end of applicationDidFinishLaunching.***********");
}

- (NSNumber*) fetchMaxRecipeId { //get MaxID from DB

	NSNumber *theMax, *theMaxOut;
	sqlite3 *database;
   NSComparisonResult result;
   int prepare;
	
	DLog(@"databasePath=%@",fullPathSqlite);
	// Open the database from the users filessytem
	theMaxOut = [NSNumber numberWithInt:-1];
   if( [self doesDbExistAtLoad]){ //if(DB is brandNew and empty
      if(sqlite3_open([fullPathSqlite UTF8String], &database) == SQLITE_OK) {
         // Setup the SQL Statement and compile it for faster access
         //const char *sqlStatement = "SELECT * FROM mynotes";// table name
         const char *sqlStatement = "SELECT MAX( ZRECIPEID) FROM ZRECIPE";// table name
         sqlite3_stmt *compiledStatement = nil;
         if((prepare = sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)) {
            DLog(@"compiled statement ok");
            theMax = [NSNumber numberWithInt:(int)sqlite3_column_int(compiledStatement, 0)];
            result = [theMax compare:theMaxOut]; 
            if (result == NSOrderedDescending) 
                  theMaxOut = theMax;
         }
         // Release the compiled statement from memory
         sqlite3_finalize(compiledStatement);
      }
      sqlite3_close(database);
   }
   DLog(@"result of prepare=%d where 0==OK 1==error or no DB.\n",prepare);
   DLog(@"theMaxOut=%@ \ntheMax=%@",theMaxOut,theMax);
	return theMaxOut;

}

- (void)awakeFromNib
{

}//end - (void)awakeFromNib

/*
// Creates a writable copy of the bundled default database in the application Documents directory.
- (void)createEditableCopyOfDatabaseIfNeeded {
   // First, test for existence.
   BOOL success;
   NSFileManager *fileManager = [NSFileManager defaultManager];
   NSError *error;
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   NSString *documentsDirectory = [paths objectAtIndex:0];
   NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DATA_FILENAME_EXT];
   success = [fileManager fileExistsAtPath:writableDBPath];
   if (success) return;
   // The writable database does not exist, so copy the default to the appropriate location.
   NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"bookdb.sql"];
   [self setFullPathSqlite:defaultDBPath];
   success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
   if (!success) {
      NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
   }
}
*****/

@end
