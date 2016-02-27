//
//  UserinformationSetingViewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "UserinformationSetingViewController.h"
#import <Masonry.h>
#import "UIColor+Expanded.h"

@implementation UserinformationSetingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initsubViews];

    [self initTitle];

    [_nameTextField becomeFirstResponder];
}

- (void)initNavgation
{
    self.view.backgroundColor = [UIColor colorWithRGBHex:0xfafafa];
    // 返回按钮
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(0, 0, 30, 30);
    [backbtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    //backbtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [backbtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneToChangeOperation)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}
// 返回前一页
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initTitle
{
    switch (_itemtype) {
        // 修改姓名
        case USERINFORMATION_NAME:{
            self.title = @"姓名修改";
            _nameTextField.placeholder = @"请输入姓名";
            break;
        }
        // 修改身份证
        case USERINFORMATION_IDCARD:{
            self.title = @"身份证号码修改";
            _nameTextField.placeholder = @"请输入身份证号码";
            break;
        }
        // 修改单位姓名
        case USERINFORMATION_WORKUNITNAME:{
            self.title = @"单位名称";
            _nameTextField.text = _cacheFlag;
            _nameTextField.placeholder = @"请输入单位名称";
            break;
        }
        // 修改单位地址
        case USERINFORMATION_WORKUNITADRESS:{
            self.title = @"单位地址";
            _nameTextField.placeholder = @"请输入单位地址";
            break;
        }
        // 修改单位联系人
        case USERINFORMATION_WORKUNITCONTACTS:{
            self.title = @"单位联系人";
            _nameTextField.placeholder = @"请输入单位联系人";
            break;
        }
        default:
            break;
    }
}

- (void)initsubViews
{
    UILabel *bglabel = [[UILabel alloc]init];
    bglabel.layer.borderWidth = 1;
    bglabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bglabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bglabel];
    [bglabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(80);
        make.left.equalTo(self.view).offset(-5);
        make.right.equalTo(self.view).offset(5);
        make.height.mas_equalTo(40);
    }];
    _nameTextField = [[UITextField alloc]init];
    [self.view addSubview:_nameTextField];
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bglabel).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    _nameTextField.text = _cacheFlag;
}

