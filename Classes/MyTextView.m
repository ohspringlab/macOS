   //
//  MyTextView.m
//  iHungryMac386
//
//  Created by Mark on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyTextView.h"
#import "AppDelegate.h"
#import "Constants.h"

@implementation MyTextView
@synthesize scrollView;
+ (void)initialize{
   [[NSFontManager sharedFontManager] setAction:@selector(changeMyFont:)];
}


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
} 

#pragma mark FirstResponder methods

- (BOOL) acceptsFirstResponder{
   BOOL retVal = YES;
   /***
    if (!self.theName) {
    [self setTheName:[ self getName]];
    }
    //[[self cell] setShowsFirstResponder:([[self window] firstResponder] == self)];
    **/
   DLog(@"AcceptsFR YES");
   //DLog(@"AcceptsFR=%d");
   return retVal;
}

- (BOOL) becomeFirstResponder{
   [self.scrollView setFocusRingType:NSFocusRingTypeExterior];
      //[self setNeedsDisplay:YES];
      //[self.scrollView setBorderType:NSBezelBorder];
   DLog(@"BecomeFR");         
   return YES;
}
- (BOOL) resignFirstResponder{ // default is YES
                               //DLog(@"%@:ResignFR=%d\n\n",self.theName, [self isEnabled]);
   [self.scrollView setFocusRingType:NSFocusRingTypeNone];
      //[self.scrollView setBorderType:NSBezelBorder];
   return YES;
}



 - (void) changeMyFont:(id)sender{
    
    AppDelegate *appDel = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    NSFont* font = [appDel tableFont];
    NSFontManager* mngr = sender;
    //DLog(@"old font size=%@",[NSNumber numberWithFloat:[font pointSize]]);
    
    //NSAssert (mngr && [mngr isKindOfClass:[NSFontManager class]],@"sender is not a FontManager.");
    font = [mngr convertFont:font];// the font newly chosen
    
    [appDel setTableFont:font];
    
    //DLog(@"new font size=%@",[NSNumber numberWithFloat:[font pointSize] ]);
    //DLog(@"new fontName=%@",[font fontName]);
    NSDictionary *fontDict = [[font fontDescriptor] fontAttributes];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:fontDict forKey:DG_TableFontAttributesKey ];
    [defaults synchronize];
    [appDel resizeBothTableViewRowHeights];
} 


@end
