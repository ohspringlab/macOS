//
//  AddRecipeController.m
//  iHungryMac386
//

//

#import "AddRecipeController.h"
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
#import "NSArrayController+NameCheck.h"

@implementation AddRecipeController

@synthesize textFieldSelectedCategoryName;
@synthesize  textViewIngredients,textViewDirections,textViewComments;
@synthesize textFieldRecipeName;
@synthesize rxCatTableView;
@synthesize  savedRecipeName;
@synthesize cancelled;

@synthesize savedRecipeIngredients,savedRecipeDirections,savedRecipeComments;
@synthesize  categoryArrayWithoutBrowseAll;
@synthesize textFieldRecipeNameAbove;
   //@synthesize  myCatArrayController;
   //////@synthesize rxFilteredArrayController;
//@synthesize theNewCategoryNameBox;
@synthesize selectedCategoryIndexInMain;
@synthesize  textFieldNewCategoryName;
@synthesize tabView;
   //@synthesize textFieldFont,textViewFont;
@synthesize doneButton,cancelButton;
@synthesize rxNameLengthWarningTextField;
@synthesize smallPanelFont;
@synthesize editRecipeTextField;
@synthesize doEnableDoneButton,isNameLengthOK,isNameUnique;
@synthesize appDelegate;
@synthesize categoryArrayController ;
@synthesize filterRxArrayController;
@synthesize selectedCategoryInMain;

@synthesize myAppController;
@synthesize myAppControllerParent;
// ------------------------------------------------------------------------------
//	windowNibName
// -------------------------------------------------------------------------------

-(NSArray *)categoryArrayMinusBrowseAll{
 
   NSMutableArray *mutRay =  
    [NSMutableArray arrayWithArray:[[[self myAppController] myCatArrayController] arrangedObjects ]];
                               
     NSArray* nonMutArray = [NSArray arrayWithArray:mutRay];
     return nonMutArray;
}


- (NSString *)windowNibName
{
	return @"AddRecipe";
}

- (AddRecipeController * )initWithWindowNibName:(NSString*)windowNibName {
   
   if (self = [super initWithWindowNibName:windowNibName ]) {
         // Custom initialization
         //get a copy for this view
         // DLog(@"");
   }
   return self;
}



- (void)awakeFromNib {
   //DLog(@"myCatArrayController=%@",myAppController.myCatArrayController);
   [super awakeFromNib];// must be called, may be anytime in this method
   
   NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
 
   [center addObserver: self
            selector: @selector(handleSelectTabItemToShowViewNotification:)
                  name:SelectTabItemToShowViewNotification //ExportDgxFolderFetchDoneNotification  //window deleted or made non-key
                        object:myPanel];// delivered if from this IBOutlet
  
}

#pragma mark NSWindowController overrides

- (void) windowWillLoad{ // NSPanel is subclass of NSWindow
   [super windowWillLoad];
   
}


