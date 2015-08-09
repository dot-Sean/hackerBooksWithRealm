//
//  Book.h
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 7/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <Realm/Realm.h>
#import "Image.h"
#import "Pdf.h"
#import "Tag.h"
#import "Author.h"
#import "Note.h"

@class Image;
@class Pdf;
@protocol Tag;
@protocol Note;

@interface Book : RLMObject
@property NSString *title;
@property NSString *imageUrl;
@property NSString *pdfUrl;
@property bool favorite;
@property long lastPageRead;
@property bool isFinished;
@property(nonatomic) Image *bookImage;
@property Pdf *bookPdf;
@property RLMArray<Tag> *tags;
@property RLMArray<Author> *authors;
@property RLMArray<Note> *notes;

-(id)initWithTitle:(NSString*)title
          imageUrl:(NSString*)imageUrl
            pdfUrl:(NSString*)pdfUrl;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Book>
RLM_ARRAY_TYPE(Book)
