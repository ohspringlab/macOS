//
//  MyImageView.h
//  
//
//  Created by Mark Barron on 9/10/15.
//
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

extern NSString * const DG_MyImageViewImageDidChangeNotification;

@interface MyImageView : NSImageView <NSWindowDelegate>
//- (NSSize)windowWillResize:(NSWindow *)window toSize:(NSSize)proposedFrameSize;
//- (void)windowDidResize:(NSNotification *)notification;
//- (void)doSelfLayout;
//- (NSImage *)getResizedImage:(NSPageController*) pController appDelegate:(AppDelegate *)appDel;
@end
