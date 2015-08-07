//
//  Tag.h
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 8/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <Realm/Realm.h>
#import "Book.h"

@protocol Book;

@interface Tag : RLMObject
@property NSString *tagName;
@property (readonly) NSArray *books;

-(id)initWithName:(NSString*)name;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Tag>
RLM_ARRAY_TYPE(Tag)
