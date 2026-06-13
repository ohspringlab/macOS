//
//  MySpeechStopButton.h
//  iHungryMac386
//
//  Created by Mark on 1/8/13.
//
//

#import <Cocoa/Cocoa.h>
@class MySpeechButton;

@interface MySpeechStopButton : NSButton {

IBOutlet MySpeechButton *speechButton;
      //IBOutlet NSTabView *tabView;

}
@property (nonatomic, strong) MySpeechButton *speechButton;
   //@property (nonatomic, retain) NSTabView *tabView;
@end
