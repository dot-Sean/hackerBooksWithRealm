//
//  ImageForNoteViewController.h
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 2/8/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLFormViewController.h"
#import "Image.h"

@interface ImageForNoteViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,XLFormRowDescriptorViewController>

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (strong,nonatomic) Note *model;


- (IBAction)takeImage:(id)sender;
- (IBAction)deleteImage:(id)sender;


@end
