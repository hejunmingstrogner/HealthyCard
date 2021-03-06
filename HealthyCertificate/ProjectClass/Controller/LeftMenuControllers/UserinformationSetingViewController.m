//
//  UserinformationSetingViewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "UserinformationSetingViewController.h"
#import <Masonry.h>
#import <MJExtension.h>

#import "Constants.h"

#import "UIColor+Expanded.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UIFont+Custom.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)


@implementation UserinformationSetingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initsubViews];

    [self initTitle];

    [_nameTextField becomeFirstResponder];

    // 限制文本输入长度
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_nameTextField];
}

#pragma mark -限制文本输入长度
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:_nameTextField];
}
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;

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
}

#pragma mark -初始化

- (void)initNavgation
{
    self.view.backgroundColor = [UIColor colorWithRGBHex:0xfafafa];
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    UIButton* completeBtn = [UIButton buttonWithTitle:@"完成"
                                              font:[UIFont fontWithType:UIFontOpenSansRegular size:17]
                                         textColor:[UIColor colorWithRGBHex:HC_Blue_Text]
                                   backgroundColor:[UIColor clearColor]];
    [completeBtn addTarget:self action:@selector(doneToChangeOperation) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:completeBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
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
        case PERSON_NAME:{
            self.title = @"姓名修改";
            _nameTextField.placeholder = @"请输入姓名";
            _textLength = NAME_LENGTH;
            break;
        }
        // 修改身份证
        case PERSON_IDCARD:{
            self.title = @"身份证号码修改";
            _nameTextField.placeholder = @"请输入身份证号码";
            _textLength = IDCARD_LENGTH;
            break;
        }
        // 修改单位姓名

        case PERSON_COMPANY_NAME:{
            self.title = @"单位名称";
            _nameTextField.placeholder = @"请输入单位名称";
            _textLength = 40;
            break;
        }
        case COMPANY_NAME:{
            self.title = @"单位名称";
            _nameTextField.placeholder = @"请输入单位名称";
            _textLength = 40;
            break;
        }
        // 修改单位地址
        case COMPANY_ADDRESS:{
            self.title = @"单位地址";
            _nameTextField.placeholder = @"请输入单位地址";
            _textLength = DEFAULT_LENGTH;
            break;
        }
        // 修改单位联系人
        case COMPANY_CONTACT:{
            self.title = @"单位联系人";
            _nameTextField.placeholder = @"请输入单位联系人";
            _textLength = NAME_LENGTH;
            break;
        }
        default:
            _textLength = DEFAULT_LENGTH;
            break;
    }
    _nameTextField.text = [_cacheFlag isEqualToString:@"暂无"]? @"" : _cacheFlag;
}

