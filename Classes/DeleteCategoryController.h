//
//  AddCategoryController.h
//  iHungryMac386
//
//  Created by Apple  User on 12/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MyAppController;
@class CategoryRx;
@class MyDoneButton;
@class MyCancelButton;

@interface DeleteCategoryController : NSWindowController{

   BOOL					cancelled;
   IBOutlet NSTextField *textFieldCategoryName;
   //IBOutlet NSTextField *textFieldDeleteCategoryLabel;

   CategoryRx *category;
   NSString *savedCategoryName;
   MyAppController *myAppController;
    //IBOutlet AppDelegate *appDelegate;
   NSFont *smallPanelFont;
   IBOutlet MyDoneButton *doneButton;
   IBOutlet MyCancelButton *cancelButton;
   //IBOutlet NSArrayController *categoryArrayController; USING CONTROLLER IN myAppController
      //IBOutlet NSTableView *rxCatsTableView;
}

@property (nonatomic, strong) MyDoneButton *doneButton;
@property (nonatomic, strong) MyCancelButton *cancelButton;
@property (nonatomic, strong)  NSFont *smallPanelFont;
@property (nonatomic, strong) MyAppController *myAppController;
@property (nonatomic, strong) CategoryRx *category;
@property (nonatomic, assign) BOOL cancelled;
@property (nonatomic, strong) NSTextField *textFieldCategoryName;

@property (nonatomic, strong) NSString *savedCategoryName;

//- (IBAction) cancelled:(id) sender;
- (NSString*) deleteCatFrom: (MyAppController *)sender;
- (BOOL)wasCancelled;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end

