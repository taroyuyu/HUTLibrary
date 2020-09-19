//
//  DataManager.h
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Manager;
@class Author;
@class BookDetail;
@class Reader;
@class Book;

@interface DataManager : NSObject
+(instancetype)sharedManager;
-(void)saveContext;

#pragma mark - 管理员
-(BOOL)createNewManagerWithName:(NSString*)name
                        account:(NSString*)account
                       password:(NSString*)password
                       andPhoto:(NSData*)photo;

-(Manager*)searchManagerWithAccount:(NSString*)account;

#pragma mark - 作者
-(BOOL)createNewAuthorWithName:(NSString*)name
                         photo:(NSData*)photo
                       country:(NSString*)country
                  andIntroduce:(NSString*)introduce;

-(Author*)searchAuthorWithName:(NSString*)name;
-(BOOL)refreshAuthorWithName:(NSString*)name
                         photo:(NSData*)photo
                       country:(NSString*)country
                  andIntroduce:(NSString*)introduce;
-(NSArray*)getAllAuthor;

#pragma mark - 读者
-(BOOL)createNewReaderWithName:(NSString*)name
                         photo:(NSData*)photo
                           sex:(BOOL)sex
                      readerID:(NSString*)readerID
                 readerCollege:(NSString*)readerCollege
                   readerClass:(NSString*)readerClass
                     readerTel:(NSString*)readerTel
        readerAllBorrowedCount:(NSInteger)readerAllBorrowedCount
          readerMaxBorrowCount:(NSInteger)readerMaxBorrowCount
       readerShouldReturnCount:(NSInteger)readerShouldReturnCount
               readerStartDate:(NSDate*)readerStartDate
                 readerEndDate:(NSDate*)readerEndDate
                readerPassword:(NSString*)readerPassword;

-(BOOL)refreshReaderWithName:(NSString*)name
                         photo:(NSData*)photo
                           sex:(BOOL)sex
                      readerID:(NSString*)readerID
                 readerCollege:(NSString*)readerCollege
                   readerClass:(NSString*)readerClass
                     readerTel:(NSString*)readerTel
        readerAllBorrowedCount:(NSInteger)readerAllBorrowedCount
          readerMaxBorrowCount:(NSInteger)readerMaxBorrowCount
       readerShouldReturnCount:(NSInteger)readerShouldReturnCount
               readerStartDate:(NSDate*)readerStartDate
                 readerEndDate:(NSDate*)readerEndDate
              readerPassword:(NSString*)readerPassword;

-(Reader*)searchReaderWithReaderID:(NSString*)readerID;
#pragma mark - 书籍分类
-(BOOL)createNewBookCatalogWithName:(NSString*)name
                          introduce:(NSString*)introduce;
-(BOOL)refreshBookCatalogWithName:(NSString*)name
                        introduce:(NSString*)introduce;
-(NSArray*)getAllBookCatalog;
#pragma mark - 书籍详情
-(BOOL)createNewBookWithName:(NSString*)name
                  authorName:(NSString*)authorName
                   bookPhoto:(NSData*)bookPhotoData
                 bookCatalog:(NSString*)bookCatalog
         publishOragnization:(NSString*)pulishOragnization
                bookDetailID:(NSString*)bookDetailID
                   introduce:(NSString*)introduce;
-(BookDetail*)searchBookDetailWithName:(NSString*)name;
-(BookDetail*)searchBookDetailWithBookDetailID:(NSString*)bookDetailID;
-(BOOL)refreshBookWithName:(NSString*)name
                  authorName:(NSString*)authorName
                   bookPhoto:(NSData*)bookPhotoData
                 bookCatalog:(NSString*)bookCatalog
         publishOragnization:(NSString*)pulishOragnization
              bookDetailID:(NSString*)bookDetailID
                   introduce:(NSString*)introduce;
-(NSArray*)getAllBook;

#pragma mark - 书籍
-(BOOL)createNewBookWithBookID:(NSString*)bookID bookDetail:(BookDetail*)bookDetail andStatus:(BOOL)status;
-(Book*)searchBookWithBookID:(NSString*)bookID;
#pragma mark - 借阅表
-(NSArray*)getReaderAllBorrowBooks:(NSString*)readerID;
-(BOOL)borrowBookWithBookID:(NSString*)bookID andReaderID:(NSString*)readerID;
-(BOOL)returnBookWithBookID:(NSString*)bookID;
#pragma mark - 搜索
-(NSArray*)searchWithKeyWord:(NSString*)keyWord;
@end
