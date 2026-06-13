//
//  NSArrayController+NameCheck.h
//  
//
//  Created by Mark on 1/7/13.
//
//


#import <Foundation/Foundation.h>

@interface NSArrayController (NameCheck)

- (BOOL) isNameLengthOK_DG:(NSString*)name ;
- (BOOL) isNameUnique_DG:(NSString*)name ;

@end
