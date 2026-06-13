//
//  main.m
//  iHungryMac_ND
//
//  Created by Mark on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
#import "Constants.h"

int main(int argc, char *argv[])
{
   NSFileManager *fm = [NSFileManager defaultManager];
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   NSURL *appFilesDir = [[fm URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject] ;
   NSURL *editAppFilesDir = [appFilesDir URLByAppendingPathComponent:@"HungryMe"];
   NSURL * appSuppDbURL = [editAppFilesDir URLByAppendingPathComponent:DATA_FILENAME_EXT];
   
   BOOL appSupportDbFileExistsAtLoad = [fm fileExistsAtPath:[appSuppDbURL path]];
   //file:///Users/mbarron/Library/Containers/com.DrummingGrouse.HungryMe/Data/Library/Application%20Support/com.DrummingGrouse.HungryMe/HM_Mac_Recipes.sqlite
   
   if(appSupportDbFileExistsAtLoad)
      [defaults setBool:YES forKey:DG_HM_APPSUPPORT_DB_PRESENT_AT_LOAD];
   else
      [defaults setBool:NO forKey:DG_HM_APPSUPPORT_DB_PRESENT_AT_LOAD];
   [defaults synchronize];
   
   return NSApplicationMain(argc, (const char **)argv);
}
