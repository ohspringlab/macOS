//
//  DeleteRecipeController.m
//  iHungryMac386
//

//

#import "DeleteRecipeController.h"
#import "MyAppController.h"
#import "AppDelegate.h"
#import "RecipeDefines.h"
#import "MyCatArrayController.h"
#import "CategoryRx.h"
#import "RxFilteredArrayController.h"
#import "Constants.h"
#import "MyRxDoneButton.h" 
#import "MyRxCancelButton.h"
#import "MyPanel.h"
#import "Recipe.h"   

@implementation DeleteRecipeController
//@synthesize savedCategorySeletionIndex;
@synthesize  textViewIngredients,textViewDirections,textViewComments;
@synthesize textFieldRecipeName;
@synthesize rxCatTableView;
@synthesize  savedRecipeName;
@synthesize cancelled;
@synthesize myAppController;
@synthesize savedRecipeIngredients,savedRecipeDirections,savedRecipeComments;
@synthesize  categoryArrayWithoutBrowseAll;
//@synthesize rxFilteredArrayController;
@synthesize recipeArrayController;
@synthesize selectedCategoryIndexInMain;
@synthesize tabView;
@synthesize doneButton,cancelButton;
@synthesize smallPanelFont;
@synthesize deleteRecipeTextField;
@synthesize selectedRecipe;
//@synthesize myCategoryArrayController;
@synthesize categoryArrayController;
@synthesize textFieldRecipeNameAbove;

@synthesize  arrayTheRecipeCats;
@synthesize arrayTheRecipe;
@synthesize appDelegate;
@synthesize categorySortDescriptorsNameOnly;
// ------------------------------------------------------------------------------
//	windowNibName
// -------------------------------------------------------------------------------
- (NSArray*) categorySortDescriptorsNameOnly {
   if (categorySortDescriptorsNameOnly) {
      return categorySortDescriptorsNameOnly;
   }
   categorySortDescriptorsNameOnly =
   [NSArray arrayWithObject:
      [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES
                                   selector:@selector(localizedCaseInsensitiveCompare:)]];
   return categorySortDescriptorsNameOnly  ;
}


-(NSArray *)arrayTheRecipe{
   if (!arrayTheRecipe) {
      arrayTheRecipe = [NSArray arrayWithObject: self.selectedRecipe];
   }
   return arrayTheRecipe;
}

-(NSArray *)categoryArrayMinusBrowseAll{
 
   NSMutableArray *mutRay =  
    [NSMutableArray arrayWithArray:[[[self myAppController] appDelegate] categoryArray ]];
                               
     NSArray* nonMutArray = [NSArray arrayWithArray:mutRay];
     return nonMutArray;
}


/*
- (NSString *)windowNibName
{
	return @"DeleteRecipe";
}
*/

- (NSArray * ) getRxCategoriesArrayMinusBA:(Recipe *)theRecipe {
      // extract all categories except 'Browse All' from this recipe
   NSSortDescriptor *descriptor = [(AppDelegate *)[NSApp delegate] sortDescriptorNameAscInsen];
   NSArray *descriptors = [NSArray arrayWithObject:descriptor];
   NSArray *arrayRxCategories = [[theRecipe categories] sortedArrayUsingDescriptors:descriptors];
      //DLog(@"[arrayRxCategories count]=%d",[arrayRxCategories count]);
   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sortIndex != -1"];
   NSArray *minusBrowseAllArray = [arrayRxCategories filteredArrayUsingPredicate:predicate];
      //DLog(@"[minusBrowseAllArray count]=%d",[minusBrowseAllArray count]);
      //return array with all of Recipe's categories except 'Browse All'
   return minusBrowseAllArray;
}




/*
- (id)initWithWindowNibName:(NSString *)windowNibName
{
    if (self = [super initWithWindowNibName:windowNibName ]) {
    // Custom initialization
       //get a copy for this view
      // DLog(@"");
     }
   return self;
 } */

#pragma mark awakeFromNib

