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
#import <Quartz/Quartz.h>

   //#import "MyTableView.h"
//static NSString *SelectedPropertyObservationContext;

@implementation PrintWindowController
@synthesize printRecipeArrayController;
@synthesize myAppController;
@synthesize  sortDescriptors;
@synthesize allRecipeArray;
//@synthesize recipeNowPrinting;
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

@synthesize printView = _printView;
///@synthesize tempDirectoryURL = _tempDirectoryURL;
@synthesize savePanelURL = _savePanelURL;
///@synthesize documentsPath = _documentsPath;

- (NSString *) windowNibName{
   return @"PrintWindow";
}

+ (void)initialize{
   [[NSFontManager sharedFontManager] setAction:@selector(changeMyFont:)];
}

/*
- (NSURL *)tempDirectoryURL {
    NSURL *tempURL;
    if(!_tempDirectoryURL){
        tempURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]] isDirectory:YES];
        DLog(@"tempDirURL=%@",tempURL);
        _tempDirectoryURL = tempURL;
    }
    return _tempDirectoryURL;
}*/

/*
- (NSString *)documentsPath {
    if(!_documentsPath){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        _documentsPath = path;
    }
    return _documentsPath;
}*/

/*
//NSURL *tempDirectoryURL = [NSURL fileURLWithPath:@"/Users/mbarron/Documents/PDFTempfiles"];
//NSURL *tempDirectoryURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]] isDirectory:YES];
- (NSURL *)tempDirectoryURL{
    NSURL* tempURL;
    if(!_tempDirectoryURL){
        tempURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]] isDirectory:YES];
        BOOL exists =
        [[NSFileManager defaultManager] fileExistsAtPath:[tempURL path]];
        //[NSURL fileURLWithPath:@"/Users/mbarron/Documents/PDFTempfiles" ];
        NSError *error = nil;
        if (!exists) {
            BOOL success =
            [[NSFileManager defaultManager] createDirectoryAtURL:tempURL withIntermediateDirectories:YES attributes:nil error:&error];
            if(!success && error)
                DLog(@"Error creating _tempDirectory.Error = \n%@",error);
            else if(success)
                DLog(@"created dir at tempURL:\n%@",tempURL);
        }
        _tempDirectoryURL = tempURL;
    }
    DLog(@"returning:\n%@",_tempDirectoryURL);
    if (!_tempDirectoryURL) {
        DLog(@"Error:tempDirectoryURL return=%@",_tempDirectoryURL);
    }
    return _tempDirectoryURL;
}
 

//Setter method
- (void) setTempDirectoryURL:(NSURL *)url {
    NSLog(@"Setting tempDirectory to: %@", url);
    
    _tempDirectoryURL = url;
}
 */

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
    //called from:- (IBAction) printAllRecipeAction:(id)sender
  
    [self window];
   NSUInteger rxSelectedCount;/// = [self updateRecipePrintCount];
   CategoryRx *selectedCategory = [[[myAppController myCatArrayController] selectedObjects] objectAtIndex:0];
   //DLog(@"selectedCategory=%@",selectedCategory.name);
   //DLog(@"selectedRecipe.name=%@",self.selectedRecipe.name);
   //DLog(@"rxSelectedCount=%lu",(unsigned long)rxSelectedCount);
   
   [self setAllRecipeArray:[[selectedCategory recipes] allObjects]];
   
   int recipeCount = (int)[[[selectedCategory recipes] allObjects] count] ;
   
   [[self recipeCountTextField ] setIntValue:recipeCount];
   [self updateRecipePrintCount];
    
   [self selectNoRecipes:self]; //insure no selected recipes
   rxSelectedCount = [self updateRecipePrintCount];
   ///DLog(@"2 rxSelectedCount=%lu",(unsigned long)rxSelectedCount);
   ///DLog(@"self.selectedRecipe.name=%@",self.selectedRecipe.name);
   ///DLog(@"self.selectedRecipe.selected=%d",self.selectedRecipe.selected);
   if(self.selectedRecipe){ // set in MyAppController
      self.selectedRecipe.selected = YES;//on snow leopard [selectedRecipe setSelected:YES] is not working
      rxSelectedCount = [self updateRecipePrintCount];
      ///DLog(@"3 rxSelectedCount=%lu",(unsigned long)rxSelectedCount);
      ///DLog(@"self.selectedRecipe.name=%@",self.selectedRecipe.name);
      [[self selectedRecipeCountTextField ] setIntValue:(int)rxSelectedCount];
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
   //DLog(@"filteredSet.count=%lu",(unsigned long)[filteredSet count]);
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

- (void)didEnd:(NSSavePanel *)sheet
    returnCode:(int)code
    saveFormat:(void *)saveType
{
    DLog(@"HHH");
}


- (void)addOutlineToDoc:(PDFDocument *)outputDocument recipeList:(NSArray*)recipeArray firstPageIndeces:(NSArray*)firstPageIndeces {
   Recipe *recipe;
   PDFOutline *outline;
   PDFDestination *destination;
   //PDFOutline *rootOutline = outputDocument.outlineRoot;
   NSEnumerator *enumerator = [recipeArray objectEnumerator];
   int docIndex = 0;
   PDFOutline *rootOutline = [[PDFOutline alloc] init];
   NSNumber* docFirstPageIndexNum;
   NSUInteger  docFirstPageDx;
   PDFPage* docFirstPage;
   while (recipe = [enumerator nextObject]) {
      docFirstPageIndexNum = (NSNumber*)[firstPageIndeces objectAtIndex:docIndex];
      docFirstPageDx = [docFirstPageIndexNum unsignedIntegerValue];
   //   DLog(@"docFirstPageDx=%lu",docFirstPageDx);
      docFirstPage = [outputDocument pageAtIndex:docFirstPageDx];
      destination = [[PDFDestination alloc] initWithPage:docFirstPage atPoint:NSMakePoint(0, 734 + 112)];
      outline = [[PDFOutline alloc] init];
      [outline setLabel:recipe.name];
   //   DLog(@"outline.label=%@",outline.label);
      [outline setDestination:destination];
      [rootOutline insertChild:outline atIndex:docIndex++];
      //[rootOutline insertChild:outline atIndex:0];
     // DLog(@"inserted outline as child at index:%d for Rx:%@",docIndex - 1,recipe.name);
   }
   [outputDocument setOutlineRoot:rootOutline];
}


- (void) createMigratePdfTempfilesForRestOfList:(NSPrintInfo*) ppPrintInfo{//USED
   
   // NSJobSavingURL = "file:///Users/mbarron/Documents/Untitled.pdf";
   //NSSavePath = "/Users/mbarron/Documents/Untitled.pdf";

   NSPrintInfo *printInfo;
   NSPrintInfo *sharedInfo;
   NSPrintOperation *printOp;
   NSMutableDictionary *printInfoDict;
   NSMutableDictionary *sharedDict;
   [printOp setShowsProgressPanel:NO];
   //need to alter NSJobSavingURL = "file:///Users/mbarron/Documents/Untitled.pdf";
   NSUInteger index = 1;
   NSArray *selectedRecipeArray = [[printRecipeArrayController arrangedObjects] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"selected == 1"]];
   NSEnumerator *enumerator = [selectedRecipeArray objectEnumerator];
   Recipe *aRecipe,*firstRx;
   firstRx=[enumerator nextObject];//skip first recipe, which is already printed
   NSUInteger pageCountOut;
   //BOOL firstRecipeWritten = NO; // Rx #1 is already in outputDoc
   NSString *documentsDirectory;
   PDFDocument *outputDocument = [[PDFDocument alloc] initWithURL:[NSURL fileURLWithPath:_pdfSavePath]];// has Rx(0)
   NSMutableArray *mutRayFirstPageIndeces = [[NSMutableArray alloc] initWithCapacity:selectedRecipeArray.count];
   [mutRayFirstPageIndeces addObject:[NSNumber numberWithInteger:0]];//index - first page of first Rx
   NSString *uniqueIdentifier = [[NSProcessInfo processInfo] globallyUniqueString];
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   documentsDirectory = [paths objectAtIndex:0];
   NSString *tempDir = [documentsDirectory stringByAppendingPathComponent:uniqueIdentifier];
   NSError *error = nil;
   if (![[NSFileManager defaultManager] fileExistsAtPath:tempDir])
      [[NSFileManager defaultManager] createDirectoryAtPath:tempDir withIntermediateDirectories:NO attributes:nil error:nil];
   //[[NSFileManager defaultManager] createDirectoryAtPath:tempDir  withIntermediateDirectories:NO attributes:nil  error:&error];
   NSDictionary *attributesDir = [[NSFileManager defaultManager] attributesOfItemAtPath:tempDir error:&error];
   NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:attributesDir ];
   
   [attributes setValue:[NSNumber numberWithShort:0777]
                 forKey:NSFilePosixPermissions];

   error = nil;
   
   NSNumber *posix = [attributes valueForKey:@"NSFilePosixPermissions"] ;
   //NSInteger intValue = [posix shortValue];
   BOOL didCreateTempfiles = NO;
   DLog(@"tempDir=%@",tempDir);
   sharedInfo = [NSPrintInfo sharedPrintInfo];
   sharedDict = [sharedInfo dictionary];
   printInfoDict = [NSMutableDictionary dictionaryWithDictionary: sharedDict];
   [printInfoDict setObject:NSPrintSaveJob
                     forKey:NSPrintJobDisposition];
   printInfo = [[NSPrintInfo alloc] initWithDictionary:printInfoDict];
   [printInfo setHorizontalPagination: NSFitPagination];//0,1,2 auto,fit,clip
   [printInfo setVerticalPagination: NSAutoPagination];
   [printInfo setVerticallyCentered:NO];
   while (firstRx && (aRecipe = [enumerator nextObject]) ) { //add 2nd and after
      NSString *fileName = [NSString stringWithFormat:@"tempPdfFile%lu.pdf",index++];
      [myAppController  setRecipePrinting:aRecipe];// UNNECESSARY
      
      NSString *path = [tempDir stringByAppendingPathComponent:fileName];
      [printInfoDict setObject:[NSURL fileURLWithPath:path
                                              isDirectory:NO] forKey:@"NSJobSavingURL"];
      DLog(@"printInfoDict=%@",printInfoDict);
      printInfo = [[NSPrintInfo alloc] initWithDictionary:printInfoDict];
      NSTextView *textView = (NSTextView*) [self printableView:aRecipe];
      printOp = [NSPrintOperation printOperationWithView:textView printInfo:printInfo];
      [printOp setShowsPrintPanel:NO]; //NSPaperSize = "NSSize: {612, 792}";
      //po [[self printInfo] imageablePageBounds]
      //(x=18, y=40), (width=576, height=734)
      [printOp setShowsProgressPanel:NO];
      
      [printOp runOperation]; // write tempFile
      PDFDocument *inputDocument = [[PDFDocument alloc] initWithURL:[NSURL fileURLWithPath:path]];
      if(!outputDocument){DLog(@"outputDoc=nil");exit(-66);}
      if(!inputDocument){DLog(@"inputDoc=nil");exit(-67);}
      didCreateTempfiles = YES;
     //already have rx#1. Here have 2nd or later recipe added
     // if(!firstRecipeWritten)
      pageCountOut = [outputDocument pageCount] ;// 1 or 2
      DLog(@"Rx=%@",aRecipe.name) ;DLog(@"[outputDocument pageCount]=%lu",[outputDocument pageCount]) ;
      [mutRayFirstPageIndeces addObject:[NSNumber numberWithInteger:[outputDocument pageCount]]];//index for first page for Rx
      for (NSUInteger j = 0; j < [inputDocument pageCount]; j++) {
         DLog(@"Inserting tempFile's pageNumber:%lu i.e inputPage:%lu of %lu",j+1,j+1,[inputDocument pageCount]);
         DLog(@"1 outputDocument.pageCount=%lu",[outputDocument pageCount]);
         DLog(@"inserting page at index:%lu",pageCountOut);
         [outputDocument insertPage:[inputDocument pageAtIndex:j] atIndex:pageCountOut++];
         DLog(@"2 outputDocument.pageCount=%lu",[outputDocument pageCount]);
      }
   }// end while
   
   [self addOutlineToDoc:outputDocument recipeList:selectedRecipeArray firstPageIndeces:mutRayFirstPageIndeces];
   [outputDocument writeToURL:[NSURL fileURLWithPath:_pdfSavePath]];
      // DELETE TEMPFILE FOLDER
