//
//  VersionXML.h
//  iHungryMacNonDoc
//
//  Created by Mark on 3/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface VersionXML : NSManagedObject {
@private
}
@property (nonatomic, strong) NSDate * installDate;
@property (nonatomic, strong) NSNumber * number;
@property (nonatomic, strong) NSDate * editDate;
@property (nonatomic, strong) NSNumber * maxRecipeId;

@end
