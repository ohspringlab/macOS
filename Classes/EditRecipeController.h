//
//  EditRecipeController.h
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
@class Recipe;
@class AppDelegate;
@class MyImageView;

@interface EditRecipeController : NSWindowController < NSTableViewDataSource,NSControlTextEditingDelegate ,NSTabViewDelegate,NSTextViewDelegate,NSPageControllerDelegate> {

   BOOL					cancelled;
   IBOutlet MyPanel* myPanel;
   IBOutlet NSTabView *tabView;
   IBOutlet NSTextField *textFieldRecipeNameAbove;
   IBOutlet NSTextField *textFieldRecipeName;//textFieldRecipeName
   IBOutlet NSTextView *textViewIngredients;
   IBOutlet NSTextView *textViewDirections;
   IBOutlet NSTextView *textViewComments;
   IBOutlet NSTableView *rxCatTableView;
   
   IBOutlet NSTextField *editRecipeTextField;
    IBOutlet NSArrayController *categoryArrayCntlr;
   /// catController must have categories via selected property in arrangedObjects

   NSString *savedRecipeName;
   NSString *savedRecipeIngredients;
   NSString *savedRecipeDirections;
   NSString *savedRecipeComments;
   NSArray *categoryArrayWithoutBrowseAll;
   
   MyAppController *myAppController;
    
   NSUInteger selectedCategoryIndexInMain;
         //   NSFont *textFieldFont;
         //   NSFont *textViewFont;
   IBOutlet NSTextField *rxNameLengthWarningTextField;
   IBOutlet MyRxDoneButton *doneButton;
   IBOutlet MyRxCancelButton *cancelButton;
   NSFont *smallPanelFont;
    
   IBOutlet NSManagedObjectContext *managedObjectContext;
    IBOutlet NSArrayController *rxArrayController;
    Recipe* selectedRecipe;
    NSArray* allCategories;
    NSPredicate *singlePredicate;
   IBOutlet AppDelegate *appDelegateOutlet;
}
@property (strong) IBOutlet MyImageView *imageView;
@property (strong, nonatomic) NSArray *imageArray;
@property (assign) IBOutlet NSLayoutConstraint *imageAspectRatio;
@property (strong) IBOutlet NSPageController *pageController;
@property (assign) IBOutlet NSButton *nextPhotoButton;
@property (assign) IBOutlet NSButton *prevPhotoButton;
@property (nonatomic, strong) IBOutlet NSTextField *infoNameTextField;
@property (nonatomic, assign) NSUInteger selectedCategoryIndexInMain;
@property (nonatomic, strong) Recipe* selectedRecipe;
@property (nonatomic, strong) NSArray* sortDescriptorsNameOnly;
@property (nonatomic, strong) AppDelegate *appDelegateOutlet;
@property (nonatomic, strong)  NSArrayController *rxArrayController;
@property (nonatomic, strong) NSArray* allCategories;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) MyAppController *myAppController;
@property (nonatomic, strong) IBOutlet NSArrayController *categoryArrayCntlr;

@property (nonatomic, strong) NSTextField *editRecipeTextField;
@property (nonatomic, strong) NSFont *smallPanelFont;
@property (nonatomic, strong) MyRxCancelButton *cancelButton;
@property (nonatomic, strong) MyRxDoneButton *doneButton;
@property (nonatomic, strong) NSTextField *rxNameLengthWarningTextField;
@property (nonatomic, strong) NSTabView *tabView;
   /////@property (nonatomic, retain) NSArrayController *rxFilteredArrayController;
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

- (void) updateRecipeNameLengthWarning;
   //- (NSString*) editRxFrom: (MyAppController *)sender;
- (BOOL)wasCancelled
;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (void) recipeNameAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
- (NSUInteger) checkItemsInTableViewForRecipe:(Recipe*)aRecipe ;
- (void) fillFieldsAndSetFontsForRecipe:(Recipe *)aRecipe ;

- (NSString*) editRecipeFrom: (MyAppController *)sender;
@end
