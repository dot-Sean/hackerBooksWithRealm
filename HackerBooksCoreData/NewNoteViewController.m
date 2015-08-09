
#import "NewNoteViewController.h"
#import <Realm/Realm.h>
#import "XLForm.h"
#import "Note.h"
#import "ImageForNoteViewController.h"
#import "ImageValueTransformer.h"
#import "LocationValueTransformer.h"
#import "MapViewController.h"

NSString *const kSelectorImage = @"selectorImage";
NSString *const kSelectorLocation = @"selectorLocation";
NSString *const kSelectorImagePopover = @"selectorImagePopover";

@interface NewNoteViewController ()

@end

@implementation NewNoteViewController




- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeForm];
    }
    return self;
}


- (void)initializeForm{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    XLFormRowDescriptor * row2;
    XLFormRowDescriptor * row3;
    
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Add Note"];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    // Title
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Title" rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Title" forKey:@"textField.placeholder"];
    row.required = YES;
    [section addFormRow:row];
    
    //Image
    row2 = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorImage rowType:XLFormRowDescriptorTypeSelectorPush title:@"Image"];
    row2.action.formSegueIdenfifier = @"ShowImage";
    row2.valueTransformer = [ImageValueTransformer class];
    [section addFormRow:row2];
    
    row3 = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorLocation rowType:XLFormRowDescriptorTypeSelectorPush title:@"Location"];
    row3.action.formSegueIdenfifier = @"ShowLocation";
    row3.valueTransformer = [LocationValueTransformer class];
    //row3.value = [[CLLocation alloc] initWithLatitude:-33 longitude:-56];
    [section addFormRow:row3];

    self.form = form;
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
    //Inicializamos la Nota
    if(!self.creatingNote){
        self.creatingNote=[[Note alloc]initWithTitle:nil];
    }else{
        self.modifying=true;
    }
    
    XLFormRowDescriptor *row =  [self.form formRowWithTag:@"Title"];
    XLFormRowDescriptor *row2 = [self.form formRowWithTag:kSelectorImage];
    XLFormRowDescriptor *row3 = [self.form formRowWithTag:kSelectorLocation];
    
    row.value=self.creatingNote.title;
    row2.value=self.creatingNote.image;
    row3.value=self.creatingNote.location;
    self.selector=row2;
    self.selector2=row3;
    self.selector.value=self.creatingNote.image;
    self.selector2.value=self.creatingNote.location;
    
}


#pragma mark - XLFormDescriptorDelegate
-(void)cancelPressed:(UIBarButtonItem * __unused)button
{
    //Borramos imagen
    
    //Ponemos el puntero a nil
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)savePressed:(UIBarButtonItem * __unused)button
{
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    [self.tableView endEditing:YES];
    //Guardamos en BBDD
    NSString *title=[self.formValues valueForKey:@"Title"];
    
    RLMRealm *context = [RLMRealm defaultRealm];
    [context beginWriteTransaction];
    self.creatingNote.title=title;
    self.creatingNote.image=self.selector.value;
    self.creatingNote.location=self.selector2.value;
    self.creatingNote.bookPage=self.bookPage;
    if(self.modifying){
        self.creatingNote.lastModificationDate=[NSDate date];
        [Note createOrUpdateInRealm:context
                          withValue:self.creatingNote];
    }else{
        
        [self.model.notes addObject:self.creatingNote];
        [Book createOrUpdateInRealm:context
                          withValue:self.model];
        
    }
    [context commitWriteTransaction];
    [self.delegate didChangeNote:self.creatingNote];
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark -Segue Storyboard
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowImage"]) {
        ImageForNoteViewController *imageNoteVC = segue.destinationViewController;
        
        imageNoteVC.model=self.creatingNote;
        imageNoteVC.rowDescriptor=self.selector;
    }else if ([segue.identifier isEqualToString:@"ShowLocation"]) {
        MapViewController *mapVC = segue.destinationViewController;
        
        //imageNoteVC.model=self.creatingNote;
        mapVC.rowDescriptor=self.selector2;
    }
}




@end