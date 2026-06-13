         //
//  MyButton.m
//  iHungryMac386
//
//  Created by Mark on 12/1/12.
//
//

#import "CancelButtonAddCat.h"
#import "DoneButtonAddCat.h"

@implementation CancelButtonAddCat;
@synthesize textField;
@synthesize doneButton;

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

- (BOOL)canBecomeFirstResponder {
   return YES;
}

- (BOOL) becomeFirstResponder{
   DLog(@"CancelButtonAddCat Become"); 
   [self.window setDefaultButtonCell:[self cell]];
   return YES;
}

- (BOOL) acceptsFirstResponder{
   DLog(@"Accepting");
   return YES;
}

- (BOOL) resignFirstResponder{
   DLog(@"Resigning");
      //[self.window disableKeyEquivalentForDefaultButtonCell]; // Enter-Key activates no button now
   return YES;
}


@end
