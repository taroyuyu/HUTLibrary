//
//  Book+CoreDataProperties.h
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface Book (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *bookID;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) NSManagedObject *detail;

@end

NS_ASSUME_NONNULL_END
