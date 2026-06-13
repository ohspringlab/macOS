//
//  DgxPathWindowController.m
//  iHungryMac386
//
//  Created by Mark on 11/3/12.
//
//

#import "DgxPathWindowController.h"

@interface DgxPathWindowController ()

@end

@implementation DgxPathWindowController
@synthesize outputDgxFolderTF;
@synthesize outputDgxFilenameTF;
@synthesize exportButton,cancelButton;
@synthesize browseButton;
@synthesize overwriteButton;
@synthesize messageField;

- (NSString *)windowNibName
{
	return @"DgxPathWindowController";
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}


- (NSString *) getDgxFileNameFrom:(MyAppController *)sender { // NIB did have Folder and Filename, now only Name
   NSString *retString=@"";
   DLog(@"sender.window=%@",sender.window);
   //[dgxPathWindowController window];
   
   //NOW GET FILENAME
	[NSApp beginSheet:[self window] modalForWindow:[sender window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
	[NSApp runModalForWindow:[self window]];
	// sheet is up here...
   retString = self.outputDgxFilenameTF.stringValue;
	[NSApp endSheet:[self window]];
	[[self window] orderOut:self];
   
   return retString;
}

// - (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;

- (IBAction)done:(id)sender
{
   DLog(@"self.outputDgxFilenameTF.stringValue=%@",self.outputDgxFilenameTF.stringValue);
	[NSApp stopModal];
}

- (IBAction)cancel:(id)sender
{
   
	[NSApp stopModal];
}

- (void) dealloc {
   [outputDgxFolderTF release];
   [outputDgxFilenameTF release];
   [exportButton release];
   [cancelButton release];
   [browseButton release];
   [overwriteButton release];
   [messageField release];

   [super dealloc];
}


@end
