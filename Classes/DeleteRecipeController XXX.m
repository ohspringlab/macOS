//
//  DeleteRecipeController.m
//  iHungryMac386
//
//  Created by Apple  User on 12/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DeleteRecipeController XXX.h"
#import "MyAppController.h"
#import "AppDelegate.h"
#import "RecipeDefines.h"
#import "Recipe.h"
#import "AppDelegate.h"
#import "Constants.h"

@implementation DeleteRecipeController

@synthesize  textFieldRecipeName,savedRecipeName,textFieldWarning;
//@synthesize  myArrayController;
@synthesize cancelled;
@synthesize recipe;
@synthesize myAppController;
@synthesize textViewIngredients,textViewDirections,textViewComments;
//@synthesize rxRxNameTableCol; - TxFieldCell font Bound in XCode
@synthesize tabView;
@synthesize categoryArrayController;
@synthesize appDel;
@synthesize  smallPanelFont;
@synthesize arrayTheRecipeCats;
@synthesize rxCatTableView;
@synthesize doneButton,cancelButton;
// -------------------------------------------------------------------------------
//	windowNibName
// -------------------------------------------------------------------------------

- (NSString *)windowNibName
{
	return @"DeleteRecipe";
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

- (void) updatePanelFont {
      ////AppDelegate *appDel = [[NSApplication sharedApplication] delegate];
   NSFontDescriptor *descriptor = [appDel.tableFont fontDescriptor];
   int fontSize = MAX_SMALL_PANEL_FONT_SIZE;
   if(descriptor.pointSize < MAX_SMALL_PANEL_FONT_SIZE)
      fontSize = descriptor.pointSize;
   self.smallPanelFont = [NSFont fontWithDescriptor:descriptor  size:fontSize];
   DLog(@"fontSize=%d",fontSize);
}


- (void)awakeFromNib{
   /**
   NSArray *selectedObjects = [[[self.appDel myAppController ] rxFilteredArrayController] selectedObjects];
   Recipe *theRecipe = [selectedObjects objectAtIndex:0];
   [self setRecipe:theRecipe];
   **/
   [self setAppDel:[[NSApplication sharedApplication] delegate]];
   [[self textViewIngredients] setFont:[appDel tableFont]];
   [[self textViewDirections] setFont:[appDel tableFont]];
   [[self textViewComments] setFont:[appDel tableFont]];
   [self updatePanelFont];
}


- (id)initWithWindowNibName:(NSString *)windowNibName 
{
    if (self = [super initWithWindowNibName:windowNibName ]) {
    // Custom initialization
    }
 return self;
}


- (void)windowDidLoad
{
    [super windowDidLoad];
   [[self textViewIngredients] setFont:[appDel tableFont]];
   [[self textViewDirections] setFont:[appDel tableFont]];
   [[self textViewComments] setFont:[appDel tableFont]];
  
   [[self textFieldWarning] setStringValue:@"*** Recipe is to be DELETED! ***" ];
   
   [[self textFieldRecipeName] setStringValue:[[self recipe] name] ];
   [[self textViewIngredients] setEditable:NO];
   [[self textViewDirections] setEditable:NO];
   [[self textViewComments] setEditable:NO];
   
   if ([[self recipe] ingredients])
      [[self textViewIngredients]  setString:[[self recipe] ingredients] ];
   if ([[self recipe] directions])
      [[self textViewDirections]  setString:[[self recipe] directions] ];
   if ([[self recipe] comments])
      [[self textViewComments]  setString:[[self recipe] comments] ];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}


- (NSString*) deleteRxFrom: (MyAppController *)sender
{
	NSWindow *window = [self window];
	cancelled = NO;
   
   NSArray *catArrayMinusBA = [self getRxCategoriesArrayMinusBA:self.recipe];//from theRecipe displayed
   [self setArrayTheRecipeCats:catArrayMinusBA];//property bound to ArrayController
   [self.window disableKeyEquivalentForDefaultButtonCell]; // Enter-Key activates no button now
   
   if(self.myAppController){ // second or later use of panel
      [[self window] setDefaultButtonCell:[cancelButton cell]];
      [self updatePanelFont];
      
      [[self textViewIngredients] setFont:[appDel tableFont]];
      [[self textViewDirections] setFont:[appDel tableFont]];
      [[self textViewComments] setFont:[appDel tableFont]];
      NSArray *selectedObjects = [[myAppController rxFilteredArrayController] selectedObjects];
      Recipe *theRecipe = [selectedObjects objectAtIndex:0];
      
      [self setRecipe:theRecipe];
      [self setRecipe:theRecipe];
      [[self textFieldWarning] setStringValue:@"*** Recipe is to be DELETED! ***" ];
      
      [[self textFieldRecipeName] setStringValue:[[self recipe] name] ];
      [[self textViewIngredients] setEditable:YES];
      [[self textViewDirections] setEditable:YES];
      [[self textViewComments] setEditable:YES];
      
      if ([[self recipe] ingredients])
         [[self textViewIngredients]  setString:[[self recipe] ingredients] ];
      if ([[self recipe] directions])
         [[self textViewDirections]  setString:[[self recipe] directions] ];
      if ([[self recipe] comments])
         [[self textViewComments]  setString:[[self recipe] comments] ];
      
   }
   [self setMyAppController: (MyAppController *) sender];
   
      //DLog(@"textViewIngredients has %@", [textViewIngredients string]);
   [[self rxCatTableView] deselectAll:self];
	[NSApp beginSheet:window modalForWindow:[sender window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
	[NSApp runModalForWindow:[self window]];
	// sheet is up here...
   
	[NSApp endSheet:window];
	[window orderOut:self];
   
	return savedRecipeName ;
}

// -------------------------------------------------------------------------------
//	done:sender
// -------------------------------------------------------------------------------
- (IBAction)done:(id)sender
{
	
   [self setSavedRecipeName:[textFieldRecipeName stringValue]]; 
   
   NSManagedObjectContext *managedObjectContext = 
      [[myAppController  appDelegate] managedObjectContext];
   
   [managedObjectContext deleteObject:[self recipe]];

   NSError *error = nil;
	if (![managedObjectContext save:&error]) { // context is from AppDel  // DELETE
		DLog(@"deleteRecipeControler:Unresolved error %@, %@", error, [error userInfo]);
		exit(-421);  // Fail
	}else{
      NSInteger savedIndex = [[myAppController tableViewCat] selectedRow];
      [[myAppController appDelegate] updateGlobalCategoryArray];//namely [appDel categoryArray]
      //[[myAppController appDelegate] updateLocalCategoryArray];
      
		[[myAppController tableViewRx] reloadData];
       
       NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:savedIndex];
       [[myAppController tableViewCat] selectRowIndexes:indexSet byExtendingSelection:NO];
	}   
	
	[NSApp stopModal];
}

// -------------------------------------------------------------------------------
//	cancel:sender
// -------------------------------------------------------------------------------
- (IBAction)cancel:(id)sender
{
	[NSApp abortModal];
   //[self setTextFieldNew:@""];
	cancelled = YES;
}

// -------------------------------------------------------------------------------
//	wasCancelled
// -------------------------------------------------------------------------------
- (BOOL)wasCancelled
{
	return cancelled;
}


#pragma NSTabViewDelegate

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem{
   
   if ([[tabViewItem identifier]intValue] == 5) {
      [[self theNewCategoryNameBox] setHidden:NO];
      
      //[[[self categoryArrayController] arrangedObjects] setSelectionIndex:selectedCategoryIndexInMain];
      //[[self categoryArrayController] setSelectionIndex:selectedCategoryIndexInMain];
   }else{
      [[self theNewCategoryNameBox] setHidden:YES];
   }
 
}


@end
