//
//  Tag.m
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 8/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "Tag.h"

@implementation Tag

+ (NSString *)primaryKey {
    return @"tagName";
}

-(id)initWithName:(NSString*)name{
    if(self=[super init]){
        self.tagName=name;
    }
    return self;
    
}

// Define "owners" as the inverse relationship to Person.dogs
- (NSArray *)books {
    return [self linkingObjectsOfClass:@"Book" forProperty:@"tags"];
}

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
