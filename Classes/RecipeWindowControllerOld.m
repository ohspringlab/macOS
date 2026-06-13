//
//  RecipeWindowController.m
//  iHungryMac_ND
//
//  Created by Mark on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RecipeWindowController.h"
#import  "Recipe.h"
#import "AppDelegate.h"
#import "Constants.h"
#import  "RecipePrintView.h" 
#import "RecipeWindow.h"
#import "Constants.h"
#import "MyCatArrayController.h"
#import "MySpeechButton.h"
#import "MySpeechStopButton.h"

#import "MyButton.h"
#import "SpeechController.h"
#import "MyTextView.h"
#import "CategoryRx.h"
#import "MyAppController.h"
//extern NSString *RecipeDeactivateNotification;
//extern NSString *RecipeActivateNotification;

//static RecipeWindowController *g_controller;

@implementation RecipeWindowController
@synthesize recipe;
@synthesize textViewID,textViewI,textViewD,textViewC;
@synthesize speechButton;
@synthesize stopButton;
@synthesize printInfo;
@synthesize appDel;
@synthesize printSelected;
//@synthesize roundButton;
@synthesize  scrollViewID,scrollViewI,scrollViewD,scrollViewC;
@synthesize myCatArrayController;
@synthesize rxCatTableView;
@synthesize arrayAllRecipeCatNames;
@synthesize arrayTheRecipeCats;
@synthesize  smallPanelFont;
@synthesize tableColumnName;
@synthesize tabViewRecipe;
@synthesize currentTabId;

@synthesize tabViewItemID;
@synthesize tabViewItemI;
@synthesize tabViewItemD;
@synthesize tabViewItemC;
@synthesize tabViewItemCatsView;
@synthesize speechOnGoing;
@synthesize speechController;
@synthesize myAppController;

+ (void)initialize{
   [[NSFontManager sharedFontManager] setAction:@selector(changeMyFont:)];
   
}



- (RecipeWindowController * )initWithWindowNibName:(NSString*)windowNibName {
   
   if (self = [super initWithWindowNibName:windowNibName ]) {
      // Custom initialization
      //get a copy for this view
      // DLog(@"");
   }
   return self;
}

#pragma mark FONT STUFF

-(void)changeFont:(id)sender {
   
}

-(void)changeMyFont:(id)sender
{
   NSFont* font = [self.appDel tableFont];
   NSFontManager* mngr = [NSFontManager sharedFontManager];
   
   font = [mngr convertFont:font];// the font newly chosen
   [self.appDel setTableFont:font];
   
   DLog(@"font size=%@",[NSNumber numberWithFloat:[font pointSize]]);
   
   [self.appDel changeMyFont:self]; // tableFont set, now resize ColHts there
   [self updatePanelFont];
      //self.smallPanelFont = [NSFont fontWithDescriptor:descriptor  size:fontSize];
      //[self.tabViewRecipe setFont:self.smallPanelFont];
   [self resizeCategoriesTabTableViewRowHeights]; //now resize ColHt here
   
}


 - (void) updatePanelFont {
    
       //AppDelegate *appDel = [[NSApplication sharedApplication] delegate];
 NSFontDescriptor *descriptor = [appDel.tableFont fontDescriptor];
 int fontSize = MAX_SMALL_PANEL_FONT_SIZE;
 if(descriptor.pointSize < MAX_SMALL_PANEL_FONT_SIZE)
 fontSize = descriptor.pointSize;
 self.smallPanelFont = [NSFont fontWithDescriptor:descriptor  size:fontSize];
 DLog(@"fontSize=%d",fontSize);
 }

/*
 - (void) resizeBothTableViewRowHeights{
 
 //[[myAppController tableViewRx] setRowHeight:11.0 + (0.75 * [[self tableFont] pointSize])];
 //[[myAppController tableViewCat] setRowHeight:11.0 + (0.75 * [[self tableFont] pointSize])];
 [[myAppController tableViewRx] setRowHeight:4.0 + (1.0 * [[self tableFont] pointSize])];
 [[myAppController tableViewCat] setRowHeight:4.0 + (1.0 * [[self tableFont] pointSize])];
 [[myAppController tableViewRx] reloadData];
 [[myAppController tableViewCat] reloadData];
 
 }
 */

