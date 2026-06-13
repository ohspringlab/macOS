//
//  RecipePrintView.h
//  iHungryMac386
//
//  Created by Mark on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RecipePrintView : NSView {
   NSMutableDictionary *attributes;
   float lineHeight;
   NSRect pageRect;
   int linesPerPage;
   int currentPage;
@private
    
}

@property (nonatomic,strong)   NSMutableDictionary *attributes;
@property (nonatomic,assign)   float lineHeight;
@property (nonatomic,assign)   NSRect pageRect;
@property (nonatomic,assign)   int linesPerPage;
@property (nonatomic,assign)   int currentPage;

@end
