//
//  CellTextVerticalCenter.m
//  iHungryMac386
//
//  Created by Mark on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CellTextVerticalCenter.h"
//#import "MyTableViewCell.h"

//@implementation NSTextFieldCell (CellTextVerticalCenter)
@implementation MyTableViewCell (CellTextVerticalCenter)

- (void)setVerticalCentering:(BOOL)centerVertical
{
   @try { _cFlags.vCentered = centerVertical ? 1 : 0; }
   @catch(...) { NSLog(@"*** unable to set vertical centering"); }
}

@end
