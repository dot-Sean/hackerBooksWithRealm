//
//  NewNoteViewController.h
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 1/8/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "XLFormViewController.h"
#import "Book.h"

@protocol NoteViewControllerDelegate <NSObject>

- (void) didChangeNote:(Note *)note;

@end

@interface NewNoteViewController : XLFormViewController

@property(strong,nonatomic) Book *model;
@property(strong,nonatomic) Note *creatingNote;
@property(nonatomic) int bookPage;
@property(strong,nonatomic) XLFormRowDescriptor * selector;
@property(strong,nonatomic) XLFormRowDescriptor * selector2;
@property (nonatomic) BOOL modifying;
@property (weak,nonatomic) id<NoteViewControllerDelegate> delegate;

@end
