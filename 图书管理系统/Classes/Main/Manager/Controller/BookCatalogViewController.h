//
//  addNewBookCatalogViewController.h
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface BookCatalogViewController : BaseTableViewController
@property(nonatomic)BookCatalog *model;
+(instancetype)getBookCatalogViewController;
@end
