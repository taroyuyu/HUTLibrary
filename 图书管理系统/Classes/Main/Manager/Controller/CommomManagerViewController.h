//
//  CommomManagerViewController.h
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum:NSUInteger{
    EditBookCatalog,
    EditBookDetail,
    EditAuthor
}ManagerType;

@interface CommomManagerViewController : UITableViewController
@property(nonatomic,assign)ManagerType managerType;
@end
