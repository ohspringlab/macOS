//
//  DgxPathWindowController.h
//  iHungryMac386
//
//  Created by Mark on 11/3/12.
//
//

#import <Cocoa/Cocoa.h>
#import "MyAppController.h"

@interface DgxPathWindowController : NSWindowController {
   
   IBOutlet NSTextField *outputDgxFolderTF;
   IBOutlet NSTextField *outputDgxFilenameTF;
   IBOutlet NSButton *exportButton;
   IBOutlet NSButton *cancelButton;
   IBOutlet NSButton *browseButton;
   IBOutlet NSButton *overwriteButton;
   IBOutlet NSTextField *messageField;
}

@property (nonatomic, retain) NSTextField *outputDgxFolderTF;
@property (nonatomic, retain) NSTextField *outputDgxFilenameTF;
@property (nonatomic, retain) NSButton *exportButton;
@property (nonatomic, retain) NSButton *cancelButton;
@property (nonatomic, retain) NSButton *browseButton;
@property (nonatomic, retain) NSButton *overwriteButton;
@property (nonatomic, retain) NSTextField *messageField;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (NSString *) getDgxFileNameFrom:(MyAppController *)sender;
@end
