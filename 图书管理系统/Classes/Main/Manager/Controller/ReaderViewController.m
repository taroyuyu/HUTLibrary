//
//  addNewReaderViewController.m
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import "ReaderViewController.h"

@interface ReaderViewController ()<UITextFieldDelegate,CodeCaptureViewControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *readerPhoto;
@property (weak, nonatomic) IBOutlet UITextField *readerName;
@property (weak, nonatomic) IBOutlet UITextField *readerSex;
@property (weak, nonatomic) IBOutlet UITextField *readerID;
@property (weak, nonatomic) IBOutlet UITextField *readerCollege;
@property (weak, nonatomic) IBOutlet UITextField *readerClass;
@property (weak, nonatomic) IBOutlet UITextField *readerTel;
@property (weak, nonatomic) IBOutlet UITextField *readerAllBorrowedCount;
@property (weak, nonatomic) IBOutlet UITextField *readerMaxBorrowCount;
@property (weak, nonatomic) IBOutlet UITextField *readerShouldResturnCount;
@property (weak, nonatomic) IBOutlet UITextField *readerStartDate;
@property (weak, nonatomic) IBOutlet UITextField *readerEndDate;
@property (weak, nonatomic) IBOutlet UITextField *readerPassword;
@property (nonatomic)UIBarButtonItem* doneBarButton;
@property (nonatomic)UIPickerView *readerSexInputView;
@property (nonatomic)UIDatePicker *datePicker;
@end

@implementation ReaderViewController

+(instancetype)getReaderViewController
{
    ReaderViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"readerViewController"];
    return viewController;
}
-(UIPickerView*)readerSexInputView
{
    if (self->_readerSexInputView != nil) {
        return self->_readerSexInputView;
    }
    self->_readerSexInputView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [self->_readerSexInputView setDataSource:self];
    [self->_readerSexInputView setDelegate:self];
    return self->_readerSexInputView;
}
-(UIDatePicker*)datePicker
{
    if (self->_datePicker != nil) {
        return self->_datePicker;
    }
    self->_datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [self->_datePicker setDatePickerMode:UIDatePickerModeDate];
    return self->_datePicker;
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
    NSData *readerPhoto = UIImagePNGRepresentation([[self readerPhoto] image]);
    NSString *readerName = [[self readerName]text];
    BOOL readerSex = [[[self readerSex] text] isEqualToString:@"男"];
    NSString *readerID = [[self readerID]text];
    NSString *readerCollege = [[self readerCollege]text];
    NSString *readerClass = [[self readerClass]text];
    NSString *readerTel = [[self readerTel]text];
    NSString *readerAllBorrowedCount = [[self readerAllBorrowedCount]text];
    NSString *readerMaxBorrowCount = [[self readerMaxBorrowCount]text];
    NSString *readerShouldReturnCount = [[self readerShouldResturnCount]text];
    NSDate *startDate  = [NSString convertDateFromString:[[self readerStartDate] text]];
    NSDate *endDate = [NSString convertDateFromString:[[self readerEndDate] text]];
    NSString *readerPassword = [[self readerPassword] text];
    //判断信息是否完整
    if (readerPhoto==nil||[readerName isEqualToString:@""]||[readerID isEqualToString:@""]||[readerCollege isEqualToString:@""]||[readerClass isEqualToString:@""]||[readerTel isEqualToString:@""]||[readerAllBorrowedCount isEqualToString:@""]||[readerMaxBorrowCount isEqualToString:@""]||[readerShouldReturnCount isEqualToString:@""]||startDate==nil||endDate==nil||[readerPassword isEqualToString:@""]) {
        [self showMessage:@"信息不完整"];
        return;
    }
    
    
    if (self->_model!=nil) {//对读者资料进行更新
        BOOL result = [[DataManager sharedManager] refreshReaderWithName:readerName photo:readerPhoto sex:readerSex readerID:readerID readerCollege:readerCollege readerClass:readerClass readerTel:readerTel readerAllBorrowedCount:[readerAllBorrowedCount integerValue] readerMaxBorrowCount:[readerMaxBorrowCount integerValue] readerShouldReturnCount:[readerShouldReturnCount integerValue] readerStartDate:startDate readerEndDate:endDate readerPassword:readerPassword];
        if (result) {
            [self showMessage:@"更新成功"];
        }else{
            [self showMessage:@"更新失败"];
        }
        
    }else{//创建新的读者用户
        BOOL result = [[DataManager sharedManager] createNewReaderWithName:readerName photo:readerPhoto sex:readerSex readerID:readerID readerCollege:readerCollege readerClass:readerClass readerTel:readerTel readerAllBorrowedCount:[readerAllBorrowedCount integerValue] readerMaxBorrowCount:[readerMaxBorrowCount integerValue] readerShouldReturnCount:[readerShouldReturnCount integerValue] readerStartDate:startDate readerEndDate:endDate readerPassword:readerPassword];
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
    [[self readerID]setDelegate:self];
    [[self readerSex] setInputView:[self readerSexInputView]];
    [[self readerStartDate] setInputView:[self datePicker]];
    [[self readerEndDate] setInputView:[self datePicker]];
    [self setControlEditable];
}

-(void)loadData
{
    if (self->_model!=nil) {
        [[self readerPhoto] setImage:[UIImage imageWithData:[self->_model photo]]];
        [[self readerName] setText:[self->_model name]];
        NSString * sex = [[self->_model sex] intValue]==1?@"男":@"女";
        [[self readerSex] setText:sex];
        [[self readerID] setText:[self->_model readerID]];
        [[self readerCollege] setText:[self->_model college]];
        [[self readerClass] setText:[self->_model currentClass]];
        [[self readerTel] setText:[self->_model telePhone]];
        [[self readerAllBorrowedCount] setText:[NSString stringWithFormat:@"%@",[self->_model borrowedCount]]];
        [[self readerMaxBorrowCount] setText:[NSString stringWithFormat:@"%@",[self->_model maxBorrowCount]]];
        [[self readerShouldResturnCount] setText:[NSString stringWithFormat:@"%@",[self->_model shouldReturnCount]]];
        [[self readerStartDate] setText:[NSString stringFromDate:[self->_model startDate]]];
        [[self readerEndDate] setText:[NSString stringFromDate:[self->_model endDate]]];
        [[self readerPassword] setText:[self->_model password]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section]==0&&[indexPath row]==0) {
        [self editUserPhoto];
    }
}
-(void)editUserPhoto
{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction* photoAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImageViewControllerWithType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }];
    
    UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImageViewControllerWithType:UIImagePickerControllerSourceTypeCamera];
    }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:photoAction];
    [alertController addAction:cancleAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)showImageViewControllerWithType:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController* imagePicker = [UIImagePickerController new];
    [imagePicker setDelegate:self];
    [imagePicker setAllowsEditing:YES];
    [imagePicker setSourceType:type];
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    [[self readerPhoto] setImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)showMessage:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==[self readerID]) {
        CodeCaptureViewController *readerIDCaptureController = [CodeCaptureViewController new];
        [readerIDCaptureController setDelegate:self];
        [[self navigationController] pushViewController:readerIDCaptureController animated:YES];
    }
    return NO;
}

