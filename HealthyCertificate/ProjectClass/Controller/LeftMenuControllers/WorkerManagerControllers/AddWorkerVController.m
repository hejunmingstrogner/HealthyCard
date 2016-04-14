//
//  AddWorkerVController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/25.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "AddWorkerVController.h"

#import <Masonry.h>
#import <MJExtension.h>

#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UIColor+Expanded.h"
#import "NSString+Count.h"
#import "NSString+Custom.h"

#import "HttpNetworkManager.h"
#import "HCRule.h"
#import "YMIDCardRecognition.h"
#import "HCNavigationBackButton.h"
#import "RzAlertView.h"
#import "HCRule.h"
#import "Constants.h"

#import "WorkManagerTBC.h"
#import "AddWorkerTBC.h"
#import "Customer.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface AddWorkerVController()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, YMIDCardRecognitionDelegate>
{
    UITableView *_tableView;

    NSMutableArray *_customArray;
    Customer *_customer;
}
@end

@implementation AddWorkerVController
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initData];

    [self initSubviews];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification  object:nil];
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-rect.size.height);
    }];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
}


- (void)initNavgation
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"员工管理";
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    
    HCNavigationBackButton* idCardScanBtn = [[HCNavigationBackButton alloc] initWithText:@"识别"];
    [idCardScanBtn addTarget:self action:@selector(idCardScanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:idCardScanBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - Action
// 返回前一页
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - view initializations
- (void)initData
{
    AddworkerTBCItem *name = [[AddworkerTBCItem alloc]initWithTitle:@"姓        名" Message:nil type:ADDWORKER_NAME];
    AddworkerTBCItem *sex = [[AddworkerTBCItem alloc]initWithTitle:@"性        别" Message:nil type:ADDWORKER_SEX];
    AddworkerTBCItem *age = [[AddworkerTBCItem alloc]initWithTitle:@"年        龄" Message:nil type:ADDWORKER_AGE];
    AddworkerTBCItem *idcard = [[AddworkerTBCItem alloc]initWithTitle:@"身份证号" Message:nil type:ADDWORKER_IDCARD];
    AddworkerTBCItem *tel = [[AddworkerTBCItem alloc]initWithTitle:@"联系电话" Message:nil type:ADDWORKER_TELPHONE];
    NSString *call = gUnitInfo.unitType.length == 0 ? @"暂无" : gUnitInfo.unitType;
    AddworkerTBCItem *calling = [[AddworkerTBCItem alloc]initWithTitle:@"行        业" Message:call type:ADDWORKER_CALLING];
    AddworkerTBCItem *unit = [[AddworkerTBCItem alloc]initWithTitle:@"工作单位" Message:gUnitInfo.unitName type:ADDWORKER_UNIT];

    _customArray = [NSMutableArray arrayWithObjects:name, sex, age, idcard, tel, calling, unit, nil];
    _customer = [[Customer alloc]init];
}
- (void)initSubviews
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _customArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddWorkerTBC *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AddWorkerTBC alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell.textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
        cell.textField.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.delegate = self;
    }
    cell.textLabel.text = ((AddworkerTBCItem *)_customArray[indexPath.row]).title;
    cell.textField.text = ((AddworkerTBCItem *)_customArray[indexPath.row]).message;
    cell.textField.tag = indexPath.row;
    cell.textField.placeholder = @"";
    switch (((AddworkerTBCItem *)_customArray[indexPath.row]).type) {
        case ADDWORKER_AGE:
            cell.textField.placeholder = @"当输入身份证号后自动计算";
            cell.textField.enabled = NO;
            break;
        case ADDWORKER_CALLING:
        case ADDWORKER_UNIT:
            cell.textField.placeholder = @"";
            cell.textField.enabled = NO;
            break;
        case ADDWORKER_SEX:
            cell.textField.placeholder = @"请点击选择性别";
            cell.textField.enabled = NO;
            break;
        case ADDWORKER_NAME:
            cell.textField.placeholder = @"请点击输入姓名";
            cell.textField.enabled = YES;
            break;
        case ADDWORKER_IDCARD:
            cell.textField.placeholder = @"请点击输入身份证号码";
            cell.textField.enabled = YES;
            break;
        case ADDWORKER_TELPHONE:
            cell.textField.placeholder = @"请点击输入手机号码";
            cell.textField.enabled = YES;
            break;
        default:
            cell.textField.placeholder = @"";
            cell.textField.enabled = YES;
            break;
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).with.offset(10);
        make.right.equalTo(view).with.offset(-10);
        make.height.mas_equalTo(40);
     //   make.edges.equalTo(view).insets(UIEdgeInsetsMake(30, 20, 0, 20));
    }];
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.layer.cornerRadius = 4;
    [confirmBtn setTitle:@"确 认" forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue]];
    [confirmBtn addTarget:self action:@selector(confrimBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return view;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (((AddworkerTBCItem *)_customArray[indexPath.row]).type == ADDWORKER_SEX) {
        [RzAlertView showAlertViewControllerWithTarget:self Title:@"请选择性别" Message:nil preferredStyle:UIAlertControllerStyleActionSheet ActionTitlesArray:@[@"男", @"女"] handle:^(NSInteger flag) {
            NSString *sex;
            if (flag == 1) {
                sex = @"男";
            }
            else if(flag == 2){
                sex = @"女";
            }
            else{
                return ;
            }
            
            AddWorkerTBC *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textField.text = sex;
            
            ((AddworkerTBCItem *)_customArray[indexPath.row]).message = sex;
        }];
    }
}


#pragma mark - UITextFieldDelegate
- (void)textFieldValueChanged:(UITextField *)textField
{
    NSInteger _textLength;
    switch (((AddworkerTBCItem *)_customArray[textField.tag]).type) {
        case ADDWORKER_NAME:// 姓名
        case ADDWORKER_SEX: // 性别
        case ADDWORKER_AGE:{
            // 年龄
            _textLength = 20;
            break;
        }
        case ADDWORKER_IDCARD:{
            // 身份证号码
            _textLength = 18;
            break;
        }
        case ADDWORKER_TELPHONE:{
            // 电话号码
            _textLength = 11;
            break;
        }
        case ADDWORKER_CALLING: // 行业
        case ADDWORKER_UNIT:{
            // 单位
            _textLength = 40;
            break;
        }
        default:
            _textLength = 20;
            break;
    }


    NSString *toBeString = textField.text;
    // 键盘输入模式
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > _textLength) {
                textField.text = [toBeString substringToIndex:_textLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{

        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > _textLength) {
            textField.text = [toBeString substringToIndex:_textLength];
        }
    }

    ((AddworkerTBCItem *)_customArray[textField.tag]).message = textField.text;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.text = [textField.text deleteSpaceWithHeadAndFootWithString];
    if (textField.text.length == 0) {
        return;
    }
    if (((AddworkerTBCItem *)_customArray[textField.tag]).type == ADDWORKER_IDCARD) {
        // 身份证验证不合法
        if(![HCRule validateIDCardNumber:textField.text]){
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"您的身份证信息输入错误" removeDelay:2];
            [textField becomeFirstResponder];
            return;
        }
        // 计算年龄
        NSString * age = [NSString getOldYears:textField.text];
        AddWorkerTBC *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag-1 inSection:0]];
        cell.textField.text = age;
        ((AddworkerTBCItem *)_customArray[textField.tag - 1]).message = age;
    }
}

