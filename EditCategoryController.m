//
//  EditRecipeController.m
//  iHungryMac386
//

//

#import "EditCategoryController.h"
#import "MyAppController.h"
#import "AppDelegate.h"
#import "RecipeDefines.h"
#import "MyCatArrayController.h"
#import "Category.h"
#import "RxFilteredArrayController.h"

@implementation EditCategoryController


@synthesize  myAppController;
@synthesize textFieldCategoryNameAbove;
@synthesize textFieldCategoryName  ;
@synthesize myCategoryArrayController;
@synthesize rxFilteredArrayController;
@synthesize savedCategoryName;
@synthesize selectedCategoryIndexInMain;
//@synthesize  textFieldNewCategoryName;
//@synthesize tabView;
@synthesize textFieldFont,textViewFont;
@synthesize doneButton,cancelButton;
   //@synthesize rxCatTableView;
@synthesize categoryNameLengthWarningTextField;
   //@synthesize smallPanelFont;
@synthesize theNewCategoryNameBox;

// ------------------------------------------------------------------------------
//	windowNibName
// -------------------------------------------------------------------------------

-(NSArray *)categoryArrayMinusBrowseAll{
 
   NSMutableArray *mutRay =  
   [NSMutableArray arrayWithArray:[[[self myAppController] appDelegate] categoryArray ]];
   NSArray* nonMutArray = [NSArray arrayWithArray:mutRay];
   
   return nonMutArray;
}

  
- (NSString *)windowNibName
{
	return @"EditCategory";
}


/*
- (void) handleTextChangedNotification : (NSNotification*)note{
   
   
} */



- (IBAction) removeSelectionFromTextField:(id)textFieldSender{
   
   NSTextField *textField = (NSTextField*)textFieldSender;
   
   [textField  setSelectable:YES];
      //[textFieldCategoryName setDelegate:self];
      [[self window] makeFirstResponder:textField];
      //Get hold of the field editor and deselect its text
   NSText* fieldEditor = [[self window] fieldEditor:YES forObject:textField];
   [fieldEditor setSelectedRange:NSMakeRange([[fieldEditor string]
                                              length],0)];
   DLog(@"[fieldEditor string ]=%@",[fieldEditor string ]);
   [fieldEditor setNeedsDisplay:YES];
   
}

- (void)awakeFromNib {
   
   
   
   
  /*
   NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
   [center addObserver:self selector:@selector(handleTextChangedNotification) name:NSTextDidChangeNotification object:self.textFieldCategoryName];
   */
}

/*
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"KeyPath: %@", keyPath);
    NSLog(@"ofObject: %@", object);
    NSLog(@"change: %@", change);
   NSLog(@"Change is good: %@", [change objectForKey:NSKeyValueChangeNewKey]);
   if (object == self.textFieldCategoryName) {
      BOOL doEnableButton ;
      NSTextField *tField = object;
      NSString *catName = [tField stringValue];
      DLog(@"catName=%@",catName);
      doEnableButton = (
         (catName.length <= MAX_CATEGORY_NAME_LENGTH) &&
         (catName.length >= MIN_CATEGORY_NAME_LENGTH)
                        ) ?  YES : NO ;
      [self.doneButton setEnabled:doEnableButton];
    
   } else {
      //pass up to super
   }
}  **/

- (id)initWithWindowNibName:(NSString *)windowNibName 
{
    if (self = [super initWithWindowNibName:windowNibName ]) {
    // Custom initialization
       //get a copy for this view
      // DLog(@"");
    }
   return self;
 } 

- (void) windowWillLoad {
   
      // [self updatePanelFont];
   
}


- (void)windowDidLoad
{
   DLog(@"\n****************EditRecipeController=%@",self);
   [super windowDidLoad];
      //[self.myAppController updateSmallPanelFont];
   [self updateCategoryNameLengthWarning ]; // handles doneButton transpar and enable and
   
   // get the Recipe in question
   Category *theCategory = [[[self.myAppController categoryArrayController] arrangedObjects]  objectAtIndex: [[self.myAppController categoryArrayController] selectionIndex] ];
      //DLog(@"theCategory=%@",theCategory);
      // Fill TabView with the Recipe data
   [[self textFieldCategoryNameAbove] setStringValue:[theCategory name]];
   [[self textFieldCategoryName] setStringValue:[theCategory name]];
   [self removeSelectionFromTextField:[self textFieldCategoryName]];
   [[self textFieldCategoryName] setSelectable:YES];
      //[self removeSelectionFromTextField:self.textFieldCategoryName];
   
   //NSString *catName = [self.textFieldCategoryName stringValue];
   [self updateCategoryNameLengthWarning ];
}

