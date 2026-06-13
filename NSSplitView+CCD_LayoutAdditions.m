//
//  NSSplitView+CCD_LayoutAdditions.m
//  iHungryMac386
//
//  Created by Mark on 1/28/13.
//
//

#import "NSSplitView+CCD_LayoutAdditions.h"

@implementation NSSplitView (CCD_LayoutAdditions)


- (NSString*)ccd__keyForLayoutName: (NSString*)name
{
   return [NSString stringWithFormat: @"CCDNSSplitView Layout %@", name];
}

- (void)storeLayoutWithName: (NSString*)name
{
   NSString*		key = [self ccd__keyForLayoutName: name];
   NSMutableArray*	viewRects = [NSMutableArray array];
   NSEnumerator*	viewEnum = [[self subviews] objectEnumerator];
   NSView*			view;
   NSRect			frame;
   
   while( (view = [viewEnum nextObject]) != nil )
   	{
      if( [self isSubviewCollapsed: view] )
         frame = NSZeroRect;
      else
         frame = [view frame];
      
      [viewRects addObject: NSStringFromRect( frame )];
   	}
   
   [[NSUserDefaults standardUserDefaults] setObject: viewRects forKey: key];
}

- (void)loadLayoutWithName: (NSString*)name
{
   NSString*		key = [self ccd__keyForLayoutName: name];
   NSMutableArray*	viewRects = [[NSUserDefaults standardUserDefaults] objectForKey: key];
   NSArray*		views = [self subviews];
   int				i, count;
   NSRect			frame;
   
   count = (int)MIN( [viewRects count], [views count] );
   
   for( i = 0; i < count; i++ )
   	{
      frame = NSRectFromString( [viewRects objectAtIndex: i] );
      if( NSIsEmptyRect( frame ) )
   		{
         frame = [[views objectAtIndex: i] frame];
         if( [self isVertical] )
            frame.size.width = 0;
         else
            frame.size.height = 0;
   		}
      
      [[views objectAtIndex: i] setFrame: frame];
   	}
}

@end
