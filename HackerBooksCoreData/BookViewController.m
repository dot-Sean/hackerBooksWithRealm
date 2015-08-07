//
//  BookViewController.m
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 10/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "BookViewController.h"
#import "ReaderDocument.h"
#import "PdfViewController.h"
#import "AFHTTPRequestOperation.h"
#import "NotesViewController.h"

@interface BookViewController ()

@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView.image=[UIImage imageWithData:self.model.bookImage.data];
    [self refreshFavIcon];
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

#pragma mark -Actions

- (IBAction)setFavorite:(id)sender {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    self.model.favorite= !self.model.favorite;
    RLMResults *tagResult = [Tag objectsWhere:@"tagName = 'Favorites' "];
    Tag *favTag=[tagResult objectAtIndex:0];
    if(self.model.favorite){
        [self.model.tags addObject:favTag];
    }else{
        //Eliminamos el elemento del array
        int index=0;
        for(Tag *tag in self.model.tags){
            if([tag.tagName isEqualToString:@"Favorites"]){
                break;
            }
            index++;
        }
        [self.model.tags removeObjectAtIndex:index];
    }
    [realm commitWriteTransaction];
    [self refreshFavIcon];
    //Avisamos delegados de cambio en Fav
    [self.delegate didChangeBook:self.model];
}

- (IBAction)viewNotes:(id)sender {
}

- (IBAction)viewBook:(id)sender {
    //Tenemos que descargar el book y meterlo en la BBDD
    [self getPdfDataFromBook:self.model];
    
}


-(void) refreshFavIcon{
    if(self.model.favorite){
        //Ponemos el icono de favoritos
        self.favIcon.image=[UIImage imageNamed:@"starFav"];
    }else{
        //Ponemos el icono de Nofavoritos
        self.favIcon.image=[UIImage imageNamed:@"starNoFav"];
    }
}

-(NSData*)getPdfDataFromBook:(Book*)book{
    
    if(book.bookPdf==nil){
        NSURL *url = [NSURL URLWithString:book.pdfUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //Hacemos la progressBar visible
        self.progressView.progress=0;
        self.progressView.hidden= NO;
        self.progressLabel.hidden=NO;
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            self.progressView.progress = (float) totalBytesRead/totalBytesExpectedToRead;
            self.progressLabel.text=[NSString stringWithFormat:@"Downloading %lld/%lld",totalBytesRead,totalBytesExpectedToRead];
        }];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            Pdf *pdf=[Pdf new];
            pdf.data=responseObject;
            
            //Persistimos pdf en la BBDD
            [[RLMRealm defaultRealm]beginWriteTransaction];
            book.bookPdf=pdf;
            [[RLMRealm defaultRealm] commitWriteTransaction];
            
            self.progressView.hidden= YES;
            self.progressLabel.hidden=YES;
            self.progressView.progress=0;
            self.progressLabel.text=@"Downloading...";
            [self relocatePdf:self.model];
            [self loadPdf:self.model];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //NSLog(@"Error: %@", error);
        }];
        
        [operation start];
    }else{
        [self relocatePdf:self.model];
        [self loadPdf:self.model];
    }
    return book.bookPdf.data;
}

-(void)relocatePdf:(Book*)book{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *baseDocumentPath = [paths objectAtIndex:0];
    NSString *fileName=@"/";
    fileName=[fileName stringByAppendingString:book.title];
    fileName=[fileName stringByAppendingString:@".pdf"];
    NSString *filePath = [baseDocumentPath stringByAppendingPathComponent:fileName];
    [book.bookPdf.data writeToFile:(filePath) atomically:YES];
}

-(void) loadPdf:(Book*)book{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *baseDocumentPath = [paths objectAtIndex:0];
    NSString *fileName=@"/";
    fileName=[fileName stringByAppendingString:book.title];
    fileName=[fileName stringByAppendingString:@".pdf"];
    NSString *filePath = [baseDocumentPath stringByAppendingPathComponent:fileName];
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:nil];
    PdfViewController *pdfVC=[[PdfViewController alloc]initWithReaderDocument:document];
    [self.navigationController pushViewController:pdfVC
                                         animated:true];
    //[self performSegueWithIdentifier: @"bookPdf"
    //                          sender: self];
}

//In a storyboard-based application, you will often want to do a little preparation before navigation
# pragma mark -Storyboard Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Get the new view controller using [segue destinationViewController].
    //Pass the selected object to the new view controller.
    NotesViewController *notesVC = segue.destinationViewController;
    notesVC.model=self.model;
}

@end
