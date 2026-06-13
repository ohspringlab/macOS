//
//  EditRecipeController.h
//  iHungryMac386
//
//  Created by Apple  User on 12/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Constants.h"
@class MyAppController;
@class MyCatArrayController;
@class RxFilteredArrayController;
@class MyRxCancelButton;
@class MyRxDoneButton;
@interface EditCategoryController : NSWindowController <NSTableViewDataSource,NSControlTextEditingDelegate > {

//BOOL					cancelled;

   IBOutlet NSTextField *textFieldCategoryNameAbove;
   IBOutlet NSTextField *textFieldCategoryName;
   IBOutlet MyRxDoneButton *doneButton;
   IBOutlet MyRxCancelButton *cancelButton;
    NSString *savedCategoryName;
   IBOutlet MyAppController *myAppController;
   NSUInteger selectedCategoryIndexInMain;
   IBOutlet NSTextField *textFieldEditCategory;
   IBOutlet NSTextField *textFieldEditCategoryLabel;
   IBOutlet NSTextField *categoryNameLengthWarningTextField;
   NSFont *smallPanelFont;
   BOOL doEnableDoneButton;
   BOOL isNameLengthOK;
   BOOL isNameUnique;
}
@property (nonatomic,assign) BOOL isNameLengthOK;
@property (nonatomic,assign) BOOL isNameUnique;
@property (nonatomic,assign) BOOL doEnableDoneButton;
@property (nonatomic, strong) NSTextField *textFieldEditCategoryLabel;
@property (nonatomic, strong)  NSFont *smallPanelFont;

@property (nonatomic, strong) NSTextField *categoryNameLengthWarningTextField;
@property (nonatomic, strong) MyRxCancelButton *cancelButton;
@property (nonatomic, strong) MyRxDoneButton *doneButton;
@property (nonatomic, strong) NSTextField *textFieldEditCategory;

@property (nonatomic, assign) NSUInteger selectedCategoryIndexInMain;

@property (nonatomic, strong) NSTextField *textFieldCategoryNameAbove;
@property (nonatomic, strong) NSTextField *textFieldCategoryName;

@property (nonatomic, strong) MyAppController *myAppController;

@property (nonatomic, strong) NSString *savedCategoryName;//setSavedRecipeName

- (IBAction) removeSelectionFromTextField:(id) sender;
- (void) editCatFrom: (MyAppController *)sender;
   //- (BOOL)wasCancelled;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
   //- (void) recipeNameAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end

