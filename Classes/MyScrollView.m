         //
//  MyScrollView.m
//  iHungryMac386
//
//  Created by Mark on 1/24/13.
//
//

#import "MyScrollView.h"

@implementation MyScrollView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
   if (self.focusRingType != NSFocusRingTypeNone) {
         NSSetFocusRingStyle(NSFocusRingOnly);
         NSRectFill(dirtyRect);
      /**
      [NSGraphicsContext saveGraphicsState];
      NSSetFocusRingStyle( NSFocusRingAbove );
      [[NSColor keyboardFocusIndicatorColor] set];
      NSFrameRect( [self visibleRect] );
      [NSGraphicsContext restoreGraphicsState]; **/
   }
   [super drawRect:dirtyRect];
}

#pragma mark FirstResponder methods

- (BOOL) acceptsFirstResponder{
  
   return YES;
}

- (BOOL) becomeFirstResponder{
      
      // [self setKeyEquivalent:@""];
      ///[self.window setDefaultButtonCell:self.cell];
   [self setFocusRingType:NSFocusRingTypeDefault];
   [self setNeedsDisplay: YES];
   return YES;
}


- (BOOL) resignFirstResponder{ // default is YES
      
   [self setFocusRingType:NSFocusRingTypeNone];
   [self setNeedsDisplay: YES];
   /***
    [[self cell] setShowsFirstResponder:NO];
    [self setFocusRingType:NSFocusRingTypeNone];
    ***/
   return YES;
}


@end
