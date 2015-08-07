//
//  BookCell.h
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 9/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorsBookLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@end
