//
//  IRTableView.h
//  iHungryMac386
//
//  Created by Mark on 12/3/12.
//
//

#import <Cocoa/Cocoa.h>
@class RxFilteredArrayController;

@interface IRTableView : NSTableView {
   
   IBOutlet RxFilteredArrayController * rxFilteredArrayController;
}

@end