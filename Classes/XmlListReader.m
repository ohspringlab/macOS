/*

File: XmlListReader.m
Abstract: Uses NSXMLParser to extract the contents of an XML file and map it
Objective-C model objects.

*/
#import "XmlListReader.h"

#ifdef IHUNGRY_MAC
#import "AppDelegate.h"
#else
#import "iHungry_MeAppDelegate.h"
#endif

#import "IngredXML.h"
#import "RecipeXML.h"
#import "VersionXML.h"
#import "CategoryRx.h"
#import "Recipe.h"
#import "Photo.h"
//extern NSString * const DG_HandleAddRecipeNotification;
static NSUInteger parsedRecipesCounter;

@implementation XmlListReader

@synthesize currentRecipeXMLObject ;
@synthesize contentOfCurrentRecipeXMLProperty ;
//@synthesize recipeXMLCategDx ;
@synthesize theAppDelegate;
@synthesize categorySetXML;
@synthesize dictionaryCodeDisplayCategory;
@synthesize getVersionOnly;
@synthesize recipeInsertionCount;
@synthesize categoryInsertionCount;
//@synthesize doesDatabaseExist;
@synthesize recipeXMLCheckedCnt;
@synthesize managedObjectContext;

// Limit the number of parsed RecipeXMLs to 50. Otherwise the application runs very slowly on the device.
//#define MAX_RECIPES 50

- (NSDictionary*) dictionaryCodeDisplayCategory{
	if (!dictionaryCodeDisplayCategory) {
		//dictionaryCodeDisplayCategory = [NSDictionary dictionary];
		dictionaryCodeDisplayCategory = [[NSDictionary alloc]
		 initWithObjects:[NSArray arrayWithObjects:@"Snacks", @"Treats", @"Desserts", 
								@"Veggies", @"Entrees",@"Vegan", @"Soups", @"Sauces", @"Browse All" ,nil]
		 forKeys:[NSArray arrayWithObjects:@"snack", @"treat", @"dessert", 
					 @"veggie", @"entree", @"vegan", @"soup", @"sauce", @"browse_all" ,nil] ];
	}
	return	dictionaryCodeDisplayCategory;
}

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
	CategoryRx* aCategory;
	BOOL retVal = YES;
	NSComparisonResult result;
	NSString *aCategoryNameTrimmed;
	NSString* theCategoryNameTrimmed;
	
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

//#ifndef IHUNGRY_MAC
// USED FOR IOS ONLY
- (id) initForVersionOnly:(BOOL)fetchVersionOnly   catArray:(NSArray*)catObjArray minimumRecipeId:(int)minId context:(NSManagedObjectContext*)context
{
   self = [super init];
	if(self) {
      self.managedObjectContext = context;
      [self setGetVersionOnly:fetchVersionOnly];
      recipeXMLCheckedCnt = 0;
      recipeInsertionCount=0;
      categoryInsertionCount=0;
      //[self setDoesDatabaseExist :doesDbExist];// did DB exist at start of run
#ifndef IHUNGRY_MAC   
      [self setTheAppDelegate:(iHungry_MeAppDelegate*)[[UIApplication sharedApplication] delegate] ];
#else
      [self setTheAppDelegate:(AppDelegate*)[[NSApplication sharedApplication] delegate] ];
#endif
      if (!fetchVersionOnly ) {  // contents of catArray show which Cats are present already
         // THIS IS SECOND RUN INIT
         [ theAppDelegate setVersionXMLString:nil]; 
         // insert all missing including BROWSE_ALL XMLCategories into catObjArray  ***********
         /// INSERT ADDITIONAL CATS THAT ARE MISSING IN MOC,  FROM DICTIONARY
         for (NSString* displayName in [[self dictionaryCodeDisplayCategory] allValues] ) {
   DLog(@"XMLRdr: isCatStringMissing=%d dispName=%@ catObjArrayCnt = %lu",[self isCategoryStringMissing:displayName catArray:catObjArray],displayName, (unsigned long)[catObjArray count]);
            if(!catObjArray || [self isCategoryStringMissing:displayName catArray:catObjArray] ) {
                  // THIS IS only run for SECOND RUN INIT for Virgin Install
               DLog(@"THIS IS only run on SECOND RUN INIT for Virgin Install, OR?");
               NSManagedObject *newManagedObject = 
               [NSEntityDescription insertNewObjectForEntityForName:@"CategoryRx"
                  inManagedObjectContext:self.managedObjectContext]; //INSERT MO
               CategoryRx* newCategory = (CategoryRx*)newManagedObject;
               [newCategory setName:displayName];///CATEG
               /***/	
                  // THIS IS SECOND RUN INIT
               /***/	
               categoryInsertionCount++;
               ////DLog(@"XMLLR:Run 2:Inserted Category: %@ CatCnt now %d"
                     //,displayName,categoryInsertionCount);
            }
         }
         if (categoryInsertionCount > 0) {
            /***/	
            // insert all new XMLCategories into datastore  ***********
            NSError* error2 = nil;
            if (![self.managedObjectContext save:&error2]) { //SAVE BROWSE_ALL
               // Update to handle the error appropriately.
               //DLog(@"XMLLR:init:Unresolved error93:categDisp=%@ %@, %@",displayName, error2, [error2 userInfo]);
               exit(-123);  // Fail
            }
            
         }
      }//if (!getVersionOnly)
   }
	return self;
}
   
