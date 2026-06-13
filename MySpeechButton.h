//
//  MySpeechButton.h
//  iHungryMac386
//
//  Created by Mark on 1/8/13.
//
//

#import <Cocoa/Cocoa.h>
@class MySpeechStopButton;

@interface MySpeechButton : NSButton {
IBOutlet MySpeechStopButton *stopButton;
      //IBOutlet NSTabView *tabView;

}
@property (nonatomic, strong) MySpeechStopButton *stopButton;
   //@property (nonatomic, retain) NSTabView *tabView;
@end
