//
//  NotesViewController.m
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 13/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "NotesViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "NewNoteViewController.h"
#import "NoteCell.h"

@interface NotesViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,NoteViewControllerDelegate>

@end

@implementation NotesViewController

static NSString * const reuseIdentifier = @"NoteCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    
    //Add ToolBar with delete Button
    UIBarButtonItem *deleteBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAction)];
    self.toolbarItems=[NSArray arrayWithObjects:deleteBarButtonItem,nil];
    
    [self configureSingleSelectionView];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.model.notes count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NoteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    Note *note=[self.model.notes objectAtIndex:indexPath.row];
    if(self.collectionView.allowsMultipleSelection){
        if([self.selectedNotes containsObject:note]){
            cell.ticker.hidden=NO;
        }else{
            cell.ticker.hidden=YES;
        }
    }else{
        cell.ticker.hidden=YES;
    }
    
    // Configure the cell
    
    if(note.image){
        cell.bookImage.image=[UIImage imageWithData:note.image.data];
    }
    cell.noteTitle.text=note.title;
    
    
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Note *note=[self.model.notes objectAtIndex:indexPath.row];
    //self.noteSelected=note;
    
    if(self.collectionView.allowsMultipleSelection){
        if([self.selectedNotes containsObject:note]){
            [self.selectedNotes removeObject:note];
        }else{
            [self.selectedNotes addObject:note];
        }
        [self.collectionView reloadData];
    }else{
        [self.selectedNotes removeAllObjects];
        [self.selectedNotes addObject:note];
        [self performSegueWithIdentifier:@"AddViewNote" sender:self];
    }
    
}

#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No Notes Found";
    return [[NSAttributedString alloc] initWithString:text attributes:nil];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    
    NSString *text = @"To add a note, please press add button on the top right corner";
    return [[NSAttributedString alloc] initWithString:text attributes:nil];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"noteImageEmpty"];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return nil;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return CGPointMake(0, -64.0);
}


#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldShow:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark -NoteDidChange Delegate
- (void) didChangeNote:(Note *)note{
    //No es muy eficiente.
    [self.collectionView reloadData];
}



-(void) configureMultipleSelectionView{
    self.selectedNotes = [@[] mutableCopy];
    self.collectionView.allowsMultipleSelection=YES;
    
    UIBarButtonItem *selectBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItems=nil;
    self.navigationItem.rightBarButtonItem=selectBarButtonItem;
    self.navigationController.toolbarHidden=NO;
    
    
}

-(void) configureSingleSelectionView{
    self.selectedNotes = [@[] mutableCopy];
    self.collectionView.allowsMultipleSelection=NO;
    
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction)];
    UIBarButtonItem *selectBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStylePlain target:self action:@selector(selectAction)];
    self.navigationItem.rightBarButtonItem=nil;
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:addBarButtonItem, selectBarButtonItem, nil];
    self.navigationController.toolbarHidden=YES;
}

#pragma mark -Targets
-(void) selectAction{
    [self configureMultipleSelectionView];
}

-(void) addAction{
   [self.selectedNotes removeAllObjects];
   [self performSegueWithIdentifier:@"AddViewNote" sender:self];
}

-(void) cancelAction{
    [self configureSingleSelectionView];
    [self.collectionView reloadData];
}

-(void) deleteAction{
    RLMRealm *context = [RLMRealm defaultRealm];
    [context beginWriteTransaction];
    for(Note *note in self.selectedNotes){
        [context deleteObject:note];
    }
    [context commitWriteTransaction];
    [self.collectionView reloadData];
}

#pragma mark -Segue Storyboard
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *navVC = segue.destinationViewController;
    NewNoteViewController *newNoteVC = [navVC.viewControllers firstObject];
    newNoteVC.model=self.model;
    newNoteVC.creatingNote=[self.selectedNotes firstObject];
    newNoteVC.delegate=self;

}



@end
