//
//  RxFilteredArrayController.h
//  iHungryMac386
//
//  Created by Apple  User on 12/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MyCatArrayController;

@interface RxFilteredArrayController : NSArrayController<NSControlTextEditingDelegate>{

IBOutlet NSString *searchString;
IBOutlet NSSearchField *searchField;
IBOutlet MyCatArrayController *myCatArrayController;
IBOutlet NSTableView *tableViewCat;
   
}
@property (nonatomic, strong) IBOutlet NSTableView *tableViewCat;

@property (nonatomic, strong) IBOutlet MyCatArrayController *myCatArrayController;

@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, strong) NSSearchField *searchField;

- (IBAction) search: (id) sender;


@end
