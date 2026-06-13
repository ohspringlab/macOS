//
//  ExportWindowController.h
//  iHungryMac386
//
//  Created by Mark on 11/3/12.
//
//

#import <Cocoa/Cocoa.h>
#import "MyAppController.h"
@interface ExportWindowController : NSWindowController{
   IBOutlet NSTextField *fileNameLabel;
   IBOutlet NSTextView *textView;
   NSURL *dgxFileURL;
   IBOutlet NSButton *doneButton;
   MyAppController *myAppController;
}
@property (nonatomic,strong) MyAppController *myAppController;
@property (nonatomic,strong) NSButton *doneButton;
@property (nonatomic,strong) NSTextField *fileNameLabel;
@property (nonatomic,strong) NSTextView *textView;
@property (nonatomic,strong) NSURL *dgxFileURL;

//- (BOOL) showAlertFrom: (MyAppController *)sender;
- (IBAction)doneAction:(id)sender;
@end
