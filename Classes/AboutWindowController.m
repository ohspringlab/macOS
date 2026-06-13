//
//  AboutWindowController.m
//  iHungryMac386
//

#import "AboutWindowController.h"
#import "AppDelegate.h"
#import  "VersionXML.h"
#import "Constants.h"

@implementation AboutWindowController

@synthesize  textFieldDataVersion,doneButton,myAppController;

- (NSString *)windowNibName {
   
   return @"About";
}

- (IBAction) done: (id)sender {
   [self close];
}

- (void)awakeFromNib {
   [super awakeFromNib];// must be called, may be anytime in this method
   //AppDelegate *appDel = (AppDelegate *)[[NSApplication  sharedApplication] delegate];
   NSString *textStr = DG_RES_DATA_VERSION_NUMBER_ABOUT_WINDOW;//1.50
   //[[[appDel versionXML] number] stringValue];
   [[self textFieldDataVersion ] setStringValue:
      [NSString stringWithFormat:@"Data Version:%@",textStr]];
   [self.window setDefaultButtonCell:self.doneButton.cell];

}


- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

/*
- (void) showAboutFrom: (id)sender
{              // sender is myAppController
   
   
   
   [self setMyAppController: (MyAppController *) sender];
   
   // Add Category Sheet
   [NSApp beginSheet:[self window] modalForWindow:[sender window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
   [NSApp runModalForWindow:[self window]];
   // sheet is up here...
   
   [NSApp endSheet:self.window];
   [self.window orderOut:self];
   
} */

@end
