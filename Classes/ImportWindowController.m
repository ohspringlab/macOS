//
//  ExportWindowController.m
//  iHungryMac386
//
//  Created by Mark on 11/3/12.
//
//

#import "ImportWindowController.h"
#import "AppDelegate.h"
/*
@interface ImportWindowController ()

@end */

@implementation ImportWindowController
@synthesize doneButton;
@synthesize fileNameLabel;
@synthesize textView;
@synthesize dgxFileURL;
@synthesize myAppController;

/*
- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}*/

- (id)initWithWindowNibName:(NSString *)windowNibName
{
   if (self = [super initWithWindowNibName:windowNibName ]) {
      // Custom initialization
      self.window.delegate = self;
   }
   return self;
}

- (void)awakeFromNib{
   [super awakeFromNib];
 
   
}


- (void)windowDidLoad
{
    [super windowDidLoad];
   
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction) doneAction:(id)sender {
   [self.window setReleasedWhenClosed:YES];
   //[self close];
   AppDelegate* appDel = (AppDelegate*)[NSApp delegate ];
   [appDel.myAppController.window endSheet:self.window returnCode:0 ] ;
   DLog(@"");
   [self.window orderOut:self];
}

#pragma mark WindowDelegate methods
- (BOOL)windowShouldClose:(id)sender{
   return YES;
}


@end
