//
//  AddCategoryController.h
//  iHungryMac386
//
//  Created by Apple  User on 12/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MyAppController;
//@class AppDelegate;
@class DoneButtonAddCat;
@class CancelButtonAddCat;


@interface AddCategoryController : NSWindowController <NSTextFieldDelegate>{

   BOOL					cancelled;
   IBOutlet NSTextField *textFieldCategoryNewName;
   IBOutlet    NSTextField *textFieldAddCategoryLabel;
   IBOutlet NSTextField *categoryNameLengthWarningTextField;
   IBOutlet DoneButtonAddCat *doneButton;
   IBOutlet CancelButtonAddCat *cancelButton;
   //IBOutlet NSArrayController *myCatArrayController;
//   AppDelegate *appDelegate;
//   IBOutlet MyAppController *myAppController;
   NSString *savedCategoryName;
   
   MyAppController *myAppController;
   
   NSFont *smallPanelFont;
   BOOL doEnableDoneButton;
   BOOL isNameLengthOK;
   BOOL isNameUnique;
}
@property (nonatomic, strong) MyAppController *myAppController;
@property (nonatomic,assign) BOOL isNameLengthOK;
@property (nonatomic,assign) BOOL isNameUnique;
@property (nonatomic,assign) BOOL doEnableDoneButton;
@property (nonatomic, strong) NSTextField *textFieldAddCategoryLabel;
@property (nonatomic, strong) DoneButtonAddCat *doneButton;
@property (nonatomic, strong) CancelButtonAddCat *cancelButton;
@property (nonatomic, strong)  NSFont *smallPanelFont;
@property (nonatomic, strong)  NSTextField *categoryNameLengthWarningTextField;
@property (nonatomic, strong)  NSTextField *textFieldCategoryNewName;
//@property (nonatomic, retain) AppDelegate *appDelegate;

@property (nonatomic, strong) NSArrayController *myCatArrayController;
@property (nonatomic, assign) BOOL cancelled;

@property (nonatomic, strong) NSString *savedCategoryName;


- (NSString*) addCatFrom: (id)sender;
- (BOOL)wasCancelled;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (void) categoryNameAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
- (void) categoryNameLengthAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;

@end

