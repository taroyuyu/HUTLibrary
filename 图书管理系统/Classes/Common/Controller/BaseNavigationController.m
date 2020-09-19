//
//  BaseNavigationController.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController


#pragma mark - UINavigationController与UITabBarController嵌套
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([[self viewControllers] count] == 1) {
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    
    [super pushViewController:viewController animated:animated];
}
- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if ([[self viewControllers] count] == 2) {
        [[[self tabBarController] tabBar] setHidden:NO];
    }
    return [super popViewControllerAnimated:animated];
}


@end
