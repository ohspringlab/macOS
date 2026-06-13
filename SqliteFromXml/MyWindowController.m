//
//  MyWindowController.m
//  iHungryMeUniv 6
//
//  Created by Apple User on 8/6/12.
//  Copyright (c) 2012 DrummingGrouse. All rights reserved.
//

#import "MyWindowController.h"
#import "AppDelegate.h"
#import "DebugMacros.h"

@implementation MyWindowController

@synthesize textFieldInputXmlFilePath;
@synthesize fileTypesArray;
@synthesize textFieldOutputSqliteFileName,textFieldOutputSqliteFolder;
@synthesize appDelegate;
@synthesize xmlURL;
@synthesize outputMessage;
   //@synthesize isOverwrite;
@synthesize outputSqliteFolderURL;

   //static NSString * const DEF_XML_INPUT = @"file://localhost/Users/appleuser/Cocoa/iHungryDataXXX/IHM_Recipes.xml";

//NSString *  DEF_XML_INPUT_PATH = @"/Volumes/DataDisk/Cocoa/iHungryData/IHM_Recipes.xml";

NSString *  DEF_XML_INPUT_PATH = @"/Volumes/Macintosh HD2 2/Users/mbarron/iHungryData/IHM_Recipes.xml";

//NSString *  DEF_XML_URL_INPUT = @"/Volumes/DataDisk/Cocoa/iHungryData/SQL\\ XML/IHM_RecipesDM4-4.xml";

   //NSString *  DEF_SQLITE_DIR_URL_OUTPUT = @"/Volumes/DataDisk/Cocoa/iHungryData/";
   //NSString *  DEF_SQLITE_DIR_URL_OUTPUT = @"/Volumes/DataDisk/Cocoa/iHungryData/SQL-and-XML-Files-DM4/";

//NSString *  DEF_SQLITE_DIR_URL_OUTPUT = @"/Volumes/DataDisk/Cocoa/iHungryData/SQLDM6/";

NSString *  DEF_SQLITE_DIR_URL_OUTPUT = @"/Volumes/Macintosh HD2 2/Users/mbarron/iHungryData/SQLDM6/";

   //@"file://localhost/Users/appleuser/Cocoa/iHungryData/SQL and XML Files DM4/";

 NSString *  DEF_SQLITE_FILENAME = @"DefaultRecipes.sqlite"; // SqlFromXml ONLY

- (id)init
{
   self=[super initWithWindowNibName:@"MainWindow"];
   if(self)
   {
      //perform any initializations
   }
   return self;
}

/**
- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}**/

- (NSString *)windowNibName {
   return @"MainWindow";
}

- (void) awakeFromNib {
      //awakeFromNib method on the object. If this method is present on an object, the NIB loader will invoke it after the whole NIB is initialized and connected, making it the perfect place to perform configuration involving multiple objects.
   [self.textFieldInputXmlFilePath setStringValue:DEF_XML_INPUT_PATH ];
   [self.textFieldOutputSqliteFolder setStringValue:DEF_SQLITE_DIR_URL_OUTPUT];
   [self.textFieldOutputSqliteFileName setStringValue:DEF_SQLITE_FILENAME];     // SqlFromXml ONLY
      //TEMPORARILY
   self.overWriteButton.state = 1;
}

/*
- (void)windowDidLoad
{
    [super windowDidLoad];
   self.appDelegate = (AppDelegate *)[NSApp delegate];
   //NSString *documentsDir = [self applicationDocumentsDirectory]; //[documentPaths objectAtIndex:0];
   //NSString *targetDbFilespec = [documentsDir stringByAppendingPathComponent:DATA_FILENAME_EXT];
   [self.inputXmlFile setStringValue:@"file://localhost/Users/appleuser/Cocoa/iHungryDataXXX/IHM_Recipes.xml"];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

*/

 
 - (IBAction)browseXML:(id)sender{
    // Accessor and mutator for an array of file types - (NSArray ) fileTypesArray; - (void) setFileTypesArray: (NSArray ) anArray;
    // Accessor and specific mutator for the 'current directory', probably // stored in NSUserDefaults somewhere // Note that the class' +initialize method should set this up to be // somewhere sensible - (NSString ) userDirectory; - (void) setUserDirectoryFromFilename: (NSString ) aFilename;
    // Accessor for the window we want to attach the sheet to. - (id) window; ... .m file : - (void) someMethod {
    NSOpenPanel  *panel = [NSOpenPanel openPanel];
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"xml",nil]];
    
    [panel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
	    if (result == NSOKButton) {
          
          NSURL *URL = [panel URL];
          self.xmlURL = URL;
             //NSString *xmlStr = [URL relativeString];
          [self.textFieldInputXmlFilePath setStringValue:[URL path]];
             ///Volumes/DataDisk/Cocoa ...
          DLog(@"URL=%@",URL);
       }
     return;
    }];
 
 }

 
