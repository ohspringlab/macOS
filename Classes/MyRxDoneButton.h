//
//  MyButton.h
//  iHungryMac386
//
//  Created by Mark on 12/1/12.
//
//

#import <Cocoa/Cocoa.h>
@class MyRxCancelButton;

@interface MyRxDoneButton : NSButton{

   IBOutlet MyRxCancelButton *cancelButton;
   IBOutlet NSTextField *textField;
   
}
@property (nonatomic, strong) MyRxCancelButton *cancelButton;
@property (nonatomic, strong) NSTextField *textField;
@end