- (void)awakeFromNib {
   [super awakeFromNib];// must be called, may be anytime in this method
   self.selectedCategoryIndexInMain = self.myAppController.myCatArrayController.selectionIndex;
   NSArray *catArray = [self getRxCategoriesArrayMinusBA:self.selectedRecipe];//from theRecipe displayed
   
   [self setArrayTheRecipeCats:catArray];
   
   NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
   
   [center addObserver: self
              selector: @selector(handleSelectTabItemToShowViewNotification:)
                  name:SelectTabItemToShowViewNotification //ExportDgxFolderFetchDoneNotification  //window deleted or made non-key
                object:myPanel];// delivered if from this IBOutlet
   
   
}


- (void) windowWillLoad{ // NSPanel is subclass of NSWindow
   [super windowWillLoad];
   
}


- (void)windowDidLoad
{
      //DLog(@"\n****************DeleteRecipeController=%@",self);
   [super windowDidLoad]; // com 1/30/13
   [self.window disableKeyEquivalentForDefaultButtonCell];
   [cancelButton setKeyEquivalent:@""];
   [doneButton setKeyEquivalent:@""];
   self.window.initialFirstResponder = self.tabView;
  
   AppDelegate *appDel =  (AppDelegate *)[NSApp  delegate];
   self.myAppController = [appDel  myAppController];
   [self.myAppController  updateSmallPanelFont];
   
    //set Category TableView according to the Recipe NSSet
   [self fillFieldsAndSetFontsForRecipe:self.selectedRecipe];
      //[self checkItemsInTableViewForRecipe:self.recipe];
} // windowDidLoad

#pragma mark SheetDidEnd: Delegate Method

- (void) sheetDidEnd:(NSWindow *) sheet returnCode:(int)returnCode contextInfo:(void *) contextInfo {
   
   DLog(@"contextInfo=%@",contextInfo);
   
}

#pragma mark Utility Methods

- (void) fillFieldsAndSetFontsForRecipe:(Recipe*)theRecipe {
   
      // DLog(@"[self textFieldRecipeNameAbove]=%@",self.textFieldRecipeNameAbove);
      //DLog(@"[self.textFieldRecipeNameAbove stringValue]=%@",[self.textFieldRecipeNameAbove stringValue]);
   
   [[self textFieldRecipeNameAbove] setStringValue:[theRecipe name]];
   [[self textFieldRecipeName] setStringValue:[theRecipe name]];
   
   if ([theRecipe ingredients]) {
      [[self textViewIngredients] setString:[theRecipe ingredients]];
   }
   if ([theRecipe directions]) {
      [[self textViewDirections] setString:[theRecipe directions]];
   }
   if ([theRecipe comments]) {
      [[self textViewComments] setString:[theRecipe comments]];
   }
   
   [[self textViewIngredients] setNeedsDisplay:YES];
   [[self textViewDirections] setNeedsDisplay:YES];
   [[self textViewComments] setNeedsDisplay:YES];
   
//   [[self textViewIngredients] displayIfNeeded];
//   [[self rxCatTableView] deselectAll:self];
   
   [[self textViewIngredients] setFont:[myAppController.appDelegate tableFont]];
   [[self textViewDirections] setFont:[myAppController.appDelegate tableFont]];
   [[self textViewComments] setFont:[myAppController.appDelegate tableFont]];
   
   [self.textFieldRecipeNameAbove setFont:self.myAppController.smallPanelFont];
   [[self textFieldRecipeName] setFont:[self.myAppController smallPanelFont]];
   
      //[[self textFieldRecipeName2] setFont:[self.myAppController smallPanelFont]];
   
   [[self rxCatTableView] setFont:[self.myAppController smallPanelFont]];
   
   [[self tabView] setFont:self.myAppController.smallPanelFont];
   [[self deleteRecipeTextField] setFont:self.myAppController.smallPanelFont];
   [self.cancelButton.cell setFont:self.myAppController.smallPanelFont  ];
   [self.doneButton.cell setFont:self.myAppController.smallPanelFont ];
   
   [[self tabView] selectLastTabViewItem:self];//name should show next time
   [[self tabView] selectFirstTabViewItem:self];//name
}


