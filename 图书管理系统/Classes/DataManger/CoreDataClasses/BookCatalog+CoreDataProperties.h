//
//  BookCatalog+CoreDataProperties.h
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BookCatalog.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookCatalog (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *catalogID;
@property (nullable, nonatomic, retain) NSString *introduce;
@property (nullable, nonatomic, retain) NSManagedObject *bookDetail;

@end

NS_ASSUME_NONNULL_END
