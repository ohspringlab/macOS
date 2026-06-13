//
//  MyImageView.m
//  
//
//  Created by Mark Barron on 9/10/15.
//
//

#import "MyImageView.h"
#import "AppDelegate.h"

@implementation MyImageView

/*
- (NSImage*)getResizedImage:(NSPageController*) pController appDelegate:(AppDelegate *)appDel{
    // change the image size
    NSSize newSize = NSMakeSize(self.bounds.size.width,self.bounds.size.height );
    int imageDx = [pController selectedIndex];
    //AppDelegate *aD = (AppDelegate *)[[NSApplication  sharedApplication] delegate];
    NSImage *currentImage = [appDel.imageArray objectAtIndex:[pController selectedIndex]];
    
    [currentImage setScalesWhenResized:YES];
    
    NSImage *newImage = [[NSImage alloc] initWithSize: newSize];
    [newImage lockFocus];
    [currentImage setSize: newSize];//sourceImage
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    //[self.image compositeToPoint:NSZeroPoint operation:NSCompositeCopy];
    [currentImage drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.];
    [newImage unlockFocus];
    return newImage;
}*/

/*
 - (NSImage *)imageResize:(NSImage*)anImage
 newSize:(NSSize)newSize
 {
 NSImage *sourceImage = anImage;
 [sourceImage setScalesWhenResized:YES];
 
 // Report an error if the source isn't a valid image
 if (![sourceImage isValid])
 {
 NSLog(@"Invalid Image");
 } else
 {
 NSImage *smallImage = [[[NSImage alloc] initWithSize: newSize] autorelease];
 [smallImage lockFocus];
 [sourceImage setSize: newSize];
 [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
 [sourceImage compositeToPoint:NSZeroPoint operation:NSCompositeCopy];
 [smallImage unlockFocus];
 return smallImage;
 }
 return nil;
 }
 */


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
