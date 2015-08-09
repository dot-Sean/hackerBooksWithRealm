//
//  BooksTableViewController.m
//  HackerBooksCoreData 
//
//  Created by Jose Manuel Franco on 9/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "BooksTableViewController.h"
#import "Tag.h"
#import "BookCell.h"
#import "BookViewController.h"
#import "AFHTTPRequestOperation.h"
#define BOOK_KEY @"BOOK_KEY"

#define BOOK_DID_CHANGE_NOTIFICATION @"BOOK_DID_CHANGE_NOTIFICATION"

@interface BooksTableViewController ()



@end

@implementation BooksTableViewController

-(void) dealloc{
    [self tearDownNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //call Realm to return data
    self.tags = [Tag allObjects];
    self.books =[Book allObjects];
    //self.tableView.delegate=self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Configuramos la barra de busqueda de libros
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.scopeButtonTitles=@[@"Tags",@"Title",@"Authors"];
    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    
    // Alta en notificaciones de library
    [self setupNotifications];
}

-(void)setupNotifications{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(didChangeBook:)
               name:BOOK_DID_CHANGE_NOTIFICATION
             object:nil];
}

-(void) tearDownNotifications{
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.searchIndex==0){
        return self.tags.count;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(self.searchIndex==0){
        Tag *tag=[self.tags objectAtIndex:section];
        return tag.books.count;
    }else{
        return [self.books count];
    }
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section{
    if(self.searchIndex==0){
        Tag *tag=[self.tags objectAtIndex:section];
        return [tag.tagName capitalizedString];
    }else{
        return @"Books";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"BookCell";
    
    BookCell *customCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //Me pasa una cosa curiosa, al reciclar una cell si, como la cell ya tiene una imagen
    //me la devuelve con la misma que ya tenia
    Book *book=nil;
    if(self.searchIndex==0){
        //Obtenemos el Book
        book=[self bookForIndexPath:indexPath];
    }else{
        book = [self.books objectAtIndex:indexPath.row];
    }
    
    // Sincronizamos modelo con vista (celda)
    //NSData *imageData=[[NSData alloc]initWithContentsOfURL:([book imageProxy])];
    //cell.imageView.image = [UIImage imageWithData:(imageData)];
    customCell.bookTitleLabel.text=book.title;
    customCell.authorsBookLabel.text=[self createAuthorsString:book.authors];
    customCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    customCell.bookImageView.image = [UIImage imageNamed:@"noImage"];
    
    if(book.lastPageRead){
        customCell.pageNumberLabel.text=[NSString stringWithFormat:@"%ld",book.lastPageRead];
        customCell.pageNumberLabel.hidden=NO;
    }else{
        customCell.pageNumberLabel.hidden=YES;
    }
    
    if(book.isFinished){
        customCell.finishedLabel.hidden=NO;
    }else{
        customCell.finishedLabel.hidden=YES;
    }
    [self setImageFromBook:book
                    toCell:customCell];
    
    return customCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.searchIndex==0){
        self.bookSelected=[self bookForIndexPath:indexPath];
    }else{
        self.bookSelected=[self.books objectAtIndex:indexPath.row];
    }
    
    [self performSegueWithIdentifier: @"bookDetail"
                              sender: self];
}

- (Book *)bookForIndexPath:(NSIndexPath *)indexPath{
    // Averiguamos de qué book se trata
    Book *book = nil;
    
    Tag *tag=[self.tags objectAtIndex:indexPath.section];
    book=[tag.books objectAtIndex:(indexPath.row)];
    return book;
}

-(NSString*) createAuthorsString:(RLMArray<Author>*) authors{
    NSString *result=[NSString new];
    for(Author *obj in authors){
        result=[result stringByAppendingString:obj.authorName];
        result=[result stringByAppendingString:@","];
    }
    result = [result substringToIndex:[result length] - 1];
    return result;
}

-(void)setImageFromBook:(Book*)book
                 toCell:(BookCell*)cell{
    
    if(book.bookImage==nil){
        NSURL *url = [NSURL URLWithString:book.imageUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //Hacemos la progressBar visible
        cell.progressBar.hidden= NO;
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFImageResponseSerializer serializer];
        
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            cell.progressBar.progress = (float) totalBytesRead/totalBytesExpectedToRead;
            [self.tableView reloadData];
        }];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            Image *image=[Image new];
            image.data=UIImagePNGRepresentation(responseObject);
            
            //Persistimos imagen en la BBDD
            [[RLMRealm defaultRealm]beginWriteTransaction];
            book.bookImage=image;
            [[RLMRealm defaultRealm] commitWriteTransaction];
            
            cell.bookImageView.image = responseObject;
            cell.progressBar.hidden= YES;
            cell.progressBar.progress=0;
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //NSLog(@"Error: %@", error);
        }];
        
        [operation start];
    }else{
        cell.bookImageView.image = [UIImage imageWithData:book.bookImage.data];
    }
}

# pragma mark - Delegate SearchController
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    NSLog(@"el indice es %ld",selectedScope);
    self.searchIndex=selectedScope;
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchIndex=0;
    self.searchController.searchBar.selectedScopeButtonIndex=0;
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = searchController.searchBar.text;
    self.searchIndex=self.searchController.searchBar.selectedScopeButtonIndex;
    NSPredicate *predicate=nil;
    
    switch (self.searchIndex){
        case 0:
            if(![searchString isEqualToString:@""]){
                predicate = [NSPredicate predicateWithFormat:@"tagName CONTAINS[c]%@", searchString];
            }else{
                predicate=[NSPredicate predicateWithValue:YES];
            }
            self.tags = [Tag objectsWithPredicate:predicate];
            break;
            
        case 1:
            if(![searchString isEqualToString:@""]){
                predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[c]%@", searchString];
            }else{
                predicate=[NSPredicate predicateWithValue:YES];
            }
            self.books = [Book objectsWithPredicate:predicate];
            break;
            
        case 2:
            if(![searchString isEqualToString:@""]){
                predicate = [NSPredicate predicateWithFormat:@"ANY authors.authorName CONTAINS[c]%@", searchString];
            }else{
                predicate=[NSPredicate predicateWithValue:YES];
            }
            self.books = [Book objectsWithPredicate:predicate];
            break;
            
    }
    [self.tableView reloadData];
}

#pragma mark -Delegates
-(void) didChangeBook:(Book *)aBook{
    //Comprobamos favorites de Book y actualizamos en Tags
    //Refrescamos.
    //Lo mismo real refresca todo el modelo y solo tenemmosmque recargar la tabla
    [self.tableView reloadData];
}


#pragma mark - Navigation

 //In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     //Get the new view controller using [segue destinationViewController].
     //Pass the selected object to the new view controller.
    BookViewController *bookVC = segue.destinationViewController;
    bookVC.delegate=self;
    bookVC.model=self.bookSelected;

}

@end
