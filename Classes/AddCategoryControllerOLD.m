
   //
//  AddCategoryController.m
//  iHungryMac386
//
//  Created by Apple  User on 12/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AddCategoryController.h"
#import "MyAppController.h"
#import "AppDelegate.h"
#import "RecipeDefines.h"
#import "Constants.h"
#import "DoneButtonAddCat.h"
#import "CancelButtonAddCat.h"
#import "NSArrayController+NameCheck.h"

@implementation AddCategoryController

@synthesize  savedCategoryName;
//@synthesize  myArrayController;
@synthesize cancelled;
@synthesize myAppController;
@synthesize appDelegate;
@synthesize textFieldCategoryNewName;
@synthesize doneButton;
@synthesize  cancelButton;
@synthesize categoryNameLengthWarningTextField;
@synthesize smallPanelFont;
@synthesize textFieldAddCategoryLabel;
@synthesize doEnableDoneButton,isNameLengthOK,isNameUnique;
// -------------------------------------------------------------------------------
//	windowNibName
// -------------------------------------------------------------------------------
+ (void)initialize{
   
   //[NSTextField exposeBinding:@"stringValue"];

}

- (NSString *)windowNibName
{
	return @"AddCategory";
}


- (void)awakeFromNib {
   [super awakeFromNib];// must be called, may be anytime in this method
  /*
   NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
   [center addObserver:self selector:@selector(handleTextChangedNotification:) name:NSTextDidChangeNotification object:self.textFieldCategoryName];
   */
}


- (void)windowDidLoad
{
    [super windowDidLoad];
   /**
    const char* className = class_getName([yourObject class]);
    NSLog(@"yourObject is a: %s", className);
    **/
   
   [self setMyAppController:[(AppDelegate *)[NSApp delegate] myAppController ]];
   [self.myAppController  updateSmallPanelFont];
      //DLog(@"[[[self myAppController] categoryArrayController] entityName]=%@",[[[self myAppController] categoryArrayController] entityName]);
      //DLog(@"class_getName([[[self myAppController] categoryArrayController] objectClass])=%s",class_getName([[[self myAppController] categoryArrayController] objectClass]));
   /**
   [doneButton setNextKeyView:cancelButton ];
   [textFieldCategoryNewName setNextKeyView:doneButton];
   [cancelButton setNextKeyView:textFieldCategoryNewName ];
   ***/
   // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
   [[self textFieldCategoryNewName]  becomeFirstResponder];
      // get the Recipe in question
   
      //Category *theCategory = [[[self.myAppController categoryArrayController] arrangedObjects]  objectAtIndex: [[self.myAppController categoryArrayController] selectionIndex] ];
   [self setSavedCategoryName:@""];
   
      // Fill TabView with the Recipe data
   [[self categoryNameLengthWarningTextField] setFont:self.myAppController.smallPanelFont];
   
   [[self textFieldCategoryNewName] setStringValue:@""];
      //[self removeSelectionFromTextField:[self textFieldCategoryName]];
   [[self textFieldCategoryNewName] setSelectable:YES];
   
   [[self textFieldCategoryNewName] setFont:self.myAppController.smallPanelFont];

   [[self doneButton] setFont:self.myAppController.smallPanelFont];
   [[self cancelButton] setFont:self.myAppController.smallPanelFont];
   [[self textFieldAddCategoryLabel] setFont:self.myAppController.smallPanelFont];
   [[self categoryNameLengthWarningTextField] setFont:self.myAppController.smallPanelFont];
   
   [[self categoryNameLengthWarningTextField] setStringValue:@""];
   [categoryNameLengthWarningTextField setHidden:NO];
   self.doEnableDoneButton = NO;
   
}



