//
//  BookMaterialMaintainViewController.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "BookMaterialMaintainViewController.h"
#import "CommomManagerViewController.h"
#import "ImportBookViewController.h"
#import "BookDetailViewController.h"
#import "BookCatalogViewController.h"
#import "AuthorViewController.h"
typedef enum:NSUInteger
{
    EditBookCatalogType,
    EditBookDetailType,
    EditAuthorType,
    ImportNewBookType = 10
}EditType;

@interface BookMaterialMaintainViewController ()<UISearchBarDelegate>
@property(nonatomic)UIBarButtonItem* addButton;
@end

@implementation BookMaterialMaintainViewController
+(instancetype)getBookMaterialMaintainViewController
{
    BookMaterialMaintainViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BookMaterialMaintainController"];
    return viewController;
}
-(UIBarButtonItem*)addButton
{
    if (self->_addButton != nil) {
        return self->_addButton;
    }
    self->_addButton = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonClicked)];
    return self->_addButton;
}
-(void)loadView
{
    [super loadView];
    [[self navigationItem]setRightBarButtonItem:[self addButton] animated:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)addButtonClicked
{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* addNewBook = [UIAlertAction actionWithTitle:@"书籍" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        BookDetailViewController *bookDetailViewController = [BookDetailViewController getBookDetailViewController];
        [bookDetailViewController setEditable:YES];
        [bookDetailViewController setTitle:@"添加书籍"];
        [[self navigationController] pushViewController:bookDetailViewController animated:YES];
    }];
    UIAlertAction *addNewCatalog = [UIAlertAction actionWithTitle:@"分类" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        BookCatalogViewController *bookCatalogViewController = [BookCatalogViewController getBookCatalogViewController];
        [bookCatalogViewController setEditable:YES];
        [bookCatalogViewController setTitle:@"添加书籍分类"];
        [[self navigationController] pushViewController:bookCatalogViewController animated:YES];
    }];
    UIAlertAction *addNewAuthor = [UIAlertAction actionWithTitle:@"作者" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        AuthorViewController *authorViewController = [AuthorViewController getAuthoViewController];
        [authorViewController setEditable:YES];
        [authorViewController setTitle:@"添加作者"];
        [[self navigationController] pushViewController:authorViewController animated:YES];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:addNewBook];
    [alertController addAction:addNewCatalog];
    [alertController addAction:addNewAuthor];
    [alertController addAction:cancleAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentSelected = [indexPath section] * 10 + [indexPath row];
    switch (currentSelected) {
        case EditBookCatalogType:{
            CommomManagerViewController *commomManagerController = [CommomManagerViewController new];
            [commomManagerController setManagerType:EditBookCatalog];
            [[self navigationController] pushViewController:commomManagerController animated:YES];
        }
            break;
        case EditBookDetailType:{
            CommomManagerViewController *commomManagerController = [CommomManagerViewController new];
            [commomManagerController setManagerType:EditBookDetail];
            [[self navigationController] pushViewController:commomManagerController animated:YES];
            
        }
            break;
        case EditAuthorType:{
            CommomManagerViewController *commomManagerController = [CommomManagerViewController new];
            [commomManagerController setManagerType:EditAuthor];
            [[self navigationController] pushViewController:commomManagerController animated:YES];
        }
            break;
        case ImportNewBookType:
        {
            ImportBookViewController *importBookController = [ImportBookViewController getImportBookViewController];
            [[self navigationController] pushViewController:importBookController animated:YES];
        }
        default:
            break;
    }
}
@end
