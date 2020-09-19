//
//  BorrowBookCenterViewController.h
//  图书管理系统
//
//  Created by Lingyu on 15/12/17.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BorrowBookCenterViewController : UITableViewController
@property(nonatomic)Reader *readerModel;
+(instancetype)getBorrowBookCenterViewController;
@end
