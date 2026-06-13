//
//  MyTextView.h
//  iHungryMac386
//
//  Created by Mark on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyTextView : NSTextView {
   IBOutlet NSScrollView *scrollView;
@private
    
}

@property (nonatomic, strong) NSScrollView *scrollView;
- (void) changeMyFont:(id)sender;
@end