- (NSString*) addCatFrom: (MyAppController *)sender 
{              // sender is myAppController
 
      //[cancelButton setEnabled: YES];
   
      //[self.window disableKeyEquivalentForDefaultButtonCell]; // Enter-Key activates no button now
   
      //NSWindow *window = [self window];
      //cancelled = NO;
   
   if (self.myAppController) { // this is second or later appearance after loading
                               // DLog(@"textFieldCategoryName.nextKeyView=%@",textFieldCategoryName.nextKeyView);
      [self.myAppController updateSmallPanelFont];
      [self setSavedCategoryName:@""];
      
         // Fill TabView with the Recipe data
      [[self categoryNameLengthWarningTextField] setFont:self.myAppController.smallPanelFont];
      
      [[self textFieldCategoryNewName] setStringValue:@""];
         //[self removeSelectionFromTextField:[self textFieldCategoryName]];
      [[self textFieldCategoryNewName] setSelectable:YES];
      
      [[self textFieldCategoryNewName] setFont:self.myAppController.smallPanelFont];
      
      [[self doneButton] setFont:self.myAppController.smallPanelFont];
      [[self cancelButton] setFont:self.myAppController.smallPanelFont];
      [[self textFieldAddCategoryLabel] setFont:self.myAppController.smallPanelFont];
      [[self categoryNameLengthWarningTextField] setFont:self.myAppController.smallPanelFont];
      
      self.doEnableDoneButton = NO;
      [categoryNameLengthWarningTextField setStringValue:@""];
      [textFieldCategoryNewName  becomeFirstResponder];
	}
   
	[self setMyAppController: (MyAppController *) sender];
   
   
	[NSApp beginSheet:self.window modalForWindow:[sender window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
	[NSApp runModalForWindow:[self window]];
	// sheet is up here...
   
	[NSApp endSheet:self.window];
	[self.window orderOut:self];
   
	return self.savedCategoryName ;
}



// -------------------------------------------------------------------------------
//	done:sender
// -------------------------------------------------------------------------------
- (IBAction)done:(id)sender
{
	
   [self setSavedCategoryName:[textFieldCategoryNewName stringValue]];

   NSString *aNameTrimmed;
	NSString* nameTrimmed = [savedCategoryName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([nameTrimmed length] < MIN_CATEGORY_NAME_LENGTH || [nameTrimmed length] > MAX_CATEGORY_NAME_LENGTH ) {
		//[self alertLengthAction:[nameTrimmed length]];// Max handled by TextViewDelegate method
      DLog(@"Name is short or long.");
      NSString *informString = [NSString stringWithFormat:@"Please check the length the category name.\nThe Minimum length is %d. The maximum length is %d.",MIN_CATEGORY_NAME_LENGTH ,MAX_CATEGORY_NAME_LENGTH];
      NSAlert *alert = [[[NSAlert alloc] init] autorelease];
      [alert setAlertStyle:NSInformationalAlertStyle];
      [alert setMessageText:@"Category Name Length Error"];
      [alert setInformativeText:informString];
      //- (void) recipeNameAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
      [alert beginSheetModalForWindow:[self window]
                        modalDelegate:self
                       didEndSelector:@selector(categoryNameLengthAlertDidEnd:returnCode:                                                contextInfo:)
                          contextInfo:nil];
      return;
	}
	//[nameTextField resignFirstResponder];
	NSEnumerator *enumerator = 
     [(NSArray*)[(AppDelegate*)[[NSApplication sharedApplication] delegate ] categoryArray] objectEnumerator];
	BOOL isNameDifferent = YES;
	NSComparisonResult result;
	Category* aCategory;
/***** THIS WORKS 
   BOOL isNameLengthOK = [[myAppController categoryArrayController] isNameLengthOK_DG:nameTrimmed];
   BOOL isUniqName = [[myAppController categoryArrayController] is NameUnique_DG:nameTrimmed];
***/ 
   
	while (aCategory = [enumerator nextObject]) {
		aNameTrimmed = [[aCategory name] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ; 
		//NSLog(@"CatName=%@ aCatName=%@", nameTrimmed,aNameTrimmed);
		result = [aNameTrimmed compare:nameTrimmed options:NSCaseInsensitiveSearch];
		if(result == NSOrderedSame){
			isNameDifferent = NO;// Name Must Be unique (ignoring case)
			break;
		}
	}
	if(isNameDifferent){
      NSManagedObjectContext *aManagedObjectContext = 
         [(AppDelegate*)[[NSApplication sharedApplication] delegate ] managedObjectContext ];
      
      Category *newCategory = 
        (Category*)[NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:aManagedObjectContext];
      
                              /*
      [NSEntityDescription insertNewObjectForEntityForName:@"Category" 
            inManagedteObjectContext:[[NSApplication sharedApplication] delegate ]];*/
      
      [newCategory setName:(NSString*)savedCategoryName];
      
      NSError *error2=nil;
		//	Could be called from EditCat or AddCat, for either do DB up date
		[[(AppDelegate*)[ [NSApplication sharedApplication] delegate ] 
         managedObjectContext ] save:&error2]; // Persist Data too 
      if(error2){
         DLog(@"Error saving Category:error=%@ error.info=%@",error2,[error2 userInfo ] );
      }
      
      [(AppDelegate*)[[NSApplication sharedApplication] delegate] updateGlobalCategoryArray];//namely [appDel recipeArray]
      
		[[myAppController tableViewCat] reloadData];
	}else{
      DLog(@"That category name is not unique.");
      NSString *informString = [NSString stringWithFormat:@"Please enter a case insensitively unique Category Name.\nThat Name already exists."];
      NSAlert *alert = [[[NSAlert alloc] init] autorelease];
      [alert setAlertStyle:NSInformationalAlertStyle];
      [alert setMessageText:@"Unique Name Required"];
      [alert setInformativeText:informString];
      //- (void) recipeNameAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
      [alert beginSheetModalForWindow:[self window]
                        modalDelegate:self
                       didEndSelector:@selector(categoryNameAlertDidEnd:returnCode:                                                contextInfo:)
                          contextInfo:nil];
      return;
	}
   
   [[self textFieldCategoryNewName] setStringValue:@""];
   
   [[self textFieldCategoryNewName] becomeFirstResponder ];
   
	[NSApp stopModal];
}

- (void) categoryNameAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo{
   self.categoryNameLengthWarningTextField.stringValue=@"";
   
   [[alert window] orderOut:self];

}
          
                                
- (void) categoryNameLengthAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo{
  
  [[alert window] orderOut:self];
  
}



// -------------------------------------------------------------------------------
//	cancel:sender
// -------------------------------------------------------------------------------
- (IBAction)cancel:(id)sender
{
   [[self textFieldCategoryNewName] becomeFirstResponder ];
	[[self textFieldCategoryNewName] setStringValue:@""];
      /// [[self textFieldCategoryNewName] becomeFirstResponder ];
   [NSApp abortModal];
	cancelled = YES;
   
}

// -------------------------------------------------------------------------------
//	wasCancelled
// -------------------------------------------------------------------------------
- (BOOL)wasCancelled
{
	return cancelled;
}


- (void) updateCategoryNameLengthWarning { // NameWarn done then doneButton
   
   NSString* nameTrimmed = [[ self.textFieldCategoryNewName stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   if (([nameTrimmed length] >= MIN_CATEGORY_NAME_LENGTH) &&
       ([nameTrimmed length] <= MAX_CATEGORY_NAME_LENGTH)
       ) {
      [categoryNameLengthWarningTextField setHidden:YES];
      [categoryNameLengthWarningTextField setStringValue:@""];
      [self.window  setDefaultButtonCell: doneButton.cell];
      [cancelButton setKeyEquivalent:@""];
      [doneButton setKeyEquivalent:@""];
         
      [textFieldCategoryNewName setNextKeyView:doneButton];
      [doneButton setNextKeyView:cancelButton ];
      [cancelButton setNextKeyView:textFieldCategoryNewName ];
   }
   else {
      [categoryNameLengthWarningTextField setStringValue:CATEGORY_NAME_LENGTH_WARNING ];
      [categoryNameLengthWarningTextField setHidden:NO];
      DLog(@"1 [window defaultButtonCell]=%@",[[self window] defaultButtonCell]);
         [self.window  setDefaultButtonCell:[cancelButton cell]];
      DLog(@"2 [self cancelButton]=%@",[cancelButton cell]);
      DLog(@"3 [self doneButton]=%@",[doneButton cell]);
         //[self.window  setDefaultButtonCell:[doneButton cell]];
      [doneButton setKeyEquivalent:@""];
      [cancelButton setKeyEquivalent:@""];
      [textFieldCategoryNewName setNextKeyView:cancelButton];
      [cancelButton setNextKeyView:textFieldCategoryNewName ];
      
         /// [doneButton setEnabled: NO];
   }
}

- (void) updateDoneButton:(NSString*) name{ // first nameWarning then doneButton
   
   NSString *nameTrimmed = [name
                            stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   self.isNameUnique = [[myAppController categoryArrayController] isNameUnique_DG:nameTrimmed];
   DLog(@"isNameUnique=%d\nself.isNameLengthOK=%d",isNameUnique,self.isNameLengthOK);
   self.isNameLengthOK = [[myAppController categoryArrayController] isNameLengthOK_DG:nameTrimmed];
   [self setDoEnableDoneButton:self.isNameLengthOK && self.isNameUnique];
   BOOL isWarningNull = (self.categoryNameLengthWarningTextField.stringValue.length == 0);
   DLog(@"isWarningNull=%d",isWarningNull);
   DLog(@"self.categoryNameLengthWarningTextField.stringValue=%@",self.categoryNameLengthWarningTextField.stringValue);
   if (self.categoryNameLengthWarningTextField.stringValue.length == 0 &&
       self.isNameUnique == NO) {
      [categoryNameLengthWarningTextField setStringValue:@"Name is already in database!"];
      [categoryNameLengthWarningTextField setHidden:NO];
   }
   
}


#pragma mark NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)aNotification{
   
   NSTextField *textField = [aNotification object];
   [categoryNameLengthWarningTextField setStringValue:@""];
   [self updateCategoryNameLengthWarning]; // Name done then doneButton
   [self updateDoneButton:[textField stringValue]];//  determine uniq ,len
}


- (void) dealloc {
   [super dealloc];
}


@end