//#endif


- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    parsedRecipesCounter = 0;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
	//DLog( @"Error from Parser! %@ LineNum:%d ",parseError,[parser lineNumber]);
	;
}

- (int)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error
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
    
   return 0;
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
        // A RecipeXML, so create an instance of it.  ! ! ! !
		self.currentRecipeXMLObject = [[RecipeXML alloc] init];
				//e = [attributeDict keyEnumerator];
		
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
    if ([elementName isEqualToString:@"specs"]) {
		 self.currentRecipeXMLObject.ctime = [attributeDict valueForKey:@"ctime"];
		 self.currentRecipeXMLObject.ptime = [attributeDict valueForKey:@"ptime"];
		 self.currentRecipeXMLObject.serves = [attributeDict valueForKey:@"serves"];
    } 
	 else if ([elementName isEqualToString:@"photo"]) {
		
		 self.currentRecipeXMLObject.iPhoneContentMode =   [attributeDict valueForKey:@"iPhoneContentMode"];
		 self.currentRecipeXMLObject.iPadContentMode =   [attributeDict valueForKey:@"iPadContentMode"];
		 self.currentRecipeXMLObject.photopath = [attributeDict valueForKey:@"name"];
    } 
	 else if ([elementName isEqualToString:@"ingreds"]) {
        // Create a mutable array to hold the multiple 'ingred' elements.
        // The contents are collected in parser:foundCharacters:.
		 self.currentRecipeXMLObject.ingreds = [NSMutableArray arrayWithCapacity:6];

	}else if ([elementName isEqualToString:@"ingred"]) {
		
		 self.contentOfCurrentRecipeXMLProperty = (NSMutableString*)[[IngredXML alloc] init];
		 [(IngredXML *)self.contentOfCurrentRecipeXMLProperty setName:[attributeDict valueForKey:@"name"]] ;
		 [(IngredXML *)self.contentOfCurrentRecipeXMLProperty setAmt:[attributeDict valueForKey:@"amt"]] ;
		 [(IngredXML *)self.contentOfCurrentRecipeXMLProperty setUnit:[attributeDict valueForKey:@"unit"]] ;
		 [(IngredXML *)self.contentOfCurrentRecipeXMLProperty setNote:[attributeDict valueForKey:@"note"]] ;
	 } else if ([elementName isEqualToString:@"directions"]) {
			 self.currentRecipeXMLObject.directions = [NSMutableArray  arrayWithCapacity:3];
    } else if ([elementName isEqualToString:@"direction"]) {
			self.contentOfCurrentRecipeXMLProperty = [NSMutableString string];
    }else if ([elementName isEqualToString:@"comment"]) {
		 self.contentOfCurrentRecipeXMLProperty = [NSMutableString string];
    }
}//(void)parser:(NSXMLParser *)parser didStartElement:

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
			namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{     
	NSArray* recipeIdArray;
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
	 } 
	 else if ([elementName isEqualToString:@"ingred"]) { //didEnd
        [self.currentRecipeXMLObject.ingreds addObject:self.contentOfCurrentRecipeXMLProperty];
			self.contentOfCurrentRecipeXMLProperty = nil;// no further  need to append in foundCharacters
   }
	 else if ([elementName isEqualToString:@"ingreds"]) { 		  //NSAssert( self.contentOfCurrentRecipeXMLProperty == nil,@"CofCRP should be nil at end of ingreds");
			////DLog(@"End of ingredS");
	 } 
	else if ([elementName isEqualToString:@"recipe"]) {
	// determine if this recipe is not yet in the DB
      ////
      //   theAppDelegate.recipeArray must exist, for DataVersion Install Run
      //
		recipeIdArray = [[[theAppDelegate recipeArray] valueForKey:@"recipeID"]  sortedArrayUsingSelector:@selector(compare:)] ;
		BOOL isThisRecipeIdMissing = YES;
		int nRidXml;
		nRidXml =[[currentRecipeXMLObject rid]  intValue];
		if (recipeIdArray) {// all DB recipes
		  NSEnumerator *enumerator = [recipeIdArray objectEnumerator];
			int nRecipeID;
			//nRidXml = [[currentRecipeXMLObject rid]  intValue];
			id obj;
			while ((obj =  [enumerator nextObject]) ) {
				nRecipeID = [obj intValue];
				if(nRidXml == nRecipeID){
				  isThisRecipeIdMissing = NO;// recipeID found in DB
					DLog(@"XmlRead:NO Need to insert Recipe.name=%@", self.currentRecipeXMLObject.name);				  
				  break;
				}
			}//while
		}
		//DLog(@"nRidXml=%d",nRidXml);//DEBUG ONLY
      if(((self.currentRecipeXMLObject != nil) && isThisRecipeIdMissing && (nRidXml > [[theAppDelegate maxRecipeIdDb] intValue]) )  ){
					 //check commented below 3/4/10
         
					newRecipe = [self convertRecipeXmlToRecipe:currentRecipeXMLObject] ;
         
					if(newRecipe == nil){
						DLog(@"Recipe - Null recipe. [theAppDelegate maxRecipeID]=%@",[theAppDelegate maxRecipeIdDb]); // needed DLog
					}
		 }
	}//end else if ([elementName isEqualToString:@"recipe"]) 
	if(self.contentOfCurrentRecipeXMLProperty != nil) {
	  self.contentOfCurrentRecipeXMLProperty = nil;// no need to append in foundCharacters
	}
}// void)parser:(NSXMLParser *)parser didEndElement:


