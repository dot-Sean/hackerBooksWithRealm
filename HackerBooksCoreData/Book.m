//
//  Book.m
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 7/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "Book.h"

@implementation Book

+ (NSString *)primaryKey {
    return @"title";
}

-(id)initWithTitle:(NSString*)title
          imageUrl:(NSString*)imageUrl
            pdfUrl:(NSString*)pdfUrl{
    
    if(self=[super init]){
        self.title=title;
        self.imageUrl=imageUrl;
        self.pdfUrl=pdfUrl;
        self.favorite=NO;
        self.lastOpened=[NSDate dateWithTimeIntervalSince1970:1];
    }
    return self;
}



@end
