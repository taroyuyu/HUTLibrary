//
//  LoginViewController.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userAccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取上一次登陆的用户名
    NSString* lastLoginAccount = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastLoginAccount"];
    [[self userAccountTextField] setText:lastLoginAccount];
}

- (IBAction)loginButtonClicked:(id)sender {
    NSString *userAccount = [[self userAccountTextField] text];
    NSString *userPassword = [[self userPasswordTextField] text];
    
    Manager *manager = [[DataManager sharedManager] searchManagerWithAccount:userAccount];
    
    if ([userAccount isEqualToString:@""]||[userPassword isEqualToString:@""]) {
        
        [self showWrongMessageWithTitle:@"提醒" message:@"请输入用户名和密码"];
        
    }else{
        
        if (manager!=nil&&[[manager password] isEqualToString:userPassword]) {
            
//            //切换到主场景
            [[NSUserDefaults standardUserDefaults] setValue:userAccount forKey:@"currentUserAccount"];
            UIViewController *mainViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainViewController"];
            [[[[UIApplication sharedApplication] delegate] window] setRootViewController:mainViewController];
        }else{
            [self showWrongMessageWithTitle:@"错误" message:@"用户名或者密码错误"];
        }
        
        
    }
}

-(void)showWrongMessageWithTitle:(NSString*)title message:(NSString*)message
{
    
    UIAlertController *wrongAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [wrongAlert addAction:defaultAction];
    [self presentViewController:wrongAlert animated:YES completion:nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}
@end