/*

- (NSMutableSet *) getMutSetOfSelectedCategories {   // Includes BrowseAll
   
   NSArray *selectedArray = [[myCategoryArrayController arrangedObjects]   valueForKey:@"selected"];
   NSArray *catArray = [[myAppController appDelegate] categoryArray];
      //NSArray *catArrayMinusBrowseAll = [catArray filteredArrayUsingPredicate:
      //                                [[myAppController appDelegate] predicateAllButBrowseAll]];
   NSEnumerator *enumerator = [catArray objectEnumerator]; // include "Browse All"
      //[catArrayMinusBrowseAll objectEnumerator]; //[[myCategoryArrayController arrangedObjects] objectEnumerator];
   CategoryRx * aCategory;
   NSMutableSet *mutSet = [NSMutableSet setWithCapacity:[ [myCategoryArrayController arrangedObjects] count]];
   int j=0;
   while (aCategory = [enumerator nextObject]) {
      if((BOOL) [[selectedArray objectAtIndex:j++] intValue]){
         [mutSet addObject:aCategory];
      }
   }
   //get Browse_All category
   NSArray *rayWithBrowseAll = [[[myAppController appDelegate] categoryArray] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"sortIndex == -1"]];
   [mutSet addObject:[rayWithBrowseAll objectAtIndex:0]];
   
   return mutSet;
   
}
*/
// -------------------------------------------------------------------------------
//	done:sender
// -------------------------------------------------------------------------------
- (IBAction)done:(id)sender
{
      //[NSApplication endSheet:self.window returnCode:0 ] ;
      // DLog(@"",)
      // GET THE CURRENTLY SELECTED RECIPE
      //Recipe *theRecipe = [[[myAppController rxFilteredArrayController] arrangedObjects]  objectAtIndex: [[myAppController rxFilteredArrayController] selectionIndex] ];
    
   NSManagedObjectContext *managedObjectContext =
   [[myAppController  appDelegate] managedObjectContext];
   
   [managedObjectContext deleteObject:[self selectedRecipe]];
   DLog(@"Deleting recipe=%@",self.selectedRecipe);
   NSError *error = nil;
	if (![managedObjectContext save:&error]) { // context is from AppDel  // DELETE
		DLog(@"deleteRecipeControler:Unresolved error %@, %@", error, [error userInfo]);
		exit(-421);  // Fail
	}else{
      NSInteger savedIndex = [[myAppController tableViewCat] selectedRow];
     // BOOL aBool =[self.myAppController.myCatArrayController canSelectNext];
      if ([self.myAppController.myCatArrayController canSelectNext] ) {
         [self.myAppController.myCatArrayController  selectNext:self];
         [[self.myAppController myCatArrayController] selectPrevious:self];
      } else {
         [[self.myAppController myCatArrayController] selectPrevious:self];
         [self.myAppController.myCatArrayController  selectNext:self];
      }
      NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:savedIndex];
      [[myAppController tableViewCat] selectRowIndexes:indexSet byExtendingSelection:NO];
	}
   [self.myAppController.myCatArrayController setSelectionIndex:0];
   
   [self.appDelegate.myAppController.window endSheet:self.window returnCode:0 ] ;
   [self.window orderOut:self];
    return;
} // end  - (IBAction)done:(id)sender



// -------------------------------------------------------------------------------
//	cancel:sender
// -------------------------------------------------------------------------------
- (IBAction)cancel:(id)sender
{
	[[self tabView] selectFirstTabViewItem:self];//name should show next time
   
   
   //[myAppController.window endSheet:self.window returnCode:0 ] ;
   [self.appDelegate.myAppController.window endSheet:self.window returnCode:0 ] ;
   [self.window orderOut:self];
}

