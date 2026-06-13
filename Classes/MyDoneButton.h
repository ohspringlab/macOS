//
//  MyButton.h
//  iHungryMac386
//
//  Created by Mark on 12/1/12.
//
//

#import <Cocoa/Cocoa.h>
@class MyCancelButton;

@interface MyDoneButton : NSButton{

   IBOutlet MyCancelButton *cancelButton;
   IBOutlet NSTextField *textField;
   
}
@property (nonatomic, strong) MyCancelButton *cancelButton;
@property (nonatomic, strong) NSTextField *textField;
@end
