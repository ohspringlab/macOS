/*

File: XmlListReader5.m
Abstract: Uses NSXMLParser to extract the contents of an XML file and map it
Objective-C model objects.
 
// 8/21/12 used now also by SqliteFromXML
 // 2/16/14 used now also by SqliteFromXML
*/
   //#import <UIKit/UIKit.h>
   //#import "XmlListReader.h"
   //#import "XmlListReader4.h"
#import "XmlListReader5.h"
#import "DebugMacros.h"
   //#ifndef IHUNGRYME_PLUS
#import "AppDelegate.h"
   //#else
   //#import "iHungry_MeAppDelegate.h"
   //#endif

#import "IngredXML.h"
#import "RecipeXML.h"
#import "VersionXML.h"
#import "Category.h"
#import "Recipe.h"
#import "Photo.h"
   //#import "Photo.h"

//extern NSString * const DG_HandleAddRecipeNotification;
static NSUInteger parsedRecipesCounter;

@implementation XmlListReader

@synthesize currentRecipeXMLObject ;
@synthesize contentOfCurrentRecipeXMLProperty ;
//@synthesize recipeXMLCategDx ;
@synthesize theAppDelegate;
@synthesize categorySetXML;
   //@synthesize dictionaryCodeDisplayCategory;
@synthesize getVersionOnly;
@synthesize recipeInsertionCount;
@synthesize categoryInsertionCount;
@synthesize doesDatabaseExist;
@synthesize recipeXMLCheckedCnt;
   //@synthesize categoryArray;
// Limit the number of parsed RecipeXMLs to 50. Otherwise the application runs very slowly on the device.
//#define MAX_RECIPES 50

/*
- (NSDictionary*) dictionaryCodeDisplayCategory{
	if (!dictionaryCodeDisplayCategory) {
      
		[self setDictionaryCodeDisplayCategory : [[NSDictionary alloc]
		 initWithObjects:[NSArray arrayWithObjects:@"Snacks", @"Treats", @"Desserts", 
								@"Veggies", @"Entrees",@"Vegan", @"Soups", @"Sauces", @"Browse All" ,nil]
		 forKeys:[NSArray arrayWithObjects:@"snack", @"treat", @"dessert", 
					 @"veggie", @"entree", @"vegan", @"soup", @"sauce", @"browse_all" ,nil] ]];
         // [dictionaryCodeDisplayCategory autorelease];
	}
	return	dictionaryCodeDisplayCategory;
}*/

- (NSSet*) categorySetXML{
	if (!categorySetXML) {
		categorySetXML = [NSSet set];
	}
	return	categorySetXML;
}

-(void) setContentOfCurrentRecipeXMLProperty:(NSMutableString *) newStr
{
	
	contentOfCurrentRecipeXMLProperty = newStr;
}

-(void) setCurrentRecipeXMLObject:(RecipeXML *) newR
{
	currentRecipeXMLObject = newR;
	//NSAssert( ([newR retainCount] == 2 ), @"CCRecObj must be set with  obj with  positive retainCount == 2.");
}


