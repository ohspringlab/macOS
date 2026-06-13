
//
//  MyCatArrayController.m
//  iHungryMac386
//
//  Created by Mark on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyCatArrayController.h"
#import "CategoryRx.h"

@implementation MyCatArrayController
@synthesize appDelegate;
@synthesize myAppController;

#ifdef XXXXX
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
      // NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
      /**
       NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES ];
       
       [self setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
       [sortDescriptor release]; 
       
       NSArray* sortDescriptors =	[NSArray arrayWithObject:
       [[NSSortDescriptor alloc] initWithKey:@"sortIndex" ascending:YES 
       selector:@selector(compare:)] ];
       **/
    }
    
    return self;
}
#endif

- (void) awakeFromNib {
   [super awakeFromNib];// must be called, may be anytime in this method
   
   [self setAppDelegate:(AppDelegate*)[[NSApplication sharedApplication] delegate]];
   //compareCategorySortIndeces
  
  // NSSortDescriptor * sd2 = [[NSSortDescriptor alloc] initWithKey:@"sortIndex" ascending:YES selector:@selector(compare:)];
  // [self setSortDescriptors:[NSArray arrayWithObjects :sd2,nil ]];
  //sd1 release]; 
   //[sd2 release];
}

- (void)remove:(id)sender
{               // remove selected from receiver
    [super remove:sender];
    [self reindexEntries];
}

- (void)insertObject:(id)object atArrangedObjectIndex:(NSUInteger)index
{
    [object setValue:[NSNumber numberWithInteger:index] forKey:@"sortIndex"];
    [super insertObject:object atArrangedObjectIndex:index];
    [self reindexEntries];
}

- (void) reindexEntries
{
    // Note: use a temporary array since modifying an item in arrangedObjects
    //       directly will cause the sort to trigger thus throwing off
    //       the re-indexing.
    //int count = [[self arrangedObjects] count];
    NSArray *tmpArray = [NSArray arrayWithArray:[self arrangedObjects]];
    //NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:[tmpArray count]] ;
    NSEnumerator *enumerator = [tmpArray objectEnumerator];
    NSComparisonResult result;
    CategoryRx* aCategory;
    int j = 0;
    while (aCategory = [enumerator nextObject]) {//sortIndex NSNumber
        result = [aCategory.name compare:@"Browse All"];
        if(result == NSOrderedSame){
            //[aCategory setSortIndex:[NSNumber numberWithInt:-1]];
            [aCategory setValue:[NSNumber numberWithInt:-1] forKey:@"sortIndex"];
            //[mutArray addObject:aCategory];
        }
        else
         [aCategory setValue:[NSNumber numberWithInt:j] forKey:@"sortIndex"];
    }
    DLog(@"[tmpArray valueForKey:@'name']=%@",[tmpArray valueForKey:@"name"]);
}
/*
Not done yet

It seems that this would be it. However, the initial sort upon first run still does not work. At first this issue took a bit of hunting to track down but, after reading the Core Data docs it becomes somewhat obvious. In order to increase performance Core Data will initially read in empty stubs of your data objects. These stubs are known as faults. Whenever an attribute of a fault object is accessed by your code then the entire data for the object is actually retrieved and filled in. This all happens behind the scenes and your code never need know the difference. More can be read on this topic in the Core Data documentation.

It seems that either there is a bug or a gap in my understanding with regards to faults and KVC. NSSortDescriptor will access its defined key attribute for the data object via KVC. From my experience this KVC access does not trigger the fault object to be filled in by Core DatD. This leaves the sort to work on empty objects – thus not working the first time the data is displayed. In order to resolve/work around this issue more NSArrayController subclassing is needed:*/


- (NSArray *)arrangeObjects:(NSArray *)objects
{
    // Note: at this point the data objects are CoreData faults and thus contain
    //       no real datD. So, go ahead and batch fault (load) the data for use
    //       in sorting
    //DLog(@"XXX self=%@",self);
 
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.myAppController.appDelegate managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"CategoryRx"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setReturnsObjectsAsFaults:NO];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self IN %@", objects];
    [request setPredicate:predicate];
    [moc executeFetchRequest:request error:&error];
   NSArray *arranged = [super arrangeObjects:objects];
    return arranged;
}

@end
