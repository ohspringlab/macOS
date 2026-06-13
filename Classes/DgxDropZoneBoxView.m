//
//  DgxDropZone.m
//  
//
//  Created by Apple  User on 12/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "ImportExportDefines.h"
#import "DgxDropZoneBoxView.h"
#import "AppDelegate.h"
#import "Recipe.h"
#import "CategoryRx.h"
#import "MyAppController.h"

@implementation DgxDropZoneBoxView

@synthesize isHidden,myAppController,highlight;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
       
       
    }
    
    return self;
}

-(void)drawRect:(NSRect)rect
{
   /*------------------------------------------------------
    draw method is overridden to do drop highlighing
    --------------------------------------------------------*/
   //do the usual draw operation to display the image
   [super drawRect:rect];
   
   if ( highlight ) {
      //highlight by overlaying a gray border
      [[NSColor greenColor] set];
      [NSBezierPath setDefaultLineWidth: 6];
      [NSBezierPath strokeRect: rect];
   }
}


- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
   /*
   if(( [[[ NSApplication sharedApplication ] currentEvent ]
         modifierFlags ] & NSAlternateKeyMask ) != 0 ) {
      return NSDragOperationCopy;
   } else {
      return NSDragOperationNone;
   }*/
   
   if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) 
       == NSDragOperationGeneric)
   {
      highlight=YES;
      
      [self setNeedsDisplay: YES];
      //this means that the sender is offering the type of operation we want
      //return that we want the NSDragOperationGeneric operation that they 
      //are offering
      DLog(@"NSDragOperationCopy");
      return NSDragOperationCopy;
   }
   else
   {
      //since they aren't offering the type of operation we want, we have 
      //to tell them we aren't interested
      DLog(@"NSDragOperationNone");
      return NSDragOperationNone;
   }
    
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
   highlight=NO;
   DLog(@"NSDragOperationNone");
   [self setNeedsDisplay: YES];

}


- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender
{
   if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) 
       == NSDragOperationGeneric)
   {
      //this means that the sender is offering the type of operation we want
      //return that we want the NSDragOperationGeneric operation that they 
      //are offering,
      DLog(@"NSDragOperationGeneric highligt=%d",highlight);
      return NSDragOperationCopy;
   }
   else
   {
      //since they aren't offering the type of operation we want, we have 
      //to tell them we aren't interested
      DLog(@"NSDragOperationNone");
      return NSDragOperationNone;
   }
}

- (void)draggingEnded:(id <NSDraggingInfo>)sender
{
   //we don't do anything in our implementation
   //this could be ommitted since NSDraggingDestination is an infomal
   //protocol and returns nothing
   DLog(@"hiya");
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
   //DLog(@"hiya");
   return YES;
}


- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
   NSPasteboard *paste = [sender draggingPasteboard];
   //gets the dragging-specific pasteboard from the sender
   NSArray *types = [NSArray arrayWithObjects://NSTIFFPboardType, 
                     NSFilenamesPboardType, nil];
   //a list of types that we can accept
   NSString *desiredType = [paste availableTypeFromArray:types];
   NSData *carriedData = [paste dataForType:desiredType];
   
   //types = [NSArray arrayWithObjects://NSTIFFPboardType,
   //         @"com.DrummingGrouse.dgx", nil];
   //NSString *desiredTypeDgx = [paste availableTypeFromArray:types];
   //NSData *carriedData2= [paste dataForType:desiredType];
   
   if (nil == carriedData)
   {
      //the operation failed for some reason
      NSRunAlertPanel(@"Paste Error", @"Sorry, but the paste operation failed, because of no carried datD.", 
                      nil, nil, nil);
      return NO;
   }
   else
   {
      //the pasteboard was able to give us some meaningful data
     /* if ([desiredType isEqualToString:NSTIFFPboardType])
      {
         //we have TIFF bitmap data in the NSData object
         NSImage *newImage = [[NSImage alloc] initWithData:carriedData];
         [self setImage:newImage];
         [newImage release];    
         //we are no longer interested in this so we need to release it
      }
      else */ 
      
      if ([desiredType isEqualToString:NSFilenamesPboardType])
      { 
         DLog(@"desiredType isEqualToString:NSFilenamesPboardType");
         //we have a list of file names in an NSData object
         NSArray *fileArray = 
            [paste propertyListForType:@"NSFilenamesPboardType"];
         //be caseful since this method returns id.  
         //We just happen to know that it will be an array.
         if ([fileArray count] == 0) {
            highlight = NO;
            [self setNeedsDisplay:YES];
            NSRunAlertPanel(@"File Type Error",@"Please drop a .dgx recipe file.",
                            nil, nil, nil);
            return NO;
         }
         NSString *path = [fileArray objectAtIndex:0];
         //assume that we can ignore all but the first path in the list
         //NSImage *newImage = [[NSImage alloc] initWithContentsOfFile:path];
         NSError *error99 = nil;
         NSStringEncoding theEncoding;
         
         NSString *dgxText = [NSString stringWithContentsOfFile:path
                                    usedEncoding:&theEncoding  error:&error99];
         
         if (nil == dgxText)
         {
            //we failed for some reason
            NSString *informString = [NSString stringWithFormat:@"Trouble finding text in DGX file."];
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setAlertStyle:NSInformationalAlertStyle];
            [alert setMessageText:@"No Data In DGX file"];
            [alert setInformativeText:informString];
            //- (void) recipeNameAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
            [alert beginSheetModalForWindow:[self window]
                              modalDelegate:self
                             didEndSelector:@selector(noDgxTextAlertDidEnd:returnCode:                                                contextInfo:)
                                contextInfo:nil];
       /*
            NSRunAlertPanel(@"File Reading Error", 
                            [NSString stringWithFormat:
                             @"Sorry, but app failed to open the file at \"%@\" ",
                             path], nil, nil, nil); */
            return NO;
         }
         else
         {     //there was text
            //
            // Check now for proper DGX extension.
            //
            BOOL isDgxFile = [[[path pathExtension] lowercaseString] isEqualToString:@"dgx"];
            //newImage is now a new valid image
            if(!isDgxFile){
               highlight = NO;
               DLog(@"highlight set to NO after file extension found missing.");
               [self setNeedsDisplay:YES];
               //DISPLAY ALERT THAT FILE WAS NOT DGX FILE
               //the operation failed for some reason
               //NSInteger NSRunAlertPanel ( NSString *title, NSString *msgFormat, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ... );
               NSRunAlertPanel(@"File Type Error",@"Please drop a .dgx recipe file.",
                               nil, nil, nil);
               
               return NO;
               // NOW POSSIBLY CHECK FOR AT LEAST ONE SET BRACKETS, DIRECTIONS_TAG, COMMENTS_TAG
            }
            /// Check is done now let importRecipes do file openning
            //[self.myAppController setDgxFileContents:dgxText];
            //NSURL *tempURL = [NSURL fileURLWithPath:path];
            [self.myAppController setDgxFileURL:[NSURL fileURLWithPath:path]];
         }
         //[newImage release];
      }
      else
      {
         //this can't happen
         NSAssert(NO, @"This can't happen. PBoard Trouble.");
         return NO;
      }
   }
   //[self setNeedsDisplay:YES];    //redraw us with the new image
   return YES;
}

- (void) noDgxTextAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo{
   
   
   [[alert window] orderOut:self];
   
}


- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
   //re-draw the view with our new data
   highlight=NO;
   [self setNeedsDisplay:YES];
   [[self  myAppController] importRecipes:[self.myAppController dgxFileURL]];
   
}


   
   
- (void)importRecipeAlertDidEnd:(NSAlert *)alert
                          returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
   //NSLog(@"clicked  button\n");
   
   
   [[alert window] orderOut:self];
   return;
}




- (void) dealloc {
   [self unregisterDraggedTypes];
}

@end
