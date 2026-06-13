#import "Constants.h"

NSString * const ImportDgxFinderPanelDoneNotification =  @"DG_ImportDgxFinderPanelDoneNotification";
NSString * const ExportDgxUrlFetchDoneNotification = @"DG_ExportDgxUrlFetchDoneNotification";

NSString * const RecipeDeactivateNotification = @"DG_RecipeWindowDeactivateNotification";
NSString * const RecipeActivateNotification = @"DG_RecipeWindowActivateNotification";
NSString * const RemoveSearchFieldStringNotification= @"DG_RemoveSearchFieldStringNotification";
NSString * const MyFontDidChangeNotification= @"DG_MyFontDidChangeNotification";

NSString* const DG_TableFontAttributesKey =@"TableFontAttributes"; //Dictionary
NSString* const DG_TableFontSizeKey  = @"NSFontSizeAttribute"; //Key in Dictionary
NSString* const DG_TableFontKey = @"NSFontNameAttribute";
NSString* const DG_HM_APPSUPPORT_DB_PRESENT_AT_LOAD = @"DG_HM_AppSupportDbPresentAtLoad";
   //NSString* const DG_SplitViewAutosaveName = @"SplitViewAutosaveName";

NSString* const DG_MainCategoryColumnWidth = @"mainCategoryColumnWidth";
//NSString* const DG_RecipeColumnWidth = @"recipeColumnWidth";

NSString* const DG_MainWindowWidth = @"mainWindowWidth";
NSString* const DG_MainWindowHeight = @"mainWindowHeight";
   //NSString* const MainWindowWidth = @"DG_MainWindowWidth";
   //NSString* const MainWindowHeight = @"DG_MainWindowHeight";

NSString* const DG_MainCategoryColumnMinWidth = @"mainCategoryColumnMinWidth";
NSString* const RxTableViewSelectionGotCarriageReturnNotification =
               @"DG_RxTableViewSelectionGotCarriageReturnNotification";
NSString* const SelectTabItemToShowViewNotification =
               @"DG_SelectTabItemToShowViewNotification";
NSString* const DG_SpeechBeginNotification = @"SpeechBeginNotification" ;
NSString* const DG_SpeechEndNotification = @"SpeechEndNotification" ;
   //NSString* const ClearSearchBarNotification =
   //@"DG_ClearSearchBarNotification";

NSString* const SplitView_Layout_DefaultName =@"DG_SplitView_Layout_DefaultName";

NSString * const  XML_FILENAME_EXT = @"IHM_Recipes.xml";
NSString * const  XML_FILENAME  = @"IHM_Recipes";
NSString * const  DATA_FILENAME = @"HM_Mac_Recipes";
NSString * const  DATA_FILENAME_EXT = @"HM_Mac_Recipes.sqlite"; // originally appleuser/Documents

NSString * const  SHM_DATA_FILENAME_EXT = @"HM_Mac_Recipes.sqlite-shm";
NSString * const  WAL_DATA_FILENAME_EXT = @"HM_Mac_Recipes.sqlite-wal";
NSString * const  RES_DATA_FILENAME_EXT = @"DefaultRecipes.sqlite";
NSString * const  DG_IOS_DGX_IMPORT_FILENAME_EXT = @"DG_Recipes_Import.dgx";

NSString* const DG_DEFAULTS_HM_APP_VERSION_KEY = @"DG_HM_App_Version";//needed store for future runs
//NSString* const DG_DEFAULTS_HM_DATA_VERSION_KEY  =   @"DG_HM_DataVersion";//Never Read
NSString* const DG_DATA_VERSION_FOR_APP_VERSION_ONE = @"1.45";// True?

// FOR VERSION 1.1.3
////NSString* const DG_HM_APP_VERSION_NEW = @"1.1.3";//Now using BundleInfo

//NSString* const DG_RES_DATA_VERSION_NUMBER_ABOUT_WINDOW = @"1.50";

// FOR VERSION 2.0
NSString* const DG_RES_DATA_VERSION_NUMBER_ABOUT_WINDOW = @"1.51"; //NEED STILL FOR ABOUT NIB FILE

/////NSString* const DG_HM_APP_VERSION_NEW = @"2.0.0";// maybe 2.0.0
////NSString* const DG_RES_DATA_VERSION_NUMBER = @"1.50"; //NOT NEED if XML file read

//BOZO

//NSString* const DG_HM_GREATEST_RX_ID_FOR_APP_VERSION_ONE = @"1.45";//5/31/2015
NSString* const DG_HM_GREATEST_RX_ID_FOR_APP_VERSION_ONE = @"84";//Myrtle Allen?????
//NSString* const  DEFAULTS_APP_VERSION_NUMBER_KEY    =  @"DG_DefaultsAppVersionNumber";
// #define DEFAULTS_RES_DATA_VERSION_NUMBER_KEY @"DG_DefaultsDataVersionNumber" //we set Res Data Version for app release
//NSString* const  NEW_APP_VERSION_NUMBER = @"1.1";
/*
#define DEFAULTS_APP_VERSION_NUMBER_KEY      @"DG_DefaultsAppVersionNumber"
// #define DEFAULTS_RES_DATA_VERSION_NUMBER_KEY @"DG_DefaultsDataVersionNumber" //we set Res Data Version for app release
#define DEFAULTS_DATA_VERSION_NUMBER_KEY     @"DG_DefaultsDataVersionNumber"
#define RES_DATA_VERSION_NUMBER @"1.50"
#define NEW_APP_VERSION_NUMBER @"1.1" */