//
//  PrintWindowController.m
//  iHungryMac386
//
//  Created by Apple  User on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrintWindowController.h"
#import "AppDelegate.h"
#import "PrintRecipeArrayController.h"
#import  "RecipePrintView.h"
#import "CategoryRx.h"
#import "MyCatArrayController.h"

   //#import "MyTableView.h"
//static NSString *SelectedPropertyObservationContext;

@implementation PrintWindowController
@synthesize printRecipeArrayController;
@synthesize myAppController;
@synthesize  sortDescriptors;
@synthesize allRecipeArray;
@synthesize printInfo, recipeNowPrinting;
@synthesize isNonZeroRecipePrintCount;
@synthesize appDelegate;
@synthesize checkBoxCol;
@synthesize recipeNameCol;
@synthesize filterPredicate;
@synthesize selectedRecipeCount;
@synthesize isCheckedAllRecipes;
@synthesize recipeCountTextField;
@synthesize printTableView;
@synthesize  selectedRecipe;
@synthesize selectedRecipeCountTextField;
@synthesize isUserOkRequiredForEachRx;
@synthesize isPDF;

- (NSString *) windowNibName{
   return @"PrintWindow";
}

+ (void)initialize{
   [[NSFontManager sharedFontManager] setAction:@selector(changeMyFont:)];
}


- (PrintRecipeArrayController *)printRecipeArrayController{
   if(!printRecipeArrayController){
      printRecipeArrayController = [[PrintRecipeArrayController alloc] init ];
      
   }
   return printRecipeArrayController;
}



- (void) windowWillLoad{
   
   DLog(@"windowWillLoad *****"  );
    
   NSSortDescriptor *desc = 
      [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
   [self setSortDescriptors: [NSArray arrayWithObject:desc]];
   
   [self setAppDelegate:(AppDelegate*)[[NSApplication sharedApplication] delegate]];
   
   NSPredicate *filterBrowseAll = [NSPredicate predicateWithFormat:@"sortIndex > -1"];
   [self setFilterPredicate:filterBrowseAll];
  
   DLog(@"myAppController from PWC=%@",myAppController  );
   
   //DLog(@"printRecipeArrayController=%@",printRecipeArrayController  );
}

- (void)windowDidLoad
{
  
   [super windowDidLoad];
   DLog(@"printTableView=%@",printTableView  );
      //[self.window  setDefaultButtonCell: doneButton.cell];
   [self setIsNonZeroRecipePrintCount:NO];
   
   [self resizeTableViewRowHeight];
   
}


- (IBAction)closePrintSheet: (id)sender
{
   [NSApp endSheet:[self window]];
}


- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
   [sheet orderOut:self];
}


