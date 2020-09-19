//
//  CodeCaptureViewController.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/12.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "CodeCaptureViewController.h"

#import "LBXScanView.h"
#import "LBXScanWrapper.h"
#import "LBXAlertAction.h"

@interface CodeCaptureViewController ()

/**
 @brief  扫码功能封装对象
 */
@property (nonatomic,strong) LBXScanWrapper* scanObj;

/**
 @brief  扫码区域视图,二维码一般都是框
 */
@property (nonatomic,strong) LBXScanView *scanView;

/**
 @brief  扫码当前图片
 */
@property(nonatomic,strong)UIImage* scanImage;


/**
 *  界面效果参数
 */
@property (nonatomic, strong) LBXScanViewStyle *style;


/**
 @brief  启动区域识别功能
 */
@property(nonatomic,assign)BOOL isOpenInterestRect;


/**
 @brief  扫码区域上方提示文字
 */
@property (nonatomic, strong) UILabel *topTitle;

/**
 @brief  闪关灯开启状态
 */
@property(nonatomic,assign)BOOL isOpenFlash;


#pragma mark - 底部几个功能：开启闪光灯、相册、我的二维码
//底部显示的功能项
@property (nonatomic, strong) UIView *bottomItemsView;

//闪光灯
@property (nonatomic, strong) UIButton *btnFlash;

@end





@implementation CodeCaptureViewController


-(LBXScanViewStyle*)style
{
    if (self->_style!=nil) {
        return self->_style;
    }
    //设置扫码区域参数
    self->_style= [[LBXScanViewStyle alloc]init];
    self->_style.centerUpOffset = 44;
    self->_style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    self->_style.photoframeLineW = 6;
    self->_style.photoframeAngleW = 24;
    self->_style.photoframeAngleH = 24;
    
    self->_style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    self->_style.animationImage = imgLine;
    
    return self->_style;
}

-(UILabel*)topTitle
{
    if (self->_topTitle!=nil) {
        return self->_topTitle;
    }
    self->_topTitle = [[UILabel alloc]initWithFrame:CGRectMake(80, 80, 160, 60)];
    [self->_topTitle setTextAlignment:NSTextAlignmentCenter];
    [self->_topTitle setText:@"将取景框对准二维码"];
    [self->_topTitle setTextColor:[UIColor whiteColor]];
    return self->_topTitle;
    
}

-(LBXScanView*)scanView
{
    if (self->_scanView!=nil) {
        return self->_scanView;
    }
    self->_scanView = [[LBXScanView alloc]initWithFrame:[[self view] bounds] style:self.style];
    return self->_scanView;
}

-(UIButton*)btnFlash
{
    if (self->_btnFlash!=nil) {
        return self->_btnFlash;
    }
    self->_btnFlash = [[UIButton alloc] initWithFrame:CGRectMake(127.5, CGRectGetMaxY(self.view.frame)-164, 65, 87)];
    [self->_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    return self->_btnFlash;
    
}

-(void)loadView
{
    [super loadView];
    
    [self.view addSubview:[self scanView]];
    [self.view addSubview:[self topTitle]];
    [self.view addSubview:[self btnFlash]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;//当视图控制器的容器为UINavigationController或者UITabBarController时，视图的范围不向四周扩展。
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [[self btnFlash] addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //启动相机
    [_scanView startDeviceReadyingWithText:@"相机启动中"];
    
    [self performSelector:@selector(startScan) withObject:nil afterDelay:0.2];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    
    //停止扫描
    [_scanObj stopScan];
    [_scanView stopScanAnimation];
}

//启动设备
- (void)startScan
{
    //判断是否得到用户的授权
    if ( ![LBXScanWrapper isGetCameraPermission] )
    {
        [_scanView stopDeviceReadying];
        
        [self showError:@"   请到设置隐私中开启本程序相机权限   "];
        return;
    }
    
    
    
    if (!_scanObj )
    {
        __weak __typeof(self) weakSelf = self;
        // AVMetadataObjectTypeQRCode   AVMetadataObjectTypeEAN13Code
        
        CGRect cropRect = CGRectZero;
        
        if (_isOpenInterestRect) {
            
            cropRect = [LBXScanView getScanRectWithPreView:self.view style:self.style];
        }
        
        self.scanObj = [[LBXScanWrapper alloc]initWithPreView:self.view
                                              ArrayObjectType:nil
                                                     cropRect:cropRect
                                                      success:^(NSArray<LBXScanResult *> *array){
                                                          [weakSelf scanResultWithArray:array];
                                                      }];
        
    }
    
    [_scanObj startScan];
    
    
    [_scanView stopDeviceReadying];
    
    [_scanView startScanAnimation];
    
    self.view.backgroundColor = [UIColor clearColor];
}






- (void)showError:(NSString*)str
{
    [LBXAlertAction showAlertWithTitle:@"提示" msg:str chooseBlock:nil buttonsStatement:@"知道了",nil];
}


- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //震动提醒
    [LBXScanWrapper systemVibrate];
    //声音提醒
    [LBXScanWrapper systemSound];
    
    
    //[self popAlertMsgWithScanResult:strResult];
    
    [self showNextVCWithScanResult:scanResult];
    
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    
    __weak __typeof(self) weakSelf = self;
    [LBXAlertAction showAlertWithTitle:@"扫码内容" msg:strResult chooseBlock:^(NSInteger buttonIdx) {
        
        //点击完，继续扫码
        [weakSelf.scanObj startScan];
    } buttonsStatement:@"知道了",nil];
}

#pragma mark - 扫码结果
- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    [[self delegate] didFinishedScan:self withCode:strResult.strScanned];
    
}


#pragma mark -底部功能项


//开关闪光灯
- (void)openOrCloseFlash
{
    [_scanObj openOrCloseFlash];
    
    self.isOpenFlash =!self.isOpenFlash;
    
    if (self.isOpenFlash)
    {
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    }
    else
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
}


#pragma mark --打开相册并识别图片
+ (UIViewController*)getWindowTopViewController
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
