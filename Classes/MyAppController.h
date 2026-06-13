//
//  AppController.h
//  iHungryMac_ND
//
//  Created by Mark on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipe.h"
@class MainPreferenceController;

//
//  AppController.h
//  iHungryMac_ND copied from 5/18/11
//
//  Created by Mark on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainPreferenceController.h"
@class MainPreferenceController;
@class AppDelegate;
@class AddCategoryController;
@class AddRecipeController;
@class EditRecipeController;
@class DeleteCategoryController;
@class DeleteRecipeController;
@class EditCategoryController;
@class DgxDropZoneBoxView;
@class MyCatArrayController;
@class PrintWindowController;
@class HelpWindowController;
@class AboutWindowController;
@class ImportWindowController;
   ///@class DgxPathWindowController;
@class RxFilteredArrayController;
@class MyButton;
@class ExportWindowController;
@class AboutWindowController;
@interface MyAppController : NSWindowController <NSTableViewDelegate,NSWindowDelegate> {
   
   IBOutlet NSUserDefaultsController *userDefaultsController;
   IBOutlet NSTableView *tableViewRx;
   IBOutlet NSTableView *tableViewCat;
   IBOutlet MyCatArrayController *myCatArrayController;
   IBOutlet RxFilteredArrayController *rxFilteredArrayController;
   IBOutlet NSSplitView *splitView;
   IBOutlet NSWindow *mainWindow;
   NSNumber  *categoryTableWidth;
   NSInteger tagLastTableSelected;
   
   EditCategoryController *editCategoryController;
   AddCategoryController	*addCategoryController;
   DeleteCategoryController *deleteCategoryController;
   
   
   AddRecipeController	*addRecipeController;
   EditRecipeController	*editRecipeController;
   DeleteRecipeController *deleteRecipeController;
   
   IBOutlet DgxDropZoneBoxView* dgxDropZoneBoxView;
   AppDelegate *appDelegate;
   NSUInteger currentCategorySelectionIndex;
   PrintWindowController *printWindowController;
   NSPrintInfo *printInfo;
   Recipe *recipePrinting;
   NSURL *exportDgxSaveURL;
   NSString *importDgxLogFile;
   NSURL *importDgxURL;
   ///NSOpenPanel *importDgxOpenPanel;
   NSFont *smallPanelFont;
   IBOutlet AppDelegate *appDelegateIB;
@private
   NSURL *dgxFileURL;
   //BOOL didCancelInFolderSearch;
  NSMutableSet * recipeWindowControllerSet;
}
@property (nonatomic, strong) ExportWindowController  *exportWindowController;
@property (nonatomic, strong) NSSavePanel *exportDgxSavePanel;
@property (nonatomic, strong) IBOutlet MyButton *rxEditButton;
@property (nonatomic, strong) IBOutlet MyButton *rxDeleteButton;

@property (nonatomic, strong) ImportWindowController *importWindowController;
@property (nonatomic, strong) NSMutableSet * recipeWindowControllerSet;
//@property (nonatomic, retain)  NSArrayController *categoryArrayController;
@property (nonatomic, strong) MyCatArrayController *myCatArrayController;
@property (nonatomic, strong) NSWindow *mainWindow;
@property (nonatomic, strong) NSFont *smallPanelFont;
@property (nonatomic, strong) RxFilteredArrayController *rxFilteredArrayController;

//@property (nonatomic, retain) NSArrayController *rxArrayController;
///@property (nonatomic, strong) NSOpenPanel *importDgxOpenPanel;
@property (nonatomic, strong) NSURL *importDgxURL;
@property (nonatomic, strong) NSString *importDgxLogFile;
@property (nonatomic,strong) NSURL *exportDgxSaveURL;
@property (nonatomic,strong) NSURL *dgxFileURL;
@property (nonatomic,strong) Recipe *recipePrinting;
@property (nonatomic,strong) NSPrintInfo *printInfo;
@property (nonatomic,strong) PrintWindowController *printWindowController;

@property (nonatomic,strong) AddCategoryController	*addCategoryController;
@property (nonatomic,strong) DeleteCategoryController *deleteCategoryController;
@property (nonatomic,strong) EditCategoryController *editCategoryController;

@property (nonatomic,strong) EditRecipeController	*editRecipeController;
@property (nonatomic,strong) AddRecipeController	*addRecipeController;
@property (nonatomic,strong) DeleteRecipeController *deleteRecipeController;

@property (nonatomic,assign) NSUInteger currentCategorySelectionIndex;
@property (nonatomic,strong) AppDelegate *appDelegate;
@property (nonatomic,strong)  AppDelegate *appDelegateIB;

@property (nonatomic, strong) IBOutlet DgxDropZoneBoxView* dgxDropZoneBoxView;

@property (nonatomic, strong) NSNumber  *  categoryTableWidth;// stored from winWillLoad to winDidLoad
@property (nonatomic, strong)  NSSplitView *splitView;



///@property (nonatomic, retain) DgxPathWindowController *dgxPathWindowController;

@property (nonatomic,assign) NSInteger tagLastTableSelected;
   //@property (nonatomic,retain) NSMutableArray *list_of_editWindow_cntrlrs;
@property (nonatomic,strong) NSTableView *tableViewRx;
@property (nonatomic,strong) NSTableView *tableViewCat;
@property (nonatomic,strong) NSUserDefaultsController *userDefaultsController;
@property (nonatomic,strong) AboutWindowController *aboutWindowController;
//@property (nonatomic,retain) MainPreferenceController *mainPreferenceController;

- (IBAction) myHideOthers:(id)sender;
- (IBAction) myHide:(id)sender;
//- (IBAction) myHide;
//- (IBAction) myShowAll:(id)sender;
- (IBAction) myPerformMiniturize:(id)sender;

- (IBAction) editCategoryNameAction:(id)sender;
//- (IBAction) showPreferencePanel:(id)sender;
- (IBAction) addCategoryAction:(id)sender;
- (IBAction) addRecipeAction:(id)sender;
- (IBAction) deleteRecipeAction:(id)sender;
- (IBAction) deleteCategoryAction:(id)sender;
- (IBAction) showFontManagerForMainWindow:(id)sender;
- (NSView *)printableView;
//- (IBAction) showHelp:(id)sender;
- (IBAction) printAllRecipeAction:(id)sender ;
   //- (IBAction) helpHungryMeFileMenuAction:(id)sender ;
- (void ) handleRemoveSearchFieldStringNotification:(NSNotification *)note;

;
- (IBAction) exportDgxFileMenuAction:(id)sender ;
- (IBAction) importDgxFileMenuAction:(id)sender ;
//- (IBAction)browseOpenPanelExport:(id)sender;
- (BOOL) importRecipes:(NSURL*)url;
//- (void) fetchExportName;
- (void) updateSmallPanelFont ;
@end
