//
//  SearchViewController.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/18.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "SearchViewController.h"
#import "BookDetailViewController.h"
#import "BookCatalogViewController.h"
#import "AuthorViewController.h"
typedef enum:NSInteger
{
    BookDetailType,
    BookCatalogType,
    BookAuthorType
}SearchResultType;

@interface SearchViewController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic)NSArray* dataModels;
@end

@implementation SearchViewController
+(instancetype)getSearchViewController
{
    
    SearchViewController *searchViewController  = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"searchViewController"];
    return searchViewController;
}

-(void)viewDidLoad
{
    [[self searchBar] setDelegate:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self dataModels] count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self dataModels] objectAtIndex:section] count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case BookDetailType:
            return @"书籍";
        case BookCatalogType:
            return @"书籍分类";
        default:
            return @"作者";
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *bookDetailCellID = @"bookDetailCellID";
    static NSString *bookCatalogCellID = @"bookCatalogCellID";
    static NSString *bookAuthorCellID = @"bookAuthorCellID";
    UITableViewCell *cell;
    switch ([indexPath section]) {
        case BookDetailType:{
            cell = [tableView dequeueReusableCellWithIdentifier:bookDetailCellID forIndexPath:indexPath];
            UIImageView *bookPhoto = [cell viewWithTag:1];
            UILabel *bookName = [cell viewWithTag:2];
            BookDetail *dataModel = [[[self dataModels] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
            [bookPhoto setImage:[UIImage imageWithData:[dataModel bookPhoto]]];
            [bookName setText:[dataModel bookName]];
        }
            break;
        case BookCatalogType:{
            cell = [tableView dequeueReusableCellWithIdentifier:bookCatalogCellID forIndexPath:indexPath];
            UILabel *bookCatalogName = [cell viewWithTag:1];
            BookCatalog *dataModel = [[[self dataModels] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
            [bookCatalogName setText:[dataModel name]];
        }
            break;
        default:{
            cell = [tableView dequeueReusableCellWithIdentifier:bookAuthorCellID forIndexPath:indexPath];
            UIImageView *authorPhoto = [cell viewWithTag:1];
            UILabel *authorName = [cell viewWithTag:2];
            Author *dataModel = [[[self dataModels] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
            [authorPhoto setImage:[UIImage imageWithData:[dataModel photo]]];
            [authorName setText:[dataModel name]];
        }
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case BookDetailType:
        {
            BookDetailViewController *bookDetailViewController = [BookDetailViewController getBookDetailViewController];
            [bookDetailViewController setModel:[[[self dataModels] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]]];
            [[self navigationController] pushViewController:bookDetailViewController animated:YES];
        }
            break;
        case BookCatalogType:
        {
            BookCatalogViewController *bookCatalogViewController = [BookCatalogViewController getBookCatalogViewController];
            [bookCatalogViewController setModel:[[[self dataModels] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]]];
            [[self navigationController] pushViewController:bookCatalogViewController animated:YES];
        }
            break;
        default:
        {
            AuthorViewController *bookAuthorViewController = [AuthorViewController getAuthoViewController];            [bookAuthorViewController setModel:[[[self dataModels] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]]];
            [[self navigationController] pushViewController:bookAuthorViewController animated:YES];
            
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case BookDetailType:
            return 80;
        case BookCatalogType:
            return 44;
        default:
            return 80;
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@",searchText);
    self->_dataModels = [[DataManager sharedManager] searchWithKeyWord:searchText];
    [[self tableView] reloadData];
}
@end
