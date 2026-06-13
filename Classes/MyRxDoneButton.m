//
//  MyButton.m
//  iHungryMac386
//
//  Created by Mark on 12/1/12.
//
//

#import "MyRxDoneButton.h"
#import "MyRxCancelButton.h"

@implementation MyRxDoneButton;
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
   DLog(@"MyRxDone Become");
   [self.window setDefaultButtonCell:self.cell];
   
   [self setKeyEquivalent:@"\r"];
   [self setFocusRingType:NSFocusRingTypeDefault];
   return YES;
}

- (BOOL) acceptsFirstResponder{
      //DLog(@"MyRxDone Accepting");
   return [self isEnabled];
}

- (BOOL) resignFirstResponder{ // default is YES
         //DLog(@"%@:ResignFR=%d\n\n",self.theName, [self isEnabled]);
      
      //[self.cell display ];
   [self setFocusRingType:NSFocusRingTypeNone];
   [self setKeyEquivalent:@""];
   
   return YES;
}
/*
 - (BOOL) resignFirstResponder{ //default is YES
 
 // must call super somewhere
   DLog(@"MyRxDone Resigning");
   [self.window disableKeyEquivalentForDefaultButtonCell]; // Enter-Key activates no button now  
   return YES;
} */



@end
