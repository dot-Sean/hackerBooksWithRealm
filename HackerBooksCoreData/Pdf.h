//
//  Pdf.h
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 7/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <Realm/Realm.h>

@class Book;

@interface Pdf : RLMObject
@property NSData *data;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<Pdf>
RLM_ARRAY_TYPE(Pdf)