- (void)windowDidLoad
{
      //DLog(@"\n****************AddRecipeController=%@",self);
   [super windowDidLoad];
   NSPredicate *predicate;
   NSPredicate *predicateSel = [NSPredicate predicateWithFormat:@"self.selected=YES"];

   NSMutableArray *compoundPredicateArray = [NSMutableArray arrayWithObject:predicateSel];
   NSPredicate* predicateSort = [NSPredicate predicateWithFormat:@" SELF.sortIndex != -1"];
   [compoundPredicateArray addObject:predicateSort];
   predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
             compoundPredicateArray ];
   NSArray* oneRxRay = [self.myAppController.myCatArrayController.arrangedObjects filteredArrayUsingPredicate:predicate] ;
   if(oneRxRay.count > 0)
      [self.filterRxArrayController addObject:(CategoryRx*)[oneRxRay objectAtIndex:0] ];
   self.appDelegate = (AppDelegate*)[NSApp delegate];
   DLog(@"self.myAppController.appDelegate.managedObjectContext=%@",self.myAppController.appDelegate.managedObjectContext );
   DLog(@"[self.myAppController.myCatArrayController.arrangedObjects valueForKey:@'name']=%@",[self.myAppController.myCatArrayController.arrangedObjects valueForKey:@"name"]);
   [self clearAllCategorySelections];

   [[self tabView] selectLastTabViewItem:self];
   [[self tabView] selectFirstTabViewItem:self];

   [self.window disableKeyEquivalentForDefaultButtonCell];
   [cancelButton setKeyEquivalent:@""];
   [doneButton setKeyEquivalent:@""];
   [self.myAppController updateSmallPanelFont];
   [self fillFieldsAndSetFonts];
   [self updateRecipeNameLengthWarning];

   [self checkSelectedCategoryForTable];//(self.selectedCategoryIndexInMain -1)
   
   NSUInteger selectedCategoryRow = [[self.categoryArrayController arrangedObjects] indexOfObject:self.selectedCategoryInMain];
   if (selectedCategoryRow != NSNotFound && selectedCategoryRow < [[self.categoryArrayController arrangedObjects] count]) {
      [self.rxCatTableView scrollRowToVisible:selectedCategoryRow];
   }

   [self.tabView setNextKeyView:textFieldRecipeName];
   [self.textFieldRecipeName setNextKeyView:cancelButton];
   [cancelButton setNextKeyView:self.tabView ];

   [[self textFieldRecipeName] setStringValue:@""];
   textFieldRecipeNameAbove.stringValue = @"***  Recipe Name Required  ***";
   
   if(self.myAppControllerParent.myCatArrayController.selectionIndex != 0 ){
      [textFieldSelectedCategoryName setStringValue:self.selectedCategoryInMain.name];
      [textFieldSelectedCategoryName setFont:self.myAppController.smallPanelFont];
   } else
      textFieldSelectedCategoryName.stringValue = @"";

   self.window.initialFirstResponder = textFieldRecipeName;
   DLog(@"self.appDelegate.managedObjectContext=%@",self.appDelegate.managedObjectContext );
} // windowDidLoad


- (IBAction)scrollToShowFirstSelection:(id)sender {
   NSPredicate *predicateSortAndRemoveBrowseAll =
   [NSPredicate predicateWithFormat:@"sortIndex > -1"];
   NSArray *allCategoryArrayMinusBA = [[myAppControllerParent.myCatArrayController arrangedObjects] filteredArrayUsingPredicate:predicateSortAndRemoveBrowseAll];
   NSEnumerator *enumerator;
   enumerator = [allCategoryArrayMinusBA objectEnumerator];
   CategoryRx *aCategory;
   NSUInteger index = 0;
   while (aCategory = [enumerator nextObject]) {
      if (aCategory.selected) {
         [self.rxCatTableView scrollRowToVisible:index];
         return;
      }
      index++;
   }
   /*if ((self.selectedCategoryIndexInMain > 0)) {
      [self.rxCatTableView scrollRowToVisible:(self.selectedCategoryIndexInMain - 1)];
   }*/
}

/*
#pragma mark AddRecipeFrom:

- (NSString*) addRecipeFrom: (MyAppController *)sender
{
    NSArray *selectedObjects = [self.myAppController.myCatArrayController selectedObjects];
    CategoryRx *theCategory = [selectedObjects objectAtIndex:0];
    //NSWindow *window = [self window];
 
    [NSApp beginSheet:self.window modalForWindow:[sender window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
    [NSApp runModalForWindow:[self window]];
    // sheet is up here...
    [NSApp endSheet:self.window];
    [self.window orderOut:self];
    
    return theCategory.name ;
} */

#pragma mark Utility Methods

- ( void) fillFieldsAndSetFonts {
   
      // Fill TabView with the Recipe data
   [[self textFieldRecipeName] setStringValue:@""];
      
   [[self textViewIngredients] setString:@""];
   [[self textViewDirections] setString :@""];
   [[self textViewComments] setString:@""];
   
   //
   [[self textViewIngredients] setFont:appDelegate.tableFont];
   [[self textViewDirections] setFont:appDelegate.tableFont];
   [[self textViewComments] setFont:appDelegate.tableFont];
   
   [[self tabView] selectLastTabViewItem:self];//name should show next time
   [[self tabView] selectFirstTabViewItem:self];//name
   
}

