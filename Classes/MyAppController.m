//
//  AppController.m
//  iHungryMac_ND
//
//  Created by Mark on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyAppController.h"
#import "MainPreferenceController.h"
#import "AppDelegate.h"
#import "AddCategoryController.h"
#import "AddRecipeController.h"
#import "EditRecipeController.h"
#import "DeleteRecipeController.h"
#import "DeleteCategoryController.h"
#import "EditCategoryController.h"
#import "Constants.h"
#import "CategoryRx.h"
#import "SelectedCatNotBrowseAllAndHasNoRxsTransformer.h"
#import "SelectedRecipesToNegatedBoolTransformer.h"
#import "MyCatArrayController.h"
#import "SelectedCategoryIsNotBrowseAllTransformer.h"
//#import "ActiveRVC_IsSelfTransformer.h"
//#import "PrintingAtLeastOneRecipeTransformer.h"
#import "PrintWindowController.h"
#import  "RecipePrintView.h" 
   //#import "HelpWindowController.h"
#import "AboutWindowController.h"
#import "ResourcePathTransformer.h"
#import  "ImportExportDefines.h"
#import "ExportWindowController.h"
#import "ImportWindowController.h"
///#import  "DgxPathWindowController.h"
#import "RxFilteredArrayController.h"

#import "NSSplitView+CCD_LayoutAdditions.h"
#import "DgxDropZoneBoxView.h"
#import "RecipeWindowController.h"
#import "MyButton.h"
//#import "SSAlert.h";
extern NSString* const DG_TableBgColorKey;
extern NSString* const DG_AllowDetailWindowCopiesKey;

@implementation MyAppController
@synthesize aboutWindowController; 
@synthesize exportWindowController;
@synthesize exportDgxSavePanel;

@synthesize currentCategorySelectionIndex;
@synthesize categoryTableWidth;
@synthesize userDefaultsController;
//@synthesize mainPreferenceController;
@synthesize tableViewRx;
@synthesize tableViewCat;
   //@synthesize  list_of_editWindow_cntrlrs;
//@synthesize tagLastTableSelected, editButton;
@synthesize addCategoryController;
@synthesize deleteCategoryController;
@synthesize editCategoryController;

@synthesize addRecipeController;
@synthesize deleteRecipeController;
@synthesize editRecipeController;


@synthesize dgxDropZoneBoxView;

//@synthesize rxArrayController;
@synthesize rxFilteredArrayController;
@synthesize splitView;

@synthesize printWindowController;
@synthesize recipePrinting;
@synthesize tagLastTableSelected;
@synthesize printInfo;
//@synthesize dgxFileContents;
@synthesize dgxFileURL;
///@synthesize dgxPathWindowController;
@synthesize  exportDgxSaveURL;
@synthesize importDgxLogFile;
@synthesize importDgxURL;
///@synthesize  importDgxOpenPanel;
@synthesize smallPanelFont;
@synthesize mainWindow;
@synthesize myCatArrayController;
@synthesize appDelegate;
@synthesize appDelegateIB;
@synthesize recipeWindowControllerSet;

// -------------------------------------------------------------------------------
//	windowNibName
// -------------------------------------------------------------------------------


- (NSString *)windowNibName
{
	return @"MainWindow";
} 


- (void) windowWillClose:(NSNotification *)notification{
  
   NSUserDefaults *defaults2 =[NSUserDefaults standardUserDefaults] ;
   [defaults2 synchronize];
   
}

- (id)initWithWindowNibName:(NSString *)windowNibName
{
   if (self = [super initWithWindowNibName:windowNibName ]) {
         // Custom initialization
         //get a copy for this view
         // DLog(@"");
   }
   return self;
}


- (void) windowWillLoad{
   
 /*********  
   NSUserDefaults *defaults2 =[NSUserDefaults standardUserDefaults];
   
   [self setAppDelegate:(AppDelegate*)[[NSApplication sharedApplication] delegate] ];
   
   [self setCategoryTableWidth :[NSNumber numberWithInteger: [defaults2 integerForKey:DG_MainCategoryColumnWidth]] ];
   
   [(AppDelegate*) [[NSApplication sharedApplication] delegate] resizeBothTableViewRowHeights];
   ****/
}

#pragma mark WindowDelegate
- (void)windowDidBecomeKey:(NSNotification *)notification{
}

- (void)windowControllerWillLoadNib:(NSWindowController *)windowController{
   
}

- (void) windowDidLoad{
   /*
    NSString * mainSplitViewSavedData = [[NSUserDefaults standardUserDefaults] valueForKey:[[self splitView] autosaveName]];
    DLog(@"[[myAppController splitView] autosaveName]=%@",[[self splitView] autosaveName]);
    DLog(@"mainSplitViewSavedData=%@",mainSplitViewSavedData);
    DLog(@"[NSUserDefaults standardUserDefaults]=%@",[NSUserDefaults standardUserDefaults]);
    DLog(@"[myAppController.splitView autosaveName]=%@",[self.splitView autosaveName]); */
    
   
}

#pragma mark Handler for RxTableViewSelectionGotCarriageReturnNotification

- (void)handleRxTableViewSelectionGotCarriageReturnNotification:(NSNotification *)notification
{     // emulating a double-click on item in RecipeTableView on MainWindow.nib
   Recipe *theRecipe = [notification.userInfo  objectForKey:@"Recipe"];
   DLog(@"theRecipe=%@",theRecipe);
   if (theRecipe) {
      NSArray *oneRecipeArray = [NSArray arrayWithObject:theRecipe];
      [self newRecipeWindowAction:oneRecipeArray];// put up new rxDetails window
   }else{
      DLog(@"theRecipe was nil.");
   }
   
}

 
 
- (void)awakeFromNib {
   [super awakeFromNib];// must be called, may be anytime in this method
   //DLog(@"********************");
   //DLog(@"1 [self.myCatArrayController.arrangedObjects count]=%ld",[self.myCatArrayController.arrangedObjects count]);
   
   [self setAppDelegate:(AppDelegate*)[[NSApplication sharedApplication] delegate] ];
   
   NSMenu *mainMenu = [[NSApplication sharedApplication] mainMenu];
   NSMenuItem *menuItemWindow = [mainMenu itemWithTitle:@"Window"];
   NSMenu *menuWindow = [menuItemWindow submenu];
   
   NSMenuItem *menuItemBATF = [menuWindow itemWithTitle:@"Bring All to Front"];
   [menuItemBATF setTarget:nil];
   [menuItemBATF setAction:@selector(arrangeInFront:)] ;
   
         NSNotificationCenter *dc;
   dc = [NSNotificationCenter defaultCenter];
   
   [dc addObserver: self
          selector: @selector(handleRxTableViewSelectionGotCarriageReturnNotification:)
              name: RxTableViewSelectionGotCarriageReturnNotification  //ReturnKey struck while RecipeTableView was Key and Now selected Recipe is going to appear in RecipeWindow : emulates DoubleClick
            object: nil];
   

   
   
     NSNotificationCenter *center;
   center = [NSNotificationCenter defaultCenter];
   
   [center addObserver: self
              selector: @selector(handleExportDgxUrlFetchDoneNotification:)
                  name:ExportDgxUrlFetchDoneNotification //ExportDgxFolderFetchDoneNotification  //window deleted or made non-key
                object: self];// send if from self
 /***/   
   [center addObserver: self
              selector: @selector(handleRemoveSearchFieldStringNotification:)
                  name:RemoveSearchFieldStringNotification //  //window deleted or made non-key
                object: nil];
  /***/
 
   [center addObserver: self
              selector: @selector(handleImportDgxFinderPanelDoneNotification:)
                  name:ImportDgxFinderPanelDoneNotification //  //window deleted or made non-key
                object: self];
  
   NSSortDescriptor *sortDesc = [(AppDelegate*)[[NSApplication sharedApplication] delegate] sortDescriptorNameAscInsen];
   if (sortDesc) {
      NSArray* sd_Array = [NSArray arrayWithObject:sortDesc];
      [rxFilteredArrayController setSortDescriptors:sd_Array];
   }
   
   NSUserDefaults *defaults2 =[NSUserDefaults standardUserDefaults];
   
   ///DLog(@"myAppController from MyAppController=%@",self );
   //DLog(@"\n*\n* AppDelegate from MyAppController = %@\n*\n*",[self appDelegate]) ;
   [self setCategoryTableWidth :[NSNumber numberWithInteger: [defaults2 integerForKey:DG_MainCategoryColumnWidth]] ];
   [self.appDelegate resizeBothTableViewRowHeights];
   
    
   [[self dgxDropZoneBoxView ] registerForDraggedTypes:[NSArray arrayWithObjects:
                                  NSFilenamesPboardType, @"com.DrummingGrouse.dgx" ,nil]];
} 

