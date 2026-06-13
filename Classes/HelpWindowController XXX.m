//
//  HelpWindowController.m
//  iHungryMac386
//
//  Created by Apple  User on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpWindowController.h"
#import "AppDelegate.h"

@implementation HelpWindowController

@synthesize  webView;

- (NSString *)windowNibName {
   
   return @"Help";
}



- (void)awakeFromNib {
   
   //NSURL*url= [NSURL URLWithString:@"file://HungryMe.html"]; //[NSURL URLWithString:@"http://www.google.com"];
   NSURL *url = [[NSBundle mainBundle] URLForResource: @"HungryMe" withExtension:@"html"];

   //[NSURL URLWithString:@"file:///DataDisk/Cocoa/HungryMeHelp/HungryMe.html"];   //
   NSURLRequest*request=[NSURLRequest requestWithURL:url];
   [[webView mainFrame] loadRequest:request];

   /********
   NSString *myText3;
   NSString *myText2;
   NSString *myText1;/Volumes/DataDisk/Cocoa/iHungryMac386/Classes/HelpWindowController.m:27:6: Unknown receiver 'webview'; did you mean 'WebView'?
   
   NSFont *tableFont = [(AppDelegate*)[[NSApplication sharedApplication] delegate] tableFont];
   NSDictionary *tableFontDict = [[tableFont fontDescriptor] fontAttributes];
   NSNumber * numTableFontSize = [tableFontDict objectForKey:NSFontSizeAttribute];
   
   CGFloat floatHelpFontSize = ( [numTableFontSize floatValue] <= 24.0 ) ? [numTableFontSize floatValue] : 24.0;
   
   NSFont *helpFont =[NSFont fontWithName:@"Helvetica" size:floatHelpFontSize];               
   
   NSString *filePath3 = [[NSBundle mainBundle] pathForResource:@"Import Export User Recipes FAQ HungryMe" ofType:@"txt"];  
   if (filePath3) {  //+ (id)stringWithContentsOfFile:(NSString *)path usedEncoding:(NSStringEncoding *)enc error:(NSError **)error
      NSError *error = nil;
      NSStringEncoding *encodingUsed;
      myText3 = [NSString stringWithContentsOfFile:filePath3 usedEncoding:encodingUsed error:&error]; 
   }  
   NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"Import and Export Help" ofType:@"txt"];
   if (filePath2) {  //+ (id)stringWithContentsOfFile:(NSString *)path usedEncoding:(NSStringEncoding *)enc error:(NSError **)error
      NSError *error = nil;
      NSStringEncoding *encodingUsed = nil;
      myText2 = [NSString stringWithContentsOfFile:filePath2 usedEncoding:encodingUsed error:&error]; 
   }  
   NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"Getting Started Help" ofType:@"txt"];
   if (filePath1) {  //+ (id)stringWithContentsOfFile:(NSString *)path usedEncoding:(NSStringEncoding *)enc error:(NSError **)error
      NSError *error = nil;
      NSStringEncoding *encodingUsed = nil;
      myText1 = [NSString stringWithContentsOfFile:filePath1 usedEncoding:encodingUsed error:&error]; 
   }  
  
   if (myText3) { 
      [textView3 setEditable:YES];
      [textView3 insertText: myText3];
      [textView3 didChangeText];
      [textView3 setEditable:NO];
   } 
   if (myText2) { 
      [textView2 setEditable:YES];
      [textView2 insertText: myText2];
      [textView2 didChangeText];
      [textView2 setEditable:NO];
   } 
   
   if (myText1) { 
      [textView1 setEditable:YES];
      [textView1 insertText: myText1];
      [textView1 didChangeText];
      [textView1 setEditable:NO];
   } 
                     
   NSTextStorage *textStorage = [textView3 textStorage];
   [textStorage beginEditing];
   [textStorage setFont:helpFont];
   [textStorage endEditing];
   
   textStorage = [textView2 textStorage];
   [textStorage beginEditing];
   [textStorage setFont:helpFont];
   [textStorage endEditing];
   
   textStorage = [textView1 textStorage];
   [textStorage beginEditing];
   [textStorage setFont:helpFont];
   [textStorage endEditing];
    ***/
         /***
         [textStorage enumerateAttributesInRange: NSMakeRange(0, [textStorage length])
                                         options: 0
                                      usingBlock: ^(NSDictionary *attributesDictionary,
                                                    NSRange range,
                                                    BOOL *stop)
          {
#pragma unused(stop)
             NSFont *font = [attributesDictionary objectForKey:NSFontAttributeName];
             if (font) {
                [textStorage removeAttribute:NSFontAttributeName range:range];
                font = [[NSFontManager sharedFontManager] convertFont:font toSize:[font pointSize] + 1];
                [textStorage addAttribute:NSFontAttributeName value:font range:range];
             }
          }];
          ***/
}


- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)dealloc
{
   [webView release];
   
   [super dealloc];
}

@end
