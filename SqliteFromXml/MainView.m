//
//  MainView.m
//  iHungryMeUniv 6
//
//  Created by Apple User on 8/6/12.
//  Copyright (c) 2012 DrummingGrouse. All rights reserved.
//

#import "MainView.h"

@implementation MainView

- (id)initWithFrame:(CGRect)paramFrame
{
   
   NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MainView"
                                                         owner:nil
                                                       options:nil];
   
   
   if ([arrayOfViews count] < 1){
      [self release];
      return nil;
   }
   
   MyView *newView = [[arrayOfViews objectAtIndex:0] retain];
   [newView setFrame:paramFrame];
   
   [self release];
   self = newView;
   
   return self;
   
   
}


MyView *myView = [[MyView alloc] initWithFrame:self.view.bounds];
[self.view addSubview:myView];
[myView release];




- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@end