- (void) resizeCategoriesTabTableViewRowHeights{
      
   [[self rxCatTableView] setRowHeight:11.0 + (0.75 * [[self.appDel tableFont] pointSize])];
      //[[self rxCatTableView] setRowHeight:4.0 + (1.0 * [[self.appDel tableFont] pointSize])];
   [[self rxCatTableView] reloadData];
   
}


// -------------------------------------------------------------------------------
//	windowNibName
// -------------------------------------------------------------------------------

- (NSString *)windowNibName
{
	return @"RecipeView";
}

- (void) handleMyFontDidChangedNotification:(id)note {
   [self resizeCategoriesTabTableViewRowHeights];
   
}

- (void) handleSpeechBeginNotification:(id)note {
   [self setSpeechOnGoing:YES];
   
}

- (void) handleSpeechEndNotification:(id)note {
   [self setSpeechOnGoing:NO];
   
}




- (void) awakeFromNib{
    [super awakeFromNib];// must be called, may be anytime in this method //CHECK 10/22/14 uncommented
   
   [self.window disableKeyEquivalentForDefaultButtonCell];
      //[stopButton setKeyEquivalent:@""];
   self.window.initialFirstResponder = tabViewRecipe;
      //+ (void)exposeBinding:(NSString *)binding
      //[pieChartView bind:@"segmentNamesArray" toObject:segmentsArrayController withKeyPath:@"arrangedObjects.name" options:nil];
      //[menuItemImportDgx bind:@"enabled" toObject:self withKeyPath:@"enablePrint" options:nil];
   self.speechOnGoing=NO;
   NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
   
   [center addObserver:self selector:@selector(handleSpeechBeginNotification:) name:DG_SpeechBeginNotification object:nil];
   [center addObserver:self selector:@selector(handleSpeechEndNotification:) name:DG_SpeechEndNotification object:nil];
   
      ///[self.rxCatTableView deselectAll:self];
   
      /// [self.window disableKeyEquivalentForDefaultButtonCell];
      ///   [speechButton setKeyEquivalent:@"\r"];
      ////[stopButton setKeyEquivalent:@""];
   
   [self updatePanelFont];
      //[self.tabViewRecipe bind:@"font" toObject:self withKeyPath:@"smallPanelFont" options:nil]; //GOOD ??
   [self.tabViewRecipe bind:@"font" toObject:self withKeyPath:@"smallPanelFont" options:nil]; //GOOD ??
      // - (void)bind:(NSString *)binding toObject:(id)observableController withKeyPath:(NSString *)keyPath options:(NSDictionary *)options
      //[NSBinding exposeBinding:@"self.tabViewRecipe"]
      
   [self resizeCategoriesTabTableViewRowHeights];
   NSArray *catArray = [self getRxCategoriesArrayMinusBA:self.recipe];//from theRecipe displayed
   
   [self setArrayTheRecipeCats:catArray];//property bound to TableColumn
      //DLog(@"arrayAllRecipeCatNames=%@",arrayAllRecipeCatNames);
   [[self window] setTitle:[[self recipe] name]];
   
   [[self textViewID] setFont:[self.appDel tableFont]];
   [[self textViewI] setFont:[self.appDel tableFont]];
   [[self textViewD] setFont:[self.appDel tableFont]];
   [[self textViewC] setFont:[self.appDel tableFont]];
   
   [stopButton setEnabled:NO];
   [textViewID setEditable:YES];
   [textViewI setEditable:YES];
   [textViewD setEditable:YES];
   [textViewC setEditable:YES];
   
   NSString* instrucDirecString = nil;
   if([[self recipe] ingredients] && [[self recipe] directions])
      instrucDirecString=[NSString stringWithFormat:@"%@\n\n%@", [[self recipe] ingredients], [[self recipe] directions]];
   else if([[self recipe] ingredients])
      instrucDirecString=[NSString stringWithFormat:@"%@", [[self recipe] ingredients]];
   else if([[self recipe] directions])
      instrucDirecString=[NSString stringWithFormat:@"%@", [[self recipe] directions]];
   
   if(instrucDirecString.length)
      [[self textViewID] insertText:instrucDirecString];
   if([[[self recipe] ingredients] length])
      [[self textViewI] insertText:[[self recipe] ingredients]];
   if([[[self recipe] directions] length])
      [[self textViewD] insertText:[[self recipe] directions]];
   if([[[self recipe] comments] length])
      [[self textViewC] insertText:[[self recipe] comments]];
   
      //DLog(@"textViewD  = %@",[self textViewD] );
      //DLog(@"[[self textViewD] text]=%@",[[self textViewD] textStorage] );
   
   [textViewID setEditable:NO];
   [textViewI setEditable:NO];
   [textViewD setEditable:NO];
   [textViewC setEditable:NO];

   NSRange startRange = NSMakeRange(0, 0);
   
   [textViewID scrollRangeToVisible:startRange];
   [textViewI scrollRangeToVisible:startRange];
   [textViewD scrollRangeToVisible:startRange];
   [textViewC scrollRangeToVisible:startRange];
   [textViewID setNeedsDisplay:YES];
   [textViewI setNeedsDisplay:YES];
   [textViewD setNeedsDisplay:YES];
   [textViewC setNeedsDisplay:YES];
   
   [self showWindow:self];
   //[self orderFront:[self window]];
}

   // - (void) performClos

