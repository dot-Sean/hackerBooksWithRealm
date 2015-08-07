//
//  NoteCell.h
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 13/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UILabel *noteTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ticker;


@end
