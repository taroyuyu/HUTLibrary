//
//  HallViewController.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/18.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "HallViewController.h"
#import "SchoolInfomationViewController.h"
#import "SearchViewController.h"
typedef enum:NSInteger
{
    SchoolIntroduceItem,
    SchoolNewsItem,
    SchoolNotificationItem
}ItemType;

@interface HallViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *pictureScrollView;
@property (nonatomic)UIBarButtonItem *searchButton;
@end
@implementation HallViewController
-(UIBarButtonItem*)searchButton
{
    if (self->_searchButton!=nil) {
        return self->_searchButton;
    }
    self->_searchButton = [[UIBarButtonItem alloc] initWithTitle:@"查找" style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonClicked)];
    return self->_searchButton;
}
-(void)loadView
{
    [super loadView];
    [[self navigationItem] setRightBarButtonItem:[self searchButton]];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SchoolInfomationViewController *schoolInfomationViewController = [SchoolInfomationViewController getSchoolInfomationViewController];
    NSURL *dataURL;
    NSURLRequest *dataRequest;
    switch ([indexPath section]) {
        case SchoolIntroduceItem:
        {
            
            dataURL = [NSURL URLWithString:@"http://www.17wanxiao.com/campus/campus/schoolinfo/info.action?type=1&customerId=786&token=49379bfa-0c27-445f-bbca-31ae58d98247&versioncode=3.0.6&systemType=IOS&UAinfo=wanxiao"];
            [schoolInfomationViewController setTitle:@"学校介绍"];
        }
            break;
        case SchoolNewsItem:
        {
            dataURL = [NSURL URLWithString:@"http://www.17wanxiao.com/campus/campus/schoolinfo/list.action?type=2&customerId=786&token=49379bfa-0c27-445f-bbca-31ae58d98247&versioncode=3.0.6&systemType=IOS&UAinfo=wanxiao"];
            [schoolInfomationViewController setTitle:@"学校新闻"];
            
        }
            break;
        case SchoolNotificationItem:
        {
            dataURL = [NSURL URLWithString:@"http://www.17wanxiao.com/campus/campus/schoolinfo/list.action?type=3&customerId=786&token=49379bfa-0c27-445f-bbca-31ae58d98247&versioncode=3.0.6&systemType=IOS&UAinfo=wanxiao"];
            [schoolInfomationViewController setTitle:@"学校通知"];
            
        }
            break;
        default:
            break;
    }
    dataRequest = [NSURLRequest requestWithURL:dataURL];
    [schoolInfomationViewController setDataRequest:dataRequest];
    [[self navigationController] pushViewController:schoolInfomationViewController animated:YES];
}

-(void)searchButtonClicked
{
    SearchViewController *searchViewController = [SearchViewController getSearchViewController];
    [[self navigationController] pushViewController:searchViewController animated:YES];
}
@end