- (NSUInteger) printAllRxFrom:(id) sender{
   [self window];
   
   NSUInteger rxSelectedCount = [self updateRecipePrintCount];
   CategoryRx *selectedCategory = [[[myAppController myCatArrayController] selectedObjects] objectAtIndex:0];
   DLog(@"selectedCategory=%@",selectedCategory.name);
   DLog(@"selectedRecipe.name=%@",self.selectedRecipe.name);
   DLog(@"rxSelectedCount=%u",rxSelectedCount);
      //NSArray *selectedCategoryRecipesArray = [NSArray arrayWithArray: [[selectedCategory recipes] allObjects]];
   
   [self setAllRecipeArray:[[selectedCategory recipes] allObjects]];
   
   int recipeCount = (int)[[[selectedCategory recipes] allObjects] count] ;
   
   [[self recipeCountTextField ] setIntValue:recipeCount];
   [self updateRecipePrintCount];
    
   [self selectNoRecipes:self]; //insure no selected recipes
   rxSelectedCount = [self updateRecipePrintCount];
   DLog(@"2 rxSelectedCount=%lu",(unsigned long)rxSelectedCount);
   DLog(@"self.selectedRecipe.name=%@",self.selectedRecipe.name);
   DLog(@"self.selectedRecipe.selected=%d",self.selectedRecipe.selected);
   if(self.selectedRecipe){ // set in MyAppController
      self.selectedRecipe.selected = YES;//on snow leopard [selectedRecipe setSelected:YES] is not working
      rxSelectedCount = [self updateRecipePrintCount];
      DLog(@"3 rxSelectedCount=%lu",rxSelectedCount);
      DLog(@"self.selectedRecipe.name=%@",self.selectedRecipe.name);
      [[self selectedRecipeCountTextField ] setIntValue:rxSelectedCount];
      [printTableView scrollRowToVisible: [[[self printRecipeArrayController] arrangedObjects] indexOfObject: self.selectedRecipe]];
   } else {
      DLog(@"Error. No Recipe Selected.");
      exit(222);
   }
   
   [self resizeTableViewRowHeight];
   
   [NSApp beginSheet:[self window] modalForWindow:[myAppController window] modalDelegate:self didEndSelector:@selector(didEndSheet:returnCode:contextInfo:) contextInfo:nil];
   
	[NSApp runModalForWindow: [self window]];//Starts a modal event loop for a given window.
	// sheet is up here...
   
   [self closePrintSheet:self];
   
   /****
	[NSApp endSheet:[self window]];
	[[self window] orderOut:self];
   //[[self printRecipeArrayController] release];
   [self close];
   [[printRecipeArrayController arrangedObjects] setValue:[NSNumber numberWithBool: NO] forKey:@"selected"];
   //[self updateRecipePrintCount];
   [self setIsCheckedAllRecipes:NO];
   [self setIsNonZeroRecipePrintCount:NO];
   [self setSelectedRecipeCount:0];
   ****/
	return 0 ;
}


- (IBAction) checkBoxClicked:(id)sender{
   
   [self updateRecipePrintCount ];
   //DLog(@"sender=%@",sender  );

} 


- (NSUInteger) updateRecipePrintCount { //selected Count
   
   NSSet *setRecipe = [NSSet setWithArray:[printRecipeArrayController arrangedObjects]];
   NSPredicate *predicate =
   [NSPredicate predicateWithFormat:@"selected == YES "];
   NSSet *filteredSet =
   [setRecipe filteredSetUsingPredicate:predicate];
   
   //BOOL countNonZero = ([filteredSet count] > 0) ? YES : NO;
   DLog(@"filteredSet.count=%lu",(unsigned long)[filteredSet count]);
   //DLog(@"countNonZero=%d",countNonZero);
   [self setIsNonZeroRecipePrintCount: ([filteredSet count] > 0) ? YES : NO ];
   //DLog(@"filteredSet.count=%d",[filteredSet count]);
   //DLog(@"countNonZero=%d",countNonZero);
   //DLog(@"isNonZeroRecipePrintCount=%d",isNonZeroRecipePrintCount);
   
   [self setSelectedRecipeCount:[filteredSet count]];
   [self setIsCheckedAllRecipes:(selectedRecipeCount == [[printRecipeArrayController arrangedObjects] count] ) ? YES : NO];
   return [filteredSet count];
}


- (IBAction) selectAllRecipes:(id)sender{
   
   [[printRecipeArrayController arrangedObjects] setValue:[NSNumber numberWithBool: YES] forKey:@"selected"];
   [self setIsCheckedAllRecipes:YES];
   [self updateRecipePrintCount];
   [printRecipeArrayController rearrangeObjects];

}


- (IBAction) selectNoRecipes:(id)sender{
   [[printRecipeArrayController arrangedObjects] setValue:[NSNumber numberWithBool: NO] forKey:@"selected"];
   [self setIsCheckedAllRecipes:NO];
   [self updateRecipePrintCount];
   [printRecipeArrayController rearrangeObjects];
}


