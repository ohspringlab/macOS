//
//  DeleteCategoryController.m
//  iHungryMac386
//
//  Created by Apple  User on 12/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DeleteCategoryController.h"
#import "MyAppController.h"
#import "AppDelegate.h"
#import "RecipeDefines.h"
#import "CategoryRx.h"
#import "Constants.h"
#import "MyCatArrayController.h"
#import "MyCancelButton.h"
#import "MyDoneButton.h"

@implementation DeleteCategoryController

@synthesize  textFieldCategoryName,savedCategoryName;
//@synthesize  myArrayController;
@synthesize cancelled;
@synthesize category;
//@synthesize categoryArrayController;
@synthesize smallPanelFont;
@synthesize doneButton, cancelButton;
@synthesize myAppController;
//@synthesize appDelegate;



// -------------------------------------------------------------------------------
//	windowNibName
// -------------------------------------------------------------------------------

- (NSString *)windowNibName
{
	return @"DeleteCategory";
}


/*
- (id)initWithWindowNibName:(NSString *)windowNibName 
{
 if (self = [super initWithWindowNibName:windowNibName ]) {
 // Custom initialization
 }
 return self;
 }
*/

- (void)awakeFromNib {
   [super awakeFromNib];// must be called, may be anytime in this method
   self.doneButton.title = @"Delete"; // use keychain but relabel
   /*
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(handleTextChangedNotification) name:NSTextDidChangeNotification object:self.textFieldCategoryName];
    */
}



- (void)windowDidLoad
{
   [super windowDidLoad];
   
   [self setMyAppController:[(AppDelegate *)[NSApp delegate] myAppController ]];
   
      //[[self cancelButton] becomeFirstResponder];
   [self.myAppController updateSmallPanelFont];
   
   NSArray *selectedObjects = [[myAppController myCatArrayController] selectedObjects];
   CategoryRx *theCategory = [selectedObjects objectAtIndex:0];
   [self setCategory:theCategory];
   [self setSavedCategoryName:theCategory.name];
   [[self textFieldCategoryName] setStringValue:[[self category] name] ];
   [[self cancelButton] becomeFirstResponder];
  
   [self.myAppController updateSmallPanelFont];
   [self.textFieldCategoryName setFont:[[self myAppController] smallPanelFont] ];
   //[[self textFieldDeleteCategoryLabel] setFont:[[self myAppController] smallPanelFont] ];
   [self.doneButton setFont:[[self myAppController] smallPanelFont] ];
   [self.cancelButton setFont:[[self myAppController] smallPanelFont] ];
}



- (NSString*) deleteCatFrom: (MyAppController *)sender
{
      //NSWindow *window = [self window];
    /* WINDOW NOT YET LOADED
	cancelled = NO;
      //[[self window] setDefaultButtonCell:[cancelButton cell] ];
   
   if (self.myAppController) { // this is second or later appearance after loading
      NSArray *selectedObjects = [categoryArrayController selectedObjects];
      CategoryRx *theCategory = [selectedObjects objectAtIndex:0];
      [self setCategory:theCategory];
      [self setSavedCategoryName:theCategory.name];
      [[self textFieldCategoryName] setStringValue:[[self category] name] ];
      [self.myAppController updateSmallPanelFont];
      [self.textFieldCategoryName setFont:[[self myAppController] smallPanelFont] ];
      //[[self textFieldDeleteCategoryLabel] setFont:[[self myAppController] smallPanelFont] ];
      [self.doneButton setFont:[[self myAppController] smallPanelFont] ];
      [self.cancelButton setFont:[[self myAppController] smallPanelFont] ];
      [[self cancelButton] becomeFirstResponder];
	}
   
      //[self setMyAppController: (MyAppController *) sender];
   [self setMyAppController:[(AppDelegate *)[NSApp delegate] myAppController ]];
   */
   [NSApp beginSheet:self.window modalForWindow:[sender window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
	[NSApp runModalForWindow:[self window]];
	// sheet is up here...
	[NSApp endSheet:self.window];
	[self.window orderOut:self];
   
	return savedCategoryName ;
}


// -------------------------------------------------------------------------------
//	done:sender
// -------------------------------------------------------------------------------
- (IBAction)done:(id)sender  // DELETE
{
	
    [self setSavedCategoryName:[textFieldCategoryName stringValue]];

    [self.myAppController.myCatArrayController remove:self]; // remove selected object from receiver
    //[self.myAppController.myCatArrayController removeObject:self.category];

    NSManagedObjectContext *managedObjectContext =[[myAppController  appDelegate] managedObjectContext];
    [managedObjectContext deleteObject:[self category]];

    NSError *error = nil;

    if (![managedObjectContext save:&error]) { // context is from AppDel  // DELETE
        DLog(@"deleteCategoryControler:Unresolved error %@, %@", error, [error userInfo]);
         //exit(-421);  // Fail
    }

   // [NSApp stopModal];
   [myAppController.window endSheet:self.window returnCode:0 ] ;
   //[self.window close];
   myAppController.deleteCategoryController = nil;
   [self.window orderOut:self];
}

// -------------------------------------------------------------------------------
//	cancel:sender
// -------------------------------------------------------------------------------
- (IBAction)cancel:(id)sender
{
	//[NSApp abortModal];
   //[self setTextFieldNew:@""];
	cancelled = YES;
   [cancelButton becomeFirstResponder ];
   [myAppController.window endSheet:self.window returnCode:0 ] ;
   myAppController.deleteCategoryController = nil;
   [self.window orderOut:self];
}

// -------------------------------------------------------------------------------
//	wasCancelled
// -------------------------------------------------------------------------------
- (BOOL)wasCancelled
{
	return cancelled;
}





@end
