//
//  MyButtonCell.m
//  iHungryMac386
//
//  Created by Mark on 1/17/13.
//
//

#import "MyButtonCell.h"
#import "MyButton.h"

@implementation MyButtonCell

- (void)drawInteriorWithFrame:(NSRect)aFrame inView:(NSView*)aView
{
      //... // draw the cell
   [super drawInteriorWithFrame:aFrame inView: aView] ;
      // draw the focus ring
      DLog(@"[self showsFirstResponder]=%d",[self showsFirstResponder]);
   
   if ([self showsFirstResponder])
   {
      // showsFirstResponder is set for us by the NSControl that is drawing us.//[[self cell] setShowsFirstResponder:([[self window] firstResponder] == self)];
   
   NSRect focusRingFrame = aFrame;
   focusRingFrame.size.height -= 2.0;
   [NSGraphicsContext saveGraphicsState];
   NSSetFocusRingStyle(NSFocusRingOnly);
   [[NSBezierPath bezierPathWithRect: NSInsetRect(focusRingFrame,3,3 )] fill];
   [NSGraphicsContext restoreGraphicsState];
   }
}

@end
