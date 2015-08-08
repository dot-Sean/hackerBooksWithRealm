//
//  BooksTableViewController.h
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 9/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
#import "BookViewController.h"

@interface BooksTableViewController : UITableViewController<UITableViewDelegate,CROBookViewControllerDelegate,UISearchBarDelegate, UISearchResultsUpdating>

@property(strong,nonatomic) Book *bookSelected;
@property(strong,nonatomic) RLMResults *tags;
@property(strong,nonatomic) RLMResults *books;
@property (strong, nonatomic) UISearchController *searchController;
@property(nonatomic) NSInteger searchIndex;

@end
