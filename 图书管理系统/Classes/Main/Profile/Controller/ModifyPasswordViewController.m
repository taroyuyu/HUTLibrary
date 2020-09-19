//
//  ModifyPasswordViewController.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userAccount;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordAgain;
@property (nonatomic)Manager *currentManager;
@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* currentUserAccount = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUserAccount"];
    self->_currentManager = [[DataManager sharedManager] searchManagerWithAccount:currentUserAccount];
    [[self userAccount] setText:currentUserAccount];
}
- (IBAction)doneButtonClicked:(UIBarButtonItem *)sender {
    
    NSString *password_a = [[self userPassword] text];
    NSString *password_b = [[self userPasswordAgain] text];
    if ([password_a isEqualToString:password_b]) {
        [self showMessage:@"密码修改成功"];
        [_currentManager setPassword:password_a];
        [[DataManager sharedManager] saveContext];
    }else{
        [self showMessage:@"两次输入的密码不相同"];
        [[self userPassword] setText:@""];
        [[self userPasswordAgain] setText:@""];
    }
    
}
-(void)showMessage:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        [[self navigationController] popViewControllerAnimated:YES];
    }];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