-(void)didFinishedScan:(CodeCaptureViewController*)viewController withCode:(NSString*)code
{
    [[self readerID] setText:code];
    [[self tableView] resignFirstResponder];
    [[self navigationController] popViewControllerAnimated:YES];
    
}

-(void)inputDone
{
    UIView   *firstResponder = [[[UIApplication sharedApplication] keyWindow] performSelector:@selector(firstResponder)];
    if (firstResponder==[self readerStartDate]) {
        [[self readerStartDate] setText:[NSString stringFromDate:[[self datePicker] date]]];
    }
    if (firstResponder == [self readerEndDate]) {
        [[self readerStartDate] setText:[NSString stringFromDate:[[self datePicker] date]]];        
    }
    [firstResponder resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED
{
    if (row==YES) {
        return @"男";
    }else{
        return @"女";
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED
{
    if (row==YES) {
        [[self readerSex] setText:@"男"];
    }else
    {
        [[self readerSex] setText:@"女"];
    }
}
-(void)setControlEditable
{
    if ([self editable]==NO) {
        [[self readerPhoto] setUserInteractionEnabled:NO];
        [[self readerName] setUserInteractionEnabled:NO];
        [[self readerSex]setUserInteractionEnabled:NO];
        [[self readerID]setUserInteractionEnabled:NO];
        [[self readerCollege] setUserInteractionEnabled:NO];
        [[self readerClass] setUserInteractionEnabled:NO];
        [[self readerTel]setUserInteractionEnabled:NO];
        [[self readerAllBorrowedCount]setUserInteractionEnabled:NO];
        [[self readerMaxBorrowCount] setUserInteractionEnabled:NO];
        [[self readerShouldResturnCount] setUserInteractionEnabled:NO];
        [[self readerStartDate]setUserInteractionEnabled:NO];
        [[self readerEndDate]setUserInteractionEnabled:NO];
        [[self readerPassword]setUserInteractionEnabled:NO];
    }
}
@end
