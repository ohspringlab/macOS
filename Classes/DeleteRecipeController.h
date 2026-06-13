//
//  DeleteRecipeController.h
//  iHungryMac386
//
//  Created by Apple  User on 12/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MyAppController;
//@class MyCatArrayController;
//@class RxFilteredArrayController;
@class MyRxDoneButton;
@class MyRxCancelButton;
@class MyPanel;
@class Recipe;
@class AppDelegate;

@interface DeleteRecipeController : NSWindowController < NSTableViewDataSource,NSControlTextEditingDelegate ,NSTabViewDelegate,NSWindowDelegate> {

   BOOL					cancelled;
   IBOutlet MyPanel* myPanel;
   IBOutlet NSTabView *tabView;
   IBOutlet NSTextField *textFieldRecipeNameAbove;
   IBOutlet NSTextField *textFieldRecipeName;//textFieldRecipeName
                                             //IBOutlet NSTextField *textFieldRecipeName2;//textFieldRecipeName
   IBOutlet NSTextView *textViewIngredients;
   IBOutlet NSTextView *textViewDirections;
   IBOutlet NSTextView *textViewComments;
   IBOutlet NSTableView *rxCatTableView;
   IBOutlet NSArrayController *categoryArrayController;
   //IBOutlet RxFilteredArrayController *rxFilteredArrayController;
   IBOutlet NSArrayController *recipeArrayController;
   IBOutlet NSTextField *deleteRecipeTextField;
   /// catController must have categories via selected property in arrangedObjects
   NSString *savedRecipeName;
   NSString *savedRecipeIngredients;
   NSString *savedRecipeDirections;
   NSString *savedRecipeComments;
   NSArray *categoryArrayWithoutBrowseAll;
   NSUInteger selectedCategoryIndexInMain;
   IBOutlet MyRxDoneButton *doneButton;
   IBOutlet MyRxCancelButton *cancelButton;
   NSFont *smallPanelFont;
   Recipe *selectedRecipe;
   NSArray *arrayTheRecipeCats;
   NSArray *arrayTheRecipe;
   NSArray* categorySortDescriptorsNameOnly;
   AppDelegate *appDelegate;
   MyAppController *myAppController;
}
//@property (nonatomic, assign) NSUInteger savedCategorySelectionIndex;
@property (nonatomic, strong) MyAppController *myAppController;
@property (nonatomic, strong) NSArray *categorySortDescriptorsNameOnly;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSArray *arrayTheRecipe;
@property (nonatomic, strong) NSArray *arrayTheRecipeCats;
@property (nonatomic, strong) Recipe *selectedRecipe;
@property (nonatomic, strong) NSTextField *deleteRecipeTextField;
@property (nonatomic, strong) NSFont *smallPanelFont;
@property (nonatomic, strong) MyRxCancelButton *cancelButton;
@property (nonatomic, strong) MyRxDoneButton *doneButton;
   //@property (nonatomic, retain) NSTextField *rxNameLengthWarningTextField;
@property (nonatomic, strong) NSTabView *tabView;
@property (nonatomic, assign) NSUInteger selectedCategoryIndexInMain;
@property (nonatomic, strong) NSArrayController *categoryArrayController;
@property (nonatomic, strong) NSArrayController *recipeArrayController;
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


- (void) fillFieldsAndSetFontsForRecipe:(Recipe*)theRecipe ;

   //- (void) checkItemsInTableViewForRecipe:(Recipe*)theRecipe  ;

- (BOOL)wasCancelled;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (void) recipeNameAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end

