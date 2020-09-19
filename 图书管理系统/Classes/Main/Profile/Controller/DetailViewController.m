//
//  DetailViewController.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userAccount;
@property (nonatomic)Manager *currentManager;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}
-(void)loadData
{
    NSString* currentUserAccount = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUserAccount"];
    self->_currentManager = [[DataManager sharedManager] searchManagerWithAccount:currentUserAccount];
    [[self userName] setText:[self->_currentManager name]];
    [[self userAccount] setText:[_currentManager managerID]];
    [[self userPhoto] setImage:[UIImage imageWithData:[_currentManager photo]]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section]==0&&[indexPath row]==0) {
        [self editUserPhoto];
    }
}

- (IBAction)changePasswordClicked:(UIButton *)sender {
    
    
    UIAlertController *verifyPasswordController = [UIAlertController alertControllerWithTitle:@"验证" message:@"请输入密码" preferredStyle:UIAlertControllerStyleAlert];
    [verifyPasswordController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setFrame:CGRectMake(0, 0, 200, 44)];
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        [textField setSecureTextEntry:YES];
    }];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString* inputPassword = [[[verifyPasswordController textFields] lastObject]text];
        NSLog(@"inputPassword = %@",inputPassword);
        NSString* userPassword = [[self currentManager] password];
        NSLog(@"userPassword = %@",userPassword);
        if ([inputPassword isEqualToString:userPassword]) {
            UIViewController *modifyViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"modifyPassword"];
            [[self navigationController] pushViewController:modifyViewController animated:YES];
        }else{
            NSLog(@"密码");
//            提示错误
        }
    }];
    [verifyPasswordController addAction:defaultAction];
    [self presentViewController:verifyPasswordController animated:YES completion:nil];
    
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
    [[self userPhoto] setImage:image];
    [[self currentManager] setPhoto:UIImagePNGRepresentation(image)];
    [[DataManager sharedManager] saveContext];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
