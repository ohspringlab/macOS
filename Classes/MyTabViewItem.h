//
//  MyTabViewItem.h
//  iHungryMac386
//
//  Created by Mark on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyTabViewItem : NSTabViewItem {
   IBOutlet NSTextView *textView;
@private
    
}
@property (strong, nonatomic) IBOutlet NSTextView *textView;

@end
