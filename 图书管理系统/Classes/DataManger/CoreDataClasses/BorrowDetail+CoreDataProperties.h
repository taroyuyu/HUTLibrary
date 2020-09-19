//
//  BorrowDetail+CoreDataProperties.h
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BorrowDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface BorrowDetail (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *readerID;
@property (nullable, nonatomic, retain) NSString *managerID;
@property (nullable, nonatomic, retain) NSString *bookID;
@property (nullable, nonatomic, retain) NSDate *borrowedDate;
@property (nullable, nonatomic, retain) NSDate *endDate;

@end

NS_ASSUME_NONNULL_END
