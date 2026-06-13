//
//  AddRecipeController.h
//  iHungryMac386
//
//  Created by Apple  User on 12/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MyAppController;
//@class MyCatArrayController;
@class RxFilteredArrayController;
@class MyRxDoneButton;
@class MyRxCancelButton;
@class MyPanel;
@class AppDelegate;
@class CategoryRx;

@interface AddRecipeController : NSWindowController < NSTableViewDataSource,NSControlTextEditingDelegate ,NSTabViewDelegate> {

   BOOL	cancelled;
   IBOutlet MyPanel* myPanel;
   IBOutlet NSTabView *tabView;
   IBOutlet NSTextField *textFieldRecipeNameAbove;
   IBOutlet NSTextField *textFieldRecipeName;//textFieldRecipeName
   IBOutlet NSTextField *textFieldSelectedCategoryName;//textFieldRecipeName
   IBOutlet NSTextView *textViewIngredients;
   IBOutlet NSTextView *textViewDirections;
   IBOutlet NSTextView *textViewComments;
   IBOutlet NSTableView *rxCatTableView;
   IBOutlet NSTextField *editRecipeTextField;
   IBOutlet NSTextField *textFieldNewCategoryName;
   /// catController must have categories via selected property in arrangedObjects
   NSString *savedRecipeName;
   NSString *savedRecipeIngredients;
   NSString *savedRecipeDirections;
   NSString *savedRecipeComments;
   NSArray *categoryArrayWithoutBrowseAll;
   
   IBOutlet NSTextField *rxNameLengthWarningTextField;
   IBOutlet MyRxDoneButton *doneButton;
   IBOutlet MyRxCancelButton *cancelButton;
   NSFont *smallPanelFont;
   BOOL doEnableDoneButton;
   BOOL isNameLengthOK;
   BOOL isNameUnique;
   
   IBOutlet NSArrayController *categoryArrayController;
   IBOutlet RxFilteredArrayController *filterRxArrayController;
   CategoryRx* selectedCategoryInMain;
   NSUInteger selectedCategoryIndexInMain;
   IBOutlet MyAppController *myAppController;
   MyAppController *myAppControllerParent;
}
@property (nonatomic, strong) IBOutlet NSTextField *textFieldSelectedCategoryName;

@property (nonatomic, strong) MyAppController *myAppControllerParent;
@property (nonatomic, strong) MyAppController *myAppController;

@property (nonatomic, strong) CategoryRx* selectedCategoryInMain;

@property (nonatomic, strong) IBOutlet RxFilteredArrayController *filterRxArrayController;
@property (nonatomic, strong) IBOutlet NSArrayController *categoryArrayController;
@property (nonatomic,assign) BOOL isNameLengthOK;
@property (nonatomic,assign) BOOL isNameUnique;
@property (nonatomic,assign) BOOL doEnableDoneButton;

   //@property (nonatomic, retain) NSTextView *recipeNameLengthWarningTextField;
@property (nonatomic, strong) NSTextField *editRecipeTextField;
@property (nonatomic, strong) NSFont *smallPanelFont;

@property (nonatomic, strong) MyRxCancelButton *cancelButton;
@property (nonatomic, strong) MyRxDoneButton *doneButton;
@property (nonatomic, strong) NSTextField *rxNameLengthWarningTextField;
@property (nonatomic, strong) NSTabView *tabView;
@property (nonatomic, strong) NSTextField *textFieldNewCategoryName;
@property (nonatomic, assign) NSUInteger selectedCategoryIndexInMain;

@property (nonatomic, strong) NSTextField *textFieldRecipeNameAbove;
@property (nonatomic, strong) NSArray *categoryArrayWithoutBrowseAll;
@property (nonatomic, strong) NSTableView *rxCatTableView;



@property (nonatomic, assign) BOOL cancelled;
@property (nonatomic, strong) NSTextField *textFieldRecipeName;
@property (nonatomic, strong) NSTextView *textViewIngredients;
@property (nonatomic, strong) NSTextView *textViewDirections;
@property (nonatomic, strong) NSTextView *textViewComments;
@property (nonatomic, strong) NSString *savedRecipeName;//setSavedRecipeName
@property (nonatomic, strong) NSString *savedRecipeIngredients;
@property (nonatomic, strong) NSString *savedRecipeDirections;
@property (nonatomic, strong) NSString *savedRecipeComments;

@property (nonatomic, strong) AppDelegate *appDelegate;

//- (IBAction) cancelled:(id) sender;
- (BOOL) updateRecipeNameLengthWarning;
   //- (NSString*) editRxFrom: (MyAppController *)sender;
- (BOOL)wasCancelled;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (void) recipeNameAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
- ( void) fillFieldsAndSetFonts;
- ( void) checkSelectedCategoryForTable;
- (void) newCategoryNameNotUniqueAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo ;

- (IBAction)scrollToShowFirstSelection:(id)sender;
@end

