//
//  RecipeWindowController.h
//  iHungryMac_ND
//
//  Created by Mark on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyImageView.h"
#import "Photo.h"
//extern NSString *BWGraphDocument_DocumentDeactivateNotification;
//extern NSString *BWGraphDocument_DocumentActivateNotification;
//@class MyTextView;
@class Recipe;
@class AppDelegate;
@class RecipePrintView;
@class RecipeWindow;
@class MyCatArrayController;
   //@class MySpeechButton;
@class MyButton;
//@class MySpeechStopButton;
@class SpeechController;
@class MyTextView;
@class MyAppController; 
@interface RecipeWindowController : NSWindowController <NSWindowDelegate,NSTabViewDelegate,NSPageControllerDelegate> {
   AppDelegate* appDel; 
   Recipe* recipe;
   IBOutlet MyTextView *textViewID;
   IBOutlet NSTextView *textViewI;
   IBOutlet NSTextView *textViewD;
   IBOutlet NSTextView *textViewC;
   IBOutlet MyButton *speechButton;
   
   IBOutlet MyButton *stopButton;
   IBOutlet NSTabViewItem *tabViewItemID;
   IBOutlet NSTabViewItem *tabViewItemI;
   IBOutlet NSTabViewItem *tabViewItemD;
   IBOutlet NSTabViewItem *tabViewItemC;
   IBOutlet NSTabViewItem *tabViewItemP;
   
   IBOutlet NSTextField *infoView;
   
   NSPrintInfo *printInfo;
   BOOL printSelected;
   IBOutlet NSScrollView *scrollViewID;
   IBOutlet NSScrollView *scrollViewI;
   IBOutlet NSScrollView *scrollViewD;
   IBOutlet NSScrollView *scrollViewC;
   IBOutlet NSTableView *rxCatTableView;
   IBOutlet NSTableColumn *tableColumnName;
   IBOutlet MyCatArrayController *myCatArrayController;
   NSArray *arrayAllRecipeCatNames;
   NSArray *arrayTheRecipeCats;
   IBOutlet NSTabView *tabViewRecipe;
   
   IBOutlet MyImageView *imageView;
    
   NSFont *smallPanelFont;
   NSUInteger currentTabId;
   BOOL speechOnGoing;
   IBOutlet SpeechController *speechController;
   MyAppController *myAppController;
}
@property (strong) IBOutlet NSTextField *infoNameTextField;
@property (strong) IBOutlet NSButton *prevPhotoButton;
@property (strong) IBOutlet NSButton *nextPhotoButton;
@property (strong) IBOutlet NSPageController *pageController;
@property (strong,nonatomic) IBOutlet MyImageView *imageView;
//@property (strong,nonatomic) IBOutlet NSTextField *infoLabel;
@property (strong, nonatomic) NSArray *imageArray;
@property (assign) IBOutlet NSLayoutConstraint *imageAspectRatio;

@property (nonatomic, strong) IBOutlet NSTextField *infoView;
@property (nonatomic, strong) MyAppController *myAppController;
@property (nonatomic, strong) SpeechController *speechController;
@property (nonatomic, assign) BOOL speechOnGoing;
@property (nonatomic, strong) NSTabViewItem *tabViewItemID;
@property (nonatomic, strong) NSTabViewItem *tabViewItemI;
@property (nonatomic, strong) NSTabViewItem *tabViewItemD;
@property (nonatomic, strong) NSTabViewItem *tabViewItemC;
@property (nonatomic, strong) IBOutlet NSTabViewItem *tabViewItemP;

@property (nonatomic, assign) NSUInteger currentTabId;

@property (nonatomic, strong) NSTabView *tabViewRecipe;
@property (nonatomic, strong) NSTableColumn *tableColumnName;
@property (nonatomic, strong)  NSFont *smallPanelFont;
@property (nonatomic,strong) NSArray *arrayTheRecipeCats;
@property (nonatomic, strong) NSArray *arrayAllRecipeCatNames;
@property (nonatomic, strong) MyCatArrayController *myCatArrayController;
@property (nonatomic, strong) NSTableView *rxCatTableView;
@property (nonatomic, strong) NSScrollView *scrollViewID;
@property (nonatomic, strong) NSScrollView *scrollViewI;
@property (nonatomic, strong) NSScrollView *scrollViewD;
@property (nonatomic, strong) NSScrollView *scrollViewC;
@property BOOL printSelected;
@property (nonatomic, strong)AppDelegate* appDel;
@property (nonatomic, strong)NSPrintInfo *printInfo;
@property (nonatomic, strong) MyButton *speechButton;
@property (nonatomic, strong) MyButton *stopButton;

@property (nonatomic, strong) MyTextView *textViewID;
@property (nonatomic, strong) NSTextView *textViewI;
@property (nonatomic, strong)NSTextView *textViewD;
@property (nonatomic, strong)NSTextView *textViewC;

@property (nonatomic, strong)Recipe* recipe;


@end