/****
- (void) editCatFrom: (MyAppController *)sender
{              // sender is myAppController
   
      //[[self textFieldCategoryName]  setEnabled:YES];
      //[[self window] setDefaultButtonCell:[doneButton cell]];
      //[[self textFieldCategoryName] setSelectable:NO];
      //[[self textFieldCategoryName]  becomeFirstResponder];
   
 //[[[self textFieldCategoryName] cell] deselectAll:self];
 ////  [[self textFieldCategoryName] setNextKeyView:doneButton];
    
   if (self.myAppController) { // this is second or later appearance after loading
      [self updatePanelFont];
      [self updateCategoryNameLengthWarning ];
      
      // get the Category in question
      Category *theCategory = [[[self.myAppController categoryArrayController] arrangedObjects]
                               objectAtIndex: [[self.myAppController categoryArrayController] selectionIndex] ];
      // Fill TabView with the Recipe data
      [[self textFieldCategoryName]  becomeFirstResponder];
      [[self textFieldCategoryName] setStringValue:[theCategory name]];
      [self removeSelectionFromTextField:textFieldCategoryName];
      
   }
	//cancelled = NO;
	[self setMyAppController: (MyAppController *) sender];
   
   [NSApp beginSheet:[self window] modalForWindow:[sender window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
	[NSApp runModalForWindow:[self window]];
	// sheet is up here...
	[NSApp endSheet: [self window]];
	[[self window] orderOut:nil];
   //[[self window] close];
	//return @"Hello";
}
******/



