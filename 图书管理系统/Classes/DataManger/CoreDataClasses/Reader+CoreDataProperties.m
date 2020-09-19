//
//  Reader+CoreDataProperties.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Reader+CoreDataProperties.h"

@implementation Reader (CoreDataProperties)

@dynamic readerID;
@dynamic password;
@dynamic name;
@dynamic college;
@dynamic currentClass;
@dynamic sex;
@dynamic telePhone;
@dynamic startDate;
@dynamic endDate;
@dynamic photo;
@dynamic borrowedCount;
@dynamic shouldReturnCount;
@dynamic maxBorrowCount;

@end
