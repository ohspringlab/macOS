//
//  EditRecipeController.m
//  iHungryMac386
//

//

#import "EditRecipeController.h"
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
#import "Photo.h"
#import "MyImageView.h"

@implementation EditRecipeController 
@synthesize  selectedCategoryIndexInMain;

@synthesize  textViewIngredients,textViewDirections,textViewComments;
@synthesize textFieldRecipeName;
@synthesize rxCatTableView;
@synthesize  savedRecipeName;
@synthesize cancelled;
@synthesize savedRecipeIngredients,savedRecipeDirections,savedRecipeComments;
@synthesize  categoryArrayWithoutBrowseAll;
@synthesize textFieldRecipeNameAbove;
@synthesize tabView;
@synthesize doneButton,cancelButton;
@synthesize rxNameLengthWarningTextField;
@synthesize smallPanelFont;
@synthesize editRecipeTextField;

@synthesize myAppController;
@synthesize managedObjectContext;

@synthesize categoryArrayCntlr;
@synthesize selectedRecipe;
@synthesize allCategories;
@synthesize rxArrayController;
@synthesize appDelegateOutlet;
@synthesize sortDescriptorsNameOnly;
// ------------------------------------------------------------------------------
//	windowNibName
// -------------------------------------------------------------------------------
- (NSArray*) sortDescriptorsNameOnly {
   if (sortDescriptorsNameOnly) {
      return sortDescriptorsNameOnly;
   }
   sortDescriptorsNameOnly =
      [NSArray arrayWithObject:
         [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES
                                 selector:@selector(localizedCaseInsensitiveCompare:)]];
   return sortDescriptorsNameOnly  ;
}

-(NSArray *)categoryArrayMinusBrowseAll{
 
   NSMutableArray *mutRay =  
    [NSMutableArray arrayWithArray:[[[self myAppController] appDelegate] categoryArray ]];
                               
     NSArray* nonMutArray = [NSArray arrayWithArray:mutRay];
     return nonMutArray;
}

/*
- (void) updatePanelFont {
   AppDelegate *appDel = [[NSApplication sharedApplication] delegate];
   NSFontDescriptor *descriptor = [appDel.tableFont fontDescriptor];
   int fontSize = MAX_SMALL_PANEL_FONT_SIZE;
   if(descriptor.pointSize < MAX_SMALL_PANEL_FONT_SIZE)
      fontSize = descriptor.pointSize;
   self.smallPanelFont = [NSFont fontWithDescriptor:descriptor  size:fontSize];
   DLog(@"fontSize=%d",fontSize);
}
*/

/*
- (NSString *)windowNibName
{
	return @"EditRecipe";
}
*/
- (void)windowControllerDidLoadNib:(NSWindowController *)windowController {
   
   //[super windowControllerDidLoadNib:windowController];
   
}

#pragma mark awakeFromNib

