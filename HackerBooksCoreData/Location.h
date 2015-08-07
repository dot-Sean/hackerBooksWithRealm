//
//  Location.h
//  HackerBooksRealm
//
//  Created by Jose Manuel Franco on 6/8/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface Location : RLMObject

@property float latitude;
@property float longitude;

-(id)initWithLatitude:(float)latitude
         andLongitude:(float)longitude;

@end

RLM_ARRAY_TYPE(Location)