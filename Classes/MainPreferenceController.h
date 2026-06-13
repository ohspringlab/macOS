//
//  MainPreferenceController.h
//  iHungryMac_ND
//
//  Created by Mark on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
extern NSString* const DG_TableBgColorKey;
extern NSString* const DG_AllowDetailWindowCopiesKey;
extern NSString* const DG_FontAttributesKey;


@interface MainPreferenceController : NSWindowController {
   IBOutlet NSColorWell* colorWell;
   IBOutlet NSButton* allowDetailCopiesCheckBox;
@private
    
}
- (IBAction)changeBackgroundColor:(id)sender;
- (IBAction)changeDetailCopies:(id)sender;

- (NSColor *)tableBgColor;
- (BOOL)detailCopiesFlag;
@end
