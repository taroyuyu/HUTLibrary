//
//  ReaderMaterialMaintainViewController.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "ReaderMaterialMaintainViewController.h"
#import "ReaderViewController.h"
typedef enum:NSInteger
{
    AddReaderType,
    EditReaderType
}MaaintainType;

@interface ReaderMaterialMaintainViewController ()<CodeCaptureViewControllerDelegate>

@end

@implementation ReaderMaterialMaintainViewController
+(instancetype)getReaderMaterialMaintainViewController
{
    ReaderMaterialMaintainViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"readerMaterialMaintainController"];
    return viewController;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case AddReaderType:
        {
            ReaderViewController *readerViewController = [ReaderViewController getReaderViewController];
            [readerViewController setEditable:YES];
            [readerViewController setTitle:@"添加读者"];
            [[self navigationController] pushViewController:readerViewController animated:YES];
        }
            break;
        case EditReaderType:
        {
            CodeCaptureViewController *readerIDCaptureController = [CodeCaptureViewController new];
            [readerIDCaptureController setDelegate:self];
            [[self navigationController] pushViewController:readerIDCaptureController animated:YES];
        }
            break;
    }
}
-(void)showMessage:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)didFinishedScan:(CodeCaptureViewController*)viewController withCode:(NSString*)code
{
    [[self navigationController] popViewControllerAnimated:NO];
    Reader *readerModel = [[DataManager sharedManager] searchReaderWithReaderID:code];
    if (readerModel==nil) {
        [self showMessage:@"不存在此读者"];
    }else{
        ReaderViewController *readerViewController = [ReaderViewController getReaderViewController];
        [readerViewController setModel:readerModel];
        [readerViewController setEditable:YES];
        [readerViewController setTitle:@"编辑"];
        [[self navigationController] pushViewController:readerViewController animated:YES];
    }
}
@end