#pragma mark New Recipe Window Action

- (IBAction) newRecipeWindowAction:(NSArray *)selectedObjects {
   
   id object = ((selectedObjects != nil) && ([selectedObjects count] > 0)) ? [selectedObjects objectAtIndex:0] : nil;
   
   if (object != nil) {
      Recipe* aRecipe = nil;
      aRecipe = (Recipe*)object;
      RecipeWindowController* controller =
      [[RecipeWindowController alloc] initWithWindowNibName:@"RecipeView" ];
      [controller setRecipe:aRecipe];
      [controller setShouldCascadeWindows:YES];
      [[self recipeWindowControllerSet] addObject:controller];
      DLog(@"recipeWindowControllerSet = %@\n\nObject count=%lu",recipeWindowControllerSet,(unsigned long)recipeWindowControllerSet.count );
      [controller setSpeechOnGoing:NO];
      [controller setMyAppController:self];
      [controller window];
      
   }else{
      DLog(@"selectedObjs contained no recipe.");
   }
   
}



- (NSMutableSet*) recipeWindowControllerSet {
   
   if(!recipeWindowControllerSet){
      recipeWindowControllerSet = [[NSMutableSet alloc] init ];
   }
   //DLog(@"recipeWindowControllerSet=%@",self.recipeWindowControllerSet);
   return recipeWindowControllerSet;
}

- (void) updateSmallPanelFont {
   AppDelegate *appDel = (AppDelegate*)[[NSApplication sharedApplication] delegate];
   NSFontDescriptor *descriptor = [appDel.tableFont fontDescriptor];
   int fontSize = MAX_SMALL_PANEL_FONT_SIZE;
   if(descriptor.pointSize < MAX_SMALL_PANEL_FONT_SIZE)
      fontSize = descriptor.pointSize;
   self.smallPanelFont = [NSFont fontWithDescriptor:descriptor  size:fontSize];
   DLog(@"smallPanelFont.size=%d",fontSize);
}

/**
- (NSMutableArray *) list_of_editWindow_cntrlrs {
   
   if(!list_of_editWindow_cntrlrs){
      list_of_editWindow_cntrlrs = [NSMutableArray arrayWithCapacity:8];
   }
   
   return  list_of_editWindow_cntrlrs ;
   
} **/


- (NSString *)applicationSupportDirectory {
   
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
   NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
   return [basePath stringByAppendingPathComponent:@"iHungryMacNonDoc"];

}


- (NSString *)preferencesDirectory {
   
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
   NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
   return [basePath stringByAppendingPathComponent:@"iHungryMacNonDoc"];
}



+ (void) initialize{
   //Initialize the value transformers used throughout the application bindings
   
/*  
	NSValueTransformer *transformer;
   
   transformer= [[[ResourcePathTransformer alloc] init] autorelease];
   
   [NSValueTransformer setValueTransformer:transformer forName:@"ResourcePathTransformer"];
*/
   

   return;
}


-(void)handleManagedObjectContextDidSave:(NSNotification*)note
{
   
    NSSet *updatedObjects = [[note userInfo] objectForKey:NSUpdatedObjectsKey];
    NSSet *deletedObjects = [[note userInfo] objectForKey:NSDeletedObjectsKey];
    NSSet *insertedObjects = [[note userInfo] objectForKey:NSInsertedObjectsKey];
  
   BOOL changeCategory = 
      (updatedObjects != nil 
         && [[updatedObjects anyObject] isKindOfClass:[CategoryRx class]])
   || (deletedObjects != nil 
       && [[deletedObjects anyObject] isKindOfClass:[CategoryRx class]])
   ||  (insertedObjects != nil 
        && [[insertedObjects anyObject] isKindOfClass:[CategoryRx class] ]);
   if (changeCategory) {
      [tableViewCat reloadData];
   }
   
   BOOL changeRecipe = 
   (updatedObjects != nil 
    && [[updatedObjects anyObject] isKindOfClass:[Recipe class]])
   || (deletedObjects != nil 
       && [[deletedObjects anyObject] isKindOfClass:[Recipe class]])
   ||  (insertedObjects != nil 
        && [[insertedObjects anyObject] isKindOfClass:[Recipe class]]);
   if (changeRecipe) {
      [tableViewRx reloadData];
   }
   
} 

