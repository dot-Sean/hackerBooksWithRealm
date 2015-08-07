//
//  Note.h
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 16/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <Realm/Realm.h>
#import "Image.h"
#import "Location.h"

@class Image;

@interface Note : RLMObject
@property NSString *title;
@property NSDate *creationDate;
@property NSDate *lastModificationDate;
@property Image *image;
@property Location *location;
@property int milliseconds;

-(id)initWithTitle:(NSString*)title;


@end

// This protocol enables typed collections. i.e.:
// RLMArray<Note>
RLM_ARRAY_TYPE(Note)
