/*

File: Recipe.m
Abstract: The model class that stores the information about a Recipe.
*/

#import "RecipeXML.h"
#import "IngredXML.h"
/*@interface Earthquake()
- (void)getMagnitudeAndLocationFromTitle:(NSString *)wholeTitle;
@end*/

@implementation RecipeXML
@synthesize rid = _rid;
@synthesize name  = _name;
@synthesize tag  = _tag;
@synthesize categ = _categ;
@synthesize categ2 = _categ2;
@synthesize ptime = _ptime;
@synthesize ctime = _ctime;
@synthesize serves = _serves;
@synthesize photopath = _photopath;
@synthesize ingreds = _ingreds;
@synthesize directions = _directions;
@synthesize comment = _comment ;
@synthesize iPhoneContentMode = _iPhoneContentMode;
@synthesize iPadContentMode = _iPadContentMode;

/*
- (id)init{
	[super init];
	return self;
} */


- (NSString *)description
{
    // Override of -[NSObject description] to print a meaningful representation of self.
    return [NSString stringWithFormat:@"rid:%@ categ:%@ categ2:%@ name:%@",[self rid] , self.categ, self.categ2, self.name];
}

/*
- (NSComparisonResult) sortByName:(Recipe *)recipe  {
	// Compare nodes to each other by comparing the data part.
	return [self.name compare:[recipe name]];
}*/
 

/*
 - (NSString *)formattedDate
{
    // You could use an NSDateFormatter to return a user-friendly representation
    // of the date.
    return self.eventDateString;
}*/

/*- (void)setTitle:(NSString *)newTitle
{
    [newTitle retain];
    [_title release];
    _title = newTitle;
    
    // The location and magnitude of the earthquake are parsed from the title.
    [self getMagnitudeAndLocationFromTitle:_title];
}*/
/*
- (NSString *)locationAndMagnitude:(NSString **)outMagnitude inString:(NSString *)wholeTitle
{
	// <title>M 3.6, Virgin Islands region<title/>,
	// Pull out the magnitude and the title using a scanner.
			
	NSScanner *scanner = [NSScanner scannerWithString:wholeTitle];
	static NSString *magnitudeSeparator = @", ";
	NSString *magnitude = nil;
	[scanner scanUpToString:@" " intoString:nil]; // Scan past the "M " before the number.
    // Scan from the space up to the comma separator, which gives us the magnitude.
	BOOL foundSpace = [scanner scanUpToString:magnitudeSeparator intoString:&magnitude];
	if (foundSpace && magnitude && outMagnitude) {
		// If we found the pattern, set the outMagnitude argument to this method to the value we found.
		*outMagnitude = magnitude;
	}
	
	NSString *title = nil;
    // Scan from after the locaion of the separator up to the end of the string.
    // That gives us the location of the earthquake.
	[scanner setScanLocation:[scanner scanLocation] + [magnitudeSeparator length]];
	BOOL foundTitle = [scanner scanUpToString:@"" intoString:&title];
	if (foundTitle && title) {
		// Virgin Islands region
		return [title capitalizedString];
	}
	
    // Failed to find the location and magnitude of the earthquake.
	return nil;
}*/
/*
- (void)getMagnitudeAndLocationFromTitle:(NSString *)wholeTitle
{
    NSString *magnitude = nil;
    NSString *location = [self locationAndMagnitude:&magnitude inString:wholeTitle];
    
    self.magnitude = magnitude;
    self.location = location;
}*/

@end