- (void) checkSelectedCategoryForTable{ // also clear newCatName
      /////
      // THE RX'S CATEGORIES COME FROM  categoryArrryController
      ////
      //
   [self clearAllCategorySelections];
   if (self.selectedCategoryInMain == nil || self.selectedCategoryIndexInMain == 0) {
      return;
   }
   
   NSArray *allCategoryArrayMinusBA = [self.categoryArrayController arrangedObjects];
   DLog(@"allCategoryArrayMinusBA=%@",[allCategoryArrayMinusBA valueForKey:@"name"] );
   DLog(@"self.selectedCategoryIndexInMain=%lu",self.selectedCategoryIndexInMain );

   NSUInteger categoryIndex = [allCategoryArrayMinusBA indexOfObject:self.selectedCategoryInMain];
   if (categoryIndex == NSNotFound) {
      NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"name == %@", self.selectedCategoryInMain.name];
      NSArray *matchingCategories = [allCategoryArrayMinusBA filteredArrayUsingPredicate:namePredicate];
      if ([matchingCategories count] > 0) {
         [[matchingCategories objectAtIndex:0] setSelected:YES];
      }
   } else if (categoryIndex < [allCategoryArrayMinusBA count]) {
      [[allCategoryArrayMinusBA objectAtIndex:categoryIndex] setSelected:YES];
   }
   /*
   NSEnumerator *enumerator;
   enumerator = [allCategoryArrayMinusBA objectEnumerator];
   CategoryRx *aCategory;
   NSUInteger i = 0;
   while (aCategory = [enumerator nextObject]) {
      aCategory.selected =
         (i++ == self.selectedCategoryIndexInMain) ? YES : NO;
   } */
   
   [self.textFieldNewCategoryName setStringValue:@""];
}

- (void)clearAllCategorySelections{
   
   NSPredicate *predicateSortAndRemoveBrowseAll =
   [NSPredicate predicateWithFormat:@"sortIndex > -1"];
   NSArray *allCategoryArrayMinusBA = [[myAppControllerParent.myCatArrayController arrangedObjects] filteredArrayUsingPredicate:predicateSortAndRemoveBrowseAll];
   NSEnumerator *enumerator;
   enumerator = [allCategoryArrayMinusBA objectEnumerator];
   CategoryRx *aCategory;
   //NSUInteger i = 0;
   while (aCategory = [enumerator nextObject]) {
      [aCategory setSelected:NO];
   }
}


