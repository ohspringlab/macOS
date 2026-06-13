//
//  Ingred.m
//  iHungry
//
//  Created by Mark on 3/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "IngredXML.h"


@implementation IngredXML
@synthesize name  = _name;
@synthesize amt = _amt;
@synthesize unit = _unit;
@synthesize note = _note;


- (NSString *)description
{
	// Override of -[NSObject description] to print a meaningful representation of self.
	return [NSString stringWithFormat:@"%@ %@ %@ (%@)"
			  , self.name,self.amt,self.unit,self.note];
}

@end
