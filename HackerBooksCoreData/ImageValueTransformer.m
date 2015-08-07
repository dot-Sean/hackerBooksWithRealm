//
//  ImageValueTransformer.m
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 3/8/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "ImageValueTransformer.h"
#import "Image.h"

@implementation ImageValueTransformer

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
    Image  *image = (Image *)value;
    if(image.data){
        return [NSString stringWithFormat:@"Image Loaded"];
    }else{
        return [NSString stringWithFormat:@""];
    }
}

@end