- (void)initsubViews
{
    UILabel *bglabel = [[UILabel alloc]init];
    bglabel.layer.borderWidth = 1;
    bglabel.layer.borderColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1].CGColor;
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
    NSString *textName = [_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _nameTextField.text = textName;
    if (textName.length == 0) {
        [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"您未填写信息" ActionTitle:@"明白了" ActionStyle:0];
        return;
    }
    if ([textName isEqualToString:_cacheFlag]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [_nameTextField resignFirstResponder];
    __weak typeof(self) weakself = self;
    switch (_itemtype) {
            // 修改姓名
        case PERSON_NAME:{
            // 封装需要修改的信息
            NSMutableDictionary *personinfo = [[NSMutableDictionary alloc]init];
            [personinfo setObject:gCustomer.custCode forKey:@"custCode"];
            [personinfo setObject:_nameTextField.text forKey:@"custName"];

            [[HttpNetworkManager getInstance]createOrUpdateUserinformationwithInfor:personinfo resultBlock:^(BOOL successed, NSError *error) {
                if (successed) {
                    gCustomer.custName = _nameTextField.text;
                    if (weakself.updateBlcok) {
                        weakself.updateBlcok(YES, weakself.nameTextField.text);
                    }
                    [self backToPre:nil];
                }
                else{
                    [RzAlertView showAlertViewControllerWithTarget:weakself Title:@"提示" Message:@"您的修改未成功，请检查网络后重试" ActionTitle:@"明白了" ActionStyle:0];
                }
            }];
            break;
        }
            // 修改身份证
        case PERSON_IDCARD:{
            BOOL isvalidate = [HCRule validateIDCardNumber:_nameTextField.text];    // 身份证号码验证
            // 身份证信息填写不成功
            if (!isvalidate) {
                [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"身份证信息填写错误，请检查后重试" ActionTitle:@"明白了" ActionStyle:0];
                return ;
            }
            NSMutableDictionary *personinfo = [[NSMutableDictionary alloc]init];
            [personinfo setObject:gCustomer.custCode forKey:@"custCode"];
            [personinfo setObject:_nameTextField.text forKey:@"idCard"];

            [[HttpNetworkManager getInstance]createOrUpdateUserinformationwithInfor:personinfo resultBlock:^(BOOL successed, NSError *error) {
                if (successed) {
                    gCustomer.idCard = weakself.nameTextField.text;
                    if (weakself.updateBlcok) {
                        weakself.updateBlcok(YES, weakself.nameTextField.text);
                    }
                    [weakself backToPre:nil];
                }
                else{
                    [RzAlertView showAlertViewControllerWithTarget:weakself Title:@"提示" Message:@"您的修改未成功，请检查网络后重试" ActionTitle:@"明白了" ActionStyle:0];
                }
            }];
            break;
        }
        case PERSON_COMPANY_NAME:{
            break;
        }
            // 修改单位姓名
        case COMPANY_NAME:{
            // 公司单位修改
                NSMutableDictionary *cUnitInfo = [[NSMutableDictionary alloc]init];
                [cUnitInfo setObject:gUnitInfo.unitCode forKey:@"unitCode"];
                [cUnitInfo setObject:_nameTextField.text forKey:@"unitName"];

                [[HttpNetworkManager getInstance]createOrUpdateBRServiceInformationwithInfor:cUnitInfo resultBlock:^(BOOL successed, NSError *error) {
                    if (successed) {
                        gUnitInfo.unitName = weakself.nameTextField.text;
                        if (weakself.updateBlcok) {
                            weakself.updateBlcok(YES, weakself.nameTextField.text);
                        }
                        [weakself backToPre:nil];
                    }
                    else{
                        [RzAlertView showAlertViewControllerWithTarget:weakself Title:@"提示" Message:@"您的修改未成功，请检查网络后重试" ActionTitle:@"明白了" ActionStyle:0];
                    }
                }];
            
            break;
        }

            // 修改单位地址
        case COMPANY_ADDRESS:{
            NSMutableDictionary *cUnitInfo = [[NSMutableDictionary alloc]init];
            [cUnitInfo setObject:gUnitInfo.unitCode forKey:@"unitCode"];
            [cUnitInfo setObject:_nameTextField.text forKey:@"addr"];

            [[HttpNetworkManager getInstance]createOrUpdateBRServiceInformationwithInfor:cUnitInfo resultBlock:^(BOOL successed, NSError *error) {
                if (successed) {
                    gUnitInfo.addr = weakself.nameTextField.text;
                    if (weakself.updateBlcok) {
                        weakself.updateBlcok(YES, weakself.nameTextField.text);
                    }
                    [weakself backToPre:nil];
                }
                else{
                    [RzAlertView showAlertViewControllerWithTarget:weakself Title:@"提示" Message:@"您的修改未成功，请检查网络后重试" ActionTitle:@"明白了" ActionStyle:0];
                }
            }];
            break;
        }
            // 修改单位联系人
        case COMPANY_CONTACT:{
            NSMutableDictionary *cUnitInfo = [[NSMutableDictionary alloc]init];
            [cUnitInfo setObject:gUnitInfo.unitCode forKey:@"unitCode"];
            [cUnitInfo setObject:_nameTextField.text forKey:@"linkPeople"];

            [[HttpNetworkManager getInstance]createOrUpdateBRServiceInformationwithInfor:cUnitInfo resultBlock:^(BOOL successed, NSError *error) {
                if (successed) {
                    gUnitInfo.linkPeople = weakself.nameTextField.text;
                    if (weakself.updateBlcok) {
                        weakself.updateBlcok(YES, weakself.nameTextField.text);
                    }
                    [weakself backToPre:nil];
                }
                else{
                    [RzAlertView showAlertViewControllerWithTarget:weakself Title:@"提示" Message:@"您的修改未成功，请检查网络后重试" ActionTitle:@"明白了" ActionStyle:0];
                }
            }];
            break;
        }
        default:
            break;
    }
}

@end
