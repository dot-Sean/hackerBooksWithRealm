//
//  Note.m
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 16/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "Note.h"

@implementation Note

-(id)initWithTitle:(NSString*)title{
    
    if(self=[super init]){
        self.title=title;
        self.creationDate=[NSDate date];
        self.lastModificationDate=[NSDate date];
        self.milliseconds=(int)[self.creationDate timeIntervalSince1970]*1000;
    }
    return self;

}

+ (NSString *)primaryKey {
    return @"milliseconds";
}

@end
