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
#import "HCRule.h"

#import "UIButton+Easy.h"
#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"

#import "HttpNetworkManager.h"
#import "UIScreen+Type.h"

#import "HMNetworkEngine.h"
#import "QueueServerInfo.h"
#import "UIScreen+Type.h"

#import "IndexViewController.h"

#define LoginButtonColor 0x0097ed
#define LoginButtonPlaceHolderColor 186


#define TextField_Height FIT_HEIGHT(60)
#define Gap              FIT_HEIGHT(25)
#define PlaceHolder_Font FIT_FONTSIZE(24)
#define Btn_Font         FIT_FONTSIZE(27)

@interface LoginController()  <UITextFieldDelegate, HMNetworkEngineDelegate>
{
    UITextField*    _phoneNumTextField;
    UITextField*    _vertifyTextField;
    UIButton*       _vertifyButton;
    UIButton*       _loginButton;
    
    NSString*       _authCodeStr;
    NSTimer*        _vertifyTimer;
    BOOL            _isFirstShown;
    CGFloat         _viewHeight;
    
    UIView*         _containerView;
    UIImageView*    _logoImageView;
}

@end

@implementation LoginController

#pragma mark - Life Circle
-(void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView* backGroundIamgeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginBackGround"]];
    [self.view addSubview:backGroundIamgeView];
    [backGroundIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    
    _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_Logo"]];
    [self.view addSubview:_logoImageView];
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(SCREEN_HEIGHT*5/24-kStatusBarHeight);
    }];
    
    _containerView = [[UIView alloc] init];
    [self.view addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).with.offset(SCREEN_WIDTH*0.1);
        make.right.mas_equalTo(self.view).with.offset(-SCREEN_WIDTH*0.1);
        make.top.mas_equalTo(self.view).with.offset(SCREEN_HEIGHT*5/12);
        make.height.mas_equalTo(3*TextField_Height + 2*Gap);
    }];

    _phoneNumTextField = [[UITextField alloc] init];
    _phoneNumTextField.backgroundColor = [UIColor whiteColor];
    [_containerView addSubview:_phoneNumTextField];
    [_phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(_containerView);
        make.height.mas_equalTo(TextField_Height);
    }];
    _phoneNumTextField.placeholder = @"输入手机号";
    _phoneNumTextField.layer.cornerRadius = 5;
    _phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumTextField.delegate = self;
    [_phoneNumTextField setValue: [UIFont fontWithType:UIFontOpenSansRegular size:PlaceHolder_Font] forKeyPath:@"_placeholderLabel.font"];
    
    _vertifyTextField = [[UITextField alloc] init];
    _vertifyTextField.backgroundColor = [UIColor whiteColor];
    [_containerView addSubview:_vertifyTextField];
    [_vertifyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_phoneNumTextField.mas_bottom).with.offset(Gap);
        make.left.mas_equalTo(_containerView);
        make.width.mas_equalTo(SCREEN_WIDTH*0.8*2/3);
        make.height.mas_equalTo(_phoneNumTextField.mas_height);
    }];
    _vertifyTextField.placeholder = @"输入验证码";
    _vertifyTextField.keyboardType = UIKeyboardTypeNumberPad;
    _vertifyTextField.delegate = self;
    [_vertifyTextField setValue: [UIFont fontWithType:UIFontOpenSansRegular size:PlaceHolder_Font] forKeyPath:@"_placeholderLabel.font"];
    
    
    _vertifyButton = [UIButton buttonWithTitle:@"验证" font:[UIFont fontWithType:UIFontOpenSansRegular size:PlaceHolder_Font] textColor:MO_RGBCOLOR(83,182,234) backgroundColor:[UIColor whiteColor]];
    [_containerView addSubview:_vertifyButton];
    [_vertifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_vertifyTextField.mas_right).with.offset(FIT_WIDTH(5));
        make.right.mas_equalTo(_containerView);
        make.centerY.mas_equalTo(_vertifyTextField);
        make.height.mas_equalTo(_phoneNumTextField.mas_height);
    }];
    [_vertifyButton addTarget:self action:@selector(veritifyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _loginButton = [UIButton buttonWithTitle:@"登 录" font:[UIFont fontWithType:UIFontOpenSansRegular size:Btn_Font] textColor:[UIColor whiteColor] backgroundColor:[UIColor colorWithRGBHex:LoginButtonColor]];
    _loginButton.layer.cornerRadius = 5;
    [_containerView addSubview:_loginButton];
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_vertifyTextField.mas_height);
        make.top.mas_equalTo(_vertifyTextField.mas_bottom).with.offset(Gap);
        make.centerX.mas_equalTo(_phoneNumTextField.mas_centerX);
        make.width.mas_equalTo(_phoneNumTextField.mas_width);
    }];
    [_loginButton addTarget:self action:@selector(loginBtnCliked:) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_vertifyButton.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _vertifyButton.bounds;
        maskLayer.path = maskPath.CGPath;
        _vertifyButton.layer.mask = maskLayer;
        
        maskPath = [UIBezierPath bezierPathWithRoundedRect:_vertifyTextField.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *FieldmaskLayer = [[CAShapeLayer alloc] init];
        FieldmaskLayer.frame = _vertifyTextField.bounds;
        FieldmaskLayer.path = maskPath.CGPath;
        _vertifyTextField.layer.mask = FieldmaskLayer;
        
        CGRect frame = [_phoneNumTextField frame];
        frame.size.width = 7.0f;
        UIView *phoneNumLeftview = [[UIView alloc] initWithFrame:frame];
        UIView *vertifyLeftView = [[UIView alloc] initWithFrame:frame];
        _phoneNumTextField.leftViewMode = UITextFieldViewModeAlways;
        _phoneNumTextField.leftView = phoneNumLeftview;
        _vertifyTextField.leftViewMode = UITextFieldViewModeAlways;
        _vertifyTextField.leftView = vertifyLeftView;
    });
    
    _isFirstShown = NO;
    
    //添加手势
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.view addGestureRecognizer:singleRecognizer];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self registerKeyboardNotification];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
     [self cancelKeyboardNotification];
}

#pragma mark - Button Action
-(void)loginBtnCliked:(id)sender
{
    //    if ([_authCodeStr isEqualToString:_vertifyTextField.text]){
    //        [self performSegueWithIdentifier:@"LoginIdentifier" sender:self];
    //    }else{
    //    }
    
    //暂时先将socket的连接操作放在这里
    [HMNetworkEngine getInstance].delegate = self;
    [[HMNetworkEngine getInstance] startControl];

   // [self performSegueWithIdentifier:@"AppointmentIdentifier" sender:self];
}

-(void)veritifyBtnClicked:(id)sender
{
    [[HttpNetworkManager getInstance] verifyPhoneNumber:_phoneNumTextField.text resultBlock:^(NSDictionary *result, NSError *error) {
        if (error){
            NSLog(@"%@", error.localizedDescription);
        }else{
            //接收到验证码，这里解析感觉可以封装到下层去
            NSDictionary* dataDic = [result objectForKey:@"data"];
            _authCodeStr = [dataDic objectForKey:@"authCode"];
            _vertifyTextField.text = _authCodeStr;
        }
    }];
}

#pragma mark - HMNetworkEngine Delegate
-(void)setUpControlSucceed{
    [[HMNetworkEngine getInstance] queryServerList];
}

-(void)setUpControlFailed{
}

-(void)queueServerListResult:(NSData *)data Index:(NSInteger *)index{
    NSString* listString =  [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(*index, data.length-*index)] encoding:NSUTF8StringEncoding];
    //return format tijian-510100-ZXQueueServer1,武汉国药阳光体检中心,描述:知名体检中心;tijian-510100-ZXQueueServer1,武汉国药阳光体检中心,描述:知名体检中心
    NSArray *array = [listString componentsSeparatedByString:@";"];
    
    //返回的数据按理应该是一个，所以如果不为空，只取第一条数据
    if (array.count != 0){
        QueueServerInfo* info = [[QueueServerInfo alloc] initWithString:array[0]];
        [HMNetworkEngine getInstance].serverID = info.serverID;
        
        //获得机构后向服务端发送客户电话号码相关的信息 这里为了测试先定一个假数据
        [[HMNetworkEngine getInstance] askLoginInfo:@"18380447466"];
    }
}

-(void)getLoginInfoSucceed{
    //因为现在是异步队列，所以不能在该函数里面操作ui线程
    dispatch_async(dispatch_get_main_queue(), ^{
       // [self performSegueWithIdentifier:@"LoginIdentifier" sender:self];
        IndexViewController* indexViewController = [[IndexViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:indexViewController];
        [self presentViewController:nav animated:YES completion:nil];
    });
}

#pragma mark - UITextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![self isPureInt:string]){
        _vertifyButton.enabled = NO;
        return YES;
    }
    
    if (textField.text.length > 10){
        _vertifyButton.enabled = NO;
        return NO;
    }else if (textField.text.length == 10){
        _vertifyButton.enabled = YES;
        return YES;
    }else{
        _vertifyButton.enabled = NO;
        return YES;
    }
}

#pragma mark - Private Methods
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

-(void)registerKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification  object:nil];
}

-(void)cancelKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    if (_isFirstShown == NO){
        _isFirstShown = YES;
        CGRect keyboardBounds;//UIKeyboardFrameEndUserInfoKey
        [[notification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBounds];
        _viewHeight = keyboardBounds.size.height;
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [_containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).with.offset(SCREEN_WIDTH*0.1);
            make.right.mas_equalTo(self.view).with.offset(-SCREEN_WIDTH*0.1);
            make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-_viewHeight-5);
            make.height.mas_equalTo(3*TextField_Height + 2*Gap);
        }];
        
        if ([UIScreen is480HeightScreen] || [UIScreen is568HeightScreen]){
            [_logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.view);
                make.bottom.mas_equalTo(_containerView.mas_top).with.offset(-10);
            }];
        }
        
    } completion:NULL];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [_logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(SCREEN_HEIGHT*5/24-kStatusBarHeight);
    }];
    
    [_containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).with.offset(SCREEN_WIDTH*0.1);
        make.right.mas_equalTo(self.view).with.offset(-SCREEN_WIDTH*0.1);
        make.top.mas_equalTo(self.view).with.offset(SCREEN_HEIGHT*5/12);
        make.height.mas_equalTo(3*TextField_Height + 2*Gap);
    }];
}
- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer
{
    if (![recognizer.view isKindOfClass:[UITextField class]]){
        [_phoneNumTextField resignFirstResponder];
        [_vertifyTextField resignFirstResponder];
    }
}

@end
