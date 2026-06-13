//
//  DoneButtonAddCat.h
//  iHungryMac386
//
//  Created by Mark on 12/1/12.
//
//

#import <Cocoa/Cocoa.h>
@class CancelButtonAddCat;

@interface DoneButtonAddCat : NSButton{

   IBOutlet CancelButtonAddCat *cancelButton;
   IBOutlet NSTextField *textField;
   
}
@property (nonatomic, strong) CancelButtonAddCat *cancelButton;
@property (nonatomic, strong) NSTextField *textField;
@end
