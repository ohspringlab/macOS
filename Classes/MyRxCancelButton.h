//
//  MyButton.h
//  iHungryMac386
//
//  Created by Mark on 12/1/12.
//
//

#import <Cocoa/Cocoa.h>
@class MyRxDoneButton;

@interface MyRxCancelButton : NSButton{

   IBOutlet MyRxDoneButton *doneButton;
   IBOutlet NSTextField *textField;
   
}
@property (nonatomic, strong) MyRxDoneButton *doneButton;
@property (nonatomic, strong) NSTextField *textField;
@end
