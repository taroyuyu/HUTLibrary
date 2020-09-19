//
//  DataManager.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "DataManager.h"
#import <CoreData/CoreData.h>

@interface DataManager ()
@property (nonatomic,readonly) NSManagedObjectContext *context;
@property (nonatomic,readonly) NSManagedObjectModel *userModel;
@property (nonatomic,readonly) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic,readonly) NSPersistentStore *store;
@end

@implementation DataManager
static NSString *storeDataFile = @"dataStore.sqlite";
static DataManager *sigleTon;
+(instancetype)sharedManager
{
    if (sigleTon==nil) {
        sigleTon = [self new];
        [sigleTon loadDataBase];
    }
    return sigleTon;
}
-(void)saveContext
{
    if ([self->_context hasChanges]) {
        [self->_context save:nil];
    }
}

-(void)loadDataBase
{
    
    //第一步创建托管对象模型
    self->_userModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    //第二步创建数据存储区协调器
    self->_coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self->_userModel];
    //第三步创建数据存储区
    self->_store = [self->_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self dataStoreURL] options:nil error:nil];
    
    //第四步初始化托管对象上下文
    self->_context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [self->_context setPersistentStoreCoordinator:self->_coordinator];
}

-(NSURL*)dataStoreURL
{
    
    NSURL *storeDirectore = [[NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]]  URLByAppendingPathComponent:@"Stores"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeDirectore path]]) {
        [[NSFileManager defaultManager] createDirectoryAtURL:storeDirectore withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    storeDirectore = [storeDirectore URLByAppendingPathComponent:storeDataFile];
    return storeDirectore;
}

#pragma mark - 管理员
-(Manager*)searchManagerWithAccount:(NSString*)account
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Manager"];
    //设置筛选条件
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"managerID = %@",account];
    [request setPredicate:filter];
    
    NSArray *allManager = [self->_context executeFetchRequest:request error:nil];
    
    return [allManager lastObject];
}

-(BOOL)createNewManagerWithName:(NSString*)name account:(NSString*)account password:(NSString*)password andPhoto:(NSData*)photo
{
    if ([self searchManagerWithAccount:account]!=nil) {
        //存在该管理员
        return NO;
    }
    
    Manager *newManager = [NSEntityDescription insertNewObjectForEntityForName:@"Manager" inManagedObjectContext:self->_context];
    [newManager setName:name];
    [newManager setManagerID:account];
    [newManager setPassword:password];
    [newManager setPhoto:photo];
    [self saveContext];
    return YES;
}
#pragma mark - 读者
-(Reader*)searchReaderWithReaderID:(NSString*)readerID
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reader"];
    //设置筛选条件
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"readerID = %@",readerID];
    [request setPredicate:filter];
    
    NSArray *allManager = [self->_context executeFetchRequest:request error:nil];
    
    return [allManager lastObject];
}

