//
//  MyTableView.m
//  iHungryMac_ND
//
//  Created by Mark on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyTableView.h"
#import "AppDelegate.h"

/*
NSString* const DG_TableFontAttributesKey =@"TableFontAttributes"; //Dictionary
NSString* const DG_TableFontSizeKey  = @"NSFontSizeAttribute"; //Key in Dictionary
NSString* const DG_TableFontKey = @"NSFontNameAttribute";
*/
@implementation MyTableView
@synthesize appDelegate;

//- (id)initWithNib
/***
- (id)init
{
   self = [super init];
    if (self) {
        // Initialization code here.
       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
       NSDictionary *fontAttributes = [defaults objectForKey:
 ];
       NSFontDescriptor *fontDescriptor = [NSFontDescriptor fontDescriptorWithFontAttributes:fontAttributes];
       NSNumber *fontSize = [NSNumber numberWithFloat:[fontDescriptor pointSize]];
       DLog(@"fontDescriptor=%@",fontDescriptor);
       DLog(@"fontAttributes=%@",fontAttributes);
       NSAssert(([fontSize intValue] > 0 ),@"fontAttributes == nil!");
       NSFont *aFont = [NSFont fontWithDescriptor:fontDescriptor size:[fontSize floatValue ]] ;
       [self setFont:aFont];
       //[self setSelectionFont:aFont];
  //     [self setSelectionFontSize:fontSize ];
  //     [self setSelectionFont:[NSFont fontWithDescriptor:fontDescriptor size:[fontDescriptor pointSize]]];
       DLog(@"fontAttributesDict=%@",fontAttributes);
   //    DLog(@"selectionFontSize=%@\nselectionFont=%@",selectionFontSize,selectionFont);
       DLog(@"defaults=%@",defaults);
      
    }
    
    return self;
}
 ***/

-(BOOL)becomeFirstResponder
{
   BOOL rval = [super becomeFirstResponder];
   
   //if (rval) 
      //[self fontPanelUpdate];
   return rval;
}





@end
