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
//#import "MySpeechStopButton.h"

#import "MyButton.h"
#import "SpeechController.h"
#import "MyTextView.h"
#import "CategoryRx.h"
#import "MyAppController.h"
//extern NSString *RecipeDeactivateNotification;
//extern NSString *RecipeActivateNotification;

//static RecipeWindowController *g_controller;
@interface RecipeWindowController ()
//@property (nonatomic, assign) NSPageControllerTransitionStyle transitionStyle;
//@property (strong,nonatomic) NSArray *imageArray;
@end

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
@synthesize tabViewItemP;
//@synthesize tabViewItemCatsView;
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


#pragma mark awakeFromNib()

- (void) awakeFromNib{
   [super awakeFromNib];// must be called, may be anytime in this method //CHECK 10/22/14 uncommented
   NSArray *photosArray = [NSArray arrayWithArray:self.recipe.photos.allObjects];//photosArray has Photos
   int i= 0;
   if (photosArray.count) {
      NSMutableArray *mutImageArray = [NSMutableArray arrayWithCapacity:[photosArray count]];
      NSImage * theImage;
      Photo *thePhoto;
      NSEnumerator *enumerator = [photosArray objectEnumerator];
      while ((thePhoto  = (Photo  *) [ enumerator nextObject])) {
         if([[thePhoto filename] length]){
            theImage = [NSImage imageNamed:[thePhoto filename]];
         }else{
            theImage = [[NSImage alloc ]initWithData:[thePhoto image]];
         }
         if (theImage) { //may not find the image file
            [theImage setName:[thePhoto photoName]];
            [mutImageArray insertObject:theImage atIndex:i++];
         }else{
            DLog(@"File not found for:%@",thePhoto.photoName);
         }
      }
      _imageArray = mutImageArray;// may have zero objects
   }
   /* Set delegate for NSPageControl */
   [_pageController setDelegate:self];
   /* Set arranged objects for NSPageControl */
   if(_imageArray.count)
      [_pageController setArrangedObjects:_imageArray]; // might be empty
   /* Set transition style, in this example we use book style */
   [_pageController setTransitionStyle:NSPageControllerTransitionStyleStackHistory];
   if (self.pageController.arrangedObjects.count) {
      NSImage *object = [self.pageController.arrangedObjects objectAtIndex:0];
      [_imageView setImage:object];
      [self.pageController setSelectedIndex:0];
   }
   
   [self.window disableKeyEquivalentForDefaultButtonCell];
   
   self.window.initialFirstResponder = tabViewRecipe;
      
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
   
   [textViewID setEditable:NO];
   [textViewI setEditable:NO];
   [textViewD setEditable:NO];
   [textViewC setEditable:NO];
   
   NSString* instrucDirecString = nil;
   if([[self recipe] ingredients] && [[self recipe] directions])
      instrucDirecString=[NSString stringWithFormat:@"%@\n\n%@", [[self recipe] ingredients], [[self recipe] directions]];
   else if([[self recipe] ingredients])
      instrucDirecString=[NSString stringWithFormat:@"%@", [[self recipe] ingredients]];
   else if([[self recipe] directions])
      instrucDirecString=[NSString stringWithFormat:@"%@", [[self recipe] directions]];
   
   if(instrucDirecString.length){
      [[self textViewID] setString:instrucDirecString];
      //[[self textViewID] insertText:@"ABC"];
   }
   if([[[self recipe] ingredients] length])
      [[self textViewI] setString:[[self recipe] ingredients]];
   if([[[self recipe] directions] length])
      [[self textViewD] setString:[[self recipe] directions]];
   if([[[self recipe] comments] length])
      [[self textViewC] setString:[[self recipe] comments]];
   
      DLog(@"\ntextViewI.string  = %@",[[self textViewI] string ]);
      DLog(@"recipe.name=%@\n[[self textViewI] textStorage]=%@",recipe.name,[[self textViewI] textStorage] );
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

- (void)updatePhotoInfoString {
   NSString *info;
   if ([_imageArray count] == 0) {
      info = @"No Photos Found";
      return;
   }
   
   NSImage  *image = [_imageArray objectAtIndex:[_pageController selectedIndex]];
   
   info = [NSString stringWithFormat:@"%ld/%ld %@", ([_pageController selectedIndex]+1), [_imageArray count],image.name ];
   [_infoNameTextField setStringValue:info];
}

/*
- (NSString *)getInfoString {
   NSImage  *image = [_imageArray objectAtIndex:[_pageController selectedIndex]];
   NSString *info = [NSString stringWithFormat:@"%ld/%ld %@", ([_pageController selectedIndex]+1), [_imageArray count],image.name ];
   return info;
}*/


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
         if (speechOnGoing) {
      DLog(@"Stop Speech Before Leaving Tab. ");
      [self.speechController stopIt:self];
      
      return; 
   }
   DLog(@"tabViewItem.identifier=%@",tabViewItem.identifier);
   NSComparisonResult result = [(NSString*)tabViewItem.identifier compare:@"5"];

   if (result != NSOrderedSame) {// if NOT Photos
      //self LoadInfoViewPhotoArray
      //self.infoView
      
      self.speechButton.enabled = YES;
      self.stopButton.enabled = YES;
   }else{ // Photos
      self.speechButton.enabled = NO;
      self.stopButton.enabled = NO;
      [self updatePhotoButtonsEnabled];
      [self updatePhotoInfoString];
   }
   [self updateKeyViewChain];
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

// uncommented 6/10/15
- (BOOL)tabView:(NSTabView *)tabView shouldSelectTabViewItem:(NSTabViewItem *)tabViewItem {
   return YES;
}



@end