- (IBAction) printAllRecipeAction:(id)sender {
   
   DLog(@"myAppController from self=%@",self  );
   // setup the PrintAll sheet controller if one hasn't been setup already
	if (printWindowController == nil){
		printWindowController = [[PrintWindowController alloc] initWithWindowNibName:@"PrintWindow" ] ;
      [printWindowController setMyAppController:self];
       DLog(@"set into printWindowController:myAppController=%@",self );
   }
   NSPredicate* predicateSelected = [NSPredicate predicateWithFormat:@" SELF.selected != 0"];
   NSArray* selectedRxRay = [self.rxFilteredArrayController.arrangedObjects filteredArrayUsingPredicate:predicateSelected] ;
   DLog(@"selectedRxRay.count=%lu",selectedRxRay.count );
   //[[rxFilteredArrayController  selectedObjects] count]
   // DLog(@"myAppController just b4 call to printAllRxFrom:=%@\nThe above should be same as [self myAppController in pARxF:",self  );
   if([[rxFilteredArrayController  selectedObjects] count] > 0) {
      [printWindowController setSelectedRecipe: [[rxFilteredArrayController  selectedObjects] objectAtIndex:0]];
      [printWindowController printAllRxFrom:self];
   }
   else
      NSBeep ();
}


 
 - (NSView *)printableView
 {
 NSTextView    *printView;
 NSDictionary    *titleAttr;
 
 // CREATE THE PRINT VIEW
 // 480 pixels wide seems like a good width for printing text
 //printView = [[[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, 480, 200)] autorelease];
 printView = [[NSTextView alloc] initWithFrame:[[self printInfo] imageablePageBounds]];
 [printView setVerticallyResizable:YES];
 [printView setHorizontallyResizable:NO];
 
 // ADD THE TEXT
 // This assumes there is an NSTextField called titleField
 // and an NSTextView called mainTextView
 
 [[printView textStorage] beginEditing];
 
 // Set the attributes for the title
 //titleAttr = [NSDictionary dictionaryWithObject:[NSFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
 
 titleAttr = [NSDictionary dictionaryWithObject:[(AppDelegate*)[[NSApplication sharedApplication] delegate] tableFont] forKey:NSFontAttributeName];
 
 // Add the title
 ///initWithString:[titleField stringValue] attributes:titleAttr] autorelease] ]];
 [
 [printView textStorage] appendAttributedString:
 [[NSAttributedString alloc] initWithString:[[self window] title] attributes:titleAttr ] 
 ];
 
 // Create a couple returns between the title and the body
 [[printView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
 
 // Add the body text
 
 [[printView textStorage] appendAttributedString: (NSAttributedString*)[recipePrinting ingredients]];
 // Create a couple returns between the ingredients and the directions
 [[printView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
 
 [[printView textStorage] appendAttributedString:(NSAttributedString*)[recipePrinting directions]];
 // Create a couple returns between the directions and the comments
 [[printView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
 
 [[printView textStorage] appendAttributedString:(NSAttributedString*)[recipePrinting comments]];
 
 // Center the title
 ///[printView setAlignment:NSCenterTextAlignment range:NSMakeRange(0, [[titleField stringValue] length])];
 [printView setAlignment:NSCenterTextAlignment range:NSMakeRange(0, [[[self window] title] length])];
 
 [[printView textStorage] endEditing];
 
 // Resize the print view to fit the added text
 // (Is this done automatically?)
 [printView sizeToFit];
 
 return printView;
    
 }

/***
 
 - (NSPrintOperation *)printOperationWithSettings:(NSDictionary *)ps error:(NSError **)e 
 { 
 RecipePrintView *view = [[RecipePrintView alloc] init]; 
 //NSPrintInfo *printInfo = [self printInfo]; 
 NSPrintOperation *printOp = [NSPrintOperation printOperationWithView:view                                   printInfo:[self printInfo]]; 
 [view release]; 
 return printOp; 
 
 }  ***/
/*
- (void) disableAbout{
   NSMenu *mainMenu = [[NSApplication sharedApplication] mainMenu];
   NSMenuItem *menuItemHungryMe = [mainMenu itemWithTitle:@"HungryMe"];
   NSMenu *menuHungryMe = [menuItemHungryMe submenu];
   
   //NSMenuItem *menuItemMinimize = [menuAbout itemAtIndex:2];
   /// NSMenuItem *menuItemAbout = [menuHungryMe itemAtIndex:0];
   
   NSMenuItem *menuItemAbout = [menuHungryMe itemAtIndex:[menuHungryMe indexOfItemWithTitle:@"About HungryMe"]];
   
   [menuItemAbout setEnabled:NO];
   DLog(@"[menuItemAbout isEnabled]=%d",[menuItemAbout isEnabled]);
}

- (void) enableAbout{
   NSMenu *mainMenu = [[NSApplication sharedApplication] mainMenu];
   NSMenuItem *menuItemHungryMe = [mainMenu itemWithTitle:@"HungryMe"];
   NSMenu *menuHungryMe = [menuItemHungryMe submenu];
   
   NSMenuItem *menuItemAbout = [menuHungryMe itemAtIndex:0];
   [menuItemAbout setEnabled:YES];
   DLog(@"[menuItemAbout isEnabled]=%d",[menuItemAbout isEnabled]);
}
*/

#pragma mark Category and Recipe ACTIONS

- (IBAction) addCategoryAction:(id)sender {//meb
                                           // insert another row in cat Table, editable
                                           // setup the addCat sheet controller if one hasn't been setup already
   //[self disableAbout];
   
	if (addCategoryController == nil)
		addCategoryController = [[AddCategoryController alloc] initWithWindowNibName:@"AddCategory"];
   
   [addCategoryController setMyAppController:self];
   //[addCategoryController addCatFrom:self];
   [self.window beginSheet:addCategoryController.window completionHandler:^(NSModalResponse returnCode) {
      DLog(@"completionHandler called");
      //[self enableAbout];
   
   }];
   
}


- (IBAction) deleteCategoryAction:(id)sender {//action send by button
   // insert another row in cat Table, editable
   // setup the edit sheet controller if one hasn't been setup already
   
   //[self disableAbout];
	if (deleteCategoryController == nil)
		deleteCategoryController = [[DeleteCategoryController alloc] initWithWindowNibName:@"DeleteCategory"];
         //self.tabViewRecipe.nextKeyView = self.textViewID;
   
      //deleteCategoryController.window.initialFirstResponder = self.deleteCategoryController.cancelButton;
   [deleteCategoryController setMyAppController:self];
    CategoryRx *aCategory = [self.myCatArrayController.selectedObjects objectAtIndex:0];
    [deleteCategoryController setCategory:aCategory];
   //[deleteCategoryController deleteCatFrom:self]; //send self so that deleteCatController can access mainWindow via myAppController
   [self.window beginSheet:deleteCategoryController.window completionHandler:^(NSModalResponse returnCode) {
      //[self enableAbout];
      DLog(@"completionHandler called"); }];
   
}


- (IBAction) editCategoryNameAction:(id)sender {
   //DLog(@"editCategoryNameAction.");
   
   //[self disableAbout];
   
   if (self.editCategoryController == nil)
		editCategoryController = [[EditCategoryController alloc] initWithWindowNibName:@"EditCategory"];
   [editCategoryController setMyAppController:self];
   //[editCategoryController editCatFrom:self];
   
   [self.window beginSheet:editCategoryController.window completionHandler:^(NSModalResponse returnCode) {
      DLog(@"completionHandler called");
      //[self enableAbout];
   }];
   
}

- (IBAction) addRecipeAction:(id)sender {//meb
    // insert another row in cat Table, editable
    // setup the addRecipe sheet controller if one hasn't been setup already
    //[self disableAbout];
    DLog(@"self.appDelegate=%@",self.appDelegate);
    if (addRecipeController == nil){
        addRecipeController = [[AddRecipeController alloc] initWithWindowNibName:@"AddRecipe"];
    }
   addRecipeController.myAppControllerParent = self;
   CategoryRx* aCat = [self.myCatArrayController.selectedObjects objectAtIndex:0];
   [self.addRecipeController setSelectedCategoryInMain:aCat];
   DLog(@"aCat=%@\nself.myCatArrayController.selectionIndex=%lu",aCat.name,self.myCatArrayController.selectionIndex);
   [self.addRecipeController setSelectedCategoryIndexInMain:myCatArrayController.selectionIndex];//BrowseAll
   /*
   if (myCatArrayController.selectionIndex > 0) {
      [self.addRecipeController setSelectedCategoryIndexInMain:self.myCatArrayController.selectionIndex - 1];
      /// [self.addRecipeController checkSelectedCategoryForTable];
   }*/
   
   [self.window beginSheet:addRecipeController.window completionHandler:^(NSModalResponse returnCode) {
      addRecipeController.window = nil;
      addRecipeController = nil;
      DLog(@"completionHandler called"); }];
} // addRecipeAction:


- (IBAction) deleteRecipeAction:(id)sender {//action send by button
   
   //[self disableAbout];
    if (deleteRecipeController == nil){
        deleteRecipeController = [[DeleteRecipeController alloc] initWithWindowNibName:@"DeleteRecipe"];
        [deleteRecipeController setMyAppController:self];
    }
    // code done each time here
    [deleteRecipeController.tabView selectLastTabViewItem:nil]; // reset KeyPath
    [deleteRecipeController.tabView selectFirstTabViewItem:nil];
    Recipe *theRecipe = [[[self rxFilteredArrayController] arrangedObjects]  objectAtIndex: [[self rxFilteredArrayController] selectionIndex] ];
    DLog(@"theRecipe=%@",theRecipe);
   [deleteRecipeController  setMyAppController:self];
    [deleteRecipeController  setSelectedRecipe:theRecipe];
    [deleteRecipeController setAppDelegate:self.appDelegate ];
    //[[deleteRecipeController window] makeFirstResponder:[deleteRecipeController tabView]];
    /*
    [NSApp beginSheet:self.deleteRecipeController.window
       modalForWindow:self.window
        modalDelegate:nil didEndSelector:nil contextInfo:nil];
    [NSApp runModalForWindow:[self window]];
    // sheet is up here...
    [NSApp endSheet:self.deleteRecipeController.window returnCode:0];
    [self.window orderOut:self]; */
    [self.window beginSheet:deleteRecipeController.window completionHandler:^(NSModalResponse returnCode) {
       DLog(@"completionHandler called");
       deleteRecipeController.window = nil;
       deleteRecipeController = nil;
      // [self enableAbout];
    }];
}


- (IBAction) editRecipeAction:(id)sender {
   
   //[self disableAbout];
    if (self.editRecipeController == nil){
        self.editRecipeController = [[EditRecipeController alloc] initWithWindowNibName:@"EditRecipe"];
    }
    [editRecipeController.tabView selectLastTabViewItem:self]; // reset KeyPath
    [editRecipeController.tabView selectFirstTabViewItem:self];
    editRecipeController.myAppController = self;
    editRecipeController.managedObjectContext = self.appDelegate.managedObjectContext;
    Recipe *theRecipe = [[[self rxFilteredArrayController] arrangedObjects]  objectAtIndex: [[self rxFilteredArrayController] selectionIndex]] ;
    [editRecipeController setSelectedRecipe:theRecipe];
   DLog(@"theRecipe=%@\n\n",theRecipe);
   /// [self.editRecipeController editRecipeFrom:self];
   [self.window beginSheet:editRecipeController.window completionHandler:^(NSModalResponse returnCode) {
      DLog(@"completionHandler called");
      editRecipeController=nil;
      //[self enableAbout];
   }];
}


- (IBAction) showFontManagerForMainWindow:(id)sender {
   [[self window ]makeKeyAndOrderFront:self];
   [[NSFontManager sharedFontManager] orderFrontFontPanel:self];
}

/*
- (IBAction) editCatsRxsAction:(id)sender {
   //[self tableViewRx] set
   
}*/
#pragma mark IMPORT DGX

- (IBAction) importDgxFileMenuAction:(id)sender {
   
   // called from Menu
   [self setDgxFileURL:nil];
   [self showOpenPanelImport:sender] ;

} 



#pragma mark NSTableViewDelegate tableViewCat 

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification{
   
   if (aNotification.object == tableViewCat) {
      
      [tableViewCat selectColumnIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
      [[[self.rxFilteredArrayController.searchField cell] cancelButtonCell] performClick:self];
      
      [self.rxFilteredArrayController setSelectionIndex:0];////5/24/15
   
   }
}

- (void)tableViewColumnDidResize:(NSNotification *)aNotification{ //tableViewCat
   
   if(userDefaultsController ){
      ////NSDictionary *dict = [aNotification userInfo];
      
      [userDefaultsController save:self];
      
      //NSTableColumn *col = (NSTableColumn*)[dict objectForKey:@"NSTableColumn"];
      //DLog(@"Resize column.Old Width=%@ Col ToolTip=%@"
        //   ,[dict objectForKey:@"NSOldWidth"],[col headerToolTip]);
   }
}

/*

- (IBAction) showHelp:(id)sender {
   
  int status =  MyGotoHelpPage();
   DLog(@"status for HelpBook load is %d",status);
   
} */

OSStatus MyGotoHelpPage (void)
{
   CFBundleRef myApplicationBundle = NULL;
   CFStringRef myBookName = NULL;
   OSStatus err = noErr;
   
   myApplicationBundle = CFBundleGetMainBundle();// 1
   //if (myApplicationBundle == NULL) {err = fnfErr; goto bail;}// 2
   myBookName = CFBundleGetValueForInfoDictionaryKey(// 3
                                                     myApplicationBundle,
                                                     CFSTR("CFBundleHelpBookName"));
   
   if (myBookName == NULL) {err = fnfErr; return err;}
   
   if (CFGetTypeID(myBookName) != CFStringGetTypeID()) {// 4
      err = paramErr;
   } 
   
   err = AHGotoPage (myBookName, NULL,NULL);// load title page
   return err;
   
}

- (IBAction) myPerformMiniturize:(id)sender {
   [NSApp performMiniaturize:sender] ;
}

/**
- (IBAction) myShowAll:(id)sender {
 [[NSWorkspace sharedWorkspace] performSelectorOnMainThread:@selector( unhideAllApplications:) withObject:NULL waitUntilDone:NO];
}**/


- (IBAction) myHideOthers:(id)sender {
   [[NSWorkspace sharedWorkspace] performSelectorOnMainThread:@selector(hideOtherApplications:) withObject:NULL waitUntilDone:NO];
}


- (IBAction) myHide:(id)sender {
NSString * source = @"tell application \"System Events\" to set visible of process \"Safari\" to false";
NSAppleScript * script = [[NSAppleScript alloc] initWithSource:source];
[script executeAndReturnError:nil];
}
/*
- (IBAction) myHide {
   NSString * source = @"tell application \"System Events\" to set visible of process \"Safari\" to false";
   NSAppleScript * script = [[NSAppleScript alloc] initWithSource:source];
   [script executeAndReturnError:nil];
   [script release];
}*/

- (IBAction) showAbout:(id)sender {
 
   if (self.window.sheets.count == 0) {
      self.aboutWindowController =
        [[AboutWindowController alloc] initWithWindowNibName:@"About" ];
      DLog(@"AboutWC=%@",self.aboutWindowController);
      [self.window beginSheet:self.aboutWindowController.window completionHandler:^(NSModalResponse returnCode) {
      DLog(@"completionHandler called"); }];
   }
      
}


- (void)showOpenPanelImport:(id)sender
{
   //self.importDgxOp = nil;
   
   NSOpenPanel *importDgxOpenPanel = [NSOpenPanel openPanel];
   DLog(@"importDgxOpenPanel 1=%@",importDgxOpenPanel);
   [importDgxOpenPanel setCanChooseDirectories:NO];
   [importDgxOpenPanel setCanChooseFiles:YES];
   [importDgxOpenPanel setAllowsMultipleSelection:NO];
   [importDgxOpenPanel setMessage:@"Import DGX File"];
   [importDgxOpenPanel setAllowedFileTypes:[NSArray arrayWithObject:@"dgx"]];
   //you can make all non-selectable files be transparent via the delegate - (BOOL)panel:(id)sender shouldEnableURL:(NSURL *)url
   DLog(@"importDgxOpenPanel 2=%@",importDgxOpenPanel);
   DLog(@"myAppController=%@\n****",self);
   /*
    - (void)beginSheetModalForWindow:(NSWindow *)window
    completionHandler:(void (^)(NSInteger result))handler
    Parameters
    window
    The window in which the panel will be presented.
    handler
    The block called after the user dismisses the panel. The argument passed in will be NSFileHandlingPanelOKButton if the user chose the OK button or NSFileHandlingPanelCancelButton if the user chose the Cancel button.

    */
   [importDgxOpenPanel beginSheetModalForWindow:self.window
                     completionHandler:^(NSInteger result) {
                        DLog(@"\n\nOpenPanel dismissed. result=%ld",result);
                         //NSOKButton  = 1,
                         //NSCancelButton  = 0
                        if (result==NSOKButton) {
                           NSURL *selection = importDgxOpenPanel.URLs[0];
                           self.importDgxURL = selection;
                           [[NSNotificationCenter defaultCenter] postNotificationName:ImportDgxFinderPanelDoneNotification object:self userInfo:nil];
                        }
               //[self.window endSheet:self.importDgxOpenPanel returnCode:0] ;
               //         [self.importDgxOpenPanel orderOut:self];
               ///self.importDgxOpenPanel = nil;
                     }];
   
   /*
   [self.window beginSheet:self.importDgxOp completionHandler:^(NSModalResponse returnCode) {
      
      DLog(@"returnCode=%lu",returnCode);
      [self.window endSheet:self.importDgxOp returnCode:0 ] ;
      //[self.window close];
      //myAppController.deleteCategoryController = nil;
      [self.importDgxOp orderOut:self];
   }];*/

}





- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo{
   
}
/*
-(void)openPanelImportDidEnd:(NSOpenPanel*)sheet
            returnCode:(int)returnCode
           contextInfo:(void*)contextInfo {
   //[self setUserDirectoryFromFilename:[sheet filename]];
   DLog(@"sheet.filename=%@",sheet.filename);
} **/

#pragma mark Help Menu Action

/*
- (void) helpHungryMeFileMenuAction:(id)sender {
   
   HelpWindowController *helpWindowController = [[HelpWindowController alloc] initWithWindowNibName:@"Help"];
   [helpWindowController window];
   
}*/




#pragma mark handleImportDgxFinderPanelDone
//NSWindowDidEndSheetNotification
//handleImportDgxFinderPanelDoneNotification

   //-(void)handleNSWindowDidEndSheetNotification:(NSNotification*)note
-(void)handleImportDgxFinderPanelDoneNotification:(NSNotification*)note
{
      // THIS HANDLER USED BY SHEET_FINDER //importDgx
   //ivar has SaveURl now
   //[NSApp stopModal];
   //[NSApp endSheet:self.importDgxOp];
   //NSNumber *numberResultCode = [[note userInfo] objectForKey:@"ResultCode" ];
   if (self.importDgxURL) {
      
      [self importRecipes:self.importDgxURL]; // put up panel at finish of importRecipes:
      self.importDgxURL = nil;
   }else {
      DLog(@"notification was not for OpenPanelImport for DGX import ..............................");
   }
   
}



#pragma mark handleExportUrlFetchDone

-(void)handleExportDgxUrlFetchDoneNotification:(NSNotification*)note
{
   //ivar has SaveURl now
   [NSApp stopModal];
   
   NSNumber *numberResultCode = [[note userInfo] objectForKey:@"ResultCode" ];
   NSInteger returnCode = [numberResultCode integerValue];
   /*
    NSNumber * numberRetCode = [NSNumber numberWithInteger:result];
    NSDictionary *dictionary =
    [NSDictionary dictionaryWithObjects:
    [NSArray arrayWithObjects:numberRetCode,nil ]
    forKeys:[NSArray arrayWithObjects:@"ResultCode",nil ]
    ];
    */
   if (returnCode == NSOKButton) {
      DLog(@"OK Button.");
      [self exportRecipes:[self exportDgxSaveURL]];
   } else
      DLog(@"Cancel Button.");
      
   
   

}

#pragma mark HandleRemoveSearchFieldStringNotification

- (void) handleRemoveSearchFieldStringNotification:(NSNotification*)note {
   
      [[[self.rxFilteredArrayController.searchField cell] cancelButtonCell] performClick:self];
}

/**
#pragma mark handleClearSearchBarNotification

-(void)handleClearSearchBarNotification:(NSNotification*)note
{
   [self.rxFilteredArrayController.searchField setStringValue:@""];
   
}**/


#pragma mark EXPORT DGX

- (IBAction) exportDgxFileMenuAction:(id)sender {
      // called from Menu
      /////
      //    PUT UP DGX Path Input Screen AS A PANELÏ
      /////
   DLog(@"self.window=%@",self.window);
   
      //FIRST GET THE DGX FOLDER FROM NSSavePANEL
   [self fetchDgxSaveUrl];
   
      // Have dgx FileURL Now need to write it
}


- (void) fetchDgxSaveUrl {
   
   self.exportDgxSavePanel = [NSSavePanel savePanel];
   
   [exportDgxSavePanel setTitle:@"Export DGX"];
   
   [exportDgxSavePanel setNameFieldLabel:@"DGX Name"];
   [exportDgxSavePanel setAllowedFileTypes:[NSArray arrayWithObject:@"dgx"]];
   [exportDgxSavePanel setMessage:@"Export: If for iOS, use DG_Recipes_Import.dgx. \nIf absent, the '.dgx' extension is appended."];
   [exportDgxSavePanel setAllowedFileTypes:[NSArray arrayWithObject:@"dgx"]];
   [exportDgxSavePanel setNameFieldStringValue:DG_IOS_DGX_IMPORT_FILENAME_EXT];
   
   /*
    - (void)beginSheetModalForWindow:(NSWindow *)window
    completionHandler:(void (^)(NSInteger result))handler
    Parameters
    window
    The window in which the panel will be presented.
    handler
    The block called after the user dismisses the panel. The argument passed in will be NSFileHandlingPanelOKButton if the user chose the OK button or NSFileHandlingPanelCancelButton if the user chose the Cancel button.
    
    */
   [exportDgxSavePanel beginSheetModalForWindow:self.window
                              completionHandler:^(NSInteger result) {
         DLog(@"\n\nexportDgxSavePanel dismissed. result=%ld",result);
         //NSOKButton  = 1,
         //NSCancelButton  = 0
         if (result==NSOKButton) {
            self.exportDgxSaveURL = exportDgxSavePanel.URL;
           [self exportRecipes:[self exportDgxSaveURL]];
         }// check cancel?
         else {
            DLog(@"ExportDgxSavePanel canceled");
         }
         /*
         NSNumber * numberRetCode = [NSNumber numberWithInteger:result];
         NSDictionary *dictionary =
         [NSDictionary dictionaryWithObjects:
          [NSArray arrayWithObjects:numberRetCode,nil ]
                                     forKeys:[NSArray arrayWithObjects:@"ResultCode",nil ]
          ];
                                 
         
         DLog(@"[NSNotificationCenter defaultCenter]=%@",[NSNotificationCenter defaultCenter]);
         [[NSNotificationCenter defaultCenter] postNotificationName:ExportDgxUrlFetchDoneNotification object:self userInfo:dictionary];
           */
         
         
      }];

   /**
   void (^exportDgxOpHandler)(NSInteger) = ^( NSInteger resultCode )
	{
		@autoreleasepool {
      [self setExportDgxSaveURL:nil];
		if( resultCode )
		{
         [self setExportDgxSaveURL:[exportDgxOp URL]]; // Folder for DGX
                  
      } else {
         DLog(@"OpenPanelExport canceled");
      }
		}
      
      NSNumber * numberRetCode = [NSNumber numberWithInteger:resultCode];
      NSDictionary *dictionary = 
    [NSDictionary dictionaryWithObjects:
            [NSArray arrayWithObjects:numberRetCode,nil ]
                  forKeys:[NSArray arrayWithObjects:@"ResultCode",nil ]
                                  ];

      DLog(@"[NSNotificationCenter defaultCenter]=%@",[NSNotificationCenter defaultCenter]);
      [[NSNotificationCenter defaultCenter] postNotificationName:ExportDgxUrlFetchDoneNotification object:self userInfo:dictionary];
       
	};
   
   [exportDgxOp beginSheetModalForWindow:[self window]
                       completionHandler:exportDgxOpHandler];
    **/
}




- (BOOL) exportRecipes:(NSURL*) dgxURL {
   
   NSFetchRequest *fetchRequest3 = [[NSFetchRequest alloc] init];
   // Edit the entity name as appropriate.
   
   NSEntityDescription *entity3 = [NSEntityDescription entityForName:@"Recipe"	
                                              inManagedObjectContext:[(AppDelegate*)[[NSApplication sharedApplication] delegate] managedObjectContext]];
   [fetchRequest3 setEntity:entity3];
   NSError *error3 = nil;
   NSArray *recipeArray = [[(AppDelegate*)[[NSApplication sharedApplication] delegate] managedObjectContext] executeFetchRequest:fetchRequest3 error:&error3];
   if (error3) {
      DLog(@"iHMdidLaunch:Version Fetch error. Normal until fixed");
   }
   //sortedArray 
   NSArray *sortedArray = [recipeArray sortedArrayUsingSelector:@selector(compareRecipeNames:)];
   NSString *outString = @" ";
   NSString *string;
   int exportedRecipeCount = 0;
   for (Recipe* theRecipe in sortedArray){
      if([[theRecipe recipeID] intValue] == 0){
         string =@"";
         string = [string stringByAppendingFormat:@"%@%@",BEGIN_RECIPE_NAME,theRecipe.name ];
         //NSArray *catsArray = [[theRecipe categories] allObjects];//NSSet
         NSEnumerator *enumerator = [[theRecipe categories] objectEnumerator];
         CategoryRx *aCategory;
         while ((aCategory  = (CategoryRx *) [enumerator nextObject])) {
            if([[aCategory sortIndex] integerValue] != -1 ){
               string = [string stringByAppendingFormat:@"%@ %@",START_CATEGORY_TAG, [[aCategory name]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            }
         }
         /***
         while ((aCategory  = (Category *) [enumerator nextObject])) {
            
            string = [string stringByAppendingFormat:@"%@ %@",START_CATEGORY_TAG, [[aCategory name]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
         }***/
         //string = [string stringByAppendingFormat:@"%@",
         string = [string stringByAppendingFormat:@"%@\n\n%@\n\n%@\n\n%@",END_RECIPE_NAME,theRecipe.ingredients,DIRECTIONS_TAG_STRING ,theRecipe.directions];
         string = [string stringByAppendingFormat:@"\n\n%@\n\n%@\n\n",COMMENTS_TAG_STRING ,[theRecipe.comments stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
         
         outString = [[outString stringByAppendingString:string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
         exportedRecipeCount++;
         //DLog(@"Recipe #%d: outString=\n%@",exportedRecipeCount,outString);
      }
   }
   NSError *errorDGX = nil;
    
   NSString *exportDGX_path ;
#ifndef IHUNGRY_MAC
   // iOS 
   recipesDGX_Filename = [NSString stringWithFormat: @"%@.%@",BASE_RECIPES_FILENAME_EXPORT,@"dgx"];
   documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   documentsDir = [documentPaths objectAtIndex:0];
   exportDGX_path = [documentsDir stringByAppendingPathComponent:recipesDGX_Filename];
#else
   //
   // OS X
   //
   //NSURL* exportDgxURL = [self dgxFileURL];
   // Running on OS X
   //NSURL *exportNameURL = [[self dgxFileURL] URLByDeletingPathExtension];
   exportDGX_path =  [dgxURL path];
   // place log file next to dgx File
   //recipesLogFilename = [exportNameURL URLByAppendingPathExtension:@"log"];

#endif
   
   BOOL bOK = [outString writeToFile:exportDGX_path atomically:YES encoding:
               NSUnicodeStringEncoding error:&errorDGX];
   
   /////
   //    PUT WINDOW TO DISPLAY CONTENTS OF NEWLY CREATED EXPORT DGX FILE
   /////

   self.exportWindowController = [[ExportWindowController alloc] initWithWindowNibName:@"ExportWindowController"];
   DLog(@"exportWindowController=%@",exportWindowController );
   
   if(!bOK){
      // an error occurred
      DLog(@"Error writing DGX file: %@",[errorDGX localizedFailureReason]);
      //[self.exportWindowController setDgxFileURL:nil];
      // DLog(@"exportRecipeViewController=%@",exportWindowController );
      //[self.exportWindowController showAlertFrom:self];
      return NO;
   }
   
   //DLog(@"DGX file written!");
   //[self exportRecipesAlertAction:(int)exportedRecipeCount file:outString error:NO];
   //[self.exportWindowController setDgxFileURL:dgxURL];
   //[self exportRecipesAlertAction:(int)exportedRecipeCount file:@"" error:YES];
   [exportWindowController.window setTitleWithRepresentedFilename:[dgxURL path ] ];
  [exportWindowController setShouldCascadeWindows:YES];
   [exportWindowController.fileNameLabel setStringValue:[dgxURL path ]];
   [exportWindowController.textView insertText:outString];
   
  [self.window addChildWindow:exportWindowController.window ordered:NSWindowAbove];
   /*[self.window beginSheet:exportWindowController.window completionHandler:^(NSModalResponse returnCode) {
   //   DLog(@"returnCode=%ld",returnCode);
      
      
   }];  */


   return YES;
} // end exportRecipes





- (void) showExportRecipeAlertView {
  
}


/*
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
   if (alertView == self.importRxAlertView) {
      DLog(@"importRxAlertView");
   }
   if (alertView == self.exportRxAlertView) {
      DLog(@"exportRxAlertView");
   }
   
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
	
	//DLog(@"actionSheet=%@ actionsheet.name=%@\n actionSheet.retainCount=%d newsAlertView_Info.retainCount=%d",actionSheet,[actionSheet title],[actionSheet retainCount] ,[[self newsAlertView_Info] retainCount]);
   
	///[actionSheet release];
   ///actionSheet = nil;
}
 ***/


#define TOP_IMPORT_MSG  @"\tIf no recipe names are found below in this imported log file, you have not used '[[' to begin the recipe names.\n\tIf one or more recipe name in imported DGX file is missing below, you have not correctly used '[[' to signal the begin of the name for a particular recipe."


- (BOOL) importRecipes:(NSURL *) aDgxFileURL {
   BOOL bRetVal = NO;
   BOOL okLog;
   NSString *outString = [NSString stringWithFormat:@"%@\n\nBegin Recipes Import: %@\n",TOP_IMPORT_MSG,[[NSDate date] description] ];
   NSString *tempFinalImportedRecipeName ;
   int nRecipeWrittenCount = 0, nRecipeCount = 0;
   NSString *finalImportedRecipe = @"No Recipe";   
   NSString *recipesLogFilename;
   NSString *myText;
   NSError *error99 = nil;
   NSError *errorLog=nil;
   NSString *recipesLogFilespec;
   AppDelegate* appDel = (AppDelegate*) [[NSApplication sharedApplication] delegate];
   BOOL isFormatErrorFound = NO;
   BOOL isSaveError = NO;
   NSStringEncoding theEncoding;
/***
#ifndef IHUNGRY_MAC
   /// running  iOS
   recipesLogFilename = [NSString stringWithFormat: @"%@.log",BASE_RECIPES_FILENAME_IMPORT];
   NSArray *documentPaths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   NSString *documentsDir = [documentPaths objectAtIndex:0];
   /////
   //    OPEN LOGFILE in /Documents/DG_Recipes_Import.log
   ////
   recipesLogFilespec = [documentsDir stringByAppendingPathComponent:recipesLogFilename];
#else
   // Running on OS X
   NSURL *importNameURL = [ aDgxFileURL URLByDeletingPathExtension];
   // place log file next to dgx File
   recipesLogFilespec = [[importNameURL URLByAppendingPathExtension:@"log"] path];
   self.importDgxLogFile=recipesLogFilespec;
#endif
 **/
   // Running on OS X
   NSArray *documentPaths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   NSString *documentsDir = [documentPaths objectAtIndex:0];

   NSURL *importNameURL = [ aDgxFileURL URLByDeletingPathExtension];
      //NSURL *importUrlMinusFilename = [importNameURL URLByDeletingLastPathComponent];
   // place log file next to dgx File
   NSString *logFileNameOnly= [importNameURL lastPathComponent];
   recipesLogFilename = [NSString stringWithFormat: @"%@.log",logFileNameOnly
                         ];
   recipesLogFilespec = [documentsDir stringByAppendingPathComponent:recipesLogFilename];
   self.importDgxLogFile=recipesLogFilespec;

   DLog(@"self.importDgxLogFile=%@",self.importDgxLogFile);
   //DLog(@"[aDgxFileURL path] = \n%@",[aDgxFileURL path]);
   theEncoding = 1;
   myText = [NSString stringWithContentsOfFile:[aDgxFileURL path] usedEncoding:&theEncoding  error:&error99];
   //DLog(@"file contents = \n%@",myText);
   if (myText) {
      NSRange rangeNextNameStartTag;
      NSString* myTextLookAhead;
      NSRange rangeNameStartTag = [myText rangeOfString:BEGIN_RECIPE_NAME];//#define BEGIN_RECIPE_NAME @"\[\["
      NSRange rangeNameEndTag,rangeBetweenBrackets;
      NSRange rangeIngredients, rangeDirections, rangeComments, rangeShorter, rangeDirectionsTag, rangeCommentsTag;
      NSRange rangeCategoryTag,rangeNameOnly;
      NSString *recipeNameAndCats, *recipeName,  *recipeIngredients, *recipeComments, *recipeDirections ;
      //NSArray* arrayCategoryNames=nil;
      NSArray *categoryArrayAllCategories;
      BOOL isTagOrderIncorrect,isMissingDirectionsTag,isMissingCommentsTag,isMissingNameBeginTagNext;
      if(rangeNameStartTag.location == NSNotFound){
			outString = [outString stringByAppendingFormat:@"\nThe input file in missing the '[[' tag before the first recipe name."];
      } 
      NSRange rangeFirstCategoryTag = [myText rangeOfString:START_CATEGORY_TAG];
      BOOL areCategoriesFoundInFile = NO;
      if(rangeFirstCategoryTag.location != NSNotFound)
         areCategoriesFoundInFile = YES;
      else{
         outString = [outString stringByAppendingFormat:@"\n ****** ***** If you BELIEVE you are including categories when importing your recipes, be aware that no category marker, double colons '::', ']]' , has been found anywhere in the import file. \nIf you are using some other marker by mistake, these false markers and following category names may appear as part of the recipe name. \nSince the category name have not been recognized, the only way to see such a recipe name is by selecting Browse All."]; 
      }
      
      while (rangeNameStartTag.location != NSNotFound && !isFormatErrorFound && !isSaveError) {
         //DLog(@"At Top Starting Recipe #%d \nmyText = \n_%@_",nRecipeWrittenCount ,myText);
         rangeNameEndTag = [myText rangeOfString:END_RECIPE_NAME];
         //DLog(@"rangeNameEndTag.location=%d",rangeNameEndTag.location);
         if (rangeNameEndTag.location < rangeNameStartTag.location) {
            outString = [outString stringByAppendingFormat:@"\nThe '[[' tag is missing before the current recipe name."];
            isFormatErrorFound = YES;
            //DLog(@"Logfile follows:\n%@",outString);
            continue;
         }
         if (rangeNameEndTag.location  == NSNotFound) {
            outString = [outString stringByAppendingFormat:@"\nThe end of name tag, ']]' , is missing from the final recipe name."];
            isFormatErrorFound = YES;
            //DLog(@"\n\nisFormatErrorFound = YES\n   -----  Logfile follows:\n%@",outString);
            continue;
         }
         int nameEndTagLoc = (int)rangeNameEndTag.location;
         if (nameEndTagLoc >  400 ) { // this compare works
            outString = [outString stringByAppendingFormat:@"\n ****** ***** Check to see if the end of name tag, ']]' , is missing after the current recipe name"];
         }
         rangeBetweenBrackets = NSMakeRange(rangeNameStartTag.location + 2, rangeNameEndTag.location - rangeNameStartTag.location -2);
         // the above range length is correct
         recipeNameAndCats = [[myText substringWithRange:rangeBetweenBrackets] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
         rangeCategoryTag = [recipeNameAndCats rangeOfString:START_CATEGORY_TAG];// Cats within brackets
         /*
          if wrong char used as Cat separator, rangeBetweenBrackets.length is very large -> exception at line below here
          */
         if (rangeCategoryTag.location != NSNotFound) {
            rangeNameOnly = NSMakeRange(0, rangeCategoryTag.location );
            recipeName = [recipeNameAndCats substringWithRange:rangeNameOnly]; // receiver is already trimmmed
            recipeName = [recipeName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];// trim again
         }else{
            recipeName = recipeNameAndCats;// trimmed already
            // location ==12 for 13th character
         }
         tempFinalImportedRecipeName = recipeName;
         //DLog(@"Recipe Name and any Categories:\n_%@_",recipeNameAndCats);
         //DLog(@"trimRecipeName:\n_%@_",recipeName);
         /////// Categories               
         ///rangeCategory = [recipeNameAndCats rangeOfString:START_CATEGORY_TAG];//START_CATEGORY_TAG
         //ok
         NSArray *listItems;
         categoryArrayAllCategories=nil;
         NSArray *categoryArrayWithListFromFile=nil;
         // SEE IF CATS EXIST;
         if (rangeCategoryTag.location != NSNotFound){
            // the first listItem is the RecipeName
            listItems = [recipeNameAndCats componentsSeparatedByString:START_CATEGORY_TAG];
            // get all categories list for this Recipe from the dgx file
            categoryArrayWithListFromFile = [appDel getCategoriesFromList:listItems];
         }
         // code just below altered 2/1/12
         CategoryRx *catBrowseAll = [(AppDelegate*) [[NSApplication sharedApplication] delegate] fetchCategoryBrowseAll];
         if (!categoryArrayWithListFromFile ) { // Array gets BrowseAll Only
            categoryArrayAllCategories = [NSArray arrayWithObject:catBrowseAll];
         } else { // Array gets BrowseAll and all user-entered categories
            NSMutableArray *mutRay = [NSMutableArray arrayWithArray:categoryArrayWithListFromFile];
            [mutRay addObject:catBrowseAll];
            categoryArrayAllCategories = mutRay;
         }
         
         NSAssert(categoryArrayAllCategories, @"Browse All Category at least, was not found!");
         /// NSMutableSet * categoryForRecipeMutSet = 
         ///       [NSMutableSet setWithArray:categoryArrayAllCategories];
         //This set of categories (those not already present) should be added only
         //  after the current Recipe is added to the MOC
         
         /////
         /////// Categories END  ////////////////
         /////
         rangeDirectionsTag = [myText rangeOfString:DIRECTIONS_TAG_STRING];
         rangeCommentsTag = [myText rangeOfString:COMMENTS_TAG_STRING];
         rangeNameStartTag = [myText rangeOfString:BEGIN_RECIPE_NAME]; // look for next recipe
         //// begin
         NSRange rangeLookAhead;
         NSRange rangeNextNameStartTagAdjusted;
         rangeLookAhead = NSMakeRange(rangeNameEndTag.location + 2 , myText.length - (rangeNameEndTag.location + 2 ));
         myTextLookAhead = [myText substringWithRange:rangeLookAhead];
         rangeNextNameStartTag = [myTextLookAhead rangeOfString:BEGIN_RECIPE_NAME];
         if (rangeNextNameStartTag.location == NSNotFound) {
            rangeNextNameStartTagAdjusted = NSMakeRange(NSNotFound, 0);
         } else {
            rangeNextNameStartTagAdjusted = NSMakeRange(rangeNextNameStartTag.location + (rangeNameEndTag.location +2) , rangeNextNameStartTag.length  );
         }
         
         isMissingNameBeginTagNext = (  rangeNextNameStartTag.location == NSNotFound  ) ? YES : NO;
         
         
         isMissingDirectionsTag = (rangeDirectionsTag.location == NSNotFound ||
                                   (!isMissingNameBeginTagNext && rangeDirectionsTag.location != NSNotFound && rangeDirectionsTag.location > rangeNextNameStartTagAdjusted.location)
                                   ) ? YES : NO; 
         
         isMissingCommentsTag = (rangeCommentsTag.location == NSNotFound ||
                                 (!isMissingNameBeginTagNext && rangeCommentsTag.location != NSNotFound && rangeCommentsTag.location > rangeNextNameStartTagAdjusted.location)
                                 
                                 ) ? YES : NO;
         
         isTagOrderIncorrect = (
                                (  (rangeDirectionsTag.location != NSNotFound &&  rangeCommentsTag.location != NSNotFound 
                                    && rangeDirectionsTag.location > rangeCommentsTag.location && isMissingNameBeginTagNext
                                    )
                                 ||
                                 ( !isMissingNameBeginTagNext && rangeDirectionsTag.location < rangeNextNameStartTagAdjusted.location &&
                                  rangeDirectionsTag.location != NSNotFound &&  rangeCommentsTag.location != NSNotFound &&
                                  rangeCommentsTag.location < rangeNextNameStartTagAdjusted.location &&
                                  rangeDirectionsTag.location > rangeCommentsTag.location
                                  )
                                 ) 
                                ) ? YES : NO;
         
         if(isTagOrderIncorrect || isMissingDirectionsTag || isMissingCommentsTag ) { //|| isMissingNameBeginTagNext)
            
            if(isTagOrderIncorrect){
               outString = [outString stringByAppendingFormat:@"\n'Directions@' and 'Comments@' tags out of order for: %@",recipeName];
            }
            if(isMissingDirectionsTag){
               outString = [outString stringByAppendingFormat:@"\n'Directions@' tag is missing for: %@",recipeName];
            }
            if(isMissingCommentsTag){
               outString = [outString stringByAppendingFormat:@"\n'Comments@' tag is missing for: %@",recipeName];
            }
            
            outString = [outString stringByAppendingFormat:@"\n\nPlease edit the %@ file and copy (replace) it again to the device using iTunes File Sharing.",recipesLogFilename];
            
            isFormatErrorFound = YES;
            //DLog(@"Logfile follows:\n%@",outString);
            continue;
         }
         //// end
         
         NSUInteger directionsStart = rangeDirectionsTag.location + [DIRECTIONS_TAG_STRING length];
         if (directionsStart < [myText length] && [myText characterAtIndex:directionsStart] == '.') {
            directionsStart++;
         }
         NSUInteger ingredientsStart = rangeNameEndTag.location + [END_RECIPE_NAME length];
         rangeIngredients = NSMakeRange(ingredientsStart, rangeDirectionsTag.location - ingredientsStart);
         rangeDirections = NSMakeRange(directionsStart, rangeCommentsTag.location - directionsStart);
         
         recipeIngredients = [[myText substringWithRange:rangeIngredients] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ;
         
         recipeDirections = [[myText substringWithRange:rangeDirections] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
         
         // shorten file and search for next Recipe Name
         NSRange rangeAbbrev = NSMakeRange(rangeNameEndTag.location + 2 , [myText length] - (rangeNameEndTag.location + 2));
         myText = [[myText substringWithRange:rangeAbbrev] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ;
         // now look for NEXT recipe name in shortened file
         rangeNameStartTag = [myText rangeOfString:BEGIN_RECIPE_NAME];
         
         // update range for Comments
         rangeCommentsTag = [myText rangeOfString:COMMENTS_TAG_STRING];
         //Comments:  len==9
         NSUInteger commentsStart = rangeCommentsTag.location + [COMMENTS_TAG_STRING length];
         if (commentsStart < [myText length] && [myText characterAtIndex:commentsStart] == '.') {
            commentsStart++;
         }
         if (rangeNameStartTag.location == NSNotFound) { // if final recipe in file
            rangeComments = NSMakeRange(commentsStart, [myText length] - commentsStart);//
         }else{
            rangeComments = NSMakeRange(commentsStart, rangeNameStartTag.location - commentsStart);
         }
         
         recipeComments = [[myText substringWithRange:rangeComments]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
         //DLog(@"comments=\n%@",recipeComments); 
         
         if (rangeNameStartTag.location != NSNotFound){ // if this is not that final Rx
            //shorten myText by length of current top recipe
            rangeShorter = NSMakeRange(rangeComments.location + rangeComments.length - 1 , [myText length] - (rangeComments.location + rangeComments.length ) + 1 );
            myText = [[myText substringWithRange:rangeShorter] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            rangeNameStartTag = [myText rangeOfString:BEGIN_RECIPE_NAME];// reset range for New shorter myText
         }
         
         nRecipeCount++;
         
         /*** check if recipe already present ***/
         
         NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];//autorelease add 10/12/11         // Edit the entity name as appropriate.
         NSEntityDescription *entityRx = [NSEntityDescription entityForName:@"Recipe"	
                                                     inManagedObjectContext:[appDel managedObjectContext]];
         [fetchRequest setEntity:entityRx];
         
         NSString *attributeName = @"name";
         
         NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                   @"%K LIKE [cd] %@",attributeName, recipeName ];
         [fetchRequest setPredicate:predicate];
         NSError *error = nil;
         
         NSArray *rxArray = [[appDel managedObjectContext] executeFetchRequest:fetchRequest error:&error]; 
         if(error){
            DLog(@"Error fetching recipe");
         }
         
         if([rxArray count] == 0){ // Rx not yet present. Go ahead and insert new Rx
            // Now insert RecipeName, I,D and C into DB
            NSManagedObject *newManagedObject = 
            [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" 
                                          inManagedObjectContext:[appDel managedObjectContext]]; //INSERT MO
            [newManagedObject setValue:recipeName forKey:@"name"];
            [newManagedObject setValue:recipeIngredients forKey:@"ingredients"];
            [newManagedObject setValue:recipeDirections forKey:@"directions"];
            [newManagedObject setValue:recipeComments forKey:@"comments"];
            
            Recipe* theRecipe = (Recipe *) newManagedObject;
            //addedRecipeSet 
            if (categoryArrayAllCategories) {
               [theRecipe addCategories:[NSSet setWithArray:categoryArrayAllCategories]];
            }            
            
            for(CategoryRx *categ in categoryArrayAllCategories){
               [categ addRecipesObject:theRecipe];
            }
            
            outString = [outString stringByAppendingFormat:@"\nAbout to save recipe:%@",recipeName];
            
            NSError *error91 = nil;
            if (![[appDel managedObjectContext] save:&error91]) {
               outString = [outString stringByAppendingFormat:@"\nTerminating.\n Could not save recipe #%d :\n'%@'\n to database.",nRecipeCount,recipeName];
               [[appDel managedObjectContext] deleteObject:newManagedObject ];///check uncommented 12/5/11
               // Update to handle the error appropriately.
               NSInteger nErrorCode = [error91 code];
               if(nErrorCode == 1660)
                  outString = [outString stringByAppendingFormat:@"\nThe Recipe Name exceeds the maximum length of %d characters.",MAX_RECIPE_NAME_LENGTH];
               //DLog(@"Perhaps Recipe Name Length:Unresolved error %@, %@", error91, [error91 userInfo]);
               isSaveError = YES;
            }else {
               nRecipeWrittenCount++;
               finalImportedRecipe = tempFinalImportedRecipeName;
               outString = [outString stringByAppendingFormat:@"\nDid save recipe #%d :\n'%@'\nto database.\n",nRecipeCount,recipeName];
            }
         }else{ // don't try to put in DB, Log it.
            
            outString = [outString stringByAppendingFormat:@"\nDid not save recipe #%d :\n'%@'\nto database. It was already present.\n",nRecipeCount,recipeName];
         }
         /*** end check for recipe existence ***/
         
      } //end while loop
      
      okLog = [outString writeToFile: recipesLogFilespec atomically:YES
                            encoding:NSUTF8StringEncoding error:&errorLog];
      if (!okLog) {
         // an error occurred
         DLog(@"Outstring:Error writing file at \n%@.\nError=%@",
              recipesLogFilespec, [errorLog localizedFailureReason]);
      }
      // Show Alert notifying of recipe additions.
   } else {
      DLog(@"error reading recipesFile =\n%@",error99);
   }
   myText = nil;
   
   /*****************/
   
   NSString *informString = [NSString stringWithFormat:@"%d recipe(s) inserted into DB.",nRecipeWrittenCount];
   NSAlert *alertLogFile = [[NSAlert alloc] init];
   [alertLogFile setAlertStyle:NSInformationalAlertStyle];
   [alertLogFile setMessageText:@"Import Recipe Info"];
   [alertLogFile setInformativeText:informString];
   
   [alertLogFile addButtonWithTitle:@"OK"];
   
   [alertLogFile addButtonWithTitle:@"Show Import Log"];
   
   NSButton *button = [[alertLogFile buttons] objectAtIndex:0];
   //NSButton *button2 = [[alertLogFile buttons] objectAtIndex:1];
   
   
   [alertLogFile beginSheetModalForWindow:[self window]
                    modalDelegate:self
                    didEndSelector:@selector(importRecipeAlertDidEnd:returnCode:
                                            contextInfo:)
                       contextInfo:nil];
   [[button window] makeFirstResponder:nil];
  
   /* Any or all of the arguments can be nil or NULL.  Default usage:
    [SSAlert runModalBadgeCritical:NO
    bigTopText:nil
    smallBottomText:nil
    defaultButtonTitle:nil
    leftButtonTitle:nil
    middleButtonTitle:nil
    helpButtonAnchor:nil
    checkboxTitle:nil
    checkboxState:NULL
    alertReturn:NULL ];
    */
   
/* commented 10/22/14
   if(nRecipeWrittenCount > 0){
      [ appDelegate updateGlobalCategoryArray];//namely [appDel recipeArray]
      bRetVal = YES;
   }
*/   
   [[self tableViewCat] reloadData];
   [[self tableViewRx] reloadData];
   [[self rxFilteredArrayController] rearrangeObjects];
   
   return bRetVal;
   
}// end importRecipes


- (void)importRecipeAlertDidEnd:(NSAlert *)alert
                     returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
   
   DLog(@"FileOpenPanel Closed. clicked %d button\n", returnCode);// Show Import Log Button == 1001 OK == 1000?
   
   [[alert window] orderOut:self];
   //[alert release];
   
   if (returnCode != NSAlertFirstButtonReturn) {//Show Import Log Button == 1001
      /////
      //    PUT WINDOW TO DISPLAY LOGFILE CONTENTS  - because User touched "showImportLogFile" button
      /////
      self.importWindowController = [[ImportWindowController alloc] initWithWindowNibName:@"ImportWindowController"];
      DLog(@"self.importWindowController=%@",self.importWindowController );
      self.importWindowController.myAppController = self;
      [self.importWindowController.window setTitleWithRepresentedFilename:@"DGX File Import" ];
      AppDelegate* appDel = (AppDelegate*)[NSApp delegate ];
      [appDel.myAppController updateSmallPanelFont];
      DLog(@"appDel.myAppController.smallPanelFont=%@",appDel.myAppController.smallPanelFont);
      [[self.importWindowController textView] setFont:appDel.myAppController.smallPanelFont];
      DLog(@"self.importWindowController.textView.font=%@",self.importWindowController.textView.font);
      
      //[[self textView] setFont:self.myAppController.smallPanelFont];
      NSError *error = nil;
      NSString *theText = [NSString stringWithContentsOfFile:self.importDgxLogFile  encoding:NSASCIIStringEncoding error:&error];
     
      [self.importWindowController.textView insertText:theText];
      [self.importWindowController.fileNameLabel setStringValue:[self.importDgxLogFile copy]];
      //[importWindowController.window orderFront:self];
      [self.window beginSheet:self.importWindowController.window completionHandler:^(NSModalResponse returnCode) {
         DLog(@"returnCode=%ld",returnCode);
      
      }];
   }
   
   
}


- (void)dealloc
{
   // [mainPreferenceController release];
   /**
    NSEnumerator *enumerator = [[self list_of_editWindow_cntrlrs] objectEnumerator];
    for (EditWindowController* editWindowController in [enumerator allObjects] ) { 
    [editWindowController release];
    }
    **/
   
   NSNotificationCenter *center;
   center = [NSNotificationCenter defaultCenter];
   [center removeObserver: self] ;
   
   
   
   
   
   ///[dgxPathWindowController release];
   
      //[tagLastTableSelected release];
      //[list_of_editWindow_cntrlrs release];
   
}



@end
