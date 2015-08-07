//
//  Author.h
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 10/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <Realm/Realm.h>

@interface Author : RLMObject

@property NSString *authorName;
@property (readonly) NSArray *books;

-(id)initWithName:(NSString*)name;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Author>
RLM_ARRAY_TYPE(Author)
