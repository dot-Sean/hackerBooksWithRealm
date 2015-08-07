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

@interface BooksTableViewController ()



@end

@implementation BooksTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //call Realm to return data
    self.tags = [Tag allObjects];
    //self.tableView.delegate=self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.tags.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    Tag *tag=[self.tags objectAtIndex:section];
    return tag.books.count;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section{
    Tag *tag=[self.tags objectAtIndex:section];
    return [tag.tagName capitalizedString];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"BookCell";
    
    BookCell *customCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //Me pasa una cosa curiosa, al reciclar una cell si, como la cell ya tiene una imagen
    //me la devuelve con la misma que ya tenia
    
    //Obtenemos el Book
    Book *book=[self bookForIndexPath:indexPath];
    
    // Sincronizamos modelo con vista (celda)
    //NSData *imageData=[[NSData alloc]initWithContentsOfURL:([book imageProxy])];
    //cell.imageView.image = [UIImage imageWithData:(imageData)];
    customCell.bookTitleLabel.text=book.title;
    customCell.authorsBookLabel.text=[self createAuthorsString:book.authors];
    customCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    customCell.bookImageView.image = [UIImage imageNamed:@"noImage"];
    [self setImageFromBook:book
                    toCell:customCell];
    
    return customCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.bookSelected=[self bookForIndexPath:indexPath];
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
