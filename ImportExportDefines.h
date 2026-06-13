#define BASE_RECIPES_FILENAME_IMPORT @"DG_Recipes_Import"
#define BASE_RECIPES_FILENAME_EXPORT @"DG_Recipes_Export"
#define RECIPES_FILE_EXTENSION @"dgx"
   /// #define RECIPES_FILE_EXTENSION_UPPERCASE @"DGX" // comment 1/28/13
//#define BEGIN_RECIPE_NAME @"\[\["
#define BEGIN_RECIPE_NAME @"\[\["

#define END_RECIPE_NAME @"]]"
#define START_CATEGORY_TAG  @"::"
#define DIRECTIONS_TAG_STRING @"Directions@"
#define COMMENTS_TAG_STRING @"Comments@"
#ifdef DEBUG
#define MAX_RECIPE_COUNT_FOR_NO_DGX_DELETE  5
#else
#define MAX_RECIPE_COUNT_FOR_NO_DGX_DELETE  0
#endif

#define BASE_FAQ_FILENAME @"FAQ For Recipe Import Export"
#define FAQ_FILE_EXTENSION @"txt"