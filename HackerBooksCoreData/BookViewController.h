//
//  BookViewController.h
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 10/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
#import "ReaderDocument.h"

@protocol CROBookViewControllerDelegate <NSObject>

- (void) didChangeBook:(Book *)aBook;

@end

@interface BookViewController : UIViewController

@property (strong,nonatomic) Book *model;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favIcon;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak,nonatomic) id<CROBookViewControllerDelegate> delegate;

- (IBAction)setFavorite:(id)sender;
- (IBAction)viewNotes:(id)sender;
- (IBAction)viewBook:(id)sender;



@end
