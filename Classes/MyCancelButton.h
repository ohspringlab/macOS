//
//  MyButton.h
//  iHungryMac386
//
//  Created by Mark on 12/1/12.
//
//

#import <Cocoa/Cocoa.h>
@class MyDoneButton;

@interface MyCancelButton : NSButton{

   IBOutlet MyDoneButton *doneButton;
   IBOutlet NSTextField *textField;
   
}
@property (nonatomic, strong) MyDoneButton *doneButton;
@property (nonatomic, strong) NSTextField *textField;
@end