- (BOOL) windowShouldClose:(id)sender{
   
   if (speechOnGoing) {
      DLog(@"Stop Speech Before Leaving Tab. ");
      [self.speechController stopIt:self];
      [self setSpeechOnGoing:NO];
   }
   
   return YES;
}

- (void) windowWillLoad {
   [super windowWillLoad];
   [self setAppDel:(AppDelegate*)[[NSApplication sharedApplication] delegate] ];
}

- (void) windowDidLoad {
   [super windowDidLoad];
   
   [[self tabViewRecipe] selectLastTabViewItem:self];
   [[self tabViewRecipe] selectFirstTabViewItem:self];
   
          //set Category TableView according to the Recipe NSSet
      //
   NSPredicate *predicateSortAndRemoveBrowseAll =
   [NSPredicate predicateWithFormat:@"sortIndex > -1"];
   NSArray *recipeCategoriesMinusBA = [NSArray arrayWithArray: [[[recipe categories] allObjects] filteredArrayUsingPredicate:predicateSortAndRemoveBrowseAll]];
   NSArray *allCategoryArrayMinusBA = [[[appDel myAppController] myCatArrayController] arrangedObjects];
      // use recipeCategories to set check boxes
   NSEnumerator *enumerator = [recipeCategoriesMinusBA  objectEnumerator];
   CategoryRx *aCategory;
   [allCategoryArrayMinusBA setValue:[NSNumber numberWithBool:NO] forKey:@"selected"];
   while (aCategory = [enumerator nextObject]) {
      NSUInteger i = [allCategoryArrayMinusBA indexOfObject:aCategory];
      CategoryRx *selectedCat = [allCategoryArrayMinusBA objectAtIndex:i];
         //DLog(@"\n\n[aCategory name]=%@ index=%d \naCategory=%@\nselectedCat=%@",[aCategory name],i,aCategory, selectedCat);
      [selectedCat setSelected : YES];
   }

}


- (NSArray * ) getRxCategoriesArrayMinusBA:(Recipe *)theRecipe {
      // extract all categories except 'Browse All'
   NSSortDescriptor *descriptor = [[self appDel] sortDescriptorNameAscInsen];
   NSArray *descriptors = [NSArray arrayWithObject:descriptor];
   NSArray *arrayRxCategories = [[theRecipe categories] sortedArrayUsingDescriptors:descriptors];
      //DLog(@"[arrayRxCategories count]=%d",[arrayRxCategories count]);
   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sortIndex != -1"];
   NSArray *minusBrowseAllArray = [arrayRxCategories filteredArrayUsingPredicate:predicate];
      //DLog(@"[minusBrowseAllArray count]=%d",[minusBrowseAllArray count]);
      //return array with all of Recipe's categories except 'Browse All'
   return minusBrowseAllArray;
}



