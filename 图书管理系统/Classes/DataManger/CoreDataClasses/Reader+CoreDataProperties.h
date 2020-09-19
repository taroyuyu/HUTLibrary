//
//  Reader+CoreDataProperties.h
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Reader.h"

NS_ASSUME_NONNULL_BEGIN

@interface Reader (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *readerID;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *college;
@property (nullable, nonatomic, retain) NSString *currentClass;
@property (nullable, nonatomic, retain) NSNumber *sex;
@property (nullable, nonatomic, retain) NSString *telePhone;
@property (nullable, nonatomic, retain) NSDate *startDate;
@property (nullable, nonatomic, retain) NSDate *endDate;
@property (nullable, nonatomic, retain) NSData *photo;
@property (nullable, nonatomic, retain) NSNumber *borrowedCount;
@property (nullable, nonatomic, retain) NSNumber *shouldReturnCount;
@property (nullable, nonatomic, retain) NSNumber *maxBorrowCount;

@end

NS_ASSUME_NONNULL_END
