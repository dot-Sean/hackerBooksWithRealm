//
//  ImageForNoteViewController.m
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 2/8/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "ImageForNoteViewController.h"
#import "UIImage+Resize.h"

@interface ImageForNoteViewController ()

@end

@implementation ImageForNoteViewController

@synthesize rowDescriptor = _rowDescriptor;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Caragamos la imagen en su hueco si no es nula
    if(self.rowDescriptor.value){
        self.image.image = [UIImage imageWithData:((Image *)self.rowDescriptor.value).data];
        
    }else{
        //Le metemos imagen por defecto
        self.image.image=[UIImage imageNamed:@"noImage"];
    }
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

- (IBAction)takeImage:(id)sender {
    UIImagePickerController *imgPickerVC=[[UIImagePickerController alloc]init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imgPickerVC.sourceType=UIImagePickerControllerSourceTypeCamera;
    }else{
        imgPickerVC.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imgPickerVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    imgPickerVC.delegate=self;
    
    [self presentViewController:imgPickerVC
                       animated:YES
                     completion:^{

                     }];
    
}

- (IBAction)openImageFolder:(id)sender {
    UIImagePickerController *imgPickerVC=[[UIImagePickerController alloc]init];
    
    imgPickerVC.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    
    imgPickerVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    imgPickerVC.delegate=self;
    
    [self presentViewController:imgPickerVC
                       animated:YES
                     completion:^{
                         
                     }];

}

- (IBAction)deleteImage:(id)sender {
    //Pasamos a rowDescriptor Imagen Vacia
    self.rowDescriptor.value=nil;
    self.image.image=[UIImage imageNamed:@"noImage"];
}




#pragma mark - UIImagePickerControllerDelegate
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *img = [([info objectForKey:UIImagePickerControllerOriginalImage])
                    resizedImage:self.calculateScreenSize
                    interpolationQuality:kCGInterpolationMedium];
    
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                Image *imageCreated=[[Image alloc]init];
                                 imageCreated.data=UIImagePNGRepresentation(img);
                                 
                                 self.image.image=img;
                                 self.rowDescriptor.value=imageCreated;
                             }];
    
    
    
}

-(CGSize) calculateScreenSize{
    CGRect screenBounds = [[UIScreen mainScreen]bounds];
    CGFloat screenScale = [[UIScreen mainScreen]scale];
    return CGSizeMake(screenBounds.size.width * screenScale,
                      screenBounds.size.height * screenScale);
}




@end
