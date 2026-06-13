//
//  CancelButtonAddCat.h
//  iHungryMac386
//
//  Created by Mark on 1/5/13.
//
//

#import <Cocoa/Cocoa.h>
@class DoneButtonAddCat;

@interface CancelButtonAddCat : NSButton{

   IBOutlet DoneButtonAddCat *doneButton;
   IBOutlet NSTextField *textField;
   
}
@property (nonatomic, strong) DoneButtonAddCat *doneButton;
@property (nonatomic, strong) NSTextField *textField;
@end
