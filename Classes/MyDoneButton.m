//
//  MyButton.m
//  iHungryMac386
//
//  Created by Mark on 12/1/12.
//
//

#import "MyDoneButton.h"
   //#import "MyCancelButton.h"

@implementation MyDoneButton;
@synthesize textField;
@synthesize cancelButton;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

/*
- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}*/

#pragma mark FirstResponder methods

- (BOOL) becomeFirstResponder{
   DLog(@"Become");
   [self.window setDefaultButtonCell:[self cell]];
   return YES;
}

- (BOOL) acceptsFirstResponder{
   DLog(@"Accepting");
   /**
    [self.window  setDefaultButtonCell:doneButton.cell];
    [self.window enableKeyEquivalentForDefaultButtonCell];
    [doneButton setNextKeyView:cancelButton ];
    [textFieldCategoryName setNextKeyView:doneButton];
    **/
   return YES;
}

/*
 - (BOOL) resignFirstResponder{ //default is YES
 // must call super somewhere
   DLog(@"Resigning");
   [self.window disableKeyEquivalentForDefaultButtonCell]; // Enter-Key activates no button now 
   return YES;
} */

@end
