//
//  AddWorkerVController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/25.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "AddWorkerVController.h"
#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UIColor+Expanded.h"
#import <Masonry.h>
#import "WorkManagerTBC.h"
#import "Constants.h"
#import "AddWorkerTBC.h"
#import "RzAlertView.h"
#import "Customer.h"
#import "HCRule.h"
#import "NSString+Count.h"
#import "NSString+Custom.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface AddWorkerVController()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UIBarButtonItem *_rightBarItem;

    UITableView *_tableView;

    UITextField  *_nameTextField;
    UIButton     *_sexBtn;
    UILabel      *_ageLabel;
    UITextField  *_idCardTextField;
    UITextField  *_phoneNoTextField;
    UILabel      *_callingLabel;
    UILabel      *_unitLabel;

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

    _rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"身份证号码识别" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.rightBarButtonItem = _rightBarItem;
}
// 返回前一页
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData
{
    AddworkerTBCItem *name = [[AddworkerTBCItem alloc]initWithTitle:@"姓        名" Message:nil type:ADDWORKER_NAME];
    AddworkerTBCItem *sex = [[AddworkerTBCItem alloc]initWithTitle:@"性        别" Message:nil type:ADDWORKER_SEX];
    AddworkerTBCItem *age = [[AddworkerTBCItem alloc]initWithTitle:@"年        龄" Message:nil type:ADDWORKER_AGE];
    AddworkerTBCItem *idcard = [[AddworkerTBCItem alloc]initWithTitle:@"身份证号" Message:nil type:ADDWORKER_IDCARD];
    AddworkerTBCItem *tel = [[AddworkerTBCItem alloc]initWithTitle:@"联系电话" Message:nil type:ADDWORKER_TELPHONE];
    NSString *call = gCompanyInfo.cUnitType.length == 0 ? @"暂无" : gCompanyInfo.cUnitType;
    AddworkerTBCItem *calling = [[AddworkerTBCItem alloc]initWithTitle:@"行        业" Message:call type:ADDWORKER_CALLING];
    AddworkerTBCItem *unit = [[AddworkerTBCItem alloc]initWithTitle:@"工作单位" Message:gCompanyInfo.cUnitName type:ADDWORKER_UNIT];

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
            cell.textField.placeholder = @"输入身份证号后自动计算";
        case ADDWORKER_CALLING:
        case ADDWORKER_UNIT:
        case ADDWORKER_SEX:
            cell.textField.enabled = NO;
            break;
        default:
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
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(30, 20, 0, 20));
    }];
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.layer.cornerRadius = 4;
    [confirmBtn setTitle:@"确 认" forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue]];
    [confirmBtn addTarget:self action:@selector(confrimBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return view;
}

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
                _customer.sex = [item.message isEqualToString:@"男"]? '0' : '1';
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
}

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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.text = [textField.text deleteSpaceWithHeadAndFootWithString:textField.text];
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
@end