-(BOOL)createNewReaderWithName:(NSString *)name photo:(NSData *)photo sex:(BOOL)sex readerID:(NSString *)readerID readerCollege:(NSString *)readerCollege readerClass:(NSString *)readerClass readerTel:(NSString *)readerTel readerAllBorrowedCount:(NSInteger)readerAllBorrowedCount readerMaxBorrowCount:(NSInteger)readerMaxBorrowCount readerShouldReturnCount:(NSInteger)readerShouldReturnCount readerStartDate:(NSDate *)readerStartDate readerEndDate:(NSDate *)readerEndDate readerPassword:(NSString *)readerPassword{
    if ([self searchReaderWithReaderID:readerID]!=nil) {
        //存在该管理员
        return NO;
    }
    Reader *newReader = [NSEntityDescription insertNewObjectForEntityForName:@"Reader" inManagedObjectContext:self->_context];
    [newReader setName:name];
    [newReader setPhoto:photo];
    [newReader setSex:sex?@1:@0];
    [newReader setReaderID:readerID];
    [newReader setCollege:readerCollege];
    [newReader setCurrentClass:readerClass];
    [newReader setTelePhone:readerTel];
    [newReader setBorrowedCount:[NSNumber numberWithInteger:readerAllBorrowedCount]];
    [newReader setMaxBorrowCount:[NSNumber numberWithInteger:readerMaxBorrowCount]];
    [newReader setShouldReturnCount:[NSNumber numberWithInteger:readerShouldReturnCount]];
    [newReader setStartDate:readerStartDate];
    [newReader setEndDate:readerEndDate];
    [newReader setPassword:readerPassword];
    [self saveContext];
    return YES;
    
}
-(BOOL)refreshReaderWithName:(NSString *)name photo:(NSData *)photo sex:(BOOL)sex readerID:(NSString *)readerID readerCollege:(NSString *)readerCollege readerClass:(NSString *)readerClass readerTel:(NSString *)readerTel readerAllBorrowedCount:(NSInteger)readerAllBorrowedCount readerMaxBorrowCount:(NSInteger)readerMaxBorrowCount readerShouldReturnCount:(NSInteger)readerShouldReturnCount readerStartDate:(NSDate *)readerStartDate readerEndDate:(NSDate *)readerEndDate readerPassword:(NSString *)readerPassword
{
    Reader *reader = [self searchReaderWithReaderID:readerID];
    if (reader==nil) {
        return NO;
    }
    [reader setName:name];
    [reader setPhoto:photo];
    [reader setSex:sex?@1:@0];
    [reader setReaderID:readerID];
    [reader setCollege:readerCollege];
    [reader setCurrentClass:readerClass];
    [reader setTelePhone:readerTel];
    [reader setBorrowedCount:[NSNumber numberWithInteger:readerAllBorrowedCount]];
    [reader setMaxBorrowCount:[NSNumber numberWithInteger:readerMaxBorrowCount]];
    [reader setShouldReturnCount:[NSNumber numberWithInteger:readerShouldReturnCount]];
    [reader setStartDate:readerStartDate];
    [reader setEndDate:readerEndDate];
    [reader setPassword:readerPassword];
    
    [self saveContext];
    return YES;

}
#pragma mark - 作者

-(BOOL)createNewAuthorWithName:(NSString *)name photo:(NSData *)photo country:(NSString *)country andIntroduce:(NSString *)introduce
{
    if ([self searchAuthorWithName:name]!=nil) {
        return NO;
    }
    Author *newAuthor = [NSEntityDescription insertNewObjectForEntityForName:@"Author" inManagedObjectContext:self->_context];
    [newAuthor setName:name];
    [newAuthor setPhoto:photo];
    [newAuthor setContry:country];
    [newAuthor setIntroduce:introduce];
    [self saveContext];
    
    return YES;
}
-(Author*)searchAuthorWithName:(NSString*)name
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Author"];
    //设置筛选条件
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"name = %@",name];
    [request setPredicate:filter];
    
    NSArray *allManager = [self->_context executeFetchRequest:request error:nil];
    
    return [allManager lastObject];
}
-(NSArray*)searchAuthorWithKeyWord:(NSString*)keyWord
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Author"];
    //设置筛选条件
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"name CONTAINS %@",keyWord];
    [request setPredicate:filter];
    
    NSArray *allManager = [self->_context executeFetchRequest:request error:nil];
    return allManager;
}

-(BOOL)refreshAuthorWithName:(NSString *)name photo:(NSData *)photo country:(NSString *)country andIntroduce:(NSString *)introduce
{
    
    Author *author = [self searchAuthorWithName:name];
    if (author==nil) {
        return NO;
    }
    [author setName:name];
    [author setPhoto:photo];
    [author setContry:country];
    [author setIntroduce:introduce];
    [self saveContext];
    return YES;
}

-(NSArray*)getAllAuthor
{
  //  NSLog(@"%s",__func__);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Author"];
    NSArray *allAuhor = [self->_context executeFetchRequest:request error:nil];
    return allAuhor;
}

#pragma mark - 书籍分类

-(BOOL)createNewBookCatalogWithName:(NSString *)name introduce:(NSString *)introduce
{
    if ([self searchBookCatalogWithName:name]!=nil) {
        return NO;
    }
    BookCatalog *newCatalog = [NSEntityDescription insertNewObjectForEntityForName:@"BookCatalog" inManagedObjectContext:self->_context];
    [newCatalog setName:name];
    [newCatalog setIntroduce:introduce];
    
    [self saveContext];
    
    return YES;

}

-(BOOL)refreshBookCatalogWithName:(NSString *)name introduce:(NSString *)introduce
{
    BookCatalog *bookCatalog = [self searchBookCatalogWithName:name];
    if (bookCatalog==nil) {
        return NO;
    }
    [bookCatalog setIntroduce:introduce];
    [self saveContext];
    return YES;
}

