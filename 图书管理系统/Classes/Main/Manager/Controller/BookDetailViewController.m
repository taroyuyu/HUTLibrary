//
//  addNewBookDetailViewController.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "BookDetailViewController.h"

@interface BookDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bookPhoto;
@property (weak, nonatomic) IBOutlet UITextField *bookName;
@property (weak, nonatomic) IBOutlet UITextField *bookAuthor;
@property (weak, nonatomic) IBOutlet UITextField *bookCatalog;
@property (weak, nonatomic) IBOutlet UITextField *bookPulishOrganization;
@property (weak, nonatomic) IBOutlet UITextField *bookDetailID;
@property (weak, nonatomic) IBOutlet UITextView *bookIntroducation;
@property (nonatomic)UIBarButtonItem* doneBarButton;
@end

@implementation BookDetailViewController

+(instancetype)getBookDetailViewController
{
    BookDetailViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"bookDetailController"];
    return viewController;
}
-(UIBarButtonItem*)doneBarButton
{
    if (self->_doneBarButton!=nil) {
        return self->_doneBarButton;
    }
    self->_doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonClicked)];
    return self->_doneBarButton;
}
-(void)loadView
{
    [super loadView];
    if ([self editable]) {
        [[self navigationItem] setRightBarButtonItem:[self doneBarButton]];
    }
}
-(void)doneButtonClicked
{
    //获取信息
    
    NSData *bookPhoto = UIImagePNGRepresentation([[self bookPhoto] image]);
    NSString *bookName = [[self bookName]text];
    NSString *bookAuthor = [[self bookAuthor]text];
    NSString *bookCatalog = [[self bookCatalog]text];
    NSString *bookPulishOrganization = [[self bookPulishOrganization] text];
    NSString *bookDetailID = [[self bookDetailID]text];
    NSString *bookIntroduce = [[self bookIntroducation]text];
    //判断信息是否完整
    if ([bookName isEqualToString:@""]||[bookAuthor isEqualToString:@""]||[bookCatalog isEqualToString:@""]||[bookPulishOrganization isEqualToString:@""]||[bookDetailID isEqualToString:@""]||[bookIntroduce isEqualToString:@""]||bookPhoto==nil) {
        [self showMessage:@"书籍信息不完整"];
        return;
    }
    
    if (self->_model!=nil) {
        //NSLog(@"开始更新书籍信息");
        NSData* image = UIImagePNGRepresentation([[self bookPhoto] image]);
        BOOL result = [[DataManager sharedManager] refreshBookWithName:bookName authorName:bookAuthor bookPhoto:bookPhoto bookCatalog:bookCatalog publishOragnization:bookPulishOrganization bookDetailID:bookDetailID introduce:bookIntroduce];
        [[DataManager sharedManager] saveContext];
        if (result) {
            [self showMessage:@"更新成功"];
        }else{
            [self showMessage:@"更新失败"];
        }
    }else{
       // NSLog(@"开始保存书籍信息");
        BOOL result = [[DataManager sharedManager] createNewBookWithName:bookName authorName:bookAuthor bookPhoto:bookPhoto bookCatalog:bookCatalog publishOragnization:bookPulishOrganization bookDetailID:bookDetailID introduce:bookIntroduce];
        if (result) {
            [self showMessage:@"添加成功"];
        }else{
            [self showMessage:@"添加失败"];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setControlEditable];
}
-(void)loadData
{
    NSLog(@"开始加载数据");
    if (self->_model!=nil) {
        [[self bookPhoto] setImage:[UIImage imageWithData:[self->_model bookPhoto]]];
        [[self bookName] setText:[self->_model bookName]];
        [[self bookAuthor] setText:[[self->_model author] name]];
        [[self bookCatalog] setText:[self->_model bookCataogID]];
        [[self bookPulishOrganization] setText:[self->_model publishOraganization]];
        [[self bookIntroducation] setText:[self->_model introduce]];
        [[self bookDetailID] setText:[self->_model detailID]];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section]==0&&[indexPath row]==0) {
        [self editUserPhoto];
    }
}
-(void)editUserPhoto
{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction* photoAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImageViewControllerWithType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }];
    
    UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImageViewControllerWithType:UIImagePickerControllerSourceTypeCamera];
    }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:photoAction];
    [alertController addAction:cancleAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)showImageViewControllerWithType:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController* imagePicker = [UIImagePickerController new];
    [imagePicker setDelegate:self];
    [imagePicker setAllowsEditing:YES];
    [imagePicker setSourceType:type];
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    [[self bookPhoto] setImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)showMessage:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)setControlEditable
{
    if ([self editable]==NO) {
        [[self bookPhoto] setUserInteractionEnabled:NO];
        [[self bookName] setUserInteractionEnabled:NO];
        [[self bookAuthor]setUserInteractionEnabled:NO];
        [[self bookCatalog] setUserInteractionEnabled:NO];
        [[self bookPulishOrganization]setUserInteractionEnabled:NO];
        [[self  bookDetailID] setUserInteractionEnabled:NO];
        [[self bookIntroducation]setUserInteractionEnabled:NO];
    }
}

@end
