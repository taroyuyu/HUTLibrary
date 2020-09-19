//
//  ImportBookViewController.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/17.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "ImportBookViewController.h"

@interface ImportBookViewController ()<UITextFieldDelegate,CodeCaptureViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *bookDetailID;
@property (weak, nonatomic) IBOutlet UITextField *bookID;
@property (nonatomic)UIBarButtonItem* doneBarButton;
@property (nonatomic,assign)BOOL isBookDetailID;
@end

@implementation ImportBookViewController
+(instancetype)getImportBookViewController
{
    ImportBookViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"importBookViewController"];
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
    NSLog(@"%s",__func__);
    [super loadView];
    [[self navigationItem] setRightBarButtonItem:[self doneBarButton]];
}
-(void)viewDidLoad
{
    [[self bookDetailID] setDelegate:self];
    [[self bookID] setDelegate:self];
}
-(void)doneButtonClicked
{
    //获取信息
    NSString *bookDetailID = [[self bookDetailID]text];
    NSString *bookID = [[self bookID]text];
    //判断信息是否完整
    if ([bookDetailID isEqualToString:@""]||[bookID isEqualToString:@""]) {
        [self showMessage:@"信息不完整"];
        return;
    }
    
    BookDetail *bookDetail = [[DataManager sharedManager] searchBookDetailWithBookDetailID:[[self bookDetailID] text]];
    BOOL result = [[DataManager sharedManager] createNewBookWithBookID:[[self bookID] text] bookDetail:bookDetail andStatus:YES];
    if (result) {
        [self showMessage:@"新书入库成功"];
    }else{
        [self showMessage:@"新书入库失败"];
    }
    [[self bookDetailID] setText:@""];
    [[self bookID] setText:@""];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    if (textField==[self bookDetailID]) {
        return YES;
    }
    CodeCaptureViewController *codeCaptureViewController = [CodeCaptureViewController new];
    [codeCaptureViewController setDelegate:self];
    [[self navigationController] pushViewController:codeCaptureViewController animated:YES];
    return NO;
}
-(void)didFinishedScan:(CodeCaptureViewController *)viewController withCode:(NSString *)code
{
    [[self navigationController] popViewControllerAnimated:NO];
    if ([self isBookDetailID]) {
        BookDetail *bookDetailID = [[DataManager sharedManager] searchBookDetailWithName:code];
        if (bookDetailID==nil) {
            [self showMessage:@"没有这个书籍详情ID"];
        }else{
            [[self bookDetailID] setText:[bookDetailID detailID]];
        }
    }else{
        [[self bookID] setText:code];
    }
}

-(void)showMessage:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
