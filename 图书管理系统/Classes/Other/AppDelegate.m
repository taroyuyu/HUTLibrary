//
//  AppDelegate.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "AppDelegate.h"
#import "DataManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //判断是否是第一次启动，如果是，则创建默认账号
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstBoot"]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"false" forKey:@"isFirstBoot"];
        [[DataManager sharedManager] createNewManagerWithName:@"root" account:@"14408300117" password:@"aixocm" andPhoto:nil];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[DataManager sharedManager] saveContext];//保存数据
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[DataManager sharedManager] saveContext];//保存数据
}

@end
