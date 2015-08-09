//
//  PdfViewController.h
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 10/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"
#import "Book.h"
#import "ReaderMainToolbar.h"
#import "BookViewController.h"

@interface PdfViewController : UIViewController<ReaderViewControllerDelegate,ReaderMainToolbarDelegate,UIGestureRecognizerDelegate>

@property(strong,nonatomic) Book *model;
@property(strong,nonatomic) ReaderDocument *document;
@property(strong,nonatomic) ReaderViewController *readerVC;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak,nonatomic) id<GestureDelegate> gestureDelegate;

@end
