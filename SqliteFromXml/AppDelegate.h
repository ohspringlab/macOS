//
//  AppDelegate.h
//  SqliteFromXml
//
//  Created by Apple  User on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>  //2/16/14
#import "MyWindowController.h"
@class VersionXML;
@class XmlListReader;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
   IBOutlet MyWindowController *myWindowController;
   XmlListReader *xmlListReader;
	VersionXML* versionXML;
	NSString* versionXMLString;
	NSString* installDateXMLString;
	NSString* editDateXMLString;
   NSURL *databaseURL;
   NSPersistentStoreCoordinator *persistentStoreCoordinator;
   NSManagedObjectModel *managedObjectModel;
   NSManagedObjectContext *managedObjectContext;
   

}
@property (nonatomic,retain) NSArray *categoryArray;
@property (nonatomic,retain) NSDictionary *dictionaryCodeDisplayCategory;
@property (nonatomic,retain) NSURL *databaseURL;
@property (nonatomic,retain) XmlListReader *xmlListReader;
@property (nonatomic,retain) VersionXML* versionXML;
@property (nonatomic,retain) NSString* versionXMLString;
@property (nonatomic,copy) NSString* installDateXMLString;
@property (nonatomic,copy) NSString* editDateXMLString;
@property (nonatomic,retain) MyWindowController *myWindowController;
   //@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property ( strong, nonatomic) NSPersistentStore *persistentStore;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;
- (BOOL) populateDbFromXmlString:(NSString*)XmlFilePath;

@end
