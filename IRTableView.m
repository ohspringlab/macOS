//
//  IRTableView.m
//  iHungryMac386
//
//  Created by Mark on 12/3/12.
//
//

#import "IRTableView.h"
#import "RxFilteredArrayController.h"
#import "AppDelegate.h"
#import  "Recipe.h"
#import "Constants.h"

@implementation IRTableView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void)keyDown:(NSEvent *)event
{
      // Based on LTKeyPressTableView.
      //https://github.com/jacobx/thoughtkit/blob/master/LTKeyPressTableView
   
      //id delegate = [self delegate];
   
      // (removed unused LTKeyPressTableView code)
   
   unichar key = [[event charactersIgnoringModifiers] characterAtIndex:0];
   if(key == NSCarriageReturnCharacter){
      if([self selectedRow] == -1)
      {
         NSBeep();
      }
      
      BOOL isEditing = ([[self.window firstResponder] isKindOfClass:[NSText class]]);
                        //&&
                        //[[[self.window firstResponder] delegate] isKindOfClass:[AppDelegate class]]);
                        ////[[[self.window firstResponder] delegate] isKindOfClass:[IRTableView class]])
      if (!isEditing)
      {
         NSArray *selectedObjects = [rxFilteredArrayController selectedObjects];
         Recipe *theRecipe = [selectedObjects objectAtIndex:0];
         NSDictionary *dict = [NSDictionary dictionaryWithObject:theRecipe forKey:@"Recipe"];
         [[NSNotificationCenter defaultCenter] postNotificationName:RxTableViewSelectionGotCarriageReturnNotification object:self userInfo:dict];
         
         return;
      }
      
   }
   /***/
      // c == 99 63 143 Dec Hx Oct
   if (([event modifierFlags] & NSControlKeyMask) &&
       ([event modifierFlags] & NSCommandKeyMask) &&
       key == '\143'
       )
   {
      NSNotificationCenter *nc = [ NSNotificationCenter  defaultCenter];
      [nc postNotificationName:RemoveSearchFieldStringNotification object:self userInfo:nil];
      return;
   }
    /***/
      // still here?
   [super keyDown:event];
}


@end
