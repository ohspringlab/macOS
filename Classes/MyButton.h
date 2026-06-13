//
//  MyButton.h
//  iHungryMac386
//
//  Created by Mark on 12/1/12.
//
//

#import <Cocoa/Cocoa.h>
@class MyButton;

@interface MyButton : NSButton{

       NSString *theName;
   
}
   @property (nonatomic, strong) NSString *theName;
- (NSString *)getName ;
@end
