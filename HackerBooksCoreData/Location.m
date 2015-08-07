//
//  Location.m
//  HackerBooksRealm
//
//  Created by Jose Manuel Franco on 6/8/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "Location.h"

@implementation Location

-(id)initWithLatitude:(float)latitude
         andLongitude:(float)longitude{
    if(self=[super init]){
        self.latitude=latitude;
        self.longitude=longitude;
    }
    return self;
    
}

@end
