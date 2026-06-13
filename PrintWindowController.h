//
//  PrintWindowController.h
//  iHungryMac386
//
//  Created by Apple  User on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyAppController.h"
@class PrintRecipeArrayController;
@class AppDelegate;
@class NSTableColumn ;
   //@class MyTableView;
//@class Recipe;
@interface PrintWindowController : NSWindowController{
    /*
   IBOutlet PrintRecipeArrayController *printRecipeArrayController; // set from printRecipeArrayController itself
   MyAppController *myAppController;
   NSArray *sortDescriptors;
   NSArray *allRecipeArray; // all recipes for the activeCategory
   //NSPrintInfo *printInfo;
   Recipe* recipeNowPrinting;
   BOOL isNonZeroRecipePrintCount;
   AppDelegate *appDelegate;
   IBOutlet NSTableColumn *checkBoxCol;
   IBOutlet NSTableColumn *recipeNameCol;
   NSPredicate * filterPredicate;
   BOOL isCheckedAllRecipes;
   NSUInteger selectedRecipeCount;
   IBOutlet NSTextField *__weak recipeCountTextField;
   IBOutlet NSTextField *__weak selectedRecipeCountTextField;
  // NSArray *selectedCategoryRecipesArray;
   IBOutlet NSTableView *printTableView;
   Recipe *selectedRecipe;
   BOOL isUserOkRequiredForEachRx;
   BOOL isPDF;
    */
   NSURL *_savePanelURL;
   ///NSURL *_tempDirectoryURL;
}
///@property (nonatomic,copy) NSString *documentsPath ;
///@property (nonatomic,strong) NSURL *tempDirectoryURL; // [] = _[]
@property (nonatomic,strong) NSTextView *printView;
@property (nonatomic,copy) NSURL *savePanelURL ;

@property (nonatomic,assign) NSPrintInfo *printInfo;
@property (nonatomic,copy) NSString *pdfTempFilePath;
@property (nonatomic,copy) NSString *pdfSavePath ;
@property (nonatomic,assign) BOOL isPDF;
@property (nonatomic,assign) BOOL isUserOkRequiredForEachRx;
@property (nonatomic,strong) Recipe *selectedRecipe;
@property (nonatomic,strong) NSTableView *printTableView;
@property (nonatomic,assign) NSTextField *recipeCountTextField;
@property (nonatomic,assign) NSTextField *selectedRecipeCountTextField;

@property (nonatomic,assign) NSUInteger selectedRecipeCount;
@property (nonatomic,strong) NSPredicate * filterPredicate;
@property (nonatomic,strong) NSTableColumn *checkBoxCol;
@property (nonatomic,strong) NSTableColumn *recipeNameCol;
@property (nonatomic,strong) AppDelegate *appDelegate;
@property (nonatomic,assign) BOOL isNonZeroRecipePrintCount;
@property (nonatomic,assign) BOOL isCheckedAllRecipes;
@property (nonatomic,strong) Recipe* recipeNowPrinting;
@property (nonatomic,strong) NSArray *allRecipeArray;
@property (nonatomic,strong) NSArray *sortDescriptors;
@property (nonatomic,strong) MyAppController *myAppController; 
@property (nonatomic,strong) PrintRecipeArrayController *printRecipeArrayController;
- (IBAction) selectAllRecipes:(id)sender;
- (IBAction) selectNoRecipes:(id)sender;
- (NSUInteger) printAllRxFrom:(id) sender;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (void) setPrintRecipeArrayController:(PrintRecipeArrayController*)controller;
- (NSView *)printableView:(Recipe *)recipe;
- (IBAction) checkBoxClicked:(id)sender;
- (NSUInteger) updateRecipePrintCount;

@end
