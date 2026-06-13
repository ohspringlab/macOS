//
//  MyTableViewCell.m
//  iHungryMac386
//
//  Created by Mark on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyTableViewCell.h"
#import "CellTextVerticalCenter.h"
#import "AppDelegate.h"

@implementation MyTableViewCell

- (id)copyWithZone:(NSZone *)zone {
   
   MyTableViewCell *copy = [[[self class] allocWithZone:zone] init];
                            
   return copy;
   
}

/*
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}*/

- (id)initWithCoder:(NSCoder *)aDecoder
{
	id cell = [super initWithCoder:aDecoder];
   //[cell setVerticalCentering:YES];
   [cell setPlaceholderString:@"nil"];
   
   //NSColor *aColor = [NSColor blueColor];
   //[cell setTextColor :aColor];
   //DLog(@"verticalCentering=%d", _cFlags.vCentered);
   // NOTA BENE: this flag is not documented and could go away.
   
   
	return cell;
}


- (id)initTextCell:(NSString *)aString{
   id cell = [super initTextCell:aString];
   
   return cell;
}

- (id)initImageCell:(NSImage *)anImage{
   id cell = [super initImageCell:anImage];
   return cell;
}


/***   THIS WORKS ***/
- (NSRect)titleRectForBounds:(NSRect)theRect {
   //Returns the rectangle in which the receiver draws its title text.
   NSRect titleFrame = [super titleRectForBounds:theRect];
   NSSize titleSize = [[self attributedStringValue] size];
   //DLog(@"titleSize:height=%f",titleSize.height );
   //DLog(@"theRect:height=%f",theRect.size.height );
   //titleFrame.origin.y = 
         //theRect.origin.y  + (theRect.size.height - titleSize.height) / 2.0;
   //titleFrame.origin.y =
       //theRect.origin.y - ((0.1 * titleSize.height) + 1.8 ) + (theRect.size.height - titleSize.height) / 2.0;// needed if height of row is made greater than suggested.
   
   titleFrame.origin.y = theRect.origin.y - ( (0.1 * titleSize.height) - 0.0  ) + ((theRect.size.height - titleSize.height) / 2.0)  ;
   
   
  /// titleFrame.origin.y =
  /// theRect.origin.y - ( (0.1 * titleSize.height) + 1.8 ) + ((theRect.size.height - titleSize.height) / 2.0) ;
   ///titleFrame.origin.y = theRect.origin.y  + (theRect.size.height - titleSize.height) / 2.0;
   titleFrame.size.height = titleSize.height;
   return titleFrame;
}
/* Explanation of adjustment factor : ((0.1 * titleSize.height) + 1.8 )
   I found empirically that the titleRect was always a bit low , i.e. the top was 
    a bit low, that is y is too large. 
 
Adjustment of  y
9|
8|                                                       0 (72,8)
7|
6|
5|
4|
3|
2|        0 (9,2)
1|
0| 
 ________________________________~~~~_______________________________> X - FontSize
 0 2      9                                               72
 
 By eye I thought the y-adjustment should be -8 at fontSize==72 and -2 at fontSize=9
 By eye using graph paper, I judged the line y-intercept something close to 1.8
 
   y = mx + b
   
   m = slope = delta y / delta x = (8-2)/(72-9) = 6/61 = approx 0.1
   b = y intercept (where x = 0) =>  y = 0.1(0) + b  => y = b 
 
 This is close enough for me, but go crazy.
 */

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
   NSRect titleRect = [self titleRectForBounds:cellFrame];
   [[self attributedStringValue] drawInRect:titleRect];
}
 

/****
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
   NSSize size = [self cellSize];
   DLog(@"width=%f\nheight=%f ",size.width,size.height);
   // width=106.679688
   // height=33.000000
   NSRect bounds = NSMakeRect(0, 0, size.width, size.height);
   NSLayoutManager		*lm;
	NSFont					*font;
   // Returns the rectangle within which the receiver draws itself
    // - (NSRect)drawingRectForBounds:(NSRect)theRect  
	lm = [[NSLayoutManager alloc] init];
	//font = [NSFont fontWithName:@"Ayuthaya" size:18];
   
   AppDelegate *appDel = [[NSApplication sharedApplication] delegate];
   font = [appDel tableFont];
	bounds.size.height = [lm defaultLineHeightForFont:font];
	//[self setFrame:[self convertRect:bounds toView:[self superview]]];
   
   
	[NSGraphicsContext saveGraphicsState];
   
   
	[[NSColor blueColor] set];
	[NSBezierPath strokeRect:bounds];
   
   
	[@"jJpP" drawAtPoint:NSMakePoint(0, 0) withAttributes:
    [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,
     nil]];
   
   
	[NSGraphicsContext restoreGraphicsState];

   
   DLog(@" ");
   

}
 ***/
 /*
 Parameters
 cellFrame
 The bounding rectangle of the receiver.
 controlView
 The control that manages the cell.
 Discussion
 This method draws the cell in the currently focused view, which can be different from the controlView passed in. Taking advantage of this behavior is not recommended, however.
 
 
 */
/*  
 NSMakeRect
 Creates a new NSRect from the specified values.
 
 NSRect NSMakeRect (
 CGFloat x,
 CGFloat y,
 CGFloat w,
 CGFloat h
 );
 Return Value
 An NSRect having the specified origin of [x, y] and size of [w, h].
 
 NSSize NSMakeSize (
 CGFloat w,
 CGFloat h
 );
 Return Value
 An NSSize having the specified width and height.
 
 
 NSLayoutManager		*lm;
 NSFont					*font;
 NSRect					bounds;
 
 
 lm = [[NSLayoutManager alloc] init];
 
 
 font = [NSFont fontWithName:@"Ayuthaya" size:18];
 bounds = [self bounds];
 bounds.size.height = [lm defaultLineHeightForFont:font];
 [self setFrame:[self convertRect:bounds toView:[self superview]]];
 
 
 [NSGraphicsContext saveGraphicsState];
 
 
 [[NSColor blueColor] set];
 [NSBezierPath strokeRect:bounds];
 
 
 [@"jJpP" drawAtPoint:NSMakePoint(0, 0) withAttributes:
 [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,
 nil]];
 
 
 [NSGraphicsContext restoreGraphicsState];
 */



@end
