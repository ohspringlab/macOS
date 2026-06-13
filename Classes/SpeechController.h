//
//  SpeechController.h
//  iHungryMac386
//
//  Created by Mark on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MyTabViewItem;
@class RecipeWindowController;
@interface SpeechController : NSObject <NSSpeechSynthesizerDelegate, NSTextViewDelegate> {
   IBOutlet NSTabView *tabView;
   IBOutlet NSTextView *tvID;
   IBOutlet NSTextView *tvI;
   IBOutlet NSTextView *tvD;
   IBOutlet NSTextView *tvC;
   IBOutlet NSButton *startButton;
   IBOutlet NSButton *stopButton;
   NSSpeechSynthesizer *speechSynth;
@private
    
}
- (IBAction)sayIt:(id)sender;
- (IBAction)stopIt:(id)sender;
- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking;

@end
