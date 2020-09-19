//
//  CommomManagerViewController.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "CommomManagerViewController.h"
#import "BookCatalogViewController.h"
#import "AuthorViewController.h"
#import "BookDetailViewController.h"

@interface CommomManagerViewController ()
@property(nonatomic)NSArray* models;
@end

@implementation CommomManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadData];
}
-(void)loadData
{
    
    switch (self->_managerType) {
        case EditBookCatalog:
            [self setModels:[[DataManager sharedManager] getAllBookCatalog]];
            break;
        case EditBookDetail:
            [self setModels:[[DataManager sharedManager] getAllBook]];
            break;
        case EditAuthor:
            [self setModels:[[DataManager sharedManager] getAllAuthor]];
            break;
        default:
            break;
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self models] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* bookCatalogID = @"bookCatalogID";
    static NSString* authorID = @"authorID";
    static NSString* bookID = @"bookID";
    UITableViewCell *cell;
    switch (self->_managerType) {
        case EditBookCatalog:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:bookCatalogID];;
            if (cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bookCatalogID];
            }
            
            BookCatalog *model = [[self models] objectAtIndex:[indexPath row]];
            [cell setText:[model name]];
        }
            break;
        case EditBookDetail:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:bookID];;
            if (cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bookID];
            }
            BookDetail *model = [[self models] objectAtIndex:[indexPath row]];
            [cell setText:[model bookName]];
        }
            break;
        case EditAuthor:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:authorID];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:authorID];
            }
            Author *model = [[self models] objectAtIndex:[indexPath row]];
            [cell setText:[model name]];
        }
            break;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self->_managerType) {
        case EditBookCatalog:
        {
            BookCatalog *model = [[self models] objectAtIndex:[indexPath row]];
            BookCatalogViewController *editBookCatalogViewController = [BookCatalogViewController getBookCatalogViewController];
            [editBookCatalogViewController setEditable:YES];
            [editBookCatalogViewController setTitle:@"编辑"];
            [editBookCatalogViewController setModel:model];
            [[self navigationController] pushViewController:editBookCatalogViewController animated:YES];
        }
            break;
            
        case EditBookDetail:
        {
            BookDetail *model = [[self models] objectAtIndex:[indexPath row]];
            BookDetailViewController *editBookDetailViewController = [BookDetailViewController getBookDetailViewController];
            [editBookDetailViewController setEditable:YES];
            [editBookDetailViewController setTitle:@"编辑"];
            [editBookDetailViewController setModel:model];
            [[self navigationController] pushViewController:editBookDetailViewController animated:YES];
        }
            break;
        case EditAuthor:
        {
            Author *model = [[self models] objectAtIndex:[indexPath row]];
            AuthorViewController *editAuthorViewController = [AuthorViewController getAuthoViewController];
            [editAuthorViewController setTitle:@"编辑"];
            [editAuthorViewController setEditable:YES];
            [editAuthorViewController setModel:model];
            [[self navigationController] pushViewController:editAuthorViewController animated:YES];
        }
            break;
    }
    
}
@end
