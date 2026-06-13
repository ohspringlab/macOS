//
//  MyTableView.h
//  iHungryMac_ND
//
//  Created by Mark on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  AppDelegate;


@interface MyTableView : NSTableView {
   ///NSFont *fFont;
   IBOutlet AppDelegate *appDelegate;
   
@private
    
}
@property (strong, nonatomic) AppDelegate *appDelegate;
//-(void)fontPanelUpdate;
//- (id)init;
//- (id)initWithFrame:(NSRect)frameRect;
//-(void)setFont:(NSFont*)font;

@end
