//
//  RxFilteredArrayController.m
//  iHungryMac386
//
//  Created by Apple  User on 12/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RxFilteredArrayController.h"
#import "MyCatArrayController.h"
#import "NSArrayController+NameCheck.h"

@implementation RxFilteredArrayController

@synthesize searchString;
@synthesize searchField;
@synthesize myCatArrayController;
@synthesize tableViewCat;

- (id)init
{
   self = [super init];
   if (self) {
      // Initialization code here.
   }
   
   return self;
}

- (void)awakeFromNib{
   [super awakeFromNib];// must be called, may be anytime in this method
   //searchField.delegate = self;
   /*
   NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
   [center addObserver: self
              selector: @selector(handleTextDidChangeNotification:)
                  name:NSTextDidChangeNotification //ExportDgxFolderFetchDoneNotification  //window deleted or made non-key
                object:nil];// delivered if from this IBOutlet
    */
}

/*
#pragma mark   handleTextDidChangeNotification

- (void) handleTextDidChangeNotification:(NSNotification * ) note{
   [tableViewCat selectColumnIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
} */

#pragma mark NSControlTextEditingDelegate methods

/*
- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor{
   if (control == searchField) {
      [tableViewCat selectColumnIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
   }
   return YES;
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{
   if (control == searchField) {
      [tableViewCat selectColumnIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
   }
   return NO;
}*/

// returns an array containing the content of the objects arranged
// with the user's critera entered into the search box thingie



- (NSArray *) arrangeObjects: (NSArray *) objects
{
    //DLog(@"ZZZ self=%@",self);
   // result of the filtering
   NSArray *returnObjects = objects;
   
   // if there is a search string, use it to compare with the
   // search field string
   
   if (searchString != nil) {
      
      // where to store the filtered
      NSMutableArray *filteredObjects;
      filteredObjects = [NSMutableArray arrayWithCapacity: [objects count]];
      
      // walk the enumerator
      NSEnumerator *enumerator = [objects objectEnumerator];
      
      id item; // actully BWFileEntries
      while (item = [enumerator nextObject]) {
         
         // get the filename from the entry
         NSString *rxName;
         rxName = [item valueForKeyPath: @"name"];
         
         // see if the file name matches the search string
         NSRange range;
         range = [rxName rangeOfString: searchString
                                 options: NSCaseInsensitiveSearch];
         
         // found the search string in the file name, add it to
         // the result set
         if (range.location != NSNotFound) {
            [filteredObjects addObject: item];
         }
      }
      
      returnObjects = filteredObjects;
   }
   
   // have the superclass arrange them too, to pick up NSTableView sorting
   return ([super arrangeObjects:returnObjects]);
   
} // arrangeObjects

// and then to set the search string:

- (void) setSearchString: (NSString *) string
{
   
   if ([string length] == 0) {
      searchString = nil;
   } else {
      searchString = [string copy];
   }
   
} // setSearchString


- (void) search: (id) sender
{
   [self setSearchString: [sender stringValue]];
   [self rearrangeObjects];
   
} // search


@end
