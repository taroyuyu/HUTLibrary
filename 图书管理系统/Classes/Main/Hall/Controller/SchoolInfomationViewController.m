//
//  SchoolIntroduceController.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/18.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "SchoolInfomationViewController.h"

@interface SchoolInfomationViewController () <UIWebViewDelegate>
@property (nonatomic,readonly)UIWebView *webView;
@property (nonatomic,assign)BOOL nextPageIsFirstPage;
@end

@implementation SchoolInfomationViewController
+(instancetype)getSchoolInfomationViewController
{
    SchoolInfomationViewController *schoolInfomationViewController = [SchoolInfomationViewController new];
    return schoolInfomationViewController;
}
-(UIWebView*)webView
{
    return [self view];
}
-(void)loadView
{
    [self setView:[UIWebView new]];
}
-(void)viewDidLoad
{
    [[self webView] setDelegate:self];
    [self loadFirstView];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"大厅" style:UIBarButtonItemStylePlain target:self action:@selector(backPreviousViewController)];
    [[self navigationItem] setLeftBarButtonItem:leftBarButton];
}
-(void)loadFirstView
{
    [self setNextPageIsFirstPage:YES];
    [[self webView] loadRequest:_dataRequest];
}
-(void)backPreviousViewController
{
    [[self navigationController] popToRootViewControllerAnimated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([self nextPageIsFirstPage]) {
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"大厅" style:UIBarButtonItemStylePlain target:self action:@selector(backPreviousViewController)];
        [[self navigationItem] setLeftBarButtonItem:leftBarButton animated:YES];
        [self setNextPageIsFirstPage:NO];
    }else{
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(loadFirstView)];
        [[self navigationItem] setLeftBarButtonItem:leftBarButton animated:YES];
    }
}

@end