- (void)isUpdateInfoSucceed:(updateInfo)block
{
    _updateBlcok = block;
}
// 点击完成当前修改的操作
- (void)doneToChangeOperation
{
    if (_nameTextField.text.length == 0) {
        [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"您未填写信息" ActionTitle:@"明白了" ActionStyle:0];
        return;
    }
    switch (_itemtype) {
            // 修改姓名
        case USERINFORMATION_NAME:{
            // 封装需要修改的信息
            NSMutableDictionary *personinfo = [[NSMutableDictionary alloc]init];
            [personinfo setObject:gPersonInfo.mCustCode forKey:@"mCustCode"];
            [personinfo setObject:_nameTextField.text forKey:@"mCustName"];
            
            [[HttpNetworkManager getInstance]createOrUpdateUserinformationwithInfor:personinfo resultBlock:^(BOOL successed, NSError *error) {
                if (successed) {
                    gPersonInfo.mCustName = _nameTextField.text;
                    if (_updateBlcok) {
                        _updateBlcok(YES);
                    }
                }
                else{
                    [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"您的修改未成功，请检查网络后重试" ActionTitle:@"明白了" ActionStyle:0];
                }
            }];
            break;
        }
            // 修改身份证
        case USERINFORMATION_IDCARD:{
            BOOL isvalidate = [HCRule validateIDCardNumber:_nameTextField.text];
            // 身份证信息填写不成功
            if (!isvalidate) {
                [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"身份证信息填写错误，请检查后重试" ActionTitle:@"明白了" ActionStyle:0];
                return ;
            }
            NSMutableDictionary *personinfo = [[NSMutableDictionary alloc]init];
            [personinfo setObject:gPersonInfo.mCustCode forKey:@"mCustCode"];
            [personinfo setObject:_nameTextField.text forKey:@"CustId"];

            [[HttpNetworkManager getInstance]createOrUpdateUserinformationwithInfor:personinfo resultBlock:^(BOOL successed, NSError *error) {
                if (successed) {
                    gPersonInfo.CustId = _nameTextField.text;
                    if (_updateBlcok) {
                        _updateBlcok(YES);
                    }
                }
                else{
                    [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"您的修改未成功，请检查网络后重试" ActionTitle:@"明白了" ActionStyle:0];
                }
            }];
            break;
        }
            // 修改单位姓名
        case USERINFORMATION_WORKUNITNAME:{
            NSInteger type = GetUserType;     // 1个人，2单位
            if (type == 1) {    // 个人单位修改
                NSMutableDictionary *personinfo = [[NSMutableDictionary alloc]init];
                [personinfo setObject:gPersonInfo.mCustCode forKey:@"mCustCode"];
                [personinfo setObject:_nameTextField.text forKey:@"cUnitName"];

                [[HttpNetworkManager getInstance]createOrUpdateUserinformationwithInfor:personinfo resultBlock:^(BOOL successed, NSError *error) {
                    if (successed) {
                        gPersonInfo.cUnitName = _nameTextField.text;
                        if (_updateBlcok) {
                            _updateBlcok(YES);
                        }
                    }
                    else{
                        [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"您的修改未成功，请检查网络后重试" ActionTitle:@"明白了" ActionStyle:0];
                    }
                }];
            }
            else{   // 公司单位修改
                NSMutableDictionary *cUnitInfo = [[NSMutableDictionary alloc]init];
                [cUnitInfo setObject:gCompanyInfo.cUnitCode forKey:@"cUnitCode"];
                [cUnitInfo setObject:_nameTextField.text forKey:@"cUnitName"];

                [[HttpNetworkManager getInstance]createOrUpdateBRServiceInformationwithInfor:cUnitInfo resultBlock:^(BOOL successed, NSError *error) {
                    if (successed) {
                        gCompanyInfo.cUnitName = _nameTextField.text;
                        if (_updateBlcok) {
                            _updateBlcok(YES);
                        }
                    }
                    else{
                        [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"您的修改未成功，请检查网络后重试" ActionTitle:@"明白了" ActionStyle:0];
                    }
                }];
            }
            break;
        }
            // 修改单位地址
        case USERINFORMATION_WORKUNITADRESS:{
            NSMutableDictionary *cUnitInfo = [[NSMutableDictionary alloc]init];
            [cUnitInfo setObject:gCompanyInfo.cUnitCode forKey:@"cUnitCode"];
            [cUnitInfo setObject:_nameTextField.text forKey:@"cUnitAddr"];

            [[HttpNetworkManager getInstance]createOrUpdateBRServiceInformationwithInfor:cUnitInfo resultBlock:^(BOOL successed, NSError *error) {
                if (successed) {
                    gCompanyInfo.cUnitAddr = _nameTextField.text;
                    if (_updateBlcok) {
                        _updateBlcok(YES);
                    }
                }
                else{
                    [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"您的修改未成功，请检查网络后重试" ActionTitle:@"明白了" ActionStyle:0];
                }
            }];
            break;
        }
            // 修改单位联系人
        case USERINFORMATION_WORKUNITCONTACTS:{
            NSMutableDictionary *cUnitInfo = [[NSMutableDictionary alloc]init];
            [cUnitInfo setObject:gCompanyInfo.cUnitCode forKey:@"cUnitCode"];
            [cUnitInfo setObject:_nameTextField.text forKey:@"cLinkPeople"];

            [[HttpNetworkManager getInstance]createOrUpdateBRServiceInformationwithInfor:cUnitInfo resultBlock:^(BOOL successed, NSError *error) {
                if (successed) {
                    gCompanyInfo.cLinkPeople = _nameTextField.text;
                    if (_updateBlcok) {
                        _updateBlcok(YES);
                    }
                }
                else{
                    [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"您的修改未成功，请检查网络后重试" ActionTitle:@"明白了" ActionStyle:0];
                }
            }];
            break;
        }
        default:
            break;
    }
}

@end