//#ifndef DEBUG
      error=nil;
      BOOL success =[[NSFileManager defaultManager] removeItemAtPath:tempDir error:&error];
      if (!success && error) {
         DLog(@"Error deleting tempPdfFolder:%@",error);
      }
//#endif
}

- (BOOL)printRecipe:(Recipe *)aRecipe
{//used BOTT PDF and PAPER
   NSPrintOperation    *printOperation;
   [self setPrintInfo:[NSPrintInfo sharedPrintInfo] ];
   self.recipeNowPrinting = aRecipe;
   // It would be better to specify these default settings when
   // the document is created instead of in the print method.
   [[self printInfo] setHorizontalPagination:NSFitPagination];
   [[self printInfo] setHorizontallyCentered:NO];
   [[self printInfo] setVerticallyCentered:NO];
   //////////////////////////
   /// DISPLAY PANEL FOR USER TO OK OR CANCEL
   printOperation = [NSPrintOperation printOperationWithView:(NSView*)[self printableView:aRecipe] printInfo:[self printInfo] ];
   
   //[printOperation setShowsPrintPanel:self.isUserOkRequiredForEachRx];
   [printOperation setShowsPrintPanel:NO];
   
   BOOL isOK = [printOperation runOperation];// if OK printing is done
   
   return isOK; // continue printing next Rx in list
}




