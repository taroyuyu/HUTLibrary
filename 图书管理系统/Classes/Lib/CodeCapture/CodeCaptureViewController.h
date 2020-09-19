//
//  CodeCaptureViewController.h
//  图书管理系统
//
//  Created by Lingyu on 15/12/12.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CodeCaptureViewController;

@protocol CodeCaptureViewControllerDelegate <NSObject>
-(void)didFinishedScan:(CodeCaptureViewController*)viewController withCode:(NSString*)code;
@end

@interface CodeCaptureViewController : UIViewController
@property(nonatomic) UIViewController<CodeCaptureViewControllerDelegate>* delegate;
@end

