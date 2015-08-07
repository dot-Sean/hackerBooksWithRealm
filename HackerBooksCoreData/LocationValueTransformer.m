//
//  LocationValueTransformer.m
//  HackerBooksRealm
//
//  Created by Jose Manuel Franco on 6/8/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "LocationValueTransformer.h"
#import "Location.h"

@implementation LocationValueTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    if (!value) return nil;
    Location *location = (Location *)value;
    return [NSString stringWithFormat:@"%0.4f, %0.4f", location.latitude, location.longitude];
}

@end
