//
//  PdfViewController.m
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 10/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "PdfViewController.h"
#import "ReaderThumbCache.h"

@interface PdfViewController ()

@end

@implementation PdfViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate=self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