-(BookCatalog*)searchBookCatalogWithName:(NSString*)name
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BookCatalog"];
    //设置筛选条件
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"name = %@",name];
    [request setPredicate:filter];
    
    NSArray *allManager = [self->_context executeFetchRequest:request error:nil];
    return [allManager lastObject];
}
-(NSArray*)searchBookCatalogWithKeyWord:(NSString*)keyWord
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BookCatalog"];
    //设置筛选条件
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"name CONTAINS %@",keyWord];
    [request setPredicate:filter];
    
    NSArray *allManager = [self->_context executeFetchRequest:request error:nil];
    return allManager;
}
-(NSArray*)getAllBookCatalog
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BookCatalog"];
    NSArray *allModel = [self->_context executeFetchRequest:request error:nil];
    return allModel;
}

#pragma mark - 书籍详情
-(BOOL)createNewBookWithName:(NSString *)name authorName:(NSString *)authorName bookPhoto:(NSData *)bookPhotoData bookCatalog:(NSString *)bookCatalog publishOragnization:(NSString *)pulishOragnization bookDetailID:(NSString *)bookDetailID introduce:(NSString *)introduce
{
    if ([self searchBookDetailWithName:name]!=nil) {
        return NO;
    }
    if ([self searchBookDetailWithBookDetailID:bookDetailID]!=nil) {
        return NO;
    }
    BookDetail *newBookDetail = [NSEntityDescription insertNewObjectForEntityForName:@"BookDetail" inManagedObjectContext:self->_context];
    [newBookDetail setBookName:name];
    [self createNewAuthorWithName:name photo:nil country:nil andIntroduce:nil];
    Author *author = [self searchAuthorWithName:name];
    [newBookDetail setAuthor:author];
    [newBookDetail setBookPhoto:bookPhotoData];
    [self createNewBookCatalogWithName:bookCatalog introduce:nil];
    [newBookDetail setBookCataogID:bookCatalog];
    [newBookDetail setPublishOraganization:pulishOragnization];
    [newBookDetail setDetailID:bookDetailID];
    [newBookDetail setIntroduce:introduce];
    [self saveContext];
    return YES;
}
-(NSArray*)searchBookDetailWithKeyWord:(NSString*)keyWord
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BookDetail"];
    //设置筛选条件
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"bookName CONTAINS %@",keyWord];
    [request setPredicate:filter];
    
    NSArray *allManager = [self->_context executeFetchRequest:request error:nil];
    return allManager;
}
-(BookDetail*)searchBookDetailWithBookDetailID:(NSString*)bookDetailID
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BookDetail"];
    //设置筛选条件
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"detailID = %@",bookDetailID];
    [request setPredicate:filter];
    
    NSArray *allManager = [self->_context executeFetchRequest:request error:nil];
    return [allManager lastObject];
}

-(BookDetail*)searchBookDetailWithName:(NSString *)name
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BookDetail"];
    //设置筛选条件
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"bookName = %@",name];
    [request setPredicate:filter];
    
    NSArray *allManager = [self->_context executeFetchRequest:request error:nil];
    return [allManager lastObject];
}
-(BOOL)refreshBookWithName:(NSString*)name
                authorName:(NSString*)authorName
                 bookPhoto:(NSData*)bookPhotoData
               bookCatalog:(NSString*)bookCatalog
       publishOragnization:(NSString*)pulishOragnization
              bookDetailID:(NSString*)bookDetailID
                 introduce:(NSString*)introduce;
{
    BookDetail *bookDetail = [self searchBookDetailWithBookDetailID:bookDetailID];
    if (bookDetail==nil) {
        return NO;
    }
    [self createNewAuthorWithName:name photo:nil country:nil andIntroduce:nil];
    Author *author = [self searchAuthorWithName:name];
    [bookDetail setAuthor:author];
    [bookDetail setBookPhoto:bookPhotoData];
    [self createNewBookCatalogWithName:bookCatalog introduce:nil];
    [bookDetail setBookCataogID:bookCatalog];
    [bookDetail setPublishOraganization:pulishOragnization];
    [bookDetail setIntroduce:introduce];
    [self saveContext];
    return YES;
}
-(NSArray*)getAllBook
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BookDetail"];
    NSArray *allModel = [self->_context executeFetchRequest:request error:nil];
    return allModel;
}

