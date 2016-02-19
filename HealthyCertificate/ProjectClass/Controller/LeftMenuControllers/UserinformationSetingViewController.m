//
//  UserinformationSetingViewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "UserinformationSetingViewController.h"
#import <Masonry.h>

@implementation UserinformationSetingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initsubViews];

    [self initTitle];
}

- (void)initNavgation
{
    self.view.backgroundColor = [UIColor whiteColor];
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
    bglabel.layer.borderWidth = 2;
    bglabel.layer.borderColor = [UIColor grayColor].CGColor;
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
}

// 点击完成当前修改的操作
- (void)doneToChangeOperation
{
    switch (_itemtype) {
            // 修改姓名
        case USERINFORMATION_NAME:{
            break;
        }
            // 修改身份证
        case USERINFORMATION_IDCARD:{
            break;
        }
            // 修改单位姓名
        case USERINFORMATION_WORKUNITNAME:{
            break;
        }
            // 修改单位地址
        case USERINFORMATION_WORKUNITADRESS:{

            break;
        }
            // 修改单位联系人
        case USERINFORMATION_WORKUNITCONTACTS:{

            break;
        }
        default:
            break;
    }
}

@end