- (BOOL) isCategoryStringMissing:(NSString*)displayName catArray:(NSArray*)catObjArray {
	NSEnumerator* enumerator = [catObjArray objectEnumerator];
	Category* aCategory;
	BOOL retVal = YES;
	NSComparisonResult result;
	NSString *aCategoryNameTrimmed;
	NSString* theCategoryNameTrimmed;
   
   // added 8/9/2012
   //if(catObjArray == nil)
   //   return YES;
	
	theCategoryNameTrimmed = [displayName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ; 

	while ((aCategory = [enumerator nextObject])) {
		aCategoryNameTrimmed = [[aCategory name] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ; 
		result = [aCategoryNameTrimmed compare:theCategoryNameTrimmed options:NSCaseInsensitiveSearch];
		
		if (result == NSOrderedSame) {
			retVal = NO;
			break;
		}
	}
	return retVal;
}

#ifdef SQLITE_FROM_XML

- (id) init {
   if (! (self = [super init])) { // SQLITE_FROM_XML
      return nil;
   }

   return self;
}

#endif



//#ifndef IHUNGRY_MAC
// USED FOR IOS ONLY
 
/*
- (id) initForVersionOnly:(BOOL)fetchVersionOnly doesDatabaseExist:(BOOL)doesDbExist  catArray:(NSArray*)catObjArray
{
   if(!(self = [super init]))
		return nil;
	//DLog(@"initForVersionOnly fetchVersionOnly=%d", fetchVersionOnly);
	[self setGetVersionOnly:fetchVersionOnly];
	recipeXMLCheckedCnt = 0;
	recipeInsertionCount=0;
	categoryInsertionCount=0;
	[self setDoesDatabaseExist :doesDbExist];
#ifndef IHUNGRY_MAC
	[self setTheAppDelegate:(iHungry_MeAppDelegate*)[[UIApplication sharedApplication] delegate] ];
#else
   [self setTheAppDelegate:(AppDelegate*)[[NSApplication sharedApplication] delegate] ];
#endif
	
	if (!fetchVersionOnly ) {
		[ theAppDelegate setVersionXMLString:nil];
		
		// insert all XMLCategories into catObjArray  ***********
            
		for (NSString* displayName in [[self dictionaryCodeDisplayCategory] allValues] ) {
				
			if([self isCategoryStringMissing:displayName catArray:catObjArray] ) {
					
				NSManagedObject *newManagedObject = 
				[NSEntityDescription insertNewObjectForEntityForName:@"Category" 
														inManagedObjectContext:[[[self theAppDelegate] cdh] context]]; //INSERT MO
				Category* newCategory = (Category*)newManagedObject;
				[newCategory setName:displayName];///CATEG
				categoryInsertionCount++;
				////DLog(@"XMLLR:Run 2:Inserted Category: %@ CatCnt now %d"
						//,displayName,categoryInsertionCount);
			}
		}
		if (categoryInsertionCount > 0) {
				
			// insert all XMLCategories into datastore  ***********
			NSError* error2 = nil;
			if (![[[theAppDelegate cdh] context] save:&error2]) { //SAVE BROWSE_ALL
				// Update to handle the error appropriately.
				//DLog(@"XMLLR:init:Unresolved error93:categDisp=%@ %@, %@",displayName, error2, [error2 userInfo]);
				exit(-123);  // Fail
			}
      }
		
	}//if (!fetchVersionOnly)

	return self;
}
*/
//#endif

/*
#ifdef IHUNGRY_MAC

- (void) setupMacXmlRun2 
{
   [self setTheAppDelegate:(AppDelegate*)[[NSApplication sharedApplication] delegate] ];
		// insert all XMLCategories into catObjArray  ***********
   for (NSString* displayName in [[self dictionaryCodeDisplayCategory] allValues] ) {
      ////DLog(@"XMLRdr: isCatStringMissing=%d dispName=%@ catObjArrayCnt = %d",[self isCategoryStringMissing:displayName catArray:catObjArray],displayName, [catObjArray count]);
      // MAYBE NEED TO FETCH ALL CATS HERE AT TOP --------
#ifndef SQLITE_FROM_XML
      NSArray *catArray =  [[[theAppDelegate rootTableViewController] fetchedResultsController] fetchedObjects];//7/29/12
      if( [self isCategoryStringMissing:displayName catArray:catArray] )
      {
#endif
         NSManagedObject *newManagedObject = 
            [NSEntityDescription insertNewObjectForEntityForName:@"Category" 
                                       inManagedObjectContext:[[self theAppDelegate] managedObjectContext]]; //INSERT MO
         Category* newCategory = (Category*)newManagedObject;
         [newCategory setName:displayName];///CATEG

         categoryInsertionCount++;

         DLog(@"XMLLR:Run 2:Inserted Category: %@ CatCnt now %d"
         ,displayName,categoryInsertionCount);

#ifndef SQLITE_FROM_XML
      }
#endif
   } // end for
}// USED FOR OSX  setupMacXmlRun2

#endif

*/

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    parsedRecipesCounter = 0;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
	//DLog( @"Error from Parser! %@ LineNum:%d ",parseError,[parser lineNumber]);
	;
}

- (BOOL)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error
{	
	//[self setGetVersionOnly:versionOnly];
	//NSNumber *num = self.recipeXMLCategDx;
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
    // Set self as the delegate of the parser so that it will receive the 
	 // parser delegate methods callbacks.
    [parser setDelegate:self];
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    
    NSError *parseError = [parser parserError];
    if (parseError && error) {
        *error = parseError;
    }
    
   return YES;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
			namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
				attributes:(NSDictionary *)attributeDict
{

	if (qName) {
		elementName = qName;
	}
	if ([elementName isEqualToString:@"recipes"]) {
		//Store Version Number until Doc End
	
		NSString* tempStr =(NSString*)[attributeDict valueForKey:@"version"];
		[theAppDelegate setVersionXMLString:tempStr]	;
		
		NSString* editDate = (NSString*)[attributeDict valueForKey:@"date"];
		[theAppDelegate setEditDateXMLString:editDate]	;
		
		if (getVersionOnly) { 
			//bail out now that we have saved the versionString in appDel
			//for possible use at EndDoc on 2nd parser run
			[parser abortParsing];
		}
	}
	if ([elementName isEqualToString:@"recipe"]) {//begin of data for Recipe object		
		recipeXMLCheckedCnt++;
		parsedRecipesCounter++;
      //DLog(@"RecipeCount = %d",parsedRecipesCounter);
        // A RecipeXML, so create an instance of it.  ! ! ! !
		self.currentRecipeXMLObject = [[RecipeXML alloc] init];
				//e = [attributeDict keyEnumerator];
		//for (NSString *s in e ){
		//	////DLog(@"key is %@, value is %@",s, [attributeDict objectForKey:s]);
		//}
		//this works: NSNumber* theRxId = (NSNumber*)[attributeDict valueForKey:@"id"];
		self.currentRecipeXMLObject.rid = (NSNumber*)[attributeDict valueForKey:@"id"];
		//int number = (int)[currentRecipeXMLObject rid];
		//[[attributeDict valueForKey:@"rid"] stringValue ];
		self.currentRecipeXMLObject.name = [attributeDict valueForKey:@"name"];
		self.currentRecipeXMLObject.categ = [attributeDict valueForKey:@"categ"];
		self.currentRecipeXMLObject.categ2 = [attributeDict valueForKey:@"categ2"];
		self.currentRecipeXMLObject.tag = [attributeDict valueForKey:@"tag"];
		////DLog(@"For newRecipeXML description is:  %@" , [self.currentRecipeXMLObject description]);
		return;
	}
	/*if(! self.bRecipeXMLWanted){
		return;
	}*/
	//NSNumber* mode;
    if ([elementName isEqualToString:@"specs"]) {
		 self.currentRecipeXMLObject.ctime = [attributeDict valueForKey:@"ctime"];
		 self.currentRecipeXMLObject.ptime = [attributeDict valueForKey:@"ptime"];
		 self.currentRecipeXMLObject.serves = [attributeDict valueForKey:@"serves"];
    } 
	 else if ([elementName isEqualToString:@"photo"]) {
		/****
		 self.currentRecipeXMLObject.iPhoneContentMode =   [attributeDict valueForKey:@"iPhoneContentMode"];
		 self.currentRecipeXMLObject.iPadContentMode =   [attributeDict valueForKey:@"iPadContentMode"];
       ****/
       /// DLog(@"self.currentRecipeXMLObject=%@",self.currentRecipeXMLObject);
		 self.currentRecipeXMLObject.photopath = [attributeDict valueForKey:@"name"];
    } 
	 else if ([elementName isEqualToString:@"ingreds"]) {
        // Create a mutable array to hold the multiple 'ingred' elements.
        // The contents are collected in parser:foundCharacters:.
		 self.currentRecipeXMLObject.ingreds = [NSMutableArray arrayWithCapacity:6];

	}else if ([elementName isEqualToString:@"ingred"]) {
		
		 self.contentOfCurrentRecipeXMLProperty = [[IngredXML alloc] init];
         ///self.contentOfCurrentRecipeXMLProperty = [[[IngredXML alloc] init] mutableCopy];
		 [(IngredXML *)self.contentOfCurrentRecipeXMLProperty setName:[attributeDict valueForKey:@"name"]] ;
		 [(IngredXML *)self.contentOfCurrentRecipeXMLProperty setAmt:[attributeDict valueForKey:@"amt"]] ;
		 [(IngredXML *)self.contentOfCurrentRecipeXMLProperty setUnit:[attributeDict valueForKey:@"unit"]] ;
		 [(IngredXML *)self.contentOfCurrentRecipeXMLProperty setNote:[attributeDict valueForKey:@"note"]] ;
	 } else if ([elementName isEqualToString:@"directions"]) {
//////DLog(@"To Assign array to COCRP.directions  nonAlloc");			 
			 self.currentRecipeXMLObject.directions = [NSMutableArray  arrayWithCapacity:3];
//[self.currentRecipeXMLObject.directions retain]; //xtra
    } else if ([elementName isEqualToString:@"direction"]) {
//////DLog(@"To Assign string to COCRP AS a direction  nonAlloc");			 
			self.contentOfCurrentRecipeXMLProperty = [NSMutableString string];
///[self.contentOfCurrentRecipeXMLProperty retain]; //xtra
    }else if ([elementName isEqualToString:@"comment"]) {
//////DLog(@"To Assign string to COCRP AS a comment nonAlloc");		 
		 self.contentOfCurrentRecipeXMLProperty = [NSMutableString string];
///[self.contentOfCurrentRecipeXMLProperty retain]; //xtra
    }else {
		 //NSAssert((self.contentOfCurrentRecipeXMLProperty == nil),@"YES  COCRP  Leak!");
			//self.contentOfCurrentRecipeXMLProperty = nil;
    }
}//(void)parser:(NSXMLParser *)parser didStartElement:

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
			namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{     
	//NSArray* recipeIdArray;
#ifndef SQLITE_FROM_XML
   BOOL isThisRecipeIdMissing;
#endif
	Recipe* newRecipe;
    if (qName) {
        elementName = qName;
    }
    if ([elementName isEqualToString:@"directions"]) { //didEnd
		 ////DLog(@"End of directionS");
    }
	 else if ([elementName isEqualToString:@"direction"]) {
		 // add NSMutableString to NSMutableArray
		 [self.currentRecipeXMLObject.directions addObject:self.contentOfCurrentRecipeXMLProperty];
		 self.contentOfCurrentRecipeXMLProperty = nil;// no further  need to append in foundCharacters
    }
	 else if ([elementName isEqualToString:@"comment"]) { //didEnd
		 self.currentRecipeXMLObject.comment = self.contentOfCurrentRecipeXMLProperty;
		  //int i = 0;
		  self.contentOfCurrentRecipeXMLProperty = nil;// no further  need to append in foundCharacters
		  ////DLog(@"End of Comment  Set CoCRP to nil");
	 } 
	 else if ([elementName isEqualToString:@"ingred"]) { //didEnd
        [self.currentRecipeXMLObject.ingreds addObject:self.contentOfCurrentRecipeXMLProperty];
			self.contentOfCurrentRecipeXMLProperty = nil;// no further  need to append in foundCharacters
			 ////DLog(@"End of ingred. Set CoCRP to nil");
	 } 
	 else if ([elementName isEqualToString:@"ingreds"]) { 		  //NSAssert( self.contentOfCurrentRecipeXMLProperty == nil,@"CofCRP should be nil at end of ingreds");
			////DLog(@"End of ingredS");
	 } 
	else if ([elementName isEqualToString:@"recipe"]) {
	// determine if this recipe is not yet in the DB
#ifndef SQLITE_FROM_XML
      
      int nRidXml;
      nRidXml = -2;

      isThisRecipeIdMissing = YES;
      //HERE only if iHM or IHMP
      //////
      NSError *error=nil;
      NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
      NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:[self.theAppDelegate managedObjectContext]];
      [fetchRequest setEntity:entity];
      NSArray *recipeIdArray = [[self.theAppDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error];

      //////
		////recipeIdArray = [[[theAppDelegate recipeArray] valueForKey:@"recipeID"]  sortedArrayUsingSelector:@selector(compare:)] ;
		if (recipeIdArray) {// all DB recipes
		  NSEnumerator *enumerator = [recipeIdArray objectEnumerator];
			int nRecipeID;
			nRidXml = [[currentRecipeXMLObject rid]  intValue];
			id obj;
			while ((obj =  [enumerator nextObject]) ) {
				////DLog(@"obj as int=%d  ", [obj intValue]); 
				nRecipeID = [obj intValue];
				if(nRidXml == nRecipeID){
				  isThisRecipeIdMissing = NO;// recipeID found in DB
					////DLog(@"XmlRead:NO Need to insert Recipe.name=%@", self.currentRecipeXMLObject.name);				  
				  break;
				}
			}//while
		}
#endif 
		//DLog(@"nRidXml=%d",nRidXml);//DEBUG ONLY
	  //replace deleted recipe from earlier version?? below == NO don't do it 6/16/10
#ifndef SQLITE_FROM_XML      
///  DLog(@"Checkout nRidXml below.");
#endif
		if(((self.currentRecipeXMLObject != nil)
#ifndef SQLITE_FROM_XML
          && [theAppDelegate isXmlFileVersionNewer] && isThisRecipeIdMissing && (nRidXml > [[theAppDelegate maxRecipeId] intValue])
#endif          
          ))
        {
					 //check commented below 3/4/10
               // insert new MO into MOC and xfer data to MO
                newRecipe = [self convertRecipeXmlToRecipe:currentRecipeXMLObject] ;
                if(newRecipe == nil){
                    DLog(@"Recipe - Null recipe. "); // needed DLog
                }
		 }
	}//end else if ([elementName isEqualToString:@"recipe"])
    
	if(self.contentOfCurrentRecipeXMLProperty != nil) {
		////DLog(@"Bottom didEnd: CofCRP != nil. Setting CofCRP = nil");
	  self.contentOfCurrentRecipeXMLProperty = nil;// no need to append in foundCharacters
	}
}// void)parser:(NSXMLParser *)parser didEndElement:


-(Recipe *) convertRecipeXmlToRecipe:(RecipeXML*)recipeXml {
	
   NSManagedObjectContext *moc =
#ifdef SQLITE_FROM_XML
         [[self theAppDelegate] managedObjectContext]; //INSERT MO
#else
         //[[[self theAppDelegate] cdh] context]; //INSERT MO IHMP
         [[self theAppDelegate] managedObjectContext];
#endif
   
	NSManagedObject *newManagedObject = 
   [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:moc];

	Recipe* aRecipe = (Recipe *)newManagedObject;
	if(aRecipe){
      aRecipe.name = recipeXml.name;
      NSRange r;
      r.location = 0;
      r.length = 1;
      aRecipe.firstLetter = [aRecipe.name substringWithRange:r];
      
      	// NSMutableArray* ingreds;
      [aRecipe setIngredients:[self getStringFromIngredsArray:(RecipeXML*)recipeXml]];
      [aRecipe setDirections:[self getStringFromDirectionsArray:(RecipeXML*)recipeXml]];
      [aRecipe setComments:[recipeXml comment]];
      [aRecipe setModified:[NSDate date]];//2/24/14
      
      DLog(@"createUID for Rx:%@",aRecipe.name);
      
      [aRecipe setUid:[Photo calculateNewUniqueID]];

		if([[recipeXml photopath] length]) {
         
            NSManagedObject *newManagedObject =
            [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:moc] ;

            Photo* aPhoto = (Photo*)newManagedObject;
            [aPhoto setFilename:[recipeXml photopath]];
            [aPhoto setId:[NSNumber numberWithInt:1]];
            [aPhoto setPath:[recipeXml photopath]];
            int actPhotoNameLen = (int) MIN(MAX_PHOTO_NAME_LENGTH, [[recipeXml name] length]);
            [aPhoto setName: [[recipeXml name] substringWithRange: NSMakeRange(0,actPhotoNameLen)]];//only one photo per recipe
           ///  DLog(@"createUID for Photo:%@",aPhoto.name);
            [aPhoto setUid:[Photo  calculateNewUniqueID]];
            [aPhoto setModified:[NSDate date]];
                  // PhotoData
            NSArray *nameParts = [[recipeXml photopath] componentsSeparatedByString:@"."];
            NSString *pathToPhoto = [[NSBundle mainBundle] pathForResource:[nameParts objectAtIndex:0] ofType:@"png"];
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:pathToPhoto];//2/24/14
            NSData *imageData = [image TIFFRepresentation];
            aPhoto.image = imageData;
            [aRecipe addPhotosObject:aPhoto] ;
            [aPhoto addRecipesObject:aRecipe];//2/24/14
		}
				
		if([recipeXml rid]){
			//Preloaded RecipeID > 0  NSNumber
			int i = [[recipeXml rid] intValue];//check  why needed?
			[aRecipe setRecipeID:[NSNumber numberWithInt:i] ];
		}
		
		if([recipeXml categ]){ 
			NSString* strDisplayCategName = 
				[[theAppDelegate dictionaryCodeDisplayCategory] objectForKey:[recipeXml categ]];
			
            //NSArray *catArray =  [self.theAppDelegate categoryArray];
         NSEnumerator *enumerator = [self.theAppDelegate.categoryArray objectEnumerator];//7/29/12
			Category* aCategory ;
			Category* theCategory = nil ;
			NSComparisonResult result ; 
			while ((aCategory = [enumerator nextObject])) {
				result = [[aCategory name] compare:strDisplayCategName options:NSCaseInsensitiveSearch];
				if(result == NSOrderedSame){ //NSNumber *rid;
					theCategory=aCategory;// recipeID found in DB
					break;
				}
			}
			//// if Category1 is not in MOC insert it
			if(theCategory){
            [aRecipe	addCategoriesObject:theCategory];
            [theCategory addRecipesObject:aRecipe]; // 1/18/13 added
         }else{
            DLog(@"Could not find cat1 for Rx=%@ strDisplayCategName=%@",aRecipe.name,strDisplayCategName);
            exit(66);
         }
		}
		if([[recipeXml categ2] length]){
			NSString* strDisplayCategName = 
			[[theAppDelegate dictionaryCodeDisplayCategory] objectForKey:[recipeXml categ2]];
            //NSArray *catArray =  self.theAppDelegate.categoryArray;
            NSEnumerator *enumerator = [self.theAppDelegate.categoryArray objectEnumerator];
			Category* aCategory ;
			Category* theCategory = nil ;
			NSComparisonResult result ; 
			while ((aCategory = [enumerator nextObject])) {
				result = [[aCategory name] compare:strDisplayCategName options:NSCaseInsensitiveSearch];
				if(result == NSOrderedSame){ //NSNumber *rid;
					theCategory=aCategory;// recipeID found in DB
					break;
				}
			}
			//// if Category2 is not in MOC insert it
			////DLog(@"po Categ=%@",theCategory);
         if (theCategory ){
            [aRecipe	addCategoriesObject:theCategory];
            [theCategory addRecipesObject:aRecipe]; // 1/18/13 added
         }else{
            DLog(@"Could not find cat2 for Rx=%@ strDisplayCategName=%@",aRecipe.name,strDisplayCategName);
            exit(67);
         }

      }
      /// DLog(@"Recipe.name=%@\naRecipe.firstLetter=%@",aRecipe.name,aRecipe.firstLetter);
		recipeInsertionCount++;
	}
	return aRecipe;
} // end   -(Recipe*) convertRecipeXmlToRecipe:(RecipeXML*)recipeXml
		
- (NSString*) getStringFromDirectionsArray:(RecipeXML*)recipeXML {
	
	NSMutableString *theDirections = [[NSMutableString alloc]  init];
	int i=1;
	for (NSString *str2 in [recipeXML directions]){
		NSString *strNum;
		if (i==1) {
			strNum = [NSString stringWithFormat:@"[%@]\n%d. %@\n",[recipeXML name],i++,str2];
		}else 
			strNum = [NSString stringWithFormat:@"%d. %@\n",i++,str2];
		[theDirections appendString:strNum];
	}	
	return theDirections;		
}			


- (NSString*) getStringFromIngredsArray:(RecipeXML*)recipeXML {
   
	NSMutableString* theIngreds = [[NSMutableString alloc]  init];
	[theIngreds appendString:[NSString stringWithFormat:@"[%@]\npreptime %@ cooktime %@ serves:%@\n\n"
                             ,[recipeXML name],[recipeXML ptime], [recipeXML ctime], [recipeXML serves] ]];
	
   for (IngredXML *ingred  in [recipeXML ingreds]){
      //str = [NSString stringWithFormat:@"	%@   %@  %@	%@\n"
      //		 ,ingred.name, [ingred amt], ingred.unit, ingred.note];
      [theIngreds appendString:[NSString stringWithFormat:@"%@   %@  %@	%@\n"
                                ,ingred.name, [ingred amt], ingred.unit, ingred.note]];
   }
	
	return theIngreds;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	/*if(! self.bRecipeXMLWanted){
		return;
	}*/
    if (self.contentOfCurrentRecipeXMLProperty) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        [self.contentOfCurrentRecipeXMLProperty appendString:string];//leak here
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
	NSError* error = nil;
	//insert update Version if any new data have been added
	//DLog(@"XMLLR:parserDidEnd: recipeInsertionCount=%d.",recipeInsertionCount);
	if(recipeInsertionCount == 0  ){
#ifdef DEBUG		
		NSLog(@"********* NO NEW RECIPES INSERTED in MOC ************");	
#endif
	}
   
#ifdef SQLITE_FROM_XML
      if (![[[self theAppDelegate] managedObjectContext] save:&error]) {
         // Update to handle the error appropriately]) { //INSERT MO
#else
      if (![[[self theAppDelegate] cdh] context] save:&error]) {
            // Update to handle the error appropriately]) { //INSERT MO IHMP
#endif
		// Update to handle the error appropriately.
         exit(-123);  // Fail
      }
	//DLog(@"XMLLR:parserDidEndDoc:[[[theAppDelegate managedObjectContext] insertedObjects] count] = %u", [[[theAppDelegate managedObjectContext] insertedObjects] count]);
}

		
@end