- (BOOL)printRecipe:(Recipe *)aRecipe
{
   NSPrintOperation    *printOperation;
   [self setPrintInfo:[NSPrintInfo sharedPrintInfo] ];
   self.recipeNowPrinting = aRecipe;
   
   // This will scale the view to fit the page without centering it.
   // It would be better to specify these default settings when
   // the document is created instead of in the print method.
   [[self printInfo] setHorizontalPagination:NSFitPagination];
   [[self printInfo] setHorizontallyCentered:NO];
   [[self printInfo] setVerticallyCentered:NO];
   
   // Setup the print operation with the print info and view
   // + (NSPrintOperation *)printOperationWithView:(NSView *)aView printInfo:(NSPrintInfo *)aPrintInfo
   
   //NSError *error = nil;
   // alternately runOperationModalForWindow:mainWindow
   //NSView *aView = [self printableView];
   // NSPrintInfo *aPrintInfo = [self printInfo];
   
      //runOperationModalForWindow:delegate:didRunSelector:contextInfo:
   ///////////
   
   /* commented 11/17/14
    
   NSPrintInfo *printInfo;
   NSPrintInfo *sharedInfo;
   NSPrintOperation *printOp;
   NSMutableDictionary *printInfoDict;
   NSMutableDictionary *sharedDict;
    */
   /*
    - (void)didEnd:(NSSavePanel *)sheet
    returnCode:(int)code
    saveFormat:(void *)saveType
{
   if (code == NSOKButton)
   {
      if (pageIt)
      {
    NSPrintInfo *printInfo;
    NSPrintInfo *sharedInfo;
    NSPrintOperation *printOp;
    NSMutableDictionary *printInfoDict;
    NSMutableDictionary *sharedDict
   sharedInfo = [NSPrintInfo sharedPrintInfo];
   sharedDict = [sharedInfo dictionary];
   printInfoDict = [NSMutableDictionary dictionaryWithDictionary:
                    sharedDict];
    [printInfoDict setObject:NSPrintSaveJob
    forKey:NSPrintJobDisposition];
    [printInfoDict setObject:[sheet filename] forKey:NSPrintSavePath];
    printInfo = [[NSPrintInfo alloc] initWithDictionary: printInfoDict];
   [printInfo setHorizontalPagination: NSAutoPagination];
   [printInfo setVerticalPagination: NSAutoPagination];
   [printInfo setVerticallyCentered:NO];
    printOp = [NSPrintOperation printOperationWithView:textView
    printInfo:printInfo];
    [printOp setShowPanels:NO];
    [printOp runOperation];
    */
   //////////////////////////
   /// DISPLAY PANEL FOR USER TO OK OR CANCEL
   printOperation = [NSPrintOperation printOperationWithView:(NSView*)[self printableView] printInfo:[self printInfo] ];
   
   [printOperation setShowsPrintPanel:self.isUserOkRequiredForEachRx];
   //[printOperation setShowsPrintPanel:YES];
   
   //[printOperation runOperationModalForWindow:[self window] delegate:nil
   //                            didRunSelector:NULL contextInfo:NULL];
   BOOL isOK = [printOperation runOperation];// if OK printing is done
   
  self.isUserOkRequiredForEachRx = !isOK; // if the first printOp is OK the the rest are auto-OK'd
   
   DLog(@"OK=%d",isOK); // cancel == !OK
   NSString *destFormat = [[printOperation.printPanel.printInfo dictionary] valueForKey:@"NSDestinationFormat"];
   if (printOperation.printPanel.printInfo) {
      NSComparisonResult result = [destFormat compare:@"application/pdf"];
      self.isPDF = (result == NSOrderedSame) ? YES : NO;
   }
   
   DLog(@"isPDF=%d",isPDF);

   /*
   BOOL isOK = [printOperation runOperation];
   BOOL isDelivered = [printOperation deliverResult];
   DLog(@"isOK=%@", (isOK == YES) ? @"YES" : @"NO");
   DLog(@"isDelivered=%@", (isDelivered == YES) ? @"YES" : @"NO");*/
return isOK; // continue printing next Rx in list
}


- (NSView *)printableView
{
   NSTextView    *printView;
   NSDictionary    *titleAttr;
   
   // CREATE THE PRINT VIEW
   // 480 pixels wide seems like a good width for printing text
   //printView = [[[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, 480, 200)] autorelease];
   //NSPrintInfo *aPrintInfo = [self printInfo];
   printView = [[NSTextView alloc] initWithFrame:[[self printInfo] imageablePageBounds]];
   [printView setVerticallyResizable:YES];
   [printView setHorizontallyResizable:NO];
   
   // ADD THE TEXT
   // This assumes there is an NSTextField called titleField
   // and an NSTextView called mainTextView
   
   [[printView textStorage] beginEditing];
   
   // Set the attributes for the title
   //titleAttr = [NSDictionary dictionaryWithObject:[NSFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
   
   titleAttr = 
   
     [NSDictionary dictionaryWithObject:[(AppDelegate*)[[NSApplication sharedApplication] delegate] tableFont] forKey:NSFontAttributeName];
   
   
   
   // Add the title
   ///initWithString:[titleField stringValue] attributes:titleAttr] autorelease] ]];
   [
    [printView textStorage] appendAttributedString:
    [[NSAttributedString alloc] initWithString:[recipeNowPrinting name]  attributes:titleAttr ] 
   ];
   
   // Create a couple returns between the title and the body
   [[printView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
   
   // Add the body text
   if([[recipeNowPrinting ingredients] length] )
       [[printView textStorage] appendAttributedString: [ [NSAttributedString alloc] 
                  initWithString:[recipeNowPrinting ingredients] attributes:titleAttr]];
   // Create a couple returns between the ingredients and the directions
   [[printView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
   
   if([[recipeNowPrinting directions] length] )
      [[printView textStorage] appendAttributedString: [ [NSAttributedString alloc] 
                     initWithString:[recipeNowPrinting directions] attributes:titleAttr]];
   // Create a couple returns between the directions and the comments
   [[printView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
   
   if([[recipeNowPrinting comments] length] )
      [[printView textStorage] appendAttributedString: [ [NSAttributedString alloc] 
                     initWithString:[recipeNowPrinting comments] attributes:titleAttr]];
   
   // Center the title
   ///[printView setAlignment:NSCenterTextAlignment range:NSMakeRange(0, [[titleField stringValue] length])];
   [printView setAlignment:NSCenterTextAlignment range:NSMakeRange(0, [[[self window] title] length])];
   
   [[printView textStorage] endEditing];
   
   // Resize the print view to fit the added text
   // (Is this done automatically?)
   [printView sizeToFit];
   
   return printView;
}

/****
- (NSPrintOperation *)printOperationWithSettings:(NSDictionary *)ps error:(NSError **)e 
{ 
   RecipePrintView *view = [[RecipePrintView alloc] init]; 
   //NSPrintInfo *printInfo = [self printInfo]; 
   NSPrintOperation *printOp = [NSPrintOperation printOperationWithView:view                                   printInfo:[self printInfo]]; 
   [view release]; 
   return printOp; 
   
} ***/


- (IBAction)done:(id)sender{ // this is the PRINT button action
   // TIME TO PRINT SELECTED RECIPE(S)
  
   NSArray *selectedRecipeArray = [[printRecipeArrayController arrangedObjects] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"selected == 1"]];
   DLog(@"selectedRecipeArray.count=%lu", (unsigned long)[selectedRecipeArray  count]);
   NSEnumerator *enumerator = [selectedRecipeArray objectEnumerator];
   Recipe *aRecipe;
   BOOL isPrintOK = YES;
   self.isUserOkRequiredForEachRx = YES; // Set to NO means 1st printOP was OK'd so do rest automatically
   while ((aRecipe = [enumerator nextObject]) && isPrintOK) {
      [myAppController  setRecipePrinting:aRecipe];
      isPrintOK = [self printRecipe:aRecipe];   // print next recipe
   }
	[NSApp stopModal];
}


- (IBAction)cancel:(id)sender{
   
	[NSApp abortModal];
}

 
- (void) resizeTableViewRowHeight{
   NSFont * aFont = [(AppDelegate *)[NSApp delegate] tableFont] ;
   [[self printTableView] setRowHeight:4.0 + (1.0 * [aFont pointSize])];
   [[self printTableView] reloadData];
   
}


-(void)changeMyFont:(id)sender
{
   [self resizeTableViewRowHeight];
}






@end
