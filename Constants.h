/*

File: Constants.h
Abstract: Common constants across source files (screen coordinate consts, etc.)

Version: 1.7

Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
("Apple") in consideration of your agreement to the following terms, and your
use, installation, modification or redistribution of this Apple software
constitutes acceptance of these terms.  If you do not agree with these terms,
please do not use, install, modify or redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and subject
to these terms, Apple grants you a personal, non-exclusive license, under
Apple's copyrights in this original Apple software (the "Apple Software"), to
use, reproduce, modify and redistribute the Apple Software, with or without
modifications, in source and/or binary forms; provided that if you redistribute
the Apple Software in its entirety and without modifications, you must retain
this notice and the following text and disclaimers in all such redistributions
of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may be used
to endorse or promote products derived from the Apple Software without specific
prior written permission from Apple.  Except as expressly stated in this notice,
no other rights or licenses, express or implied, are granted by Apple herein,
including but not limited to any patent rights that may be infringed by your
derivative works or by other works in which the Apple Software may be
incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2008 Apple Inc. All Rights Reserved.

*/

// these are the various screen placement constants used across all the UIViewControllers
/*
//VERSION EXTERNAL CHECK EXTERNAL
#define EXTERNAL_VERSION_IHMPLUS @"1.4" 

// padding for margins
#define kLeftMargin				20.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kBottomMargin			20.0
#define kTweenMargin			10.0

// control dimensions
#define kStdButtonWidth			106.0
#define kStdButtonHeight		40.0
#define kSegmentedControlHeight 40.0
#define kPageControlHeight		20.0
#define kPageControlWidth		160.0
#define kSliderHeight			7.0
#define kSwitchButtonWidth		94.0
#define kSwitchButtonHeight		27.0
#define kTextFieldHeight		30.0
#define kSearchBarHeight		40.0
#define kLabelHeight			20.0
#define kProgressIndicatorSize	40.0
#define kToolbarHeight			40.0
#define kUIProgressBarWidth		160.0
#define kUIProgressBarHeight	24.0

// specific font metrics used in our text fields and text views
#define kFontName				@"Arial"
#define kTextFieldFontSize		18.0
#define kTextViewFontSize		18.0

// UITableView row heights
#define kUIRowHeight			50.0
#define kUIRowLabelHeight		22.0

// table view cell content offsets
#define kCellLeftOffset			8.0
#define kCellTopOffset			12.0
*/
//#define PHOTO_TITLE_MAXLEN  50

#define CATEGORY_NAME_TABLE_VIEW_OBJECT_ID 534
#define RECIPE_NAME_TABLE_VIEW_OBJECT_ID 5

//#define MAX_SMALL_PANEL_FONT_SIZE 16
#define MAX_SMALL_PANEL_FONT_SIZE 20

extern NSString * const ImportDgxFinderPanelDoneNotification ;
extern NSString * const ExportDgxUrlFetchDoneNotification ;
extern NSString * const RecipeActivateNotification;
extern NSString * const RecipeDeactivateNotification;
extern NSString * const RemoveSearchFieldStringNotification; 
extern NSString * const MyFontDidChangeNotification;
extern NSString * const RxTableViewSelectionGotCarriageReturnNotification;
extern NSString * const SelectTabItemToShowViewNotification;
   //extern NSString* const ClearSearchBarNotification;

extern NSString* const DG_TableFontAttributesKey; //Dictionary
extern NSString* const DG_TableFontSizeKey; //Key in Dictionary
extern NSString* const DG_TableFontKey;
   //extern NSString* const DG_SplitViewAutosaveName;

extern NSString* const DG_MainCategoryColumnWidth ;
//extern NSString* const DG_RecipeColumnWidth ;
extern NSString* const DG_mainWindowWidth ;
extern NSString* const DG_mainWindowHeight ;

extern NSString* const mainCategoryColumnMinWidth ;
extern NSString* const DG_SpeechBeginNotification;
extern NSString* const DG_SpeechEndNotification ;
extern NSString* const SplitView_Layout_DefaultName;

extern NSString* const DG_HM_APPSUPPORT_DB_PRESENT_AT_LOAD;

extern NSString * const  XML_FILENAME;
extern NSString * const  XML_FILENAME_EXT  ;
extern NSString * const  DATA_FILENAME ;
extern NSString * const  DATA_FILENAME_EXT ; // originally appleuser/Documents

extern NSString * const  SHM_DATA_FILENAME_EXT ;
extern NSString * const  WAL_DATA_FILENAME_EXT ;
extern NSString * const  RES_DATA_FILENAME_EXT ;
extern NSString * const  DG_IOS_DGX_IMPORT_FILENAME_EXT ;

extern NSString* const DG_DEFAULTS_HM_APP_VERSION_KEY ;//store for next upgrade
///extern NSString* const DG_DEFAULTS_HM_DATA_VERSION_KEY;//Never Read

extern NSString* const DG_RES_DATA_VERSION_NUMBER_ABOUT_WINDOW;
extern NSString* const DG_DATA_VERSION_FOR_APP_VERSION_ONE;

//extern NSString* const DG_HM_APP_VERSION_NEW ;//Now using BundleInfo
extern NSString* const DG_HM_GREATEST_RX_ID_FOR_APP_VERSION_ONE;