#pragma mark - Button Action
- (void)confrimBtnClicked:(UIButton *)sender
{
    for (AddworkerTBCItem *item in _customArray) {
        if ([item.message isEqualToString:@""] || item.message == nil) {
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"您还有信息未填完整" removeDelay:2];
            return;
        }
        switch (item.type) {
            case ADDWORKER_NAME:{
                // 姓名
                _customer.custName = item.message;
                break;
            }
            case ADDWORKER_SEX:{
                // 性别
                _customer.sex = [item.message isEqualToString:@"男"]? 0 : 1;
                break;
            }
            case ADDWORKER_AGE:{
                // 年龄
                break;
            }
            case ADDWORKER_IDCARD:{
                // 身份证号码
                if(![HCRule validateIDCardNumber:item.message]){
                    [RzAlertView showAlertLabelWithTarget:self.view Message:@"您的身份证信息输入错误" removeDelay:2];
                    return;
                }
                _customer.idCard = item.message;
                break;
            }
            case ADDWORKER_TELPHONE:{
                if (item.message.length != 11) {
                    [RzAlertView showAlertLabelWithTarget:self.view Message:@"您的手机号码输入错误" removeDelay:2];
                    return;
                }
                // 电话号码
                _customer.linkPhone = item.message;
                break;
            }
            case ADDWORKER_CALLING:{
                // 行业
                if ([item.message isEqualToString:@"暂无"]) {
                    [RzAlertView showAlertLabelWithTarget:self.view Message:@"您的行业未知，暂不能添加" removeDelay:2];
                    return;
                }
                _customer.custType = item.message;
                break;
            }
            case ADDWORKER_UNIT:{
                // 单位
                _customer.unitName = item.message;
                break;
            }
            default:
                break;
        }
    }
    _customer.unitCode = gUnitInfo.unitCode;
    NSDictionary *customerDict = _customer.mj_keyValues;
    __weak typeof (self) weakself = self;
    [[HttpNetworkManager getInstance]createOrUpdateUserinformationwithInfor:customerDict resultBlock:^(BOOL successed, NSError *error) {
        if (successed) {
            [weakself creatSuccess];
        }
        else{
            [weakself creatFail];
        }
    }];
}