-(Recipe*) convertRecipeXmlToRecipe:(RecipeXML*)recipeXml {
	
	NSManagedObject *newManagedObject = 
		[NSEntityDescription insertNewObjectForEntityForName:@"Recipe" 
				inManagedObjectContext:self.managedObjectContext]; //INSERT MO

	Recipe* aRecipe = (Recipe *)newManagedObject;
	if(aRecipe){
		aRecipe.name = recipeXml.name;
		
		if([[recipeXml photopath] length]) {
			NSManagedObject *newManagedObject = 
			[NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:self.managedObjectContext]; //INSERT MO
			Photo* aPhoto = (Photo*)newManagedObject;
			
			[aPhoto setFilename:[recipeXml photopath]];
         aPhoto.photoID = [NSNumber numberWithInt:1];
			int actPhotoNameLen = (int)MIN(MAX_PHOTO_NAME_LENGTH, [[recipeXml name] length]);
			[aPhoto setPhotoName: [[recipeXml name] substringWithRange: NSMakeRange(0,actPhotoNameLen)]];//only one photo per recipe
			
			int i = [[currentRecipeXMLObject iPhoneContentMode] intValue];//check  why needed?
			[aPhoto setIPhoneContentMode: [NSNumber numberWithInt:i]];
			i = [[currentRecipeXMLObject iPadContentMode] intValue];
			[aPhoto setIPadContentMode: [NSNumber numberWithInt:i]];
			
         [(Recipe*)aRecipe addPhotosObject:(Photo*)aPhoto] ;
      } 
			// NSMutableArray* ingreds;
		[aRecipe setIngredients:[self getStringFromIngredsArray:(RecipeXML*)recipeXml]];
		[aRecipe setDirections:[self getStringFromDirectionsArray:(RecipeXML*)recipeXml]];
		[aRecipe setComments:[recipeXml comment]];
		
		if([recipeXml rid]){
			//Preloaded RecipeID > 0  NSNumber
			int i = [[recipeXml rid] intValue];//check  why needed?
			[aRecipe setRecipeID:[NSNumber numberWithInt:i] ];
		}
      // ADD Browse_All
      CategoryRx *baCat = [self.theAppDelegate fetchCategoryBrowseAll];
      if (!baCat ) {
         DLog(@"Could not fetch Category BrowseAll.");
         abort();
      }
     
      baCat.isBrowseAll = YES;
      baCat.sortIndex = [NSNumber numberWithInteger:-1];
      
      [aRecipe addCategoriesObject:baCat];
      
		if([recipeXml categ]){ 
			NSString* strDisplayCategName = 
				[[self dictionaryCodeDisplayCategory] objectForKey:[recipeXml categ]];
			NSEnumerator *enumerator = [[theAppDelegate categoryArray] objectEnumerator];
			CategoryRx* aCategory ;
			CategoryRx* theCategory = nil ;
			NSComparisonResult result ; 
			while ((aCategory = [enumerator nextObject])) {
				result = [[aCategory name] compare:strDisplayCategName options:NSCaseInsensitiveSearch];
				if(result == NSOrderedSame){ //NSNumber *rid;
					theCategory=aCategory;// recipeID found in DB
					break;
				}
			}
			//// if Category is not in MOC insert it
        // DLog(@"\n aRecipe.name=%@",aRecipe.name);
         //DLog(@"\n Categ1=%@",theCategory.name);
			if(theCategory)
            [aRecipe	addCategoriesObject:theCategory];
//#endif			
		}
		
		if([[recipeXml categ2] length]){
			NSString* strDisplayCategName = 
			[[self dictionaryCodeDisplayCategory] objectForKey:[recipeXml categ2]];//check: This was categ not categ2 4/18/2010
			NSEnumerator *enumerator = [[theAppDelegate categoryArray] objectEnumerator];
			CategoryRx* aCategory ;
			CategoryRx* theCategory = nil ;
			NSComparisonResult result ; 
			while ((aCategory = [enumerator nextObject])) {
				result = [[aCategory name] compare:strDisplayCategName options:NSCaseInsensitiveSearch];
				if(result == NSOrderedSame){ //NSNumber *rid;
					theCategory=aCategory;// recipeID found in DB
					break;
				}
			}
			/*if (!theCategory ) {
				//DLog(@"Xmlreader:convertRecipeXml:categ2: error in XML categ2, check spelling/parsing/whitespace");
				exit(-223);
			}*/
			//// if Category is not in MOC insert it
			//DLog(@"\npo Categ1=%@",theCategory.name);
         if (theCategory )
            [aRecipe	addCategoriesObject:theCategory];
      }
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
			strNum = [NSString stringWithFormat:@"[%@]\n\n%d. %@\n",[recipeXML name],i++,str2];
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
	//for(IngredXML* ingredXML in [recipeXML ingreds]){
		//[theIngreds  appendString:[ingredXML description]];
		//NSString* strName = [NSString stringWithFormat:@"[%@]\n",[recipe name]];
		
		//str = [NSString stringWithFormat:@"preptime %@ cooktime %@ serves:%@\n\n"
		//		 ,[recipe ptime], [recipe ctime], [recipe serves]];
		//[theIngreds appendString:str];
		for (IngredXML *ingred  in [recipeXML ingreds]){
			//str = [NSString stringWithFormat:@"	%@   %@  %@	%@\n"
			//		 ,ingred.name, [ingred amt], ingred.unit, ingred.note];
			[theIngreds appendString:[NSString stringWithFormat:@"%@   %@  %@	%@\n"
											  ,ingred.name, [ingred amt], ingred.unit, ingred.note]];
		}
	
	return theIngreds;
}
		 
/*				
- (BOOL) isInContext:(CategoryRx*) category managedObjectContext:(NSManagedObjectContext*) managedObjectContext
					categoryArray:(NSArray*) catRay	  {
	NSEnumerator *enumerator = [catRay objectEnumerator];
	Category * aCategory;
	BOOL equal = NO;
	while (aCategory = [enumerator nextObject]) {
		////DLog(@"Cat Name is: %@",[aCategory name]);
		equal = [[aCategory name] isEqualToString:[category name]];
		if(equal)
			break;
	}
	return (equal ); //YES means found in context.
}*/

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
	
	if (![self.managedObjectContext save:&error]) {
		// Update to handle the error appropriately.
		//DLog(@"XMLLR:parserDidEndDoc:Unresolved error73 %@, %@", error, [error userInfo]);
		exit(-123);  // Fail
	}
	//DLog(@"XMLLR:parserDidEndDoc:[[[theAppDelegate managedObjectContext] insertedObjects] count] = %u", [[[theAppDelegate managedObjectContext] insertedObjects] count]);
	
}

		
@end