// -------------------------------------------------------------------------------
//	wasCancelled
// -------------------------------------------------------------------------------
- (BOOL)wasCancelled
{
	return cancelled;
}
#pragma Data

// getting Values
// Here are some table data source methods assuming you have a 'myRows' array filled with objects with a 'booleanAttribute' property.

/***
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
   NSArray *ray = [myAppController appDelegate] cate
   BOOL value = [[myRows objectAtIndex:row] booleanAttribute];
   return [NSNumber numberWithInteger:(value ? NSOnState : NSOffState)];
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)value forTableColumn:    (NSTableColumn *)column row:(NSInteger)row {          
   [[myRows objectAtIndex:row] setBooleanAttribute:[value booleanValue]];
}
***/

- (void) recipeNameAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo{
   
   [[self tabView] selectFirstTabViewItem:self];//name should show next time
   //if (returnCode == 0) {
       //[[self window]  orderOut:self];
   //}
   //send orderOut: (NSWindow) to the window object obtained by sending window to the alert argument
   [[alert window] orderOut:self];
   return;
}

#pragma mark NSWindowDelegate

-(BOOL)canBecomeKeyWindow
{
   return YES;
}


#pragma mark NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)aNotification{
   
   DLog(@"aNotification=%@",aNotification);
   
}


#pragma mark   handleSelectTabItemToShowViewNotification

- (void) handleSelectTabItemToShowViewNotification:(NSNotification * ) note{
   NSTabViewItem * tabViewItem = [note.userInfo objectForKey:@"TabViewItem" ];
   [self.tabView selectTabViewItem:tabViewItem];
}


#pragma mark NSTabViewDelegate

   // Originally in EditRecipeController

- (void)tabView:(NSTabView *)aTabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem{
      //DLog(@"tabViewItem.identifier=%@",tabViewItem.identifier);
   
   NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
   [f setNumberStyle:NSNumberFormatterDecimalStyle ];
   NSNumber *tabNumber =
   [f numberFromString:tabViewItem.identifier];
   
   switch (tabNumber.integerValue) {
      case 1:
         
         [self.tabView setNextKeyView:cancelButton];
         [cancelButton setNextKeyView:doneButton ];
         [doneButton setNextKeyView:self.tabView ];
         break;
      case 2:
         [self.tabView setNextKeyView:textViewIngredients];
         [textViewIngredients setNextKeyView:cancelButton ];
         [cancelButton setNextKeyView:doneButton ];
         [doneButton setNextKeyView:self.tabView ];
         [textViewIngredients setSelectedRange:NSMakeRange(0,0)];
         break;
      case 3:
         [self.tabView setNextKeyView:textViewDirections];
         [textViewDirections setNextKeyView:cancelButton ];
         [cancelButton setNextKeyView:doneButton ];
         [doneButton setNextKeyView:self.tabView ];
         [textViewDirections setSelectedRange:NSMakeRange(0,0)];
         break;
      case 4:
         [self.tabView setNextKeyView:textViewComments];
         [textViewComments setNextKeyView:cancelButton ];
         [cancelButton setNextKeyView:doneButton ];
         [doneButton setNextKeyView:self.tabView ];
         [textViewComments setSelectedRange:NSMakeRange(0,0)];
         break;
      case 5: //Categories
         [self.tabView setNextKeyView:cancelButton];
            //[rxCatTableView setNextKeyView:cancelButton ];
         [cancelButton setNextKeyView:doneButton ];
         [doneButton setNextKeyView:self.tabView ];
         break;
      default:
         DLog(@"switch value error");
         break;
         
   }// end switch
   
}



- (BOOL)tabView:(NSTabView *)aTabView shouldSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
   return YES;
}
   

#pragma mark NSTextViewDelegate

- (BOOL)textView:(NSTextView *)aTextView doCommandBySelector:(SEL)aSelector {
   if (aSelector == @selector(insertTab:)) {
      [[aTextView window] selectNextKeyView:nil];
      return YES;
   }
   
   return NO;
}



@end