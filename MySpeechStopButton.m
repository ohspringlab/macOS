//
//  MySpeechStopButton.m
//  iHungryMac386
//
//  Created by Mark on 1/8/13.
//
//

#import "MySpeechStopButton.h"
#import "MySpeechButton.h"

@implementation MySpeechStopButton

@synthesize speechButton;

- (BOOL) becomeFirstResponder{
   DLog(@"Become:%d",[self isEnabled]);
   if([self isEnabled]){
      [self.window setDefaultButtonCell:[self cell]];
      [self setKeyEquivalent:@"\r"];
   }
   return [self isEnabled];
}

- (BOOL) acceptsFirstResponder{
   DLog(@"Accepting");
      //[self.window enableKeyEquivalentForDefaultButtonCell];
   
   return [self isEnabled]; //[self isEnabled]
}
- (BOOL) resignFirstResponder{ // default is YES
   DLog(@"Resigning");
      //[self.window disableKeyEquivalentForDefaultButtonCell]; // Enter-Key activates no button now
   [self setKeyEquivalent:@""];
      //[self.window makeFirstResponder:self.window.initialFirstResponder]; //tabView
   return YES;
}



@end
