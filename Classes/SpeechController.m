//
//  SpeechController.m
//  iHungryMac386
//
//  Created by Mark on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SpeechController.h"
#import "MyTabViewItem.h"
//#import "MySpeechButton.h"
#import "Constants.h"

@implementation SpeechController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
       speechSynth = [[NSSpeechSynthesizer alloc ] initWithVoice:[NSSpeechSynthesizer defaultVoice]];
         
       speechSynth.delegate=self;
    }
    return self;
}


- (IBAction)sayIt:(id)sender{
   
   NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
   [center postNotificationName:DG_SpeechBeginNotification object:self userInfo:nil];
   
   NSTextView *tv = [(MyTabViewItem*)[tabView selectedTabViewItem] textView];
   NSString *tvString = [[tv textStorage] string];
   [speechSynth startSpeakingString:tvString];

   [stopButton setEnabled:YES];
   [startButton setEnabled:NO];
   [stopButton becomeFirstResponder];
   
}


- (IBAction)stopIt:(id)sender{

   [speechSynth stopSpeaking];
   
   [stopButton setEnabled:NO];
   [startButton setEnabled:YES];
}


# pragma Synth Delegate

- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking{
   
   [stopButton setEnabled:NO];
   [startButton setEnabled:YES];
   
   NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
   [center postNotificationName:DG_SpeechEndNotification object:self userInfo:nil];
}



@end
