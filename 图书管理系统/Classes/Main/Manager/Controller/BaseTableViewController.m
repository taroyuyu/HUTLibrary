//
//  BaseTableViewController.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/19.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()
@property (nonatomic)UIToolbar *inputAccessoryView;
@end

@implementation BaseTableViewController
-(UIToolbar*)inputAccessoryView
{
    if (self->_inputAccessoryView != nil) {
        return self->_inputAccessoryView;
    }
    self->_inputAccessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(inputDone)];
    UIBarButtonItem *flexiButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self->_inputAccessoryView setItems:@[flexiButtonItem,doneItem] animated:YES];
    return self->_inputAccessoryView;
}
-(void)inputDone
{
    UIView   *firstResponder = [[[UIApplication sharedApplication] keyWindow] performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0)
{
    return [self editable];
}
@end
