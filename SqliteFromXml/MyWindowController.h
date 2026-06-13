//
//  MyWindowController.h  SqliteFromXml
//  iHungryMeUniv 6
//
//  Created by Apple User on 8/6/12.
//  Copyright (c) 2012 DrummingGrouse. All rights reserved.
//

   //#import <Cocoa/Cocoa.h> // iOS only
#import <AppKit/AppKit.h>

@class AppDelegate;

@interface MyWindowController : NSWindowController {
IBOutlet NSTextField *textFieldInputXmlFilePath;
IBOutlet NSTextField *textFieldOutputSqliteFolder;
IBOutlet NSTextField *textFieldOutputSqliteFileName;
IBOutlet NSTextField *outputMessage;
IBOutlet    AppDelegate *appDelegate;
IBOutlet    NSButton* _overWriteButton;
   
NSArray *fileTypesArray;
NSURL *xmlURL;
      //BOOL isOverwrite;
}
   //@property (nonatomic,assign) BOOL isOverwrite;
@property (nonatomic,retain) NSTextField *outputMessage;
@property (nonatomic,retain) NSURL *xmlURL;
@property (nonatomic,retain) AppDelegate *appDelegate;
@property (nonatomic, retain)NSTextField *textFieldInputXmlFilePath;
@property (nonatomic, retain)NSTextField *textFieldOutputSqliteFolder;
@property (nonatomic, retain)NSURL *outputSqliteFolderURL;
@property (nonatomic, retain)NSTextField *textFieldOutputSqliteFileName;
@property (nonatomic, retain)  NSArray *fileTypesArray;
@property (nonatomic, strong) NSButton* overWriteButton;

- (IBAction)browseXML:(id)sender;
- (IBAction)browseDatabaseFolder:(id)sender;

- (IBAction) goBuildSqlite:(id)sender;
@end
