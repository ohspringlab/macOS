//
//  MyPanel.h
//  iHungryMac386
//
//  Created by Mark on 12/4/12.
//
//

#import <Cocoa/Cocoa.h>
#import "EditRecipeController.h"

@interface MyPanel : NSPanel <NSTabViewDelegate> {

IBOutlet EditRecipeController* editRecipeController;
}
@end