- (void)awakeFromNib {
   [super awakeFromNib];// must be called, may be anytime in this method
   
   int i= 0;
   NSArray *photosArray = selectedRecipe.photos.allObjects;
   NSMutableArray *mutImageArray = [NSMutableArray arrayWithCapacity:[photosArray count]];
   if (photosArray.count ) {
      NSImage * theImage;
      Photo *thePhoto;
      NSEnumerator *enumerator = [photosArray objectEnumerator];
      while ((thePhoto  = (Photo  *) [ enumerator nextObject])) {
         theImage = nil;
         if([[thePhoto filename] length]){
            theImage = [NSImage imageNamed:[thePhoto filename]];
            if (theImage) {
               theImage = [theImage copy];
            }
         }
         if (!theImage && [thePhoto image] != nil) {
            theImage = [[NSImage alloc ]initWithData:[thePhoto image]];
         }
         if (theImage) { //may not find the image file
            [theImage setName:[thePhoto photoName]];
            [mutImageArray insertObject:theImage atIndex:i++];
            [theImage release];
         }else{
            DLog(@"File not found for:%@",thePhoto.photoName);
         }
      }
   }
   self.imageArray = mutImageArray;
   /* Set delegate for NSPageControl */
   [_pageController setDelegate:self];
   /* Set arranged objects for NSPageControl */
   if(_imageArray.count)
      [_pageController setArrangedObjects:_imageArray]; //may be empty
   /* Set transition style, in this example we use book style */
   [_pageController setTransitionStyle:NSPageControllerTransitionStyleStackHistory];
   NSString *info;
   if (self.pageController.arrangedObjects.count) {
      NSImage *object = [self.pageController.arrangedObjects objectAtIndex:0];
      [_imageView setImage:object];
      [self.pageController setSelectedIndex:0];
   }
   
   self.selectedCategoryIndexInMain = self.myAppController.myCatArrayController.selectionIndex;
  
   Recipe* recipe = [self.myAppController.rxFilteredArrayController.selectedObjects objectAtIndex:0];
   NSEnumerator *enumeratorRxCats = [recipe.categories.allObjects objectEnumerator];
   
   CategoryRx* categoryRxCat;
   while ((categoryRxCat = [enumeratorRxCats nextObject])){
      CategoryRx* categoryAllCat;
      NSEnumerator *enumeratorAllCats = [self.categoryArrayCntlr.arrangedObjects objectEnumerator];
      while ((categoryAllCat = (CategoryRx*)[enumeratorAllCats nextObject])) {
         NSComparisonResult result = [categoryRxCat.name compare:categoryAllCat.name];
         if (result == NSOrderedSame && categoryAllCat.sortIndex != [NSNumber numberWithInteger:-1]) {
            categoryRxCat.selected = YES;
         }
      }
   }
   // DLog(@"[self.categoryArrayCntlr.arrangedObjects valueForKey:@'name']=%@",[self.categoryArrayCntlr.arrangedObjects valueForKey:@"name"]);
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
 
   [center addObserver: self
            selector: @selector(handleSelectTabItemToShowViewNotification:)
                  name:SelectTabItemToShowViewNotification //ExportDgxFolderFetchDoneNotification  //window deleted or made non-key
                        object:myPanel];// delivered if from this IBOutlet
   //[self.myAppController.appDelegate.managedObjectContext.undoManager beginUndoGrouping];
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


- (void) windowWillLoad{ // NSPanel is subclass of NSWindow
   [super windowWillLoad];
   
}


- (void)windowDidLoad
{
      //DLog(@"\n****************EditRecipeController=%@",self);
   [super windowDidLoad];
   
   self.allCategories = self.myAppController.myCatArrayController.arrangedObjects;
   self.window.initialFirstResponder = self.tabView;
   
   [self.myAppController  updateSmallPanelFont];
   [self fillFieldsAndSetFontsForRecipe:selectedRecipe];
    DLog(@"selectedRecipe.name=%@",selectedRecipe.name);
   //
   //set Category TableView according to the Recipe NSSet
   //
   [self checkItemsInTableViewForRecipe:selectedRecipe ];

   [self updateRecipeNameLengthWarning];
} // windowDidLoad


- (void) fillFieldsAndSetFontsForRecipe:(Recipe *)aRecipe {
  
   DLog(@"aRecipe=%@",aRecipe.name);
   DLog(@"[aRecipe ingredients]=%@",[aRecipe ingredients]);
   
   
   [[self textFieldRecipeNameAbove] setStringValue:[aRecipe name]];
   [[self textFieldRecipeName] setStringValue:[aRecipe name]];
   
   if ([aRecipe ingredients]) {
      [[self textViewIngredients] setString:[aRecipe ingredients]];
      [[self textViewIngredients] setFont:[myAppController.appDelegate tableFont]];
   }
   if ([aRecipe directions]) {
      [[self textViewDirections] setString:[aRecipe directions]];
      [[self textViewDirections] setFont:[myAppController.appDelegate tableFont]];
   }
   if ([aRecipe comments]) {
      [[self textViewComments] setString:[aRecipe comments]];
      [[self textViewComments] setFont:[myAppController.appDelegate tableFont]];
   }
   
   [self.textFieldRecipeNameAbove setFont:self.myAppController.smallPanelFont];
   [[self textFieldRecipeName] setFont:[self.myAppController smallPanelFont]];

   [[self rxCatTableView] setFont:[self.myAppController smallPanelFont]];

   [[self tabView] setFont:self.myAppController.smallPanelFont];
   [[self editRecipeTextField] setFont:self.myAppController.smallPanelFont];
   [self.cancelButton.cell setFont:self.myAppController.smallPanelFont  ];
   [self.doneButton.cell setFont:self.myAppController.smallPanelFont ];

   [[self tabView] selectLastTabViewItem:self];//name should show next time
   [[self tabView] selectFirstTabViewItem:self];//name

   [self.doneButton setFont:self.myAppController.smallPanelFont  ];
   [self.cancelButton setFont:self.myAppController.smallPanelFont];
   //[self.textFieldRecipeNameAbove.cell setFont:self.smallPanelFont ];
}


- (NSUInteger) checkItemsInTableViewForRecipe:(Recipe*)aRecipe  {
   
   NSPredicate *predicateSortAndRemoveBrowseAll =
   [NSPredicate predicateWithFormat:@"sortIndex > -1"];
   NSArray *recipeCategoriesMinusBA = [NSArray arrayWithArray: [[[aRecipe categories] allObjects] filteredArrayUsingPredicate:predicateSortAndRemoveBrowseAll]];
      //DLog(@"[[[theRecipe categories] allObjects] count]=%d",[[[theRecipe categories] allObjects] count]);
      //DLog(@"recipeCategoriesMinusBA=%d",[recipeCategoriesMinusBA count]);
   // use recipeCategories to set check boxes
   NSEnumerator *enumerator = [recipeCategoriesMinusBA  objectEnumerator];
   CategoryRx *aCategory;
   // BLANK selected for all
   [[self.myAppController.myCatArrayController arrangedObjects] setValue:[NSNumber numberWithBool:NO] forKey:@"selected"];
   NSUInteger i = 0;
   while (aCategory = [enumerator nextObject]) { //each of theRecipe's categories
      NSUInteger i = [[self.myAppController.myCatArrayController arrangedObjects] indexOfObject:aCategory];
      if (i != NSNotFound && i < [[self.myAppController.myCatArrayController arrangedObjects] count]) {
         CategoryRx *selectedCat = [[self.myAppController.myCatArrayController arrangedObjects] objectAtIndex:i];
             //DLog(@"\n\n[aCategory name]=%@ index=%d selectedCat.name=%@\naCategory=%@\nselectedCat=%@",[aCategory name],i,selectedCat.name,aCategory, selectedCat);
         [selectedCat setSelected : YES];
      }
   }

   return i;
}

#pragma mark editRecipeFrom:

- (NSString*) editRecipeFrom: (MyAppController *)sender
{
    
    [self setSavedRecipeName:@""];
    
    [NSApp beginSheet:self.window modalForWindow:[sender window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
    [NSApp runModalForWindow:[sender window]];
    // sheet is up here...
    [NSApp endSheet:self.window];
    [self.window orderOut:self];
    
    return savedRecipeName ;
}


#pragma mark SheetDidEnd: Delegate Method

- (void) sheetDidEnd:(NSWindow *) sheet returnCode:(int)returnCode contextInfo:(void *) contextInfo {
   
   DLog(@"contextInfo=%@",contextInfo);
   
}



- (NSMutableSet *) getMutSetOfSelectedCategories {   // Includes BrowseAll
   
   NSArray *selectedArray = [[self.myAppController.myCatArrayController arrangedObjects]   valueForKey:@"selected"];
   NSArray *catArray = [self.myAppController.myCatArrayController arrangedObjects];
      //NSArray *catArrayMinusBrowseAll = [catArray filteredArrayUsingPredicate:
      //                                [[myAppController appDelegate] predicateAllButBrowseAll]];
   NSEnumerator *enumerator = [catArray objectEnumerator]; // include "Browse All"
    
   CategoryRx * aCategory;
   NSMutableSet *mutSet = [NSMutableSet setWithCapacity:[[self.myAppController.myCatArrayController arrangedObjects] count]];
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

#pragma mark ACTIONS
// -------------------------------------------------------------------------------
//	done:sender
// -------------------------------------------------------------------------------
- (IBAction)done:(id)sender
{
   DLog(@"self.textViewIngredients=%@",self.textViewIngredients ); 
   //DLog(@"self.selectedRecipe=%@",self.selectedRecipe );
    DLog(@"self.categoryArrayCntlr=%@",self.categoryArrayCntlr);
    DLog(@"self.rxArrayCntlr=%@",self.rxArrayController);
   //REMOVE AS TEXTVIEW ENFORCES MIN_LEN
   if([[textFieldRecipeName stringValue] length] < MIN_RECIPE_NAME_LENGTH){
      // sheet
      NSString *informString = [NSString stringWithFormat:@"Please enter a case insensitively unique Recipe Name\nThe Minimum length is %d.",MIN_RECIPE_NAME_LENGTH];
      NSAlert *alert = [[NSAlert alloc] init];
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
    //// TRIM RECIPE NAME
    [self setSavedRecipeName:[[textFieldRecipeName stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ]; 

    if ([savedRecipeName length] < MIN_RECIPE_NAME_LENGTH || [savedRecipeName length] > MAX_RECIPE_NAME_LENGTH ) {
        //[self alertLengthAction:[nameTrimmed length]];// Max handled by TextViewDelegate method
      DLog(@"Recipe Name is short or long.");
        return;
    }
   // compare against existing RxNames
   NSEnumerator *enumeratorRxs = [self.myAppController.rxFilteredArrayController.arrangedObjects objectEnumerator];
   Recipe* recipe;
   while ((recipe = [enumeratorRxs nextObject])) {
      DLog(@"recipe.name=%@",recipe.name);
      DLog(@"selectedRecipe.name=%@",selectedRecipe.name);
      NSComparisonResult result = [recipe.name compare:self.savedRecipeName options:NSCaseInsensitiveSearch];
      if (result == NSOrderedSame ) {
         if (![recipe.objectID isEqual:selectedRecipe.objectID]) {
            // name for this recipe is in use by another
            // put up alert that trimmed RxName already exists in another Rx
            //DLog(@"That recipe name is in use by another Recipe!");
            [rxNameLengthWarningTextField setStringValue:@"*** That recipe name is in use by another Recipe. ***"];
            NSString *informString = [NSString stringWithFormat:@"Please use a new recipe name."];
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setAlertStyle:NSInformationalAlertStyle];
            [alert setMessageText:@"Recipe Name Already In Use"];
            [alert setInformativeText:informString];
            [alert beginSheetModalForWindow:[self window]
                              modalDelegate:self
                             didEndSelector:@selector(recipeNameInUseAlertDidEnd:returnCode:                                                contextInfo:)
                                contextInfo:nil];
            return;
         }
      }
   }
   [self.selectedRecipe setName:savedRecipeName];
   DLog(@"self.textViewIngredients.string=%@",self.textViewIngredients.string);
   selectedRecipe.ingredients = self.textViewIngredients.string;
   selectedRecipe.directions = self.textViewDirections.string;
   selectedRecipe.comments = self.textViewComments.string;
   
   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.selected == YES"];
   NSArray *categoryRayChecked = [self.categoryArrayCntlr.arrangedObjects filteredArrayUsingPredicate:predicate];
   self.selectedRecipe.categories=nil;
   NSEnumerator *enumerator = [categoryRayChecked objectEnumerator];
   CategoryRx *category;
   
   while ((category = enumerator.nextObject)) {
      [self.selectedRecipe addCategoriesObject:category];
   }
   CategoryRx *baCat = [self.myAppController.appDelegate fetchCategoryBrowseAll];
   [self.selectedRecipe addCategoriesObject:baCat];
   [categoryRayChecked setValue:@NO forKey:@"selected" ];
       NSError *error2=nil;
    DLog(@"[(AppDelegate*)[ [NSApplication sharedApplication] delegate ] managedObjectContext ] = %@ ",[(AppDelegate*)[ [NSApplication sharedApplication] delegate ] managedObjectContext ]);
    [[(AppDelegate*)[ [NSApplication sharedApplication] delegate ]
      managedObjectContext ] save:&error2]; // Persist Data too
    if(error2){
        DLog(@"Error saving Recipe edits:error=%@ error.info=%@",error2,[error2 userInfo ] );
    }
   [self.myAppController.rxFilteredArrayController setSelectionIndex:self.selectedCategoryIndexInMain];
   
    [myAppController.window endSheet:self.window returnCode:0 ] ;
   //[self.window close];
    [self.window orderOut:self];

    return;
} // end  - (IBAction)done:(id)sender



// -------------------------------------------------------------------------------
//	cancel:sender
// -------------------------------------------------------------------------------
- (IBAction)cancel:(id)sender
{
    //[NSApp endSheet:self.window returnCode:1 ] ;
   //[self.window orderOut:self];
   ///[self.myAppController.appDelegate.managedObjectContext.undoManager endUndoGrouping];
   ///[self.myAppController.appDelegate.managedObjectContext.undoManager undo];
   //[[self textFieldRecipeName] setStringValue:[selectedRecipe name]];
    
   [myAppController.window endSheet:self.window returnCode:0 ] ;
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
- (void) recipeNameInUseAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo{
   
   
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

#pragma mark NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)aNotification{
   
   DLog(@"aNotification=%@",aNotification);
   
   [self updateRecipeNameLengthWarning];
   
      //if(textFieldRecipeName.stringValue.length < 2)
      //self.doneButton.isEnabled = NO;
   
}

- (void) updateRecipeNameLengthWarning {
   
      //NSString *rxName = [self.textFieldRecipeName stringValue];
   
   //DLog(@"[self.textFieldRecipeName stringValue]=%@",[textFieldRecipeName stringValue]);
   if (([[self.textFieldRecipeName stringValue]length] >= MIN_RECIPE_NAME_LENGTH) &&
       ([[self.textFieldRecipeName stringValue]length] <= MAX_RECIPE_NAME_LENGTH)
       ) {
      //[doneButton setEnabled: YES];
      [rxNameLengthWarningTextField setHidden:YES];
      [rxNameLengthWarningTextField setStringValue:@""];
      [doneButton setEnabled: YES];
      
      [self.tabView setNextKeyView:textFieldRecipeName];
      [self.textFieldRecipeName setNextKeyView:doneButton];
      [doneButton setNextKeyView:cancelButton ];
      [cancelButton setNextKeyView:self.tabView ];
   }
   else {
      [rxNameLengthWarningTextField setStringValue:RECIPE_NAME_LENGTH_WARNING ];
      [rxNameLengthWarningTextField setHidden:NO];
      [doneButton setEnabled: NO];
      
      [self.tabView setNextKeyView:textFieldRecipeName];
      [textFieldRecipeName setNextKeyView:cancelButton ];
      [cancelButton setNextKeyView:self.tabView ];
   }
}



#pragma mark   handleSelectTabItemToShowViewNotification

- (void) handleSelectTabItemToShowViewNotification:(NSNotification * ) note{
   NSTabViewItem * tabViewItem = [note.userInfo objectForKey:@"TabViewItem" ];
   [self.tabView selectTabViewItem:tabViewItem];
}

#pragma mark NSTabViewDelegate

   // Originally in EditRecipeController

- (void)tabView:(NSTabView *)aTabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem{
   DLog(@"tabViewItem.identifier=%@",tabViewItem.identifier);
   self.textFieldRecipeNameAbove.stringValue = self.textFieldRecipeName.stringValue ;
   
   NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
   [f setNumberStyle:NSNumberFormatterDecimalStyle ];
   NSNumber *tabNumber =
   [f numberFromString:tabViewItem.identifier];
   
   self.textFieldRecipeNameAbove.stringValue = self.textFieldRecipeName.stringValue;
   [self.tabView becomeFirstResponder];
   switch (tabNumber.integerValue) {
      case 1:
         if (doneButton.isEnabled) { //NAME
            [self.tabView setNextKeyView:textFieldRecipeName];
            [self.textFieldRecipeName setNextKeyView:doneButton];
            [doneButton setNextKeyView:cancelButton ];
            [cancelButton setNextKeyView:self.tabView ];
         } else {
            [self.tabView setNextKeyView:textFieldRecipeName];
            [textFieldRecipeName setNextKeyView:cancelButton ];
            [cancelButton setNextKeyView:self.tabView ];
         }
         break;
      case 2:
            //INGREDIENTS
         [self.tabView setNextKeyView:doneButton];
         [doneButton setNextKeyView:cancelButton ];
         [cancelButton setNextKeyView:self.tabView ];
         break;
      case 3:
            //[self.textViewDirections resignFirstResponder];
         [self.tabView setNextKeyView:doneButton];
         [doneButton setNextKeyView:cancelButton ];
         [cancelButton setNextKeyView:self.tabView ];
         break;
      case 4: // Comments
         [self.tabView setNextKeyView:doneButton];
         [doneButton setNextKeyView:cancelButton ];
         [cancelButton setNextKeyView:self.tabView ];
         break;
      case 5: //Categories
         if (self.doneButton.isEnabled) {
            [self.tabView setNextKeyView:rxCatTableView];
            [self.rxCatTableView setNextKeyView:doneButton];
            [doneButton setNextKeyView:cancelButton ];
            [cancelButton setNextKeyView:self.tabView ];
         } else {
            [self.tabView setNextKeyView:rxCatTableView];
            [self.rxCatTableView setNextKeyView:cancelButton];
            [cancelButton setNextKeyView:self.tabView ];
         }
         break;
      case 6: //PHOTOS
         if (self.doneButton.isEnabled) {
            [self.tabView setNextKeyView:rxCatTableView];
            [self.rxCatTableView setNextKeyView:doneButton];
            [doneButton setNextKeyView:cancelButton ];
            [cancelButton setNextKeyView:self.tabView ];
         } else {
            [self.tabView setNextKeyView:rxCatTableView];
            [self.rxCatTableView setNextKeyView:cancelButton];
            [cancelButton setNextKeyView:self.tabView ];
         }
         [self updatePhotoInfoString];
         [self updatePhotoButtonsEnabled];
         
         break;
      default:
         DLog(@"switch value error");
         break;
   }// end switch
}

- (void)updatePhotoInfoString {
   if ([_imageArray count] == 0 || _pageController == nil) {
      [_infoNameTextField setStringValue:@"No Photos Found"];
      return;
   }

   NSUInteger selectedIndex = (NSUInteger)[_pageController selectedIndex];
   if (selectedIndex >= [_imageArray count]) {
      selectedIndex = 0;
   }

   NSImage *image = [_imageArray objectAtIndex:selectedIndex];
   if (image == nil) {
      [_infoNameTextField setStringValue:@"No Photos Found"];
      return;
   }

   NSString *imageName = [image name];
   if (imageName == nil) {
      imageName = @"";
   }
   NSString *info = [NSString stringWithFormat:@"%lu/%lu %@",
                     (unsigned long)(selectedIndex + 1),
                     (unsigned long)[_imageArray count],
                     imageName];
   [_infoNameTextField setStringValue:info];
}


- (void) updatePhotoButtonsEnabled{
   NSUInteger photoCount = _pageController.arrangedObjects.count;
   if (photoCount < 2 ) {
      _prevPhotoButton.enabled = NO;
      _nextPhotoButton.enabled = NO;
   }
   else { //2 or more
      _prevPhotoButton.enabled = NO;
      if (_pageController.selectedIndex != 0) {
         _prevPhotoButton.enabled = YES;
      }
      _nextPhotoButton.enabled = NO;
      if (_pageController.selectedIndex <  photoCount -1) {
         _nextPhotoButton.enabled = YES;
      }
   }
}
/*
 #pragma mark NSTabViewDelegate methods
 
 - (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
 if (speechOnGoing) {
 DLog(@"Stop Speech Before Leaving Tab. ");
 [self.speechController stopIt:self];
 
 return;
 }
 DLog(@"tabViewItem.identifier=%@",tabViewItem.identifier);
 NSComparisonResult result = [tabViewItem.identifier compare:@"5"];
 
 if (result != NSOrderedSame) {// if Photos
 self.speechButton.enabled = YES;
 self.stopButton.enabled = YES;
 }else{ // Photos
 self.speechButton.enabled = NO;
 self.stopButton.enabled = NO;
 }
 
 [self updateKeyViewChain];
 }

 */

- (void)tabView:(NSTabView *)aTabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
   DLog (@"willSelectTabViewItem %@",tabViewItem);
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
