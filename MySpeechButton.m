//
//  MySpeechButton.m
//  iHungryMac386
//
//  Created by Mark on 1/8/13.
//
//

#import "MySpeechButton.h"
#import "MySpeechStopButton.h"

@implementation MySpeechButton

@synthesize stopButton;

#pragma mark FirstResponder methods

- (BOOL) becomeFirstResponder{
   DLog(@"Become:%d",[self isEnabled]);
   [self.window setDefaultButtonCell:[self cell]];
   [self setKeyEquivalent:@"\r"];
      //[self setFocusRingType:NSFocusRingTypeDefault];
      //[self setNeedsDisplay: YES];
   return [self isEnabled];
   
}
- (BOOL) acceptsFirstResponder{
   DLog(@"Accepts:%d",[self isEnabled] );
      //[self.window enableKeyEquivalentForDefaultButtonCell];
   return [self isEnabled]; //[self isEnabled]
}
- (BOOL) resignFirstResponder{ // default is YES
   DLog(@"Resigning");
      //[self.window disableKeyEquivalentForDefaultButtonCell];
   [self setKeyEquivalent:@""];
      //[self.window makeFirstResponder:self.tabView];
      //[self setFocusRingType:NSFocusRingTypeNone];
      //[self setNeedsDisplay: YES];
   return YES;
}
/***
 - (id)initWithFrame:(NSRect)frame
 {
 self = [super initWithFrame:frame];
 if (self) {
 // Initialization code here.
 }
 
 return self;
 }
 
 - (void)drawRect:(NSRect)dirtyRect
 {
 // Drawing code here.
 } ***/

@end