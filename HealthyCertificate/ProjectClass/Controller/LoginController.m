//
//  LoginController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/15.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "LoginController.h"
#import "Constants.h"

#import <Masonry.h>
#import <MJExtension.h>
#import "HCRule.h"

#import "UIButton+Easy.h"
#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"
#import "NSDate+Custom.h"
#import "UIView+RoundingCornor.h"
#import "UIScreen+Type.h"
#import "UILabel+Easy.h"
#import "UIButton+Easy.h"

#import "HttpNetworkManager.h"
#import "HCNetworkReachability.h"
#import "WZFlashButton.h"


#import "QueueServerInfo.h"
#import "MethodResult.h"

#import "IndexViewController.h"
#import "ConsumerAgreement.h"

#import <SDWebImageDownloader.h>
#import <SDWebImageManager.h>

#define LoginButtonColor 0x0097ed
#define LoginButtonPlaceHolderColor 186


#define ContainerViewHeight PXFIT_HEIGHT(208)
#define TextField_Height PXFIT_HEIGHT(103)
#define Gap              PXFIT_HEIGHT(2)

#define LeftMargin       15
#define BtnMargin        PXFIT_WIDTH(24)

#define PlaceHolder_Font FIT_FONTSIZE(25)
#define Btn_Font         FIT_FONTSIZE(27)

typedef NS_ENUM(NSInteger, LOGINTEXTFIELD)
{
    LOGIN_PHONENUM_TEXTFIELD,
    LOGIN_VERTIFY_TEXTFIELD
};

@interface LoginController()  <UITextFieldDelegate>
{
    UITextField*    _phoneNumTextField;
    UITextField*    _vertifyTextField;
    UIButton*       _vertifyButton;
    UIButton*       _loginButton;
    
    UIView*         _containerView;
    
    //验证定时相关
    NSTimer*        _vertifyTimer;
    NSInteger       _vertifyCount;
    
    BOOL           _isVertified;
}

@end

@implementation LoginController

#pragma mark - Life Circle
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadLoginView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _vertifyCount = 0;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_vertifyTimer.isValid) {
        [_vertifyTimer invalidate];
    }
    _vertifyTimer=nil;
}

-(void)loadLoginView{
    
    self.view.backgroundColor = [UIColor colorWithRGBHex:0xf6f5f0];
    
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).with.offset(LeftMargin);
        make.right.mas_equalTo(self.view).with.offset(-LeftMargin);
        make.top.mas_equalTo(self.view).with.offset(PXFIT_HEIGHT(196));
        make.height.mas_equalTo(ContainerViewHeight);
    }];
    _containerView.layer.cornerRadius = 5;
    
    _phoneNumTextField = [[UITextField alloc] init];
    _phoneNumTextField.backgroundColor = [UIColor whiteColor];
    _phoneNumTextField.tag = LOGIN_PHONENUM_TEXTFIELD;
    [_containerView addSubview:_phoneNumTextField];
    [_phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_containerView).with.offset(BtnMargin);
        make.right.mas_equalTo(_containerView).with.offset(-BtnMargin);
        make.top.mas_equalTo(_containerView);
        make.height.mas_equalTo(TextField_Height);
    }];
    _phoneNumTextField.placeholder = @"请输入手机号";
    _phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumTextField.delegate = self;
    [_phoneNumTextField setValue: [UIFont fontWithType:UIFontOpenSansRegular size:PlaceHolder_Font] forKeyPath:@"_placeholderLabel.font"];
    
    
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRGBHex:0xbbbbbb];
    [_containerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_containerView);
        make.height.mas_equalTo(PXFIT_HEIGHT(2));
        make.top.mas_equalTo(_phoneNumTextField.mas_bottom);
    }];
    
    _vertifyTextField = [[UITextField alloc] init];
    _vertifyTextField.backgroundColor = [UIColor whiteColor];
    _vertifyTextField.tag = LOGIN_VERTIFY_TEXTFIELD;
    [_containerView addSubview:_vertifyTextField];
    [_vertifyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom);
        make.left.mas_equalTo(_containerView).with.offset(BtnMargin);
        make.width.mas_equalTo(SCREEN_WIDTH - 2 * LeftMargin - PXFIT_WIDTH(144) - 2 * BtnMargin);
        make.height.mas_equalTo(_phoneNumTextField.mas_height);
    }];
    _vertifyTextField.placeholder = @"输入验证码";
    _vertifyTextField.keyboardType = UIKeyboardTypeNumberPad;
    _vertifyTextField.delegate = self;
    [_vertifyTextField setValue: [UIFont fontWithType:UIFontOpenSansRegular size:PlaceHolder_Font] forKeyPath:@"_placeholderLabel.font"];
    
    
    _vertifyButton = [UIButton buttonWithTitle:@"验证"
                                          font:[UIFont fontWithType:UIFontOpenSansRegular size:PlaceHolder_Font]
                                     textColor:[UIColor whiteColor]
                               backgroundColor:[UIColor colorWithRGBHex:HC_Gray_unable]];
    _vertifyButton.layer.cornerRadius = 5;
    [_vertifyButton setEnabled:NO];
    [_containerView addSubview:_vertifyButton];
    [_vertifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_vertifyTextField.mas_right).with.offset(BtnMargin);
        make.right.mas_equalTo(_containerView).with.offset(-BtnMargin);
        make.centerY.mas_equalTo(_vertifyTextField);
        make.height.mas_equalTo(TextField_Height - 2 * PXFIT_HEIGHT(20));
    }];
    [_vertifyButton addTarget:self action:@selector(veritifyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _loginButton = [UIButton buttonWithTitle:@"登  录"
                                        font:[UIFont fontWithType:UIFontOpenSansRegular size:Btn_Font]
                                   textColor:[UIColor whiteColor]
                             backgroundColor:[UIColor colorWithRGBHex:HC_Gray_unable]];
    [_loginButton setEnabled:NO];
    _loginButton.layer.cornerRadius = 5;
    [self.view addSubview:_loginButton];
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_vertifyTextField.mas_height);
        make.top.mas_equalTo(_containerView.mas_bottom).with.offset(PXFIT_HEIGHT(36));
        make.centerX.mas_equalTo(_containerView.mas_centerX);
        make.width.mas_equalTo(_containerView);
    }];
    [_loginButton addTarget:self action:@selector(loginBtnCliked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* tipInfo = [UILabel labelWithText:@"点击登录,即表示您同意"
                                         font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(23)]
                                    textColor:[UIColor colorWithRGBHex:HC_Gray_Text]];
    [self.view addSubview:tipInfo];
    [tipInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LeftMargin);
        make.top.mas_equalTo(_loginButton.mas_bottom).with.offset(PXFIT_HEIGHT(36));
    }];
    
    UIButton* linkBtn = [UIButton buttonWithTitle:@"<<用户使用协议>>"
                                             font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(23)]
                                        textColor:[UIColor colorWithRGBHex:0xf98b5e]
                                  backgroundColor:nil];
    [linkBtn addTarget:self action:@selector(linkBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:linkBtn];
    [linkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tipInfo);
        make.left.mas_equalTo(tipInfo.mas_right);
    }];
    
    //添加手势
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.view addGestureRecognizer:singleRecognizer];
}

#pragma mark - Button Action
-(void)loginBtnCliked:(id)sender
{
    //判断验证码是否正确
    [[HttpNetworkManager getInstance] vertifyPhoneNumber:_phoneNumTextField.text
                                             VertifyCode:_vertifyTextField.text
                                             resultBlock:^(NSDictionary *result, NSError *error) {
                                                
                                                 if (error != nil){
                                                     [RzAlertView showAlertLabelWithTarget:self.view Message:@"网络连接错误,请检查网络设置" removeDelay:2];
                                                     return;
                                                 }
                                                 
                                                 if([[result objectForKey:@"ProResult"] isEqualToString:@"0"]){
                                                     NSDictionary* resultDic = [result objectForKey:@"Msg"];
                                                     SetUserName([resultDic objectForKey:@"userName"]);
                                                     SetUserRole([resultDic objectForKey:@"userRole"]);
                                                     SetToken([resultDic objectForKey:@"token"]);
                                                     
                                                     SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
                                                     [manager setValue:GetUserName forHTTPHeaderField:@"DBKE-UserName"];
                                                     [manager setValue:@"zeekcustomerapp" forHTTPHeaderField:@"DBKE-ClientType"];
                                                     [manager setValue:GetToken forHTTPHeaderField:@"DBKE-Token"];
                                                     
                                                     
                                                     [[HttpNetworkManager getInstance].sharedClient.requestSerializer setValue:GetUserName forHTTPHeaderField:@"DBKE-UserName"];
                                                     [[HttpNetworkManager getInstance].sharedClient.requestSerializer setValue:@"zeekcustomerapp" forHTTPHeaderField:@"DBKE-ClientType"];
                                                     [[HttpNetworkManager getInstance].sharedClient.requestSerializer setValue:GetToken forHTTPHeaderField:@"DBKE-Token"];
                                                     
                                                     [self getLoginInfo];
                                                     
                                                     _isVertified = YES;
                                                 }
                                                 else{
                                                     [RzAlertView showAlertLabelWithTarget:self.view Message:[result objectForKey:@"Msg"] removeDelay:2];
                                                 }
                                             }];
}

-(void)linkBtnClicked:(UIButton*)sender
{
    ConsumerAgreement* consumerAgreement = [[ConsumerAgreement alloc] init];
    consumerAgreement.consumerPopStyle =  ConsumerPopStyle_DisMiss;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:consumerAgreement];
    [self presentViewController:nav animated:YES completion:nil];
}


-(void)veritifyBtnClicked:(id)sender
{
    if ([[HCNetworkReachability getInstance] isReachable] == NO){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"网络连接失败，请检查网络设置" removeDelay:3];
        return;
    }
    if (_vertifyCount != 0){
        return;
    }
    [_vertifyTextField resignFirstResponder];
    [_phoneNumTextField resignFirstResponder];
    _vertifyCount = 60;
    _vertifyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(vertifyTimerTrigger) userInfo:nil repeats:YES];
    
    [[HttpNetworkManager getInstance] verifyPhoneNumber:_phoneNumTextField.text resultBlock:^(NSDictionary *result, NSError *error) {
        _loginButton.enabled = YES;
        _loginButton.backgroundColor = [UIColor colorWithRGBHex:HC_Base_Blue];
        
        if (error)
            return;
        NSString* proResult = [result objectForKey:@"ProResult"];
        if (![proResult isEqualToString:@"0"]){
            [RzAlertView showAlertLabelWithTarget:self.view Message:[result objectForKey:@"Msg"] removeDelay:3];
        }else{
            NSLog(@"短信验证码%@", [result objectForKey:@"Msg"]);
//            _vertifyTextField.text = [result objectForKey:@"Msg"];
        }
    }];
}


-(void)buttonBackgroundHighLight:(UIButton*)sender
{
    sender.backgroundColor = [UIColor colorWithRGBHex:HC_Base_Blue_Pressed];
}


-(void)getLoginInfoSucceed{
    if (!_isVertified)
        return;
    
    IndexViewController* indexViewController = [[IndexViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:indexViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITextField Delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == LOGIN_VERTIFY_TEXTFIELD)
    {
        if (![self isPureInt:string]){
            if (![string isEqualToString:@""]){
                return NO;
            }else{
                if (textField.text.length == 4 && [string isEqualToString:@""]){
                    _loginButton.enabled = NO;
                    [_loginButton setBackgroundColor:[UIColor colorWithRGBHex:HC_Gray_unable]];
                    return YES;
                }
            }
        }
        //如果是4位及以上的验证码，则按钮可以点击
        if (textField.text.length + string.length < 4){
            _loginButton.enabled = NO;
            [_loginButton setBackgroundColor:[UIColor colorWithRGBHex:HC_Gray_unable]];
        }else{
            _loginButton.enabled = YES;
            [_loginButton setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue]];
        }
        return YES;
    }
    
    
    if (![self isPureInt:string]){
        _vertifyButton.enabled = NO;
        [_vertifyButton setBackgroundColor:[UIColor colorWithRGBHex:HC_Gray_unable]];
        return YES;
    }
    if (textField.text.length + string.length > 11){
        return NO;
    }else if (textField.text.length == 10){
        _vertifyButton.enabled = YES;
        [_vertifyButton setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue]];
        return YES;
    }else{
        _vertifyButton.enabled = NO;
        [_vertifyButton setBackgroundColor:[UIColor colorWithRGBHex:HC_Gray_unable]];
        return YES;
    }
}

#pragma mark - Private Methods
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}



- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer
{
    if (![recognizer.view isKindOfClass:[UITextField class]]){
        [_phoneNumTextField resignFirstResponder];
        [_vertifyTextField resignFirstResponder];
    }
}

-(void)vertifyTimerTrigger{
    [_vertifyButton setTitle:[NSString stringWithFormat:@"%ld秒", (long)_vertifyCount--] forState:UIControlStateNormal];
    
    if (_vertifyCount == 0){
        [_vertifyButton setTitle:@"验证" forState:UIControlStateNormal];
        [_vertifyTimer invalidate];
    }
}

-(void)getLoginInfo{
    //http://zkwebserver.witaction.com:8080/webserver/webservice/userInfo/findUserInfoByPhone?mobilePhone=18080961548
    [[HttpNetworkManager getInstance] findUserInfoByPhone:GetUserName resultBlock:^(NSDictionary *result, NSError *error) {
        if (error || result == nil){
            SetUserName(@"");
            SetToken(@"");
            SetUserRole(@"");
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"登录信息错误" removeDelay:2];
            return;
        }
        
        NSDictionary* unitInfo = [result objectForKey:@"unitInfo"];
        gUnitInfo = [BRServiceUnit mj_objectWithKeyValues:unitInfo];
        
        NSDictionary* personalInfo = [result objectForKey:@"customer"];
        gCustomer = [Customer mj_objectWithKeyValues:personalInfo];
        
        [self getLoginInfoSucceed];
    }];
}

@end
