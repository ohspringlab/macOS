//
//  EditRecipeController.m
//  iHungryMac386
//

//

#import "EditCategoryController.h"
#import "MyAppController.h"
#import "AppDelegate.h"
#import "RecipeDefines.h"
#import "MyCatArrayController.h"
#import "CategoryRx.h"
#import "RxFilteredArrayController.h"
#import "MyRxCancelButton.h"
#import  "MyRxDoneButton.h"
#import "NSArrayController+NameCheck.h"

@implementation EditCategoryController

@synthesize  myAppController;
@synthesize textFieldCategoryNameAbove;
@synthesize textFieldCategoryName  ;
//@synthesize myCategoryArrayController;
   /////@synthesize rxFilteredArrayController;
@synthesize savedCategoryName;
@synthesize selectedCategoryIndexInMain;
//@synthesize  textFieldNewCategoryName;
//@synthesize tabView;
//@synthesize textFieldFont;
@synthesize textFieldEditCategory;
@synthesize doneButton,cancelButton;
   //@synthesize rxCatTableView;
@synthesize categoryNameLengthWarningTextField;
@synthesize smallPanelFont;
@synthesize textFieldEditCategoryLabel;
@synthesize doEnableDoneButton;
@synthesize isNameUnique,isNameLengthOK;

// ------------------------------------------------------------------------------
//	windowNibName
// -------------------------------------------------------------------------------

-(NSArray *)categoryArrayMinusBrowseAll{
 
   NSMutableArray *mutRay =  
   [NSMutableArray arrayWithArray:[[[self myAppController] appDelegate] categoryArray ]];
   NSArray* nonMutArray = [NSArray arrayWithArray:mutRay];
   
   return nonMutArray;
}

  
- (NSString *)windowNibName
{
	return @"EditCategory";
}


/*
- (void) handleTextChangedNotification : (NSNotification*)note{
   
   
} */



- (IBAction) removeSelectionFromTextField:(id)textFieldSender{
   
   NSTextField *textField = (NSTextField*)textFieldSender;
   
   [textField  setSelectable:YES];
      //[textFieldCategoryName setDelegate:self];
      [[self window] makeFirstResponder:textField];
      //Get hold of the field editor and deselect its text
   NSText* fieldEditor = [[self window] fieldEditor:YES forObject:textField];
   [fieldEditor setSelectedRange:NSMakeRange([[fieldEditor string]
                                              length],0)];
   DLog(@"[fieldEditor string ]=%@",[fieldEditor string ]);
   [fieldEditor setNeedsDisplay:YES];
   
}

- (void)awakeFromNib {
   [super awakeFromNib];// must be called, may be anytime in this method
   
  /*
   NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
   [center addObserver:self selector:@selector(handleTextChangedNotification) name:NSTextDidChangeNotification object:self.textFieldCategoryName];
   */
}

/*
- (id)initWithWindowNibName:(NSString *)windowNibName 
{
    if (self = [super initWithWindowNibName:windowNibName ]) {
    // Custom initialization
       //get a copy for this view
      // DLog(@"");
    }
   return self;
 } */


- (void) windowWillLoad {
   
   
}


- (void)windowDidLoad
{
      //DLog(@"\n****************EditRecipeController=%@",self);
   [super windowDidLoad];
      //self.isNameLengthOK = NO;
      //self.isNameUnique = NO;
   
   categoryNameLengthWarningTextField.stringValue=@"";
   [cancelButton setKeyEquivalent:@""];
   [doneButton setKeyEquivalent:@""];
   
   [self setMyAppController:[(AppDelegate *)[NSApp delegate] myAppController ]];
   
   [self.myAppController updateSmallPanelFont];

   [[self textFieldCategoryName]  becomeFirstResponder];
   // get the Recipe in question
   CategoryRx *theCategory = [[[self.myAppController myCatArrayController] arrangedObjects]  objectAtIndex: [[self.myAppController myCatArrayController] selectionIndex] ];
            // Fill TabView with the Recipe data
   [[self textFieldCategoryNameAbove] setStringValue:[theCategory name]];
   
   [[self textFieldCategoryName] setStringValue:[theCategory name]];
   DLog(@"[[self textFieldCategoryName] stringValue]=%@",[[self textFieldCategoryName] stringValue]);
      //[self removeSelectionFromTextField:[self textFieldCategoryName]];
   [[self textFieldCategoryName] setSelectable:YES];
   [[self textFieldCategoryName] setFont:self.myAppController.smallPanelFont];
   [[self textFieldCategoryNameAbove] setFont:self.myAppController.smallPanelFont];
   [[self doneButton] setFont:self.myAppController.smallPanelFont];
   [[self cancelButton] setFont:self.myAppController.smallPanelFont];
   
   [[self textFieldEditCategoryLabel] setFont:self.myAppController.smallPanelFont];
   
   [self updateCategoryNameLengthWarning ]; // NameWarn done then doneButton
   
      //[doneButton setEnabled:NO];
   
   self.doEnableDoneButton = NO;
}


