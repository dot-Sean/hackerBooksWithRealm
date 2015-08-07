//
//  BookCell.m
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 9/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "BookCell.h"

@implementation BookCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
