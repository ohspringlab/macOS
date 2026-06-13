//
//  DgxDropZone.h
//  
//
//  Created by Apple  User on 12/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MyAppController;
@interface DgxDropZoneBoxView : NSBox {
   BOOL isHidden;
   //highlight the drop zone
   BOOL highlight;
   
   IBOutlet MyAppController *myAppController;
   //NSString *dgxFileContents;
}
//@property (nonatomic, retain ) NSString *dgxFileContents;
@property (nonatomic, strong ) MyAppController *myAppController;
@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, assign) BOOL highlight;

//- (void) importRecipes ;
@end
