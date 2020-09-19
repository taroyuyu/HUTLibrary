//
//  BookDetail+CoreDataProperties.h
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BookDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookDetail (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *detailID;
@property (nullable, nonatomic, retain) NSString *bookName;
@property (nullable, nonatomic, retain) NSData *bookPhoto;
@property (nullable, nonatomic, retain) NSString *introduce;
@property (nullable, nonatomic, retain) NSString *publishOraganization;
@property (nullable, nonatomic, retain) NSString *bookCataogID;
@property (nullable, nonatomic, retain) Author *author;

@end

NS_ASSUME_NONNULL_END
