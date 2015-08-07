//
//  Author.m
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 10/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "Author.h"

@implementation Author

+ (NSString *)primaryKey {
    return @"authorName";
}

-(id)initWithName:(NSString*)name{
    if(self=[super init]){
        self.authorName=name;
    }
    return self;
    
}

// Define "owners" as the inverse relationship to Person.dogs
- (NSArray *)books {
    return [self linkingObjectsOfClass:@"Book" forProperty:@"authors"];
}

@end
