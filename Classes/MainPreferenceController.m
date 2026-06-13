//
//  MainPreferenceController.m
//  iHungryMac_ND
//
//  Created by Mark on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainPreferenceController.h"
//#import "Foundation"
NSString* const DG_TableBgColorKey = @"TableBgColor";
NSString* const DG_AllowDetailWindowCopiesKey = @"DetailWindowCopiesFlag";

@implementation MainPreferenceController
/**
- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
} **/


- (id)init 
{ // Check this out
   self = [super initWithWindowNibName:@"MainPreference"];
   if (self) {
      // Initialization code here.
   }
   
   return self;
}

/*
 NSMutableDictionary *font_attributes = [[NSMutableDictionary alloc] init];
 
 NSFont *font = [NSFont fontWithName:@"Futura-MediumItalic" size:42];
 
 [font_attributes setObject:font forKey:NSFontAttributeName];
 ------
 attribs = [[NSMutableDictionary alloc] init];
 c = [NSColor redColor];
 fnt = [NSFont fontWithName:@"Times Roman" size:_size];
 
 [attribs setObject:c forKey:NSForegroundColorAttributeName];
 [attribs setObject:fnt forKey:NSFontAttributeName];

 */
- (NSColor *)tableBgColor{
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   NSData *colorAsData = [defaults objectForKey:DG_TableBgColorKey];
   return  [NSKeyedUnarchiver unarchiveObjectWithData:colorAsData];
}

- (BOOL)detailCopiesFlag{
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   return [defaults boolForKey:DG_AllowDetailWindowCopiesKey ];
}

- (void) windowDidLoad{
   [colorWell setColor:[self tableBgColor]];
   [allowDetailCopiesCheckBox setState:[self detailCopiesFlag]];
}

- (IBAction)changeBackgroundColor:(id)sender{
   NSColor *color = [colorWell color];
   NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:color];
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   [defaults setObject:colorAsData forKey:DG_TableBgColorKey];
}

- (IBAction)changeDetailCopies:(id)sender{
   NSInteger state = [allowDetailCopiesCheckBox state];
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   [defaults setBool:(BOOL)state forKey:DG_AllowDetailWindowCopiesKey];
}

@end
