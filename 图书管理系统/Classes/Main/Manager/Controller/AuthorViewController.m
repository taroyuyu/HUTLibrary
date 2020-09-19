//
//  addNewAuthorViewController.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "AuthorViewController.h"

@interface AuthorViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *authorPhoto;
@property (weak, nonatomic) IBOutlet UITextField *authorName;
@property (weak, nonatomic) IBOutlet UITextField *authorCountry;
@property (weak, nonatomic) IBOutlet UITextView *authorIntroduce;
@property (nonatomic)UIBarButtonItem* doneBarButton;
@end
@implementation AuthorViewController
+(instancetype)getAuthoViewController
{
    AuthorViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"authorViewController"];
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
    [self loadData];
}
-(void)loadData
{
    if (self->_model!=nil) {
        [[self authorPhoto] setImage:[UIImage imageWithData:[self->_model photo]]];
        [[self authorName] setText:[self->_model name]];
        [[self authorName] setEnabled:NO];
        [[self authorCountry] setText:[self->_model contry]];
        [[self authorIntroduce] setText:[self->_model introduce]];
    }
}
-(void)doneButtonClicked
{
    //获取信息
    NSString *authorName = [[self authorName]text];
    NSString *authorCountry = [[self authorCountry]text];
    NSString *authorIntroduce = [[self authorIntroduce]text];
    NSData *authorImage = UIImagePNGRepresentation([[self authorPhoto] image]);
    //判断信息是否完整
    if ([authorName isEqualToString:@""]||[authorCountry isEqualToString:@""]||[authorIntroduce isEqualToString:@""]||authorImage == nil) {
        [self showMessage:@"作者信息不完整"];
        return;
    }
    
    if (self->_model!=nil) {
        //NSLog(@"开始更新作者信息");
        BOOL result = [[DataManager sharedManager] refreshAuthorWithName:authorName photo:authorImage country:authorCountry andIntroduce:authorIntroduce];
        if (result) {
            [self showMessage:@"更新成功"];
        }else{
            [self showMessage:@"更新失败"];
        }
    }else{
        //NSLog(@"开始保存作者信息");
        BOOL result = [[DataManager sharedManager] createNewAuthorWithName:authorName photo:authorImage country:authorCountry andIntroduce:authorIntroduce];
        if (result) {
            [self showMessage:@"添加成功"];
        }else{
            [self showMessage:@"添加失败"];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setControlEditable];
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
    [[self authorPhoto] setImage:image];
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
        [[self authorPhoto] setUserInteractionEnabled:NO];
        [[self authorName] setUserInteractionEnabled:NO];
        [[self authorCountry]setUserInteractionEnabled:NO];
        [[self authorIntroduce]setUserInteractionEnabled:NO];
    }
}
@end