- (NSMutableSet *) getMutSetOfSelectedCategories {   // Includes BrowseAll
   
   NSArray *selectedArray = [[myCategoryArrayController arrangedObjects]   valueForKey:@"selected"];
   NSArray *catArray = [[myAppController appDelegate] categoryArray];
   NSArray *catArrayMinusBrowseAll = [catArray filteredArrayUsingPredicate:
                                      [[myAppController appDelegate] predicateAllButBrowseAll]];
   NSEnumerator *enumerator = [catArrayMinusBrowseAll objectEnumerator]; //[[myCategoryArrayController arrangedObjects] objectEnumerator];
   Category * aCategory;
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

// -------------------------------------------------------------------------------
//	done:sender
// -------------------------------------------------------------------------------
- (IBAction)done:(id)sender
{
   Category *theCategory = [[[myAppController categoryArrayController] arrangedObjects]  objectAtIndex: [[myAppController categoryArrayController] selectionIndex] ];
   
   [self setSavedCategoryName:[[textFieldCategoryName stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ];
 /***
   if([[textFieldCategoryName stringValue] length] < MIN_CATEGORY_NAME_LENGTH){
      // sheet
      NSString *informString = [NSString stringWithFormat:@"Please enter a case insensitively unique Category Name\nThe Minimum length is %d.",MIN_CATEGORY_NAME_LENGTH];
      NSAlert *alert = [[[NSAlert alloc] init] autorelease];
      [alert setAlertStyle:NSInformationalAlertStyle];
      [alert setMessageText:@"Recipe Name Required"];
      [alert setInformativeText:informString];
      //- (void) recipeNameAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
      [alert beginSheetModalForWindow:[self window]
          modalDelegate:self
               didEndSelector:@selector(recipeNameAlertDidEnd:returnCode:                                                contextInfo:)
                          contextInfo:nil];
      return;
   }
    
   if([[textFieldCategoryName stringValue] length] == 0){
      NSLog(@"No Name Entered.");
      NSBeep();
   }
	
   [self setSavedRecipeName:[[textFieldCategoryName stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ]; 
   
	if ([savedRecipeName length] < MIN_CATEGORY_NAME_LENGTH || [savedRecipeName length] > MAX_CATEGORY_NAME_LENGTH ) {
		//[self alertLengthAction:[nameTrimmed length]];// Max handled by TextViewDelegate method
      DLog(@"Name is short or long.");
		return;
	}
  
   [theCategory setName:savedRecipeName];
     
   NSArray *selectedArray = [[myCategoryArrayController arrangedObjects]   valueForKey:@"selected"];
   NSArray *catArray = [[myAppController appDelegate] categoryArray];
   NSArray *catArrayMinusBrowseAll = [catArray filteredArrayUsingPredicate:
                                       [[myAppController appDelegate] predicateAllButBrowseAll]];
   NSEnumerator *enumerator = [catArrayMinusBrowseAll objectEnumerator]; //[[myCategoryArrayController arrangedObjects] objectEnumerator];
   Category * aCategory;
   
   NSMutableSet *mutSet = [NSMutableSet setWithCapacity:[ [myCategoryArrayController arrangedObjects] count]];
   int j=0;
   while (aCategory = [enumerator nextObject]) {
      if((BOOL) [[selectedArray objectAtIndex:j++] intValue]){
         [mutSet addObject:aCategory];
      }
   }
   // Now readd BrowseAll Category
   NSArray  *baCategoryOnlyArray = [[[myAppController appDelegate] categoryArray] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"sortIndex == -1"]];
   [mutSet addObject:[baCategoryOnlyArray objectAtIndex:0]];
   
   [theRecipe setCategories:mutSet];
   
   [theRecipe setIngredients:[textViewIngredients string]];
   [theRecipe setDirections:[textViewDirections string]];
   [theRecipe setComments:[textViewComments string]];
**/
   [theCategory setName:savedCategoryName];
   
   NSError *error2=nil;
    DLog(@"[(AppDelegate*)[ [NSApplication sharedApplication] delegate ] managedObjectContext ] = %@ ",[(AppDelegate*)[ [NSApplication sharedApplication] delegate ] managedObjectContext ]);
   
   [[(AppDelegate*)[ [NSApplication sharedApplication] delegate ] 
         managedObjectContext ] save:&error2]; // Persist Data too 
   if(error2){
      DLog(@"Error saving Recipe edits:error=%@ error.info=%@",error2,[error2 userInfo ] );
   }
   
   [(AppDelegate*)[ [NSApplication sharedApplication] delegate ] updateGlobalCategoryArray];
   
   [[self textFieldCategoryName]  becomeFirstResponder];
   [[self textFieldCategoryName] setStringValue:@""];
   [NSApp stopModal];
   
   return;
} // end  - (IBAction)done:(id)sender


// -------------------------------------------------------------------------------
//	cancel:sender
// -------------------------------------------------------------------------------
- (IBAction)cancel:(id)sender
{
	//[[self tabView] selectFirstTabViewItem:self];//name should show next time
   //[NSApp abortModal];
///	cancelled = YES;
   [NSApp stopModal];
}

/*
// -------------------------------------------------------------------------------
//	wasCancelled
// -------------------------------------------------------------------------------
- (BOOL)wasCancelled
{
	return cancelled;
}
*/


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


#pragma NSTabViewDelegate

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem{
   /*
    DLog(@"tabViewItem.identifier=%@",tabViewItem.identifier);
    //NSComparisonResult result = [tabViewItem.identifier compare:@"5"];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle ];
    NSNumber *tabNumber =
    [f numberFromString:tabViewItem.identifier];
    [f release];
    switch (tabNumber.integerValue) {
    case 1:
    [self.speechButton setTransparent:NO];
    [self.stopButton setTransparent:NO];
    
    self.tabViewRecipe.nextKeyView = self.textViewID;
    self.textViewID.nextKeyView = self.speechButton;
    self.speechButton.nextKeyView = self.stopButton;
    self.stopButton.nextKeyView = self.tabViewRecipe;
    break;
    case 2:
    [self.speechButton setTransparent:NO];
    [self.stopButton setTransparent:NO];
    self.tabViewRecipe.nextKeyView = self.textViewI;
    self.textViewI.nextKeyView = self.speechButton;
    self.speechButton.nextKeyView = self.stopButton;
    self.stopButton.nextKeyView = self.tabViewRecipe;
    break;
    case 3:
    [self.speechButton setTransparent:NO];
    [self.stopButton setTransparent:NO];
    self.tabViewRecipe.nextKeyView = self.textViewD;
    self.textViewD.nextKeyView = self.speechButton;
    self.speechButton.nextKeyView = self.stopButton;
    self.stopButton.nextKeyView = self.tabViewRecipe;
    break;
    case 4: // Comments
    [self.speechButton setTransparent:NO];
    [self.stopButton setTransparent:NO];
    self.tabViewRecipe.nextKeyView = self.textViewC;
    self.textViewC.nextKeyView = self.speechButton;
    self.speechButton.nextKeyView = self.stopButton;
    self.stopButton.nextKeyView = self.tabViewRecipe;
    break;
    case 5: //Categories
    [self.speechButton setTransparent:YES];
    [self.stopButton setTransparent:YES];
    self.tabViewRecipe.nextKeyView = nil; //self.tabViewItemCatsView;
    //self.tabViewItemCatsView.nextKeyView = self.tabViewRecipe;
    break;
    
    default:
    DLog(@"switch value error");
    break;
    */
   
}

#pragma mark NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)aNotification{
   
   DLog(@"aNotification=%@",aNotification);
   [self updateCategoryNameLengthWarning];
   
}


- (void) updateCategoryNameLengthWarning {
   
   NSString* nameTrimmed = [[ self.textFieldCategoryName stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
      //DLog(@"[self.textFieldCategoryName stringValue]=%@",[textFieldCategoryName stringValue]);
   if (([nameTrimmed length] >= MIN_CATEGORY_NAME_LENGTH) &&
       ([nameTrimmed length] <= MAX_CATEGORY_NAME_LENGTH)
       ) {
         //[doneButton setEnabled: YES];
      [categoryNameLengthWarningTextField setHidden:YES];
      [categoryNameLengthWarningTextField setStringValue:@""];
      
      [textFieldCategoryName setNextKeyView:doneButton];
      [doneButton setEnabled: YES];
      [doneButton setTransparent:NO];
   }
   else {
      [categoryNameLengthWarningTextField setStringValue:CATEGORY_NAME_LENGTH_WARNING ];
      [categoryNameLengthWarningTextField setHidden:NO];
      [doneButton setEnabled: NO];
      [doneButton setTransparent:YES];
      [textFieldCategoryName setNextKeyView:cancelButton];
   }
}


- (void)textDidChange:(NSNotification *)aNotification
{
   }


- (void)dealloc
{
   [doneButton removeObserver:self forKeyPath:@"cell.state"];
}

@end
