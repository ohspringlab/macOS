//
//  EditCategoryViewController.m
//  iHungryMac386
//
//  Created by Apple  User on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EditCategoryController.h"
#import "MyAppController.h"
#import "RecipeDefines.h"
#import "AppDelegate.h"

@implementation EditCategoryController

@synthesize textFieldOriginal, textFieldNew,myAppController;
@synthesize cancelled;
@synthesize  savedCategoryName;
@synthesize  category;
@synthesize  doneButton;
@synthesize  doneButtonIsEnabled;


- (NSString *)windowNibName
{
	return @"EditCategory";
}

- (void) awakeFromNib{
    
   [doneButton setEnabled:NO];
}

/*
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
   
   // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
*/

- (NSString*) editCatFrom: (MyAppController *)sender 
{              // sender is myAppController
	NSWindow *window = [self window];
	cancelled = NO;
   [self setMyAppController: (MyAppController *) sender];
   
   NSArray *selectedObjects = [[myAppController categoryArrayController] selectedObjects];
   
   Category *theCategory = [selectedObjects objectAtIndex:0];
   
   [self setCategory:theCategory];
   [[self textFieldOriginal] setStringValue:[[self category] name] ];
	[[self textFieldNew] setStringValue:[[self category] name] ];
   
	[NSApp beginSheet:window modalForWindow:[sender window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
	[NSApp runModalForWindow:[self window]];
	// sheet is up here...
   
	[NSApp endSheet:window];
	[window orderOut:self];
   
	return savedCategoryName ;
}

// -------------------------------------------------------------------------------
//	done:sender
// -------------------------------------------------------------------------------
- (IBAction)done:(id)sender
{
	
   [self setSavedCategoryName:[textFieldNew stringValue]]; 
   
   NSString *aNameTrimmed;
	NSString* nameTrimmed = [savedCategoryName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([nameTrimmed length] < MIN_CATEGORY_NAME_LENGTH || [nameTrimmed length] > MAX_CATEGORY_NAME_LENGTH ) {
		//[self alertLengthAction:[nameTrimmed length]];// Max handled by TextViewDelegate method
      DLog(@"Name is short or long.");
		return;
	}
	//[nameTextField resignFirstResponder];
	NSEnumerator *enumerator = 
   [(NSArray*)[(AppDelegate*)[[NSApplication sharedApplication] delegate ] categoryArray] objectEnumerator];
	BOOL isNameDifferent = YES;
	NSComparisonResult result;
	Category* aCategory;
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
      
      [[self category] setName:[self savedCategoryName]];
      
      
      NSError *error2=nil;
		//	Could be called from EditCat or AddCat, for either do DB update
		[[(AppDelegate*)[ [NSApplication sharedApplication] delegate ] 
        managedObjectContext ] save:&error2]; // Persist Data too 
      if(error2){
         DLog(@"Error saving Category:error=%@ error.info=%@",error2,[error2 userInfo ] );
      }
      
      [(AppDelegate*)[[NSApplication sharedApplication] delegate] updateGlobalCategoryArray];//namely [appDel categoryArray]
      
		//// [[myAppController tableViewCat] reloadData];// 2/1/2012
	}else{
      NSString *informString = [NSString stringWithFormat:@"The Category '%@' is in the database.",savedCategoryName];
      NSAlert *alert = [[NSAlert alloc] init];
      [alert setAlertStyle:NSInformationalAlertStyle];
      [alert setMessageText:@"The Category Name Already Exists"];
      [alert setInformativeText:informString];
      [alert beginSheetModalForWindow:[self window]
                        modalDelegate:self
                       didEndSelector:@selector(CategoryNameExistsAlertDidEnd:returnCode:                                                contextInfo:)
                          contextInfo:nil];
      return;	
   }
   
   [[self textFieldNew] setStringValue:@""];
	
	[NSApp stopModal];
}


- (void) CategoryNameExistsAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo{
   
   [[alert window] orderOut:self];
   
}

// -------------------------------------------------------------------------------
//	cancel:sender
// -------------------------------------------------------------------------------
- (IBAction)cancel:(id)sender
{
	[[self textFieldNew] setStringValue:@""];
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

#pragma NSTextFieldDelegate

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor{
   //[self setDoneButtonIsEnabled:YES];
   [doneButton setEnabled:YES];
   return YES;
}


@end
