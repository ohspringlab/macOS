//
//  MyTableViewCell.h
//  iHungryMac386
//
//  Created by Mark on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyTableViewCell : NSTextFieldCell {
@private
    
}
////- (id) init;
- (id)initWithCoder:(NSCoder *)aDecoder;
////- (id)initTextCell:(NSString *)aString;
////- (id)initImageCell:(NSImage *)anImage;
- (id) copyWithZone:(NSZone *)zone;
@end