-(void)idCardScanBtnClicked:(UIButton*)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.videoQuality=UIImagePickerControllerQualityTypeLow;
        imagePicker.delegate = self;
        imagePicker.showsCameraControls = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"开启摄像头权限后，才能使用该功能" removeDelay:2];
    }
}


#pragma mark - UIImagePickerControllerDelegate & YMIDCardRecognitionDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    __weak typeof (self) wself = self;
    UIImage *originImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [wself reSizeImage:originImage toSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
        CGImageRef imRef = [image CGImage];
        UIImageOrientation orientation = [image imageOrientation];
        NSInteger texWidth = CGImageGetWidth(imRef);
        NSInteger texHeight = CGImageGetHeight(imRef);
        float imageScale = 1;
        if(orientation == UIImageOrientationUp && texWidth < texHeight)
            image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationLeft];
        else if((orientation == UIImageOrientationUp && texWidth > texHeight) || orientation == UIImageOrientationRight)
            image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationUp];
        else if(orientation == UIImageOrientationDown)
            image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationDown];
        else if(orientation == UIImageOrientationLeft)
            image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationUp];
        dispatch_async(dispatch_get_main_queue(), ^{
            [picker dismissViewControllerAnimated:YES completion:nil];

            [RzAlertView ShowWaitAlertWithTitle:@"身份证信息解析中"];

            [YMIDCardRecognition recongnitionWithCard:image delegate:wself];
        });
    });
}

- (void)recongnition:(YMIDCardRecognition *)YMIDCardRecognition didFailWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [RzAlertView CloseWaitAlert];
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"身份信息解析失败，请重试" removeDelay:3];
    });
    NSLog(@"身份证解析失败：%@", error.domain);
}
- (void)recongnition:(YMIDCardRecognition *)YMIDCardRecognition didRecognitionResult:(NSArray *)array
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [RzAlertView CloseWaitAlert];
        
        if (array[1] == nil || [HCRule validateIDCardNumber:array[1]] == NO){
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"扫描身份证信息失败，请注意聚焦" removeDelay:3];
            return;
        }
    
        // 计算年龄
        NSString * age = [NSString getOldYears:array[1]];
        // 将信息填充到数据中。
        for (int i = 0; i<_customArray.count; i++) {
            switch (((AddworkerTBCItem *)_customArray[i]).type) {
                case ADDWORKER_NAME:{   // 姓名
                    ((AddworkerTBCItem *)_customArray[i]).message = array[0];
                    break;
                }
                case ADDWORKER_SEX:{    // 性别
                    ((AddworkerTBCItem *)_customArray[i]).message = array[2];
                    break;
                }
                case ADDWORKER_IDCARD:{ // 身份证号码
                    ((AddworkerTBCItem *)_customArray[i]).message = array[1];
                    break;
                }
                case ADDWORKER_AGE:{    // 年龄
                    ((AddworkerTBCItem *)_customArray[i]).message = age;
                    break;
                }
                default:
                    break;
            }
        }
        [_tableView reloadData];
    });
}

- (BOOL)getCancelProcess
{
    return NO;
}

- (void)setCancelProcess:(BOOL)isCance
{
    //self.isProgressCanceled = isCance;
}



#pragma mark - Http Response
- (void)creatSuccess
{
    if ([_delegate respondsToSelector:@selector(creatWorkerSucceed)] && _delegate) {
        [_delegate creatWorkerSucceed];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatFail
{
    [RzAlertView showAlertLabelWithTarget:self.view Message:@"添加失败，请检查网络后重试" removeDelay:2];
}

#pragma mark - Private Methods
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}


@end
