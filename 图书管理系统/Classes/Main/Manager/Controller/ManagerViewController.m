//
//  ManagerViewController.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "ManagerViewController.h"
#import "BookMaterialMaintainViewController.h"
#import "ReaderMaterialMaintainViewController.h"
#import "BorrowBookCenterViewController.h"
typedef enum:NSUInteger{
    BorrowBook = 0,           //借书
    ReturnBook,               //还书
    BookMaterialMaintain = 10,//图书资料维护
    ReaderMaterialMaintain,   //读者资料维护
    DataBackup = 20,          //数据备份
    DataResume                //数据还原
}ManagerItemType;

@interface ManagerViewController ()<CodeCaptureViewControllerDelegate>

@end

@implementation ManagerViewController
{
    NSInteger _didSelectedItem;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self->_didSelectedItem = [indexPath section]*10 + [indexPath row];
    
    
    switch (_didSelectedItem) {
        case BorrowBook:
        case ReturnBook:
            [self handleBorrowBookWorkOrReturnBookWork];
            break;
        case BookMaterialMaintain:
            [self handleBookMaterialMaintainWork];
            break;
        case ReaderMaterialMaintain:
            [self handleReaderMaterialMaintainWork];
        default:
            break;
    }
    
}
-(void)handleBorrowBookWorkOrReturnBookWork
{
    //处理借书业务
    CodeCaptureViewController *codeCaptureViewController = [CodeCaptureViewController new];
    [codeCaptureViewController setDelegate:self];
    [[self navigationController] pushViewController:codeCaptureViewController animated:YES];
}

-(void)handleBorrowBookWorkDelegateWithCode:(NSString*)code
{
    Reader *readerModel = [[DataManager sharedManager] searchReaderWithReaderID:code];
    if (readerModel==nil) {
        [self showMessage:@"不存在此读者"];
        return;
    }
    BorrowBookCenterViewController *borrowBookCenterViewController = [BorrowBookCenterViewController getBorrowBookCenterViewController];
    [borrowBookCenterViewController setReaderModel:readerModel];
    [[self navigationController] pushViewController:borrowBookCenterViewController animated:YES];
}
-(void)handleReturnBookWorkDelegateWithCode:(NSString*)code
{
    BOOL result = [[DataManager sharedManager] returnBookWithBookID:code];
    if (result) {
        [self showMessage:@"还书成功"];
    }else{
        [self showMessage:@"还书失败"];
    }
}

-(void)handleBookMaterialMaintainWork
{
    //处理图书资料维护
    BookMaterialMaintainViewController *bookMaterialMaintainController = [BookMaterialMaintainViewController getBookMaterialMaintainViewController];
    [[self navigationController] pushViewController:bookMaterialMaintainController animated:YES];
    
}
-(void)handleReaderMaterialMaintainWork
{
    //处理读者资料维护
    ReaderMaterialMaintainViewController *readerMaintainController = [ReaderMaterialMaintainViewController getReaderMaterialMaintainViewController];
    [[self navigationController] pushViewController:readerMaintainController animated:YES];
}

-(void)didFinishedScan:(CodeCaptureViewController*)viewController withCode:(NSString*)code
{
    [[self navigationController] popViewControllerAnimated:NO];
    switch (_didSelectedItem) {
        case BorrowBook:
            [self handleBorrowBookWorkDelegateWithCode:code];
            break;
        case ReturnBook:
            [self handleReturnBookWorkDelegateWithCode:code];
        default:
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

@end
