//
//  TableCellView.m
//  iHungryMac386
//
//  Created by Mark on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableCellView.h"


@implementation TableCellView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void)drawRect:(NSRect)aRect
{
	NSLayoutManager		*lm;
	NSFont					*font;
	NSRect					bounds;
   
   
	lm = [[NSLayoutManager alloc] init];
   
   
	font = [NSFont fontWithName:@"Ayuthaya" size:18];
	bounds = [self bounds];
	bounds.size.height = [lm defaultLineHeightForFont:font];
	[self setFrame:[self convertRect:bounds toView:[self superview]]];
   
   
	[NSGraphicsContext saveGraphicsState];
   
   
	//[[NSColor blueColor] set];
	[NSBezierPath strokeRect:bounds];
   
   
	[@"jJpP" drawAtPoint:NSMakePoint(0, 0) withAttributes:
    [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,
     nil]];
   
   
	[NSGraphicsContext restoreGraphicsState];
}


@end