#pragma Window Delegate

- (void) postNotification: (NSString *) notificationName  //observer is the RWC
{
   
   NSNotificationCenter *center;
   center = [NSNotificationCenter defaultCenter];
   
   [center postNotificationName: notificationName
                         object: self];
    
} // postNotification



- (void) windowWillClose: (NSNotification *) notification
{
   //[self postNotification:  RecipeDeactivateNotification];
   DLog(@"windowWillClose:%@",[[self recipe] name ]);
   NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
   
   [center removeObserver:self];
   
   [[myAppController recipeWindowControllerSet] removeObject:self];
   
}  // windowDidClose


#pragma mark KeyViewChain

- (void) updateKeyViewChain {
   
   NSNumber *tabNumber =  self.tabViewRecipe.selectedTabViewItem.identifier;
      //int tabDx = [[self.tabView selectedTabViewItem ] tabDx];
   [[self speechButton] setHidden:NO];
   [[self stopButton] setHidden:NO];
   [self.stopButton   setEnabled:NO];
   [self.speechButton setEnabled:YES];
   
   switch (tabNumber.integerValue) {
      case 1:
         /*[self.speechButton setTransparent:NO];
         [self.stopButton setTransparent:YES];
         [self.stopButton   setEnabled:NO];
         [self.speechButton setEnabled:YES];*/
         
         self.tabViewRecipe.nextKeyView = self.textViewID;
         self.textViewID.nextKeyView = self.speechButton;
         self.speechButton.nextKeyView = self.stopButton;
         self.stopButton.nextKeyView = self.tabViewRecipe;
         
         break;
      case 2:
         /*[self.speechButton setTransparent:NO];
          [self.stopButton setTransparent:YES];
          [self.stopButton   setEnabled:NO];
          [self.speechButton setEnabled:YES];*/
         self.tabViewRecipe.nextKeyView = self.textViewI;
         self.textViewI.nextKeyView = self.speechButton;
         self.speechButton.nextKeyView = self.stopButton;
         self.stopButton.nextKeyView = self.tabViewRecipe;
         break;
      case 3:
            //[self.speechButton setTransparent:NO];
            //[self.stopButton setTransparent:YES];
         [self.stopButton   setEnabled:NO];
         [self.speechButton setEnabled:YES];
         self.tabViewRecipe.nextKeyView = self.textViewD;
         self.textViewD.nextKeyView = self.speechButton;
         self.speechButton.nextKeyView = self.stopButton;
         self.stopButton.nextKeyView = self.tabViewRecipe;
         break;
      case 4: // Comments
              //[self.speechButton setTransparent:NO];
              //[self.stopButton setTransparent:YES];
          [self.stopButton   setEnabled:NO];
          [self.speechButton setEnabled:YES];
         self.tabViewRecipe.nextKeyView = self.textViewC;
         self.textViewC.nextKeyView = self.speechButton;
         self.speechButton.nextKeyView = self.stopButton;
         self.stopButton.nextKeyView = self.tabViewRecipe;
         break;
      case 5: //Categories
         [self.speechButton setHidden:YES];
         [self.stopButton setHidden:YES];
         [self.stopButton setEnabled:NO];
         [self.speechButton setEnabled:NO];
         self.tabViewRecipe.nextKeyView = rxCatTableView  ;
         self.rxCatTableView.nextKeyView = self.tabViewRecipe;
         break;
      default:
         DLog(@"switch value error");
         break;
   }// end switch
   
}


#pragma mark NSTabViewDelegate

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
      //DLog(@"tabViewItem.identifier=%@",tabViewItem.identifier);
      //NSComparisonResult result = [tabViewItem.identifier compare:@"5"];
   if (speechOnGoing) {
      DLog(@"Stop Speech Before Leaving Tab. ");
      [self.speechController stopIt:self];
      
      return; 
   }
   
   [self updateKeyViewChain];
}

/*
- (BOOL)tabView:(NSTabView *)tabView shouldSelectTabViewItem:(NSTabViewItem *)tabViewItem {
   return YES;
} */



@end
