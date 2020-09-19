//
//  ProfileViewController.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userAccount;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}
-(void)loadData
{
    NSString* currentUserAccount = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUserAccount"];
    Manager *currentManager = [[DataManager sharedManager] searchManagerWithAccount:currentUserAccount];
    [[self userName] setText:[currentManager name]];
    [[self userAccount] setText:[currentManager managerID]];
    [[self userPhoto] setImage:[UIImage imageWithData:[currentManager photo]]];
    
}
- (IBAction)exitButtonClicked:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定要退出吗?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        [[NSUserDefaults standardUserDefaults] setValue:[[self userAccount] text] forKey:@"lastLoginAccount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[[[UIApplication sharedApplication] delegate] window] setRootViewController:loginViewController];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:exitAction];
    [alertController addAction:cancleAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
