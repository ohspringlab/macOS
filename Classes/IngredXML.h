//
//  Ingred.h          
//  iHungry
//
//  Created by Mark on 3/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>


@interface IngredXML : NSObject {
	NSString *_name;
	NSString	*_amt;
	NSString *_unit;
	NSString *_note;
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *amt;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *note;



@end
