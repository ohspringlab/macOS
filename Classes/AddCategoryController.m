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
#import "CategoryRx.h"
#import "MyCatArrayController.h"

@implementation AddCategoryController

@synthesize  savedCategoryName;
//@synthesize  myArrayController;
@synthesize cancelled;

@synthesize myAppController;

//@synthesize appDelegate;
@synthesize textFieldCategoryNewName;
@synthesize doneButton;
@synthesize  cancelButton;
@synthesize categoryNameLengthWarningTextField;
@synthesize smallPanelFont;
@synthesize textFieldAddCategoryLabel;
@synthesize doEnableDoneButton,isNameLengthOK,isNameUnique;
@synthesize myCatArrayController;

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
    //
   self.doneButton.title = @"Add";
  
}


- (void)windowDidLoad
{
    [super windowDidLoad];
   [self.myAppController  updateSmallPanelFont];
   // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
   [[self textFieldCategoryNewName]  becomeFirstResponder];
   
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



- (NSString*) addCatFrom: (id)sender
{              // sender is myAppController
 
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
   
   // Add Category Sheet
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
      //DLog(@"Name is short or long.");
      NSString *informString = [NSString stringWithFormat:@"Please check the length the category name.\nThe Minimum length is %d. The maximum length is %d.",MIN_CATEGORY_NAME_LENGTH ,MAX_CATEGORY_NAME_LENGTH];
      NSAlert *alert = [[NSAlert alloc] init];
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
            [[[[self myAppController] myCatArrayController] arrangedObjects ] objectEnumerator];
	BOOL isNameDifferent = YES;
	NSComparisonResult result;
	CategoryRx* aCategory;
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
      CategoryRx* newCategory =
      (CategoryRx*)[NSEntityDescription insertNewObjectForEntityForName:@"CategoryRx" inManagedObjectContext:aManagedObjectContext];
      [newCategory setName:(NSString*)savedCategoryName];
      [newCategory setIsBrowseAll:NO ];
      [newCategory setSelected:NO ];
      
      [newCategory setSortIndex:[NSNumber numberWithInt: 0]];
      [self.myAppController.appDelegate.managedObjectContext insertObject:newCategory];

      NSError *error = nil;
      if (![self.myAppController.appDelegate.managedObjectContext save:&error]) { // context is from AppDel  // DELETE
         DLog(@"deleteCategoryControler:Unresolved error %@, %@", error, [error userInfo]);
         //exit(-421);  // Fail
      }
      
   }else{
      DLog(@"That category name is not unique."); // ALERT   !!!!!!  //CHECK TEST
        
      NSString *informString = [NSString stringWithFormat:@"Please enter a case insensitively unique Category Name.\nThat Name already exists."];
      NSAlert *alert = [[NSAlert alloc] init];
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
   
	//[NSApp stopModal];
   [myAppController.window endSheet:self.window returnCode:0 ] ;
   //[self.window close];
   myAppController.addCategoryController = nil;
   [self.window orderOut:self];

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
   //[NSApp abortModal];
   
	cancelled = YES;
   [myAppController.window endSheet:self.window returnCode:0 ] ;
   myAppController.addCategoryController = nil;
   [self.window orderOut:self];
   
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
      //DLog(@"1 [window defaultButtonCell]=%@",[[self window] defaultButtonCell]);
         [self.window  setDefaultButtonCell:[cancelButton cell]];
      //DLog(@"2 [self cancelButton]=%@",[cancelButton cell]);
      //DLog(@"3 [self doneButton]=%@",[doneButton cell]);
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
   self.isNameUnique = [[[self myAppController] myCatArrayController] isNameUnique_DG:nameTrimmed];
   self.isNameLengthOK = [[[self myAppController] myCatArrayController] isNameLengthOK_DG:nameTrimmed];
   [self setDoEnableDoneButton:self.isNameLengthOK && self.isNameUnique];
   //DLog(@"self.isNameUnique=%d\nself.isNameLengthOK=%d",self.isNameUnique,self.isNameLengthOK);
   if (name.length >= MIN_CATEGORY_NAME_LENGTH &&
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
   DLog(@"[textField stringValue]=%@",[textField stringValue]);
}




@end