- (NSView *)printableView:(Recipe*)recipe
{
    ////
    //  USE for paper printing ALSO testing for PDF
    ////
   NSTextView    *printView;
   NSDictionary    *titleAttr;
   NSDictionary    *recipeAttr;
   // CREATE THE PRINT VIEW
   // 480 pixels wide seems like a good width for printing text
   //printView = [[[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, 480, 200)] autorelease];
   CGRect rect = [[self printInfo] imageablePageBounds];
   DLog(@"recipe.name=%@ ",recipe.name);
   DLog(@"rect.origin.x=%f\nrect.origin.y=%f",rect.origin.x,rect.origin.y);
   DLog(@"rect.size.width=%f\nrect.size.height=%f",rect.size.width,rect.size.height);
   printView = [[NSTextView alloc] initWithFrame:[[self printInfo] imageablePageBounds]];
   [printView setVerticallyResizable:YES];
   [printView setHorizontallyResizable:NO];
   // ADD THE TEXT
   // This assumes there is an NSTextField called titleField
   // and an NSTextView called mainTextView
   [[printView textStorage] beginEditing];
   // Set the attributes for the title
   titleAttr = [NSDictionary dictionaryWithObject:[NSFont boldSystemFontOfSize:16] forKey:NSFontAttributeName];
   recipeAttr =
     [NSDictionary dictionaryWithObject:[(AppDelegate*)[[NSApplication sharedApplication] delegate] tableFont] forKey:NSFontAttributeName];
   // Add the title
   [
    [printView textStorage] appendAttributedString:
    [[NSAttributedString alloc] initWithString:[recipe name]  attributes:titleAttr ]
   ];
   // Create a couple returns between the title and the body
   [[printView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
   // Add the body text
   if([[recipe ingredients] length] )
       [[printView textStorage] appendAttributedString: [ [NSAttributedString alloc] 
                  initWithString:[recipe ingredients] attributes:recipeAttr]];
   // Create a couple returns between the ingredients and the directions
   [[printView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
   if([[recipe directions] length] )
      [[printView textStorage] appendAttributedString: [ [NSAttributedString alloc] 
                     initWithString:[recipe directions] attributes:recipeAttr]];
   // Create a couple returns between the directions and the comments
   [[printView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
   if([[recipe comments] length] )
      [[printView textStorage] appendAttributedString: [ [NSAttributedString alloc] 
                     initWithString:[recipe comments] attributes:recipeAttr]];
   // Center the title
   [printView setAlignment:NSCenterTextAlignment range:NSMakeRange(0, [recipe.name length])];
   ///[printView setAlignment:NSCenterTextAlignment range:NSMakeRange(0, [[recipe name]  length])];
   [[printView textStorage] endEditing];
   //DLog(@"[[printView textStorage]string]=%@",[[printView textStorage]string]);
   // Resize the print view to fit the added text
   // (Is this done automatically?)
   [printView sizeToFit];
   
   return printView;
}


- (NSPrintInfo *)getPdfPrintInfoForFirstRecipe { //USED
   NSPrintInfo *pdfPrintInfo ;
   NSMutableDictionary *dict = [[NSPrintInfo sharedPrintInfo] dictionary];
   [dict setObject:NSPrintSaveJob forKey:NSPrintJobDisposition];
   //NSPrintSpoolJob is a normal print job.//NSPrintPreviewJob sends the print job to the Preview application.//NSPrintSaveJob saves the print job to a file.
   [dict setObject:_savePanelURL forKey:NSPrintJobSavingURL];
   pdfPrintInfo = [[NSPrintInfo alloc] initWithDictionary:dict];
   //[pdfPrintInfo setHorizontalPagination:NSAutoPagination];
   //[pdfPrintInfo setVerticalPagination:NSAutoPagination];
   
   return pdfPrintInfo;
}


- (void)printPanelDidEnd:(NSPrintPanel *)printPanel returnCode:(NSInteger)returnCode  contextInfo: (void *)contextInfo{
   // ACTUALLY NSSavePanel here for PDF and paper
   NSPrintInfo *printInfo;
   if (returnCode == NSOKButton){
      printInfo = printPanel.printInfo;
      _savePanelURL = [printInfo.dictionary objectForKey:@"NSJobSavingURL"] ;//[[NSSavePanel savePanel] URL ];
      NSArray *selectedRecipeArray = [[printRecipeArrayController arrangedObjects] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"selected == 1"]];
      //DLog(@"selectedRecipeArray.count=%lu", (unsigned long)[selectedRecipeArray  count]);
      NSEnumerator *enumerator = [selectedRecipeArray objectEnumerator];
      Recipe *aRecipe;
      BOOL isPrintOK = YES;
      self.isUserOkRequiredForEachRx = YES; // Set to NO means 1st printOP was OK'd so do rest automatically
      NSString *destFormat = [[printPanel.printInfo dictionary] valueForKey:@"NSDestinationFormat"];
      NSComparisonResult result = [destFormat compare:@"application/pdf"];
      self.isPDF = (result == NSOrderedSame) ? YES : NO;
      
      if (self.isPDF) {
         _pdfSavePath = [[printPanel.printInfo dictionary] valueForKey:@"NSSavePath"];
         // Create Doc with first Recipe
         // then call - (void)createMigratePdfTempfilesForRestOfList:(NSPrintInfo*) ppPrintInfo
         /***
          NEED TO SEND PDF printInfo to printRecipe:
          ***/
         NSPrintInfo *pdfPrintInfo = [self getPdfPrintInfoForFirstRecipe];
         _printInfo = pdfPrintInfo;// compare self.printInfo
         [self printRecipe:[selectedRecipeArray objectAtIndex:0]];
         [self createMigratePdfTempfilesForRestOfList:pdfPrintInfo];
      } else { // handle paper printing
         while ((aRecipe = [enumerator nextObject]) && isPrintOK) {
            [myAppController  setRecipePrinting:aRecipe];
            isPrintOK = [self printRecipe:aRecipe];   // print next recipe
         }
      }
      [NSApp stopModal];
   }else{
      DLog(@"Cancel");
   }
}

- (IBAction)done:(id)sender{ // this is the PRINT button action
   // TIME TO PRINT SELECTED RECIPE(S)
   NSPrintPanel *printPanel = [[NSPrintPanel alloc] init];
   printPanel.jobStyleHint = NSPrintAllPresetsJobStyleHint;//NSPrintNoPresetsJobStyleHint;
   
   [printPanel beginSheetWithPrintInfo:[NSPrintInfo sharedPrintInfo]
                        modalForWindow:self.window
                              delegate:self
                        didEndSelector:@selector (printPanelDidEnd:returnCode: contextInfo:)
                           contextInfo:nil];
}




/***
- (IBAction)done:(id)sender{ // this is the -- "PRINT" -- button action
   // TIME TO PRINT SELECTED RECIPE(S) -- waiting for Print Details panel, which has PDF button
    
   // _printInfo = [[[NSPrintInfo alloc] initWithDictionary: _printInfoDict];
   [self.printInfo setHorizontalPagination: NSAutoPagination];
   [self.printInfo setVerticalPagination: NSAutoPagination];
   [self.printInfo setVerticallyCentered:NO];
   NSArray *selectedRecipeArray = [[printRecipeArrayController arrangedObjects] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"selected == 1"]];
   DLog(@"selectedRecipeArray.count=%lu", (unsigned long)[selectedRecipeArray  count]);
   NSEnumerator *enumerator = [selectedRecipeArray objectEnumerator];
   Recipe *aRecipe;
   BOOL isPrintOK = YES;
   self.isUserOkRequiredForEachRx = NO; // Set to NO means 1st printOP was OK'd so do rest automatically
    // NO PrintPanel yet
    
   while ((aRecipe = [enumerator nextObject]) && isPrintOK) { //
      [myAppController  setRecipePrinting:aRecipe];
      isPrintOK = [self printRecipe:aRecipe];   // print next PAPER recipe. Examine there the printInfo.
       DLog(@"isPrintOK=%d",isPrintOK);
   }
   _savePanelURL = nil;
   _savePanelURL = [[NSSavePanel savePanel] URL ];
   //
   if (!self.isPDF) { // the above was skipped. Need to handle PDF here.
     //
     // CHECK AT HOME  !!!!!
     //
     //NSPrintInfo *printInfo;
     NSPrintInfo *sharedInfo;
     NSPrintOperation *printOp;
     NSMutableDictionary *printInfoDict;
     NSMutableDictionary *sharedDict;
     sharedInfo = [NSPrintInfo sharedPrintInfo];
     sharedDict = [sharedInfo dictionary];
     printInfoDict = [NSMutableDictionary dictionaryWithDictionary:
                      sharedDict];
     [printInfoDict setObject:NSPrintSaveJob
                       forKey:NSPrintJobDisposition];
     [printInfoDict setObject:[[NSSavePanel savePanel] URL]  forKey:NSPrintJobSavingURL]; // corrected to path
     // reset enumerator
     enumerator = [selectedRecipeArray objectEnumerator];
     while ((aRecipe = [enumerator nextObject]) ) {
         [myAppController  setRecipePrinting:aRecipe];
         //isPrintOK = [self printRecipe:aRecipe];   // print next recipe. Examine there the printInfo.
         // [[printOperation.printPanel.printInfo dictionary] valueForKey:@"NSDestinationFormat"];
        printOp = [NSPrintOperation printOperationWithView:[self printableView:aRecipe]
                                                  printInfo:self.printInfo];
         [printOp setShowsPrintPanel:NO]; 
         [printOp runOperation];
     }
   }

   [NSApp stopModal];
}
**/
- (PDFDocument*)createPdfFromViewData:(NSData *)data savePath:(NSString*)savePath
{
   //Create the pdf document reference
   CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((CFDataRef)data);
   CGPDFDocumentRef document = CGPDFDocumentCreateWithProvider(dataProvider);
   
   //Create the pdf context
   CGPDFPageRef page = CGPDFDocumentGetPage(document, 1); //Pages are numbered starting at 1
   CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
   CFMutableDataRef mutableData = CFDataCreateMutable(NULL, 0);
   
   //NSLog(@"w:%2.2f, h:%2.2f",pageRect.size.width, pageRect.size.height);
   CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData(mutableData);
   CGContextRef pdfContext = CGPDFContextCreate(dataConsumer, &pageRect, NULL);
   
   
   if (CGPDFDocumentGetNumberOfPages(document) > 0)
   {
      //Draw the page onto the new context
      //page = CGPDFDocumentGetPage(document, 1); //Pages are numbered starting at 1
      
      CGPDFContextBeginPage(pdfContext, NULL);
      CGContextDrawPDFPage(pdfContext, page);
      CGPDFContextEndPage(pdfContext);
   }
   else
   {
      DLog(@"Failed to create the document");
   }
   
   CGContextRelease(pdfContext); //Release before writing data to disk.
   
   //Write to disk
   [(__bridge NSData *)mutableData writeToFile:savePath atomically:YES];
   DLog(@"Wrote file to path:%@",savePath);
   //Clean up
   CGDataProviderRelease(dataProvider); //Release the data provider
   CGDataConsumerRelease(dataConsumer);
   CGPDFDocumentRelease(document);
   CFRelease(mutableData);
   PDFDocument *doc = [[PDFDocument alloc ]initWithURL:[NSURL fileURLWithPath:savePath]];
   // at this point pdf has no visible data in Preview
   return doc;
}

#ifdef XXX
/*
- (NSTextView *)printableViewWithRecipe:(Recipe *)recipe
{
    
    [_printView setString:@""];
    [_printView setTextColor:[NSColor blueColor]];
    [_printView setFont:[NSFont systemFontOfSize:13]];
    NSDictionary    *titleAttr;
    // po self.printInfo.imageablePageBounds
    // (origin = (x = 18, y = 40), size = (width = 576, height = 734))
    // (origin = (x = 18, y = 40), size = (width = 576, height = 734))
    // “Imageable area” is the maximum area that can possibly be marked on by the printer hardware, not the area defined by the current margin settings.
   // DLog(@"[[self printInfo] imageablePageBounds]=%@",[[self printInfo] imageablePageBounds]);
   // default page size of 8.5 by 11 inches (612 by 792 points).
    _printView = [[NSTextView alloc] initWithFrame:[[self printInfo] imageablePageBounds]];
    [_printView setVerticallyResizable:YES];
    [_printView setHorizontallyResizable:NO];
    // ADD THE TEXT
    [[_printView textStorage] beginEditing];
    // Set the attributes for the title
    //titleAttr = [NSDictionary dictionaryWithObject:[NSFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
    DLog(@"Recipe=%@",recipe.name);
    /// [printView setEditable:YES];NSString* instrucDirecString = nil;
    [[_printView textStorage] beginEditing];
    titleAttr =
    [NSDictionary dictionaryWithObject:[(AppDelegate*)[[NSApplication sharedApplication] delegate] tableFont] forKey:NSFontAttributeName];
    // Add the title
    [
     [_printView textStorage] appendAttributedString:
     [[NSAttributedString alloc] initWithString:[recipe name]  attributes:titleAttr ]
     ];
    // Create a couple returns between the title and the body
    [[_printView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    // Add the body text
    if([[recipe ingredients] length] )
        [[_printView textStorage] appendAttributedString: [ [NSAttributedString alloc]
                                                          initWithString:[recipe ingredients] attributes:titleAttr]];
    // Create a couple returns between the ingredients and the directions
    [[_printView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    if([[recipe directions] length] )
        [[_printView textStorage] appendAttributedString: [ [NSAttributedString alloc]
                                                          initWithString:[recipe directions] attributes:titleAttr]];
    // Create a couple returns between the directions and the comments
    [[_printView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    if([[recipe comments] length] )
        [[_printView textStorage] appendAttributedString: [ [NSAttributedString alloc]
                                                          initWithString:[recipe comments] attributes:titleAttr]];
    // Center the title
    ///[printView setAlignment:NSCenterTextAlignment range:NSMakeRange(0, [[titleField stringValue] length])];
   /// [_printView setAlignment:NSCenterTextAlignment range:NSMakeRange(0, [[[self window] title] length])];
    [_printView setAlignment:NSCenterTextAlignment range:NSMakeRange(0, [[recipe name] length])];
    
    [[_printView textStorage] endEditing];
    // Resize the print view to fit the added text
    // (Is this done automatically?)
    ///[printView sizeToFit];
    NSString *text = [[_printView textStorage] string];
    DLog(@"[[_printView textStorage] string] for _printView=%@",text);
    
    
    return _printView;
    
} // end printableViewForRecipe
*/

/*
- (NSTextView *)printableViewPdfForRecipeList:(NSArray *)recipeList
{
    
    NSTextView    *printView;
    NSDictionary    *titleAttr;
    Recipe *recipe;
    //pO.pP.pI has  NSJobSavingURL = "file:///Users/mbarron/Documents/Untitled.pdf";
    // need to put into self.printInfo here below
    // po self.printInfo.imageablePageBounds
    // (origin = (x = 18, y = 40), size = (width = 576, height = 734))
   //  (origin = (x = 18, y = 40), size = (width = 576, height = 734))
   //  “Imageable area” is the maximum area that can possibly be marked on by the printer //hardware, not the area defined by the current margin settings
    printView = [[NSTextView alloc] initWithFrame:[[self printInfo] imageablePageBounds]];
    [printView setVerticallyResizable:YES];
    [printView setHorizontallyResizable:NO];
    // ADD THE TEXT
    [[printView textStorage] beginEditing];
    // Set the attributes for the title
    //titleAttr = [NSDictionary dictionaryWithObject:[NSFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
    NSEnumerator *enumerator = [recipeList objectEnumerator];
    //BOOL isPdfPrintOK = YES;
    NSMutableString *mutString = [[NSMutableString alloc]init];
    while ((recipe = [enumerator nextObject]) ) {
        DLog(@"Recipe=%@",recipe.name);
        //[printView setEditable:YES];NSString* instrucDirecString = nil;
        [[printView textStorage] beginEditing];
        titleAttr =
        [NSDictionary dictionaryWithObject:[(AppDelegate*)[[NSApplication sharedApplication] delegate] tableFont] forKey:NSFontAttributeName];
        // Add the title
        [
         [printView textStorage] appendAttributedString:
         [[NSAttributedString alloc] initWithString:[recipe name]  attributes:titleAttr ]
         ];
        // Create a couple returns between the title and the body
        [[printView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
        // Add the body text
        if([[recipeNowPrinting ingredients] length] )
            [[printView textStorage] appendAttributedString: [ [NSAttributedString alloc]
                                                              initWithString:[recipe ingredients] attributes:titleAttr]];
        // Create a couple returns between the ingredients and the directions
        [[printView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
        if([[recipe directions] length] )
            [[printView textStorage] appendAttributedString: [ [NSAttributedString alloc]
                                                              initWithString:[recipe directions] attributes:titleAttr]];
        // Create a couple returns between the directions and the comments
        [[printView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
        if([[recipe comments] length] )
            [[printView textStorage] appendAttributedString: [ [NSAttributedString alloc]
                                                              initWithString:[recipe comments] attributes:titleAttr]];
        // Center the title
        ///[printView setAlignment:NSCenterTextAlignment range:NSMakeRange(0, [[titleField stringValue] length])];
        [printView setAlignment:NSCenterTextAlignment range:NSMakeRange(0, [[[self window] title] length])];
        
    }
    [[printView textStorage] endEditing];
    // Resize the print view to fit the added text
    // (Is this done automatically?)
    ///[printView sizeToFit];
    
    return printView;
    
} // end printableViewPDF
*/

/*
- (BOOL)insertTextFromRecipeList:(NSArray*)selectedRecipes intoTextView:(NSTextView*)textView{
    BOOL textInserted = YES;
    DLog(@"");
    Recipe *aRecipe;
    NSEnumerator *enumerator = [selectedRecipes objectEnumerator];
    //BOOL isPdfPrintOK = YES;
    while ((aRecipe = [enumerator nextObject]) ) {
        
    }
    NSString *recipeString = [NSString stringWithFormat:@"%@\n\n%@\n\n%@",
                              [ recipe ingredients], [recipe directions],  [recipe comments ]];
    [textView insertText:recipeString];
    
    return textInserted;
}*/
#endif

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