- (void) editCatFrom: (MyAppController *)sender
{              // sender is myAppController
   
   if (self.myAppController) { // this is second or later appearance after loading
      
      [self.myAppController updateSmallPanelFont];
      
      // get the Category in question
      CategoryRx *theCategory = [[[self.myAppController myCatArrayController] arrangedObjects]
                               objectAtIndex: [[self.myAppController myCatArrayController] selectionIndex] ];
      [[self textFieldCategoryName]  becomeFirstResponder];
      [[self textFieldCategoryName] setStringValue:[theCategory name]];
      [self removeSelectionFromTextField:textFieldCategoryName];
      [[self textFieldCategoryName] setSelectable:YES];
      [[self textFieldCategoryNameAbove] setStringValue:[theCategory name]];
         //[self removeSelectionFromTextField:[self textFieldCategoryName]];
      [[self textFieldCategoryName] setFont:self.myAppController.smallPanelFont];
      [[self textFieldCategoryNameAbove] setFont:self.myAppController.smallPanelFont];
      [[self doneButton] setFont:self.myAppController.smallPanelFont];
      [[self cancelButton] setFont:self.myAppController.smallPanelFont];
      
      [[self textFieldEditCategoryLabel] setFont:self.myAppController.smallPanelFont];
      categoryNameLengthWarningTextField.stringValue=@"";
         //self.isNameUnique=YES;
         //self.isNameLengthOK= YES;
      self.doEnableDoneButton = NO;
   }
   
	[self setMyAppController: (MyAppController *) sender];

   
   [NSApp beginSheet:[self window] modalForWindow:[sender window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
	[NSApp runModalForWindow:[self window]];
	// sheet is up here...
	[NSApp endSheet: [self window]];
	[[self window] orderOut:nil];
   
}


// -------------------------------------------------------------------------------
//	done:sender
// -------------------------------------------------------------------------------
- (IBAction)done:(id)sender
{
   CategoryRx* theCategory = [[[myAppController myCatArrayController] arrangedObjects]  objectAtIndex: [[myAppController myCatArrayController] selectionIndex] ];
    if (!theCategory) {
        DLog(@"No selected category!");
        //abort();
    }
   DLog(@"[textFieldCategoryName stringValue] = %@",[textFieldCategoryName stringValue]);
   [self setSavedCategoryName:[[textFieldCategoryName stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ];
 
   [theCategory setName:savedCategoryName];
   
   NSError *error2=nil;
    DLog(@"[(AppDelegate*)[ [NSApplication sharedApplication] delegate ] managedObjectContext ] = %@ ",[(AppDelegate*)[ [NSApplication sharedApplication] delegate ] managedObjectContext ]);
   
   [[(AppDelegate*)[ [NSApplication sharedApplication] delegate ] 
         managedObjectContext ] save:&error2]; // Persist Data too
    
   if(error2){
      DLog(@"Error saving Recipe edits:error=%@ error.info=%@",error2,[error2 userInfo ] );
       //abort();
   }
   
   [[self textFieldCategoryName]  becomeFirstResponder];
  // [[self textFieldCategoryName] setStringValue:@""];
   
   
   [myAppController.window endSheet:self.window returnCode:0 ] ;
   myAppController.editCategoryController = nil; // ensure NIB is reloaded each time
   [self.window orderOut:self];
   
   return;
} // end  - (IBAction)done:(id)sender


// -------------------------------------------------------------------------------
//	cancel:sender
// -------------------------------------------------------------------------------
- (IBAction)cancel:(id)sender
{
   [myAppController.window endSheet:self.window returnCode:0 ] ;
   myAppController.editCategoryController = nil; // ensure NIB is reloaded each time
   [self.window orderOut:self];
   
}


#pragma Alert Delegate

- (void) categoryNameAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo{
   [[alert window] orderOut:self];
   return;
}


- (void) updateDoneButton:(NSString*) name{
   
   NSString *nameTrimmed = [name
                            stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   
   
   self.isNameUnique = [[myAppController myCatArrayController] isNameUnique_DG:nameTrimmed];
   self.isNameLengthOK = [[myAppController myCatArrayController] isNameLengthOK_DG:nameTrimmed];
   DLog(@"isNameUnique=%d",isNameUnique);
   DLog(@"isNameLengthOK=%d",isNameLengthOK);
   [self setDoEnableDoneButton:self.isNameLengthOK && self.isNameUnique];
   
   if (self.categoryNameLengthWarningTextField.stringValue.length == 0 &&
       self.isNameUnique == NO) {
      [categoryNameLengthWarningTextField setStringValue:@"Name is already in database!"];
      [categoryNameLengthWarningTextField setHidden:NO];
   }
   
   
}

#pragma mark NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)aNotification{
   
   NSTextField *textField = [aNotification object];
   
   [self updateCategoryNameLengthWarning]; // first nameWarn then DoneButton
   
   [self updateDoneButton:[textField stringValue]];
   
}

- (void) updateCategoryNameLengthWarning {
   
   NSString* nameTrimmed = [[ self.textFieldCategoryName stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   if (([nameTrimmed length] >= MIN_CATEGORY_NAME_LENGTH) &&
       ([nameTrimmed length] <= MAX_CATEGORY_NAME_LENGTH)
       ) {
         //[doneButton setEnabled: YES];
      [categoryNameLengthWarningTextField setHidden:YES];
      [categoryNameLengthWarningTextField setStringValue:@""];
      
      [self.window  setDefaultButtonCell: doneButton.cell];
      [cancelButton setKeyEquivalent:@""];
      [doneButton setKeyEquivalent:@""];
      [textFieldCategoryName setNextKeyView:doneButton];
      [doneButton setNextKeyView:cancelButton ];
      [cancelButton setNextKeyView:textFieldCategoryName ];
   } else {
      [categoryNameLengthWarningTextField setStringValue:CATEGORY_NAME_LENGTH_WARNING ];
      [categoryNameLengthWarningTextField setHidden:NO];
      [doneButton setEnabled: NO];
      [doneButton setKeyEquivalent:@""];
      [cancelButton setKeyEquivalent:@""];
      [textFieldCategoryName setNextKeyView:cancelButton];
      [cancelButton setNextKeyView:textFieldCategoryName ];
              /// [textFieldCategoryName ];
   }
}

/*
- (void)dealloc
{
   NSNotificationCenter *center;
   center = [NSNotificationCenter defaultCenter];
   [center removeObserver: self] ;
}*/

@end
