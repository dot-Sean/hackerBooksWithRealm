//
//  NotesViewController.h
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 13/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface NotesViewController : UICollectionViewController<UITableViewDelegate>

@property(strong,nonatomic) Book *model;
@property(nonatomic) NSNumber *actualPage;
@property(nonatomic, strong) NSMutableArray *selectedNotes;

@end
