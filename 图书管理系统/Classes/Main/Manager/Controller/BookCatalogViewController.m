//
//  addNewBookCatalogViewController.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "BookCatalogViewController.h"

@interface BookCatalogViewController ()
@property (weak, nonatomic) IBOutlet UITextField *catalogName;
@property (weak, nonatomic) IBOutlet UITextView *introduce;
@property (nonatomic)UIBarButtonItem* doneBarButton;
@end

@implementation BookCatalogViewController

+(instancetype)getBookCatalogViewController
{
    BookCatalogViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"bookCatalogViewController"];
    return viewController;
}
-(UIBarButtonItem*)doneBarButton
{
    if (self->_doneBarButton!=nil) {
        return self->_doneBarButton;
    }
    self->_doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonClicked)];
    return self->_doneBarButton;
}
-(void)loadView
{
    [super loadView];
    if ([self editable]) {
        [[self navigationItem] setRightBarButtonItem:[self doneBarButton]];
    }
}
-(void)doneButtonClicked
{
    //获取信息
    NSString *bookCatalogName = [[self catalogName]text];
    NSString *bookIntroduce = [[self introduce]text];
     //判断信息是否完整
    if ([bookCatalogName isEqualToString:@""]||[bookIntroduce isEqualToString:@""]) {
        [self showMessage:@"书籍分类信息不完整"];
        return;
    }
    if (self->_model != nil) {
        //NSLog(@"开始更新书籍分类信息");
        BOOL result = [[DataManager sharedManager] refreshBookCatalogWithName:[self->_model name] introduce:bookIntroduce];
        if (result) {
            [self showMessage:@"更新成功"];
        }else{
            [self showMessage:@"更新失败"];
        }
    }else{
       // NSLog(@"开始保存书籍分类信息");
        BOOL result = [[DataManager sharedManager]createNewBookCatalogWithName:bookCatalogName introduce:bookIntroduce];
        if (result) {
            [self showMessage:@"添加成功"];
        }else{
            [self showMessage:@"添加失败"];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setControlEditable];
}

-(void)loadData
{
    if (self->_model!=nil) {
        [[self catalogName] setText:[self->_model name]];
        [[self catalogName] setEnabled:NO];
        [[self introduce] setText:[self->_model introduce]];
    }
}

-(void)showMessage:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)setControlEditable
{
    if ([self editable]==NO) {
        [[self catalogName] setUserInteractionEnabled:NO];
        [[self introduce] setUserInteractionEnabled:NO];
    }
}
@end