- (IBAction)browseDatabaseFolder:(id)sender{
   
   NSOpenPanel  *panel = [NSOpenPanel openPanel];
   //[panel setAllowedFileTypes:[NSArray arrayWithObjects:@"xml",nil]];
   [panel setCanCreateDirectories:YES];
   [panel setCanChooseDirectories:YES];
   [panel setCanChooseFiles:NO];
   [panel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
      if (result == NSOKButton) {
         
         NSURL *URL = [panel URL];
         self.outputSqliteFolderURL = URL;
            //NSString *dbDirStr = [URL relativeString];
         [self.textFieldOutputSqliteFolder setStringValue:[URL path]];
         
         DLog(@"URL=%@",URL);
      }
      return;
   }];
   
}

- (IBAction) goBuildSqlite :(id)sender{
   

   NSFileManager *fileManager = [NSFileManager defaultManager];
   NSURL *targetDirectoryURL = [NSURL fileURLWithPath:[[self textFieldOutputSqliteFolder] stringValue] isDirectory:YES];       //self.outputSqliteFolderURL;
   NSURL *dbURL = [targetDirectoryURL URLByAppendingPathComponent:[[self textFieldOutputSqliteFileName] stringValue]];//append an NSString
   DLog(@"dbURL=%@",dbURL);
   self.appDelegate.databaseURL = dbURL;
   BOOL databaseFileExisted = [fileManager fileExistsAtPath:[appDelegate.databaseURL path]];

   NSError *error = nil;
   
   if (!databaseFileExisted) {
         // check to see if targetDirectory exists, if not create it
      NSDictionary *properties = [targetDirectoryURL resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsDirectoryKey] error:&error];
      if (!properties) {
            // this code assume !properties means DB folder does not exist
         BOOL ok = NO;
         if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[[self textFieldOutputSqliteFolder] stringValue ] withIntermediateDirectories:YES attributes:nil error:&error];
            if (!ok) {
                  //Could not create DbFolder
               DLog(@"Could not create DbFolder");
               [[NSApplication sharedApplication] presentError:error];
               return ;
            }
            DLog(@"dbFolder Created.");
         }
      } else {
            // dbFolderExisted
         DLog(@"properties existed.");
         if (![[properties objectForKey:NSURLIsDirectoryKey] boolValue]) {
          // Customize and localize this error.
          NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [targetDirectoryURL path]];
          NSMutableDictionary *dict = [NSMutableDictionary dictionary];
          [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
          error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
          [[NSApplication sharedApplication] presentError:error];
          return;
         }
      }
      [self.appDelegate managedObjectContext];// build CoreData Stack
      [self.appDelegate populateDbFromXmlString:[[[self textFieldInputXmlFilePath] stringValue] copy]];
      return;
      
   }//if (!databaseFileExisted)
   DLog(@"DatabaseExisted");
   if(!_overWriteButton.state){ //
         //delete DB file
      DLog(@"databaseFileExisted and Overwrite No checked.");
      NSBeep();
      return;
   }
   DLog(@"File exists and Overwrite requested");
      //self.appDelegate.persistentStoreCoordinator removePersistentStore:appDelegate.per error:appDelegate
      //self.appDelegate.persistentStoreCoordinator=nil;
      //self.appDelegate.managedObjectContext=nil;
   if(![self reloadStore]){
      DLog(@"Could not reloadStore");
      NSString *errorString;
      errorString = [NSString stringWithFormat:
                     @"No StoreReload."];
      [self.outputMessage setStringValue:errorString];
                     return;
   }
   
   [self.appDelegate populateDbFromXmlString:[[[self textFieldInputXmlFilePath] stringValue] copy]];
   
}

- (BOOL)reloadStore {
   
   BOOL success = NO;
   NSError *error = nil;
   if (![appDelegate.persistentStoreCoordinator removePersistentStore:appDelegate.persistentStore error:&error]) {
      DLog(@"Unable to remove persistent store : %@", error);
   }
      // [appDelegate.managedObjectContext performBlock:^{
      [appDelegate.managedObjectContext reset];
      //}];
   appDelegate.persistentStore = nil;
   
   error=nil;
   if(![[NSFileManager defaultManager] removeItemAtURL:appDelegate.databaseURL error:&error]){
      DLog(@"FAILED to remove dbFile %@: Error:%@", appDelegate.databaseURL, error);
   }
   NSDictionary *options =
   @{
      NSMigratePersistentStoresAutomaticallyOption:@YES
      ,NSInferMappingModelAutomaticallyOption:@YES
     /// ,NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"} // Uncomment to disable WAL journal mode
     };
   error = nil;
   self.appDelegate.persistentStore =
      [appDelegate.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                       configuration:nil
                                                 URL:[self.appDelegate databaseURL]
                                             options:options
                                               error:&error];
      //storeURL: file:///var/mobile/Applications/00079260-18BC-413A-A16C-32B8513D020F/Documents/Stores/IHM_Recipes.sqlite
   
   if (!self.appDelegate.persistentStore) {
      DLog(@"Failed to add store. Error: %@", error);//abort();
   }
   else
      {DLog(@"Successfully added store: %@",self.appDelegate.persistentStore);}
      //}
   
   
   
   if (self.appDelegate.persistentStore) {success = YES;}
   return success;
}







@end
