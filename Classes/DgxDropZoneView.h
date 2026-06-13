//
//  DgxDropZone.h
//  
//
//  Created by Apple  User on 12/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MyAppController;
@interface DgxDropZoneView : NSView {
BOOL isHidden;
   NSString *fileContents;
   IBOutlet MyAppController *myAppController;
}
@property (nonatomic, retain ) MyAppController *myAppController;
@property (nonatomic, assign) BOOL isHidden; 
@property (nonatomic, retain ) NSString *fileContents;
- (void) importRecipes ;
@end
