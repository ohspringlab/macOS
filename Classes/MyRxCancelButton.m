            //
//  MyButton.m
//  iHungryMac386
//
//  Created by Mark on 12/1/12.
//
//

#import "MyRxCancelButton.h"
#import "MyRxDoneButton.h"

@implementation MyRxCancelButton;
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

- (BOOL) becomeFirstResponder{
   DLog(@"MyRxCancel Become");
   [self.window setDefaultButtonCell:self.cell];
   [self setKeyEquivalent:@"\r"];
   [self setFocusRingType:NSFocusRingTypeDefault];

   return YES;
}

- (BOOL) acceptsFirstResponder{
   DLog(@"MyRxCancel Accepting");
   return [self isEnabled];
}

- (BOOL) resignFirstResponder{ // default is YES
  /* Use the NSWindow makeFirstResponder: method, not this method, to make an 
   object the first responder. Never invoke this method directly. */
      //DLog(@"%@:ResignFR=%d\n\n",self.theName, [self isEnabled]); 
   
   
   [self setKeyEquivalent:@""];
   
   
   [self setFocusRingType:NSFocusRingTypeNone];
   [self setKeyEquivalent:@""];
   /***
    [[self cell] setShowsFirstResponder:NO];
    [self setFocusRingType:NSFocusRingTypeNone];
    ***/
   return YES;
}
/*
 - (BOOL) resignFirstResponder{ // default is YES
 // must call super somewhere
   DLog(@"MyRxCancel Resigning");
   [self.window disableKeyEquivalentForDefaultButtonCell]; // Enter-Key activates no button now  
   return YES;
}*/




@end
