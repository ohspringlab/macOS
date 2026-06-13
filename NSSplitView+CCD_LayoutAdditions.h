//
//  NSSplitView+CCD_LayoutAdditions.h
//  iHungryMac386
//
//  Created by Mark on 1/28/13.
//
//

#import <Cocoa/Cocoa.h>

@interface NSSplitView (CCD_LayoutAdditions)

- (void)storeLayoutWithName: (NSString*)name;
- (void)loadLayoutWithName: (NSString*)name;
@end
