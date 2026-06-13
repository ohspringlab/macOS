/*
File: Recipe.h
*/

#import <Foundation/Foundation.h>

@interface RecipeXML : NSObject {

@private 
    NSNumber *_rid;			// recipe id
	NSNumber *_iPhoneContentMode;			// 
	NSNumber *_iPadContentMode;			// 
    NSString *_name;       // name of recipe.
	 NSString *_tag;       // short name of recipe.
    NSString *_categ;        // category
	 NSString *_categ2;        // category2
	 NSString *_ctime;	//cooking time
	 NSString *_ptime;	//prep time
	 NSString *_serves;
    NSString *_photopath;          
    NSMutableArray	*_ingreds;         // multiple ingredients
    NSMutableArray	*_directions;     // multiple directions
	 NSString *_comment; 
}

@property (nonatomic, strong) NSNumber *iPhoneContentMode;
@property (nonatomic, strong) NSNumber *iPadContentMode;
@property (nonatomic, strong) NSNumber *rid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *categ;
@property (nonatomic, strong) NSString *categ2;
@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, strong) NSString *ptime;
@property (nonatomic, strong) NSString *serves;
@property (nonatomic, strong) NSString *photopath;
@property (nonatomic, strong) NSMutableArray  *ingreds;
@property (nonatomic, strong) NSMutableArray  *directions;
@property (nonatomic, strong) NSString  *comment;

@end