#pragma mark - 书籍
-(Book*)searchBookWithBookID:(NSString*)bookID;
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
    //设置筛选条件
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"bookID = %@",bookID];
    [request setPredicate:filter];
    
    NSArray *allManager = [self->_context executeFetchRequest:request error:nil];
    return [allManager lastObject];
}
-(BOOL)createNewBookWithBookID:(NSString*)bookID bookDetail:(BookDetail*)bookDetail andStatus:(BOOL)status;
{
    if ([self searchBookWithBookID:bookID]!=nil) {
    return NO;
    }
    Book *newBook = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self->_context];
    [newBook setBookID:bookID];
    [newBook setDetail:bookDetail];
    [newBook setStatus:status?@1:@0];
    [self saveContext];
    return YES;

}
#pragma mark - 借阅表
-(NSArray*)getReaderAllBorrowBooks:(NSString *)readerID
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BorrowDetail"];
    //设置筛选条件
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"readerID = %@",readerID];
    [request setPredicate:filter];
    NSArray *allBorrowDetail = [self->_context executeFetchRequest:request error:nil];
    NSMutableArray *allBorrowedBook;
    for (BorrowDetail *item in allBorrowDetail) {
        Book *borrowedBook = [self searchBookWithBookID:[item bookID]];
        [allBorrowedBook addObject:borrowedBook];
    }
    return allBorrowedBook;

}
-(BorrowDetail*)searchBorrowDetailWithBookID:(NSString*)bookID
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BorrowDetail"];
    //设置筛选条件
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"bookID = %@",bookID];
    [request setPredicate:filter];
    
    NSArray *allManager = [self->_context executeFetchRequest:request error:nil];
    return [allManager lastObject];
}
-(BOOL)borrowBookWithBookID:(NSString *)bookID andReaderID:(NSString *)readerID
{
    Book *book = [self searchBookWithBookID:bookID];
    if (book==nil) {
        NSLog(@"%s 没有这本书",__func__);
        return NO;
    }
    Reader *reader = [self searchReaderWithReaderID:readerID];
    if (reader==nil) {
        NSLog(@"%s 没有这个读者",__func__);
        return NO;
    }
    BorrowDetail *borrowDetail = [self searchBorrowDetailWithBookID:bookID];
    if (borrowDetail!=nil) {
        return NO;
    }
    if ([[book status] integerValue]==NO) {
        return NO;
    }
    BorrowDetail *newBorrowDetail = [NSEntityDescription insertNewObjectForEntityForName:@"BorrowDetail" inManagedObjectContext:self->_context];
    [newBorrowDetail setReaderID:[reader readerID]];
    [newBorrowDetail setBookID:[book bookID]];
    [newBorrowDetail setBorrowedDate:[NSDate new]];
    [book setStatus:[NSNumber numberWithBool:NO]];
    [self saveContext];
    return YES;
}
-(BOOL)returnBookWithBookID:(NSString *)bookID
{   Book *book = [self searchBookWithBookID:bookID];
    if (book==nil) {
        NSLog(@"%s 没有这本书",__func__);
        return NO;
    }
    BorrowDetail *brrowDetail = [self searchBorrowDetailWithBookID:bookID];
    if (brrowDetail==nil) {
        NSLog(@"%s 借阅表中没有这本书的记录",__func__);
        return NO;
    }
    [self->_context deleteObject:brrowDetail];
    [book setStatus:[NSNumber numberWithBool:YES]];
    [self saveContext];
    return YES;
}

#pragma mark - 搜索
-(NSArray*)searchWithKeyWord:(NSString*)keyWord
{
    NSArray* bookDetailSearchResultArray;
    NSArray* bookCatalogSearchResultArray = @[];
    NSArray* bookAuthorSearchResultArray = @[];
    bookDetailSearchResultArray = [self searchBookDetailWithKeyWord:keyWord];
    bookCatalogSearchResultArray = [self searchBookCatalogWithKeyWord:keyWord];
    bookAuthorSearchResultArray = [self searchAuthorWithKeyWord:keyWord];
    NSArray *resultArray = @[bookDetailSearchResultArray,bookCatalogSearchResultArray,bookAuthorSearchResultArray];
    return resultArray;
}
@end
