//
//  HelpWindowController.h
//  iHungryMac386
//
//  Created by Apple  User on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MyAppController;
@interface AboutWindowController : NSWindowController{
IBOutlet NSTextField * textFieldDataVersion;
   IBOutlet NSButton *doneButton;
}
@property (nonatomic, strong) NSButton *doneButton; 
@property (nonatomic, strong) NSTextField *textFieldDataVersion;
@property (nonatomic, strong) MyAppController *myAppController;
//@property (nonatomic,retain) NSTextView * textView;
- (IBAction) done: (id)sender;
//- (void) showAboutFrom: (id)sender;
@end
