//
//  PdfViewController.m
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 10/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "PdfViewController.h"
#import "ReaderThumbCache.h"
#import "ReaderMainToolbar.h"
#import "NotesViewController.h"

#define BOOK_DID_CHANGE_NOTIFICATION @"BOOK_DID_CHANGE_NOTIFICATION"
#define BOOK_KEY @"BOOK_KEY"

@interface PdfViewController ()

@end

@implementation PdfViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureReaderVC];
    // Do any additional setup after loading the view.
    //self.delegate=self;
    //self.mainToolbar.delegate = self;
    
    
    UITapGestureRecognizer *singleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapOne.numberOfTouchesRequired = 1; singleTapOne.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapOne];
    
    UITapGestureRecognizer *doubleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapOne.numberOfTouchesRequired = 1; doubleTapOne.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapOne];
    
    UITapGestureRecognizer *doubleTapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapTwo.numberOfTouchesRequired = 2; doubleTapTwo.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapTwo];
    
    [singleTapOne requireGestureRecognizerToFail:doubleTapOne]; // Single tap requires double tap to fail
    
}

-(void) notifyThatBookDidChange{
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    NSNotification *n = [NSNotification
                         notificationWithName:BOOK_DID_CHANGE_NOTIFICATION
                         object:self
                         userInfo:@{BOOK_KEY:self.model}];
    [nc postNotification:n];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Configuramos la Vista para Mostrar el ReaderVC
    [self configureReaderVC];
}

-(void)configureReaderVC{
    self.readerVC=[[ReaderViewController alloc]initWithReaderDocument:self.document];
    self.readerVC.delegate=self;
    self.readerVC.mainToolBarDelegate=self;
    [self.containerView addSubview:self.readerVC.view];
    self.gestureDelegate=self.readerVC;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer{
    [self.gestureDelegate handleSingleTap:recognizer];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer{
    [self.gestureDelegate handleDoubleTap:recognizer];
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
    
    [self dismissViewControllerAnimated:YES completion:^{
                if(self.model.lastPageRead!=[self.document.pageNumber integerValue]){
            RLMRealm *context = [RLMRealm defaultRealm];
            [context beginWriteTransaction];
            if([self.document.pageNumber integerValue]==[self.document.pageCount integerValue]){
                self.model.isFinished=YES;
                [self addModelToBooksFinished];
            }else{
                self.model.isFinished=NO;
            }
            self.model.lastOpened=[NSDate date];
                    [self addModelToRecentBooks];
            self.model.lastPageRead=[self.document.pageNumber integerValue];
            [context commitWriteTransaction];
            
            //Notificamos
            [self notifyThatBookDidChange];
        }
        
    }];
}

- (void)addModelToBooksFinished{
    RLMResults *tagResult = [Tag objectsWhere:@"tagName = 'Completed' "];
    Tag *completedTag=[tagResult objectAtIndex:0];
    [self.model.tags addObject:completedTag];
}

- (void)addModelToRecentBooks{
    RLMResults *tagResult = [Tag objectsWhere:@"tagName = 'Recent' "];
    Tag *recentTag=[tagResult objectAtIndex:0];
    [self.model.tags addObject:recentTag];
}



#pragma maek - ToolbarDelegate
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar doneButton:(UIButton *)button{
    [self.readerVC closeDocument];
}
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar thumbsButton:(UIButton *)button{
    
}
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar exportButton:(UIButton *)button{
    
}
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar printButton:(UIButton *)button{
    
}
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar emailButton:(UIButton *)button{
    [self performSegueWithIdentifier:@"ShowBookNotesSegue" sender:self];
}
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar markButton:(UIButton *)button{
    
}
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar bookNotesButton:(UIButton *)button{
    [self performSegueWithIdentifier:@"ShowBookNotesSegue" sender:self];
}

#pragma mark -Segue Storyboard
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *navVC = segue.destinationViewController;
    NotesViewController *notesVC = [navVC.viewControllers firstObject];
    notesVC.model=self.model;
    notesVC.actualPage=self.document.pageNumber;
    
}



@end
