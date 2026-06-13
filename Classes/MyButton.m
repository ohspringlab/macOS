//
//  MyButton.m
//  iHungryMac386
//
//  Created by Mark on 12/1/12.
//
//

#import "MyButton.h"
#import "MyButtonCell.h"

@implementation MyButton;
@synthesize theName;

#pragma mark FirstResponder methods

- (BOOL) acceptsFirstResponder{
   BOOL retVal = [self isEnabled];
   /***
   if (!self.theName) {
      [self setTheName:[ self getName]];
   }
      //[[self cell] setShowsFirstResponder:([[self window] firstResponder] == self)];
   DLog(@"%@:AcceptsFR=%d",self.theName, [self isEnabled]);
    **/
   //DLog(@"%@:AcceptsFR=%d",self.title, [self isEnabled]);
   return retVal;
}

- (BOOL) becomeFirstResponder{
   /*
   if (!self.theName) {
      [self setTheName:[ self getName]];
   }
      //[[self cell] setNeedsDisplayInRect:[self.cell frame]];
   DLog(@"BecomeFR theName=%@",self.theName);
    */
    
    [self setKeyEquivalent:@"\r"];
    
   [[self cell] setShowsFirstResponder:YES];
   /**
      ///  [self.window setDefaultButtonCell:[self cell]];
      [[self cell] setShowsFirstResponder:YES];
      //[self.cell display ];
      ////  [[self cell] setShowsFirstResponder:([[self window] firstResponder] == self)];
    */
   [self.window setDefaultButtonCell:self.cell];
   [self setFocusRingType:NSFocusRingTypeDefault];
   DLog(@"%@:BecomesFR=%d",self.title, [self isEnabled]);
   return YES;
}
- (BOOL) resignFirstResponder{ // default is YES
      //DLog(@"%@:ResignFR=%d\n\n",self.theName, [self isEnabled]);
   [self setKeyEquivalent:@""];
   [self setFocusRingType:NSFocusRingTypeNone];
   return YES;
}


- (NSString *)getName{
   NSString *aName;
   switch (self.tag) {
      case 100:
         aName=@"AddCat Button";
         break;
      case 101:
         aName=@"DeleteCat Button";
         break;
      case 102:
         aName=@"EditCat Button";
         break;
      case 103:
         aName=@"SearchField";
         break;
      case 104:
         aName=@"AddRx Button";
         break;
      case 105:
         aName=@"DeleteRx Button";
         break;
      case 106:
         aName=@"EditRx Button";
         break;
      default:
         aName=@"BAD CASE";
         break;
   }
   return aName;
}


/*
 - (BOOL) resignFirstResponder{ // default is YES
 // must call super somewhere
 DLog(@"Resigning");
 [self.window disableKeyEquivalentForDefaultButtonCell]; // Enter-Key activates no button now
 return YES;
 }*/
/**
 - (BOOL)acceptsFirstResponder
 {
 //return [self allowsFocus] && [self isEnabled];
 DLog(@"[self isEnabled]=%d",[self isEnabled]);
 [self setShowsFirstResponder:[self isEnabled]];
 
 return  [self isEnabled];
 }
 
 - (BOOL)resignFirstResponder
 {
 [self setShowsFirstResponder:NO];
 return YES;
 }
 **/

@end
