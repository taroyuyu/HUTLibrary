//
//  BorrowBookCenterViewController.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/17.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "BorrowBookCenterViewController.h"

@interface BorrowBookCenterViewController ()<CodeCaptureViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *paneView;
@property (weak, nonatomic) IBOutlet UIImageView *readerPhoto;
@property (weak, nonatomic) IBOutlet UITextField *readerName;
@property (weak, nonatomic) IBOutlet UITextField *readerClass;
@property (weak, nonatomic) IBOutlet UITextField *readerID;
@property (weak, nonatomic) IBOutlet UITextField *readerCurrentBorrowed;
@property (weak, nonatomic) IBOutlet UITextField *readerAllBorrowedCount;
@property (weak, nonatomic) IBOutlet UITextField *readerLeftBorrowCount;
@property (nonatomic)NSArray *readerBorrowBooks;
@property (nonatomic)UIBarButtonItem *borrowButton;
@end

typedef enum:NSInteger
{
    BookPhotoType = 1,
    BookNameType = 2
}BookCellSubviewType;

@implementation BorrowBookCenterViewController

+(instancetype)getBorrowBookCenterViewController;
{
    BorrowBookCenterViewController *borrowBookCenterViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BorrowBookCenterViewController"];
    return borrowBookCenterViewController;
}
-(UIBarButtonItem*)borrowButton
{
    if (self->_borrowButton!=nil) {
        return self->_borrowButton;
    }
    self->_borrowButton = [[UIBarButtonItem alloc] initWithTitle:@"借书" style:UIBarButtonItemStylePlain target:self action:@selector(borrowButtonClicked)];
    return self->_borrowButton;
}
-(void)loadView
{
    [super loadView];
    [[self navigationItem] setRightBarButtonItem:[self borrowButton]];
}
-(void)borrowButtonClicked
{
    CodeCaptureViewController *bookIDCaptureController = [CodeCaptureViewController new];
    [bookIDCaptureController setDelegate:self];
    [[self navigationController] pushViewController: bookIDCaptureController animated:YES];
}
-(void)viewDidLoad
{
    [[self paneView] setContentSize:CGSizeMake(320, 400)];
    [self loadData];
}
-(void)loadData
{
    [[self readerPhoto] setImage:[UIImage imageWithData:[[self readerModel] photo]]];
    [[self readerName] setText:[[self readerModel] name]];
    [[self readerClass] setText:[[self readerModel] currentClass]];
    [[self readerID] setText:[[self readerModel] readerID]];
    [[self readerCurrentBorrowed] setText:[NSString stringWithFormat:@"%@",[[self readerModel] shouldReturnCount]]];
    [[self readerAllBorrowedCount] setText:[NSString stringWithFormat:@"%@",[[self readerModel] borrowedCount]]];
    [[self readerLeftBorrowCount] setText:[NSString stringWithFormat:@"%ld",[[[self readerModel] maxBorrowCount] integerValue] - [[[self readerModel] shouldReturnCount]integerValue]]];
    [self setReaderBorrowBooks:[[DataManager sharedManager] getReaderAllBorrowBooks:[[self readerModel] readerID]]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [[self readerBorrowBooks] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Book *bookModel = [[self readerBorrowBooks] objectAtIndex:[indexPath row]];
    BookDetail *detailModel = [bookModel detail];
    UITableViewCell *bookCell = [tableView dequeueReusableCellWithIdentifier:@"bookCell" forIndexPath:indexPath];
    UIImageView *bookPhoto = [bookCell viewWithTag:BookPhotoType];
    [bookPhoto setImage:[UIImage imageWithData:[detailModel bookPhoto]]];
    UILabel *bookName = [bookPhoto viewWithTag:BookNameType];
    [bookName setText:[detailModel bookName]];
    return bookCell;
}

-(void)didFinishedScan:(CodeCaptureViewController*)viewController withCode:(NSString*)code
{
    [[self navigationController] popViewControllerAnimated:NO];
    BOOL result = [[DataManager sharedManager] borrowBookWithBookID:code andReaderID:[[self readerModel] readerID]];
    if (result) {
        [self showMessage:@"借书成功"];
    }else{
        [self showMessage:@"借书失败"];
    }
    
}
-(void)showMessage:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        [[self navigationController] popViewControllerAnimated:YES];
    }];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