- (BOOL) updateRecipeNameLengthWarning {
   
   NSString* nameTrimmed = [[ self.textFieldRecipeName stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   //DLog(@"nameTrimmed=%@",nameTrimmed);
   BOOL isGoodLength;
   if (([nameTrimmed length] >= MIN_RECIPE_NAME_LENGTH) &&
       ([nameTrimmed length] <= MAX_RECIPE_NAME_LENGTH)
       )
      {
      [rxNameLengthWarningTextField setHidden:YES];
      [rxNameLengthWarningTextField setStringValue:@""];
      [doneButton setEnabled: YES];
      self.textFieldRecipeNameAbove.stringValue = self.textFieldRecipeName.stringValue;
      isGoodLength = YES;
      }
   else {
      [rxNameLengthWarningTextField setStringValue:RECIPE_NAME_LENGTH_WARNING ];
      [rxNameLengthWarningTextField setHidden:NO];
      [doneButton setEnabled: NO];
      self.textFieldRecipeNameAbove.stringValue = @"";
      isGoodLength = NO;
   }
   return isGoodLength;
}



#pragma mark SheetDidEnd: Delegate Method

- (void) sheetDidEnd:(NSWindow *) sheet returnCode:(int)returnCode contextInfo:(void *) contextInfo {
   
   DLog(@"contextInfo=%@",contextInfo);
   
}



- (NSMutableSet *) getMutSetOfSelectedCategories {   // Includes BrowseAll
   
   DLog(@"myAppController=%@",myAppController);
      // DLog(@"myCatArrayController=%@",myCatArrayController);
   NSArray *arrayOfCats = [(MyCatArrayController *)[[self myAppController] myCatArrayController ] arrangedObjects];
   
   NSEnumerator *enumerator = [arrayOfCats objectEnumerator]; // DO NOT INCLUDE BROWSE_ALL
       
   CategoryRx * aCategory;
   NSMutableSet *mutSet = [NSMutableSet setWithCapacity:[ [[[self myAppController] myCatArrayController] arrangedObjects] count]];
      //int j=0;
   while (aCategory = [enumerator nextObject]) { // enumerate the categories
            //DLog(@"aCategory=%@ ",aCategory);
      if((BOOL)aCategory.selected){
          DLog(@"aCategory1.name=%@  ",aCategory.name);
         [mutSet addObject:aCategory];
      }
   }
   //get Browse_All category
   CategoryRx* baCat = [self.appDelegate fetchCategoryBrowseAll];
   if (baCat) {
      [mutSet addObject:baCat];
   }else
      DLog(@"Failed to fetch Browse_All Cat.");
   return mutSet; // this set contains "Browse_All"
}


// -------------------------------------------------------------------------------
//	done:sender
// -------------------------------------------------------------------------------
- (IBAction)done:(id)sender
{
      // short RecipeName handled by Done Button binding
      // a short name is impossible
      //NSString *theName = [textFieldRecipeName stringValue];
   DLog(@"[textFieldRecipeName stringValue]=%@",[textFieldRecipeName stringValue]);
   [self setSavedRecipeName:[[textFieldRecipeName stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ];
   
   self.isNameUnique = [myAppController.rxFilteredArrayController isNameUnique_DG:savedRecipeName];
      /////  THIS AREA SHOULD BE REMOVABLE
   
   if(!self.isNameUnique){
      NSString *informString = [NSString stringWithFormat:@"ERROR:The Recipe Name '%@' already exists in the database.",savedRecipeName];
      NSAlert *alert = [[NSAlert alloc] init];
      [alert setAlertStyle:NSInformationalAlertStyle];
      [alert setMessageText:@"Recipe Name Must Be Unique"];
      [alert setInformativeText:informString];
      [[self tabView] selectFirstTabViewItem:self];
      [alert beginSheetModalForWindow:[self window]
                        modalDelegate:self
                       didEndSelector:@selector(recipeNameNotUniqueAlertDidEnd:returnCode: contextInfo:)
                          contextInfo:nil];
      return;
   } 
   /////  /////  /////
      /// RECIPE NAME IS GOOD TO GO             ///////////
      /// NOW CHECK FOR NEW CATEGORY NAME
   NSString *newCategoryNameTrimmed = [[textFieldNewCategoryName stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
      //Handle NewCategory length == 1
   NSUInteger catLen = [newCategoryNameTrimmed  length ] ;
   BOOL isOkNewCatNameLength = ((catLen <= MAX_CATEGORY_NAME_LENGTH
                                 && catLen >= MIN_CATEGORY_NAME_LENGTH) || catLen == 0 );
   if(! isOkNewCatNameLength){ // i.e. len == 0 or OK, i.e not 1= 1
      NSString *informString = [NSString stringWithFormat:@"The New Category Name must be either empty or at least %d characters long and not over %d.\nCurrently Length = %lu", MIN_CATEGORY_NAME_LENGTH, MAX_CATEGORY_NAME_LENGTH, (unsigned long)[newCategoryNameTrimmed  length]];
      NSAlert *alert = [[NSAlert alloc] init];
      [alert setAlertStyle:NSInformationalAlertStyle];
      [alert setMessageText:@"New Category Length Wrong"];
      [alert setInformativeText:informString];
      [[self tabView] selectLastTabViewItem:self];
      [alert beginSheetModalForWindow:[self window]
                        modalDelegate:self
                       didEndSelector:@selector(newCategoryNameShortAlertDidEnd:returnCode:  contextInfo:)
                          contextInfo:nil];
      return;
   }
      //
      // The length of the category name is OK  BUT COULD BE EMPTY!!!!!!   BUT IS IT UNIQUE ???
      //
   CategoryRx *newCategory = nil;
   BOOL isNewCatUnique = NO;
   NSEnumerator *enumerator ;
   if([newCategoryNameTrimmed length] >  1 &&  ([newCategoryNameTrimmed length] <= MAX_CATEGORY_NAME_LENGTH)){  //// Check for uniqueness
      //could it be "Browse All"
      BOOL isBrowseAll;
      NSComparisonResult result = [newCategoryNameTrimmed compare:@"Browse All" options:NSCaseInsensitiveSearch];
      isBrowseAll = (result == NSOrderedSame) ? YES : NO;
      if (!isBrowseAll) {
         isNewCatUnique = YES;
         NSArray *allCategoryNames = [[[myAppController myCatArrayController] arrangedObjects] valueForKey:@"name"];
         enumerator = [allCategoryNames objectEnumerator];
         NSString *aCatName;
         NSComparisonResult result;
         while (aCatName = [enumerator nextObject]) {
            result = [aCatName localizedCaseInsensitiveCompare:newCategoryNameTrimmed];
            if (result == NSOrderedSame) {
               isNewCatUnique = NO;
               break;
            }
         }
         if(!isNewCatUnique){
               // NON-UNIQUE newCategoryName  alert
            NSString *informString = [NSString stringWithFormat:@"The New Category Name '%@' already exists in the database.",newCategoryNameTrimmed];
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setAlertStyle:NSInformationalAlertStyle];
            [alert setMessageText:@"New Category Name Must Be Unique"];
            [alert setInformativeText:informString];
            [[self tabView] selectLastTabViewItem:self];
            [alert beginSheetModalForWindow:[self window]
                              modalDelegate:self
                             didEndSelector:@selector(newCategoryNameNotUniqueAlertDidEnd:returnCode:                                                contextInfo:)
                                contextInfo:nil];
            return;
         }
      
      }else{
         DLog(@"You can not add Browse All as a new Category.");
      }
   }// end newCategory Processing
   //come here if attempted to add newCat == Browse_All//
      // Here newCatName Unique    >= 1
   /*****
    NewCategory is either absent or has length > 1 TOGETHER BOTH ARE A GO
    IF UNIQUE==TRUE THEN BOTH ARE SATISFIED
    *****/
   NSManagedObjectContext *aManagedObjectContext =
   [(AppDelegate*)[[NSApplication sharedApplication] delegate ] managedObjectContext ];
   //////////////////////////////////
   Recipe *newRecipe =
      (Recipe*)[NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:aManagedObjectContext];
   [newRecipe setName:(NSString*)savedRecipeName];
   [newRecipe setIngredients: [[textViewIngredients string]  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] ;
   [newRecipe setDirections: [[textViewDirections string]  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] ;
   [newRecipe setComments: [[textViewComments string]  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] ;
   // GET ANY SELECTED CATEGORY FOR ADDITION TO RX
   NSArray *selectedCategories = [[self.categoryArrayController arrangedObjects] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.selected=YES"]];
   
   NSError *error2=nil;
      //	Could be called from EditCat or AddCat, for either do DB update
      // WE HAVE UNIQUE NAME,
      // NOW HANDLE NEW CATEGORY NAME IF ANY  ... NEEDS to be done before existing Cats
   if(isNewCatUnique ){ // already we know newCat has good length
      //NEED CHECK THAT CATNAME IS NOT ONE OF THE UNCHECKED CATS  IN ARRAY
      //CANNOT BE: BROWSE_ALL
      newCategory =
      [NSEntityDescription insertNewObjectForEntityForName:@"CategoryRx"
                                    inManagedObjectContext:aManagedObjectContext];
      newCategory.name =  newCategoryNameTrimmed ;
      [newRecipe addCategoriesObject:newCategory];
   }
      //SelectedCategoryInMain  plus BrowseAll
   CategoryRx *aCategory;
   enumerator = [selectedCategories objectEnumerator];
   while ((aCategory = enumerator.nextObject)) {
      DLog(@"adding aCategory.name=%@",aCategory.name);
      [newRecipe addCategoriesObject:aCategory];
   }
   CategoryRx *baCategory =
      [self.appDelegate fetchCategoryBrowseAll];
   ZAssert(baCategory != nil, @"baCategory not fetched!");
   [newRecipe addCategoriesObject:baCategory];//
   DLog(@"[newRecipe.categories allObjects]=%@",[newRecipe.categories allObjects]);
   if(![aManagedObjectContext save:&error2]){
        DLog(@"My save failed: %@\n%@", [error2 localizedDescription], [error2 userInfo]);
        //abort();
   }
   [[self textFieldRecipeName] setStringValue:@""];
   
   [self clearAllCategorySelections]; /////////////////
   
   [self.appDelegate.myAppController.window endSheet:self.window returnCode:0 ] ;
//   myAppController.addRecipeController = nil; // ensure NIB is reloaded each time
   [self.window orderOut:self];
   
   return;
} // end  - (IBAction)done:(id)sender


// -------------------------------------------------------------------------------
//	cancel:sender
// -------------------------------------------------------------------------------
- (IBAction)cancel:(id)sender
{
   [self clearAllCategorySelections];
   
   [[self textFieldRecipeName] setStringValue:@""];
   [self.appDelegate.myAppController.window endSheet:self.window returnCode:1 ] ;
   [self.window orderOut:self];
   
}

// -------------------------------------------------------------------------------
//	wasCancelled
// -------------------------------------------------------------------------------
- (BOOL)wasCancelled
{
	return cancelled;
}


#pragma mark CallBacks Data

   // getting Values
   // Here are some table data source methods assuming you have a 'myRows' array filled with objects with a 'booleanAttribute' property.



- (void) newCategoryNameShortAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo{
   [[alert window] orderOut:self];
   return;
}


- (void) recipeNameNotUniqueAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo{
   
      //[[self tabView] selectFirstTabViewItem:self];//name should show next time
   [[alert window] orderOut:self];
   return;
}


- (void) recipeNameLongAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo{
   
   [[alert window] orderOut:self];
   return;
}


- (void) newCategoryNameNotUniqueAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo{
   
   [[alert window] orderOut:self];
   return;
}



- (void) recipeNameAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo{
   
   [[self tabView] selectFirstTabViewItem:self];//name should show next time
   //if (returnCode == 0) {
       //[[self window]  orderOut:self];
   //}
   //send orderOut: (NSWindow) to the window object obtained by sending window to the alert argument
   [[alert window] orderOut:self];
   return;
}

- (void) updateDoneButton:(NSString*) name { // first nameWarning then doneButton
   
   NSString *nameTrimmed = [name
                            stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   self.isNameUnique = (BOOL)[[myAppController rxFilteredArrayController] isNameUnique_DG:nameTrimmed];
   DLog(@"self.isNameUnique=%d",self.isNameUnique);
   self.isNameLengthOK = [[myAppController rxFilteredArrayController] isNameLengthOK_DG:nameTrimmed];
   
   [self setDoEnableDoneButton:self.isNameLengthOK && self.isNameUnique];
      //DLog(@"[rxNameLengthWarningTextField stringValue]=%@",[rxNameLengthWarningTextField stringValue]);
      //DLog(@"isNameUnique=%d\nisNameLengthOK=%d",isNameUnique,isNameLengthOK);
   if (self.rxNameLengthWarningTextField.stringValue.length == 0 &&
       self.isNameUnique == NO) {
      [rxNameLengthWarningTextField setStringValue:@"Name is already in database!"];
      [rxNameLengthWarningTextField setHidden:NO];
      [self.textFieldRecipeName setNextKeyView:cancelButton];
      [cancelButton setNextKeyView:tabView];
      [tabView setNextKeyView:textFieldRecipeName];
   } else {
      [self.textFieldRecipeName setNextKeyView:doneButton];
      [doneButton setNextKeyView:cancelButton ];
      [cancelButton setNextKeyView:tabView];
      [tabView setNextKeyView:textFieldRecipeName];
   }
}

#pragma mark NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)aNotification{
   NSTextField *textField = [aNotification object];
      //[categoryNameLengthWarningTextField setStringValue:@""];
   [self updateRecipeNameLengthWarning];
   [self updateDoneButton:[textField stringValue]];//  determine uniq ,len
   [self updateKeyViewChain ];
}


#pragma mark   handleSelectTabItemToShowViewNotification

- (void) handleSelectTabItemToShowViewNotification:(NSNotification * ) note{
   NSTabViewItem * tabViewItem = [note.userInfo objectForKey:@"TabViewItem" ];
   [self.tabView selectTabViewItem:tabViewItem];
}

#pragma mark NSTabViewDelegate

   // Originally in EditRecipeController

- (void)tabView:(NSTabView *)aTabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem{   
    
   if(textFieldRecipeName.stringValue.length > 1)
      self.textFieldRecipeNameAbove.stringValue = self.textFieldRecipeName.stringValue;
   else
      self.textFieldRecipeNameAbove.stringValue = @"***  Recipe Name Required  ***";
   
   if (tabViewItem.identifier == aTabView.selectedTabViewItem.identifier) {
      [self scrollToShowFirstSelection:self];
   }
   
   [self updateKeyViewChain];
   
}

- (void) updateKeyViewChain {

   NSNumber *tabNumber =  self.tabView.selectedTabViewItem.identifier;
      //int tabDx = [[self.tabView selectedTabViewItem ] tabDx];
   switch (tabNumber.integerValue) {
      case 1:
         [self.tabView setNextKeyView:textFieldRecipeName];
         [self.textFieldRecipeName setNextKeyView:doneButton];
         [doneButton setNextKeyView:cancelButton ];
         [cancelButton setNextKeyView:self.tabView ];
         break;
      case 2:
         [self.tabView setNextKeyView:textViewIngredients];
         [self.textViewIngredients setNextKeyView:doneButton];
         [doneButton setNextKeyView:cancelButton ];
         [cancelButton setNextKeyView:self.tabView ];
         break;
      case 3:
         [self.tabView setNextKeyView:textViewDirections];
         [self.tabView setNextKeyView:doneButton];
         [doneButton setNextKeyView:cancelButton ];
         [cancelButton setNextKeyView:self.tabView ];
         break;
      case 4: // Comments
         [self.tabView setNextKeyView:textViewComments];
         [self.tabView setNextKeyView:doneButton];
         [doneButton setNextKeyView:cancelButton ];
         [cancelButton setNextKeyView:self.tabView ];
         break;
      case 5: //Categories
         [self.tabView setNextKeyView:rxCatTableView];
         [rxCatTableView setNextKeyView:textFieldNewCategoryName];
         [textFieldNewCategoryName setNextKeyView:doneButton];
         [doneButton setNextKeyView:cancelButton ];
         [cancelButton setNextKeyView:self.tabView ];
         break;
      default:
         DLog(@"switch value error");
         break;
   }// end switch
  

}

/****

- (BOOL)tabView:(NSTabView *)aTabView shouldSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
      //NSLog (@"shouldSelectTabViewItem:%@",tabViewItem.identifier);
      //[[tabViewItem view ] display];
   NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
   [f setNumberStyle:NSNumberFormatterDecimalStyle ];
   NSNumber *currentTabNumber = [f numberFromString:self.tabView.selectedTabViewItem.identifier];
   
   NSNumber *aTabNumber =
   [f numberFromString:tabViewItem.identifier];
      //DLog(@"[tabViewItem state]=%@",[tabViewItem state]);
   NSLog(@"[tabViewItem tabState]=%d",[tabViewItem tabState]);
   
   
    if(aTabNumber.integerValue != currentTabNumber.integerValue &&  [tabViewItem tabState] == NSBackgroundTab ){
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:tabViewItem forKey:@"TabViewItem"];
    
    [center postNotificationName:SelectTabItemToShowViewNotification object:self userInfo:dict];
    return YES;
    
    }
   return YES;
}

- (void)tabView:(NSTabView *)aTabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
   NSLog (@"willSelectTabViewItem");
}

****/

#pragma mark NSTextViewDelegate

- (BOOL)textView:(NSTextView *)aTextView doCommandBySelector:(SEL)aSelector {
   if (aSelector == @selector(insertTab:)) {
      [[aTextView window] selectNextKeyView:nil];
      return YES;
   }
   
   return NO;
}





@end
