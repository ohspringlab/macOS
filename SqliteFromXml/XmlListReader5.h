/*

File: XmlListReader5.h
Abstract: Uses NSXMLParser to extract the contents of an XML file and map it
Objective-C model objects. Reads all recipeXMLs for the list view

Originally used in iHungry. Now adapted for iHungry Me to create a list
// 8/21/12 used by SqliteFromXML

*/

#import <Foundation/Foundation.h>

/*
    This class uses NSXMLParser to map the contents of an XML document to Objective-C model objects.
    It encodes specific knowledge of the XML document being parsed in this sample, which is aaaRecipes.xml
 <xml>
	 <recipes>
		 <recipe id="1" name="Cherry Pie" categ="dessert">
			 <photo path="" />
				 <specs ctime="1:00" ptime="0:30" serves="6-8" />
				 <ingreds>
					 <ingred name="flour" amt="1 1/2" unit="cup" note="(self-rising)" />
					 <ingred name="water" amt="3" unit="Tsp" note="" />
				 </ingreds>
				 <directions>
					 <direction>Put all the wet ingredients in a bowl and stir well.
					 </direction>
					 <direction>
					 Then throw all the dry ingredients in as well.
					 </direction>
					 <direction>
					 Pray for a good result. You are on your own here.
					 </direction>
				 </directions>
				 <comment /> 
	...Recipe
 
    When NSXMLParser encounters an <recipe> element, it invokes the delegate method 
		parser:didStartElement:namespaceURI:qualifiedName:attributes:.
    This sample's implementation of that method instantiates an instance of the 
		Recipe class and adds it to the list of objects
    that the application's delegate manages.
 
    When NSXMLParser reports an element other than a <recipe> element, in 
    parser:didStartElement:namespaceURI:qualifiedName:attributes:
    this sample allocates an NSMutableString and sets the contentOfCurrentRecipeProperty 
    property, which is used to hold
    the content of child elements of the current <entry> element.
 
    For example, if the current element is <title>, the sample creates a mutable string 
    for the contentOfCurrentRecipeProperty property.
    When NSXMLParser reports that it found characters in the parser:foundCharacters: 
    delegate method, those characters are 
    appended to the contentOfCurrentRecipeProperty mutable string. 
 
    When the parser finishes processing an element, it invokes the delegate method 
    parser:didEndElement:namespaceURI:qualifiedName:. At that point, the sample sets 
    the value of the property in the current
    Recipe object (the currentRecipeObject property) to the value of the 
    contentOfCurrentRecipeProperty string.

*/
#import <Foundation/Foundation.h>
#import "RecipeDefines.h"

@class Photo;
@class RecipeXML;
@class VersionXML;
@class Recipe;
@class Category;
@class AppDelegate;
   //@class Photo;

@interface XmlListReader : NSObject <NSXMLParserDelegate> {

@private  
	RecipeXML *currentRecipeXMLObject;
	NSMutableString *contentOfCurrentRecipeXMLProperty;
   
#ifndef IHUNGRYME_PLUS
   AppDelegate *theAppDelegate;
#else
	iHungry_MeAppDelegate *theAppDelegate;
#endif
   
	int recipeXMLCheckedCnt;
	NSSet* categorySetXML;
	BOOL getVersionOnly;
	int recipeInsertionCount;
	int categoryInsertionCount;
	BOOL doesDatabaseExist;
}

@property (nonatomic, assign) BOOL doesDatabaseExist;
@property (nonatomic, assign) int categoryInsertionCount;
@property (nonatomic, assign) int recipeInsertionCount;
@property (nonatomic, assign) int recipeXMLCheckedCnt;
@property (nonatomic, assign) BOOL getVersionOnly;
@property (nonatomic, strong) NSSet* categorySetXML;
@property (nonatomic, strong) RecipeXML *currentRecipeXMLObject;
@property (nonatomic, strong) NSMutableString *contentOfCurrentRecipeXMLProperty;
#ifndef IHUNGRYME_PLUS
@property (nonatomic, retain) AppDelegate *theAppDelegate;
#else
@property (nonatomic, strong) iHungry_MeAppDelegate *theAppDelegate;
#endif

- (BOOL)parseXMLFileAtURL:(NSURL *)URL  parseError:(NSError **)error;
- (Recipe*) convertRecipeXmlToRecipe:(RecipeXML*)recipeXml;
- (NSString*) getStringFromIngredsArray:(RecipeXML*)recipeXml;
- (NSString*) getStringFromDirectionsArray:(RecipeXML*)recipeXml;
   /// - (id) initForVersionOnly:(BOOL)fetchVersionOnly  doesDatabaseExist:(BOOL)doesDbExist catArray:(NSArray*)catArray;
#ifdef IHUNGRY_MAC
- (void) setupMacXmlRun2;
#endif
- (BOOL) isCategoryStringMissing:(NSString*)displayName catArray:(NSArray*)catArray ; //check in DB for category name
@end
