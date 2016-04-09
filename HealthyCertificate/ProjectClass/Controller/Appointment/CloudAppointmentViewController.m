//
//  CloudAppointmentViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/17.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CloudAppointmentViewController.h"
#import "Constants.h"

#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import <MJExtension.h>

#import "UIButton+Easy.h"
#import "UIColor+Expanded.h"
#import "UIFont+Custom.h"
#import "NSString+Custom.h"
#import "NSDate+Custom.h"
#import "NSString+Custom.h"
#import "UIScreen+Type.h"
#import "NSString+Custom.h"
#import "NSString+Count.h"
#import "UIButton+HitTest.h"
#import "UIView+borderWidth.h"
#import "UIImage+Color.h"
#import "UIButton+TCHelper.h"
#import "UILabel+Easy.h"

#import "BaseInfoTableViewCell.h"
#import "CloudAppointmentDateVC.h"
#import "SelectAddressViewController.h"

#import "HealthyCertificateView.h"
#import "AppointmentInfoView.h"
#import "CloudAppointmentDateVC.h"
#import "EditInfoViewController.h"
#import "HCWheelView.h"
#import "WorkTypeViewController.h"
#import "MyCheckListViewController.h"

#import "YMIDCardRecognition.h"
#import "HttpNetworkManager.h"
#import "HCNetworkReachability.h"
#import "PositionUtil.h"
#import "TakePhoto.h"
#import "RzAlertView.h"
#import "HCRule.h"
#import "HCBackgroundColorButton.h"
#import "HCNavigationBackButton.h"


#import "MethodResult.h"
#import "OrdersAlertView.h"
#import "PayMoneyController.h"

#define Button_Size 26
#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface CloudAppointmentViewController()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,HealthyCertificateViewDelegate,HCWheelViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, YMIDCardRecognitionDelegate, PayMoneyDelegate>
{
    AppointmentInfoView     *_appointmentInfoView;
    
    UITextView             *_phoneNumTextView;
    UITextView             *_appointmentDateTextView;
    UITableView             *_baseInfoTableView;
    
    HCBackgroundColorButton* _appointmentBtn;
    BOOL                    _isAppointmentBtnResponse;
    
    //键盘相关
    BOOL                    _isFirstShown;
    CGFloat                 _viewHeight;
    
    //性别选择器
    HCWheelView             *_sexWheel;
    
    RzAlertView             *_waitAlertView;
    
    //是待处理项(YES) 新建的预约(No)
    BOOL                    _isTodoTask;
    
    /*
     1. 如果是云预约 
     CustomerTest 为空 这时图片肯定是未设置的 将该变量置为false
     设置头像后，将其设置为true
     
     2. 如果是服务点预约
     先得到CustomerTest 取出编号 再用编号去请求图片
     
     */
    bool                    _isAvatarSet;
}

@property (nonatomic, strong) HealthyCertificateView* healthyCertificateView;
@property (nonatomic, strong) UITextView* locationTextView;

@end


@implementation CloudAppointmentViewController

#pragma mark - Public Methods
-(void)hideTheKeyBoard{
    [_phoneNumTextView resignFirstResponder];
}

#pragma mark - Setter & Getter
-(void)setAppointmentDateStr:(NSString *)appointmentDateStr
{
    BaseInfoTableViewCell* cell = [_baseInfoTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.textView.text = appointmentDateStr;
    _appointmentDateStr = appointmentDateStr;
}

-(void)setIdCardInfo:(NSArray *)idCardInfo{
    if ([HCRule validateIDCardNumber:idCardInfo[1]] == NO){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"扫描身份证信息失败，请注意聚焦" removeDelay:3];
        return;
    }
    _healthyCertificateView.name = idCardInfo[0];
    _healthyCertificateView.idCard = idCardInfo[1];
    _healthyCertificateView.gender = idCardInfo[2];
}

- (void)setSercersPositionInfo:(ServersPositionAnnotionsModel *)sercersPositionInfo
{
    _sercersPositionInfo = sercersPositionInfo;
    _location = sercersPositionInfo.address;
    
    if (sercersPositionInfo.type == 0) {
        _appointmentDateStr = [NSString stringWithFormat:@"%@,08:00", [[NSDate date] getDateStringWithInternel:1]];
        _isTemperaryPoint = NO;
    }
    else {
        _appointmentDateStr = [NSString stringWithFormat:@"%@(%@~%@)",  [NSDate getYear_Month_DayByDate:sercersPositionInfo.startTime/1000], [NSDate getHour_MinuteByDate:sercersPositionInfo.startTime/1000], [NSDate getHour_MinuteByDate:sercersPositionInfo.endTime/1000]];
        _isTemperaryPoint = YES;
    }
}

-(void)setCustomerTestInfo:(CustomerTest *)customerTestInfo
{
    _customerTestInfo = customerTestInfo;
    //赋值代表是待处理项目
    _isTodoTask = YES;
}

#pragma mark - Life Circle
- (void)initNavgation
{
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    self.title = _sercersPositionInfo.name;
    
    HCNavigationBackButton* QRScanButton = [[HCNavigationBackButton alloc] initWithText:@"识别"];
    QRScanButton.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [QRScanButton addTarget:self action:@selector(QRScanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:QRScanButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initNavgation];
    [self loadData];

    UIScrollView* scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = MO_RGBCOLOR(250, 250, 250);
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    UIView* containerView = [[UIView alloc] init];
    [scrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    _baseInfoTableView = [[UITableView alloc] init];
    _baseInfoTableView.delegate = self;
    _baseInfoTableView.dataSource = self;
    _baseInfoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _baseInfoTableView.separatorColor = [UIColor colorWithRGBHex:0xe8e8e8];
    _baseInfoTableView.layer.borderWidth = 1;
    _baseInfoTableView.layer.borderColor = [UIColor colorWithRGBHex:0xe8e8e8].CGColor;
    _baseInfoTableView.layer.cornerRadius = 10.0f;
    _baseInfoTableView.scrollEnabled = NO;
    [_baseInfoTableView registerClass:[BaseInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BaseInfoTableViewCell class])];
    [containerView addSubview:_baseInfoTableView];
    [_baseInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(containerView).with.offset(10);
        make.right.mas_equalTo(containerView).with.offset(-10) ;
        make.height.mas_equalTo(PXFIT_HEIGHT(100)*3);
    }];
    
    _healthyCertificateView = [[HealthyCertificateView alloc] init];
    _healthyCertificateView.layer.cornerRadius = 10;
    _healthyCertificateView.layer.borderColor = MO_RGBCOLOR(0, 168, 234).CGColor;
    _healthyCertificateView.layer.borderWidth = 1;
    _healthyCertificateView.delegate = self;
    if (_customerTestInfo == nil){
        _healthyCertificateView.customer = gCustomer;
    }else{
        _healthyCertificateView.customerTest = _customerTestInfo;
    }
    
    [containerView addSubview:_healthyCertificateView];
    [_healthyCertificateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView).with.offset(10);
        make.right.mas_equalTo(containerView).with.offset(-10);
        make.top.mas_equalTo(_baseInfoTableView.mas_bottom).with.offset(10);
        make.height.mas_equalTo(PXFIT_HEIGHT(470));
    }];
    
    UILabel* noticeLabel = [UILabel labelWithText:@"温馨提示"
                                             font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)]
                                        textColor:[UIColor blackColor]];
    [containerView addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo(containerView).with.offset(10);
        make.top.mas_equalTo(_healthyCertificateView.mas_bottom).with.offset(10);
    }];
    
    NSString* tipInfo;
    if (_isCustomerServerPoint == YES){
        tipInfo = @"您附近如果没有合适的体检服务点,请通过快速预约告之您的体检位置和体检时间,我们会及时安排体检车上门为您体检办证!";
    }else{
        tipInfo = @"请确认在体检车离开前按时到达服务点,以免给您带来不便!";
    }
    UILabel* itemLabel = [UILabel labelWithText:tipInfo
                                           font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(23)]
                                      textColor:[UIColor colorWithRGBHex:HC_Gray_Text]];
    itemLabel.numberOfLines = 0;
    [containerView addSubview:itemLabel];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView).with.offset(10);
        make.right.mas_equalTo(containerView).with.offset(-10);
        make.top.mas_equalTo(noticeLabel.mas_bottom).with.offset(10);
    }];
    
    
    UIView* bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containerView);
        make.top.mas_equalTo(itemLabel.mas_bottom);
        make.height.mas_equalTo(PXFIT_HEIGHT(136));
    }];
    
    _appointmentBtn = [[HCBackgroundColorButton alloc] init];
    [_appointmentBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue] forState:UIControlStateNormal];
    [_appointmentBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue_Pressed] forState:UIControlStateHighlighted];
    [_appointmentBtn setTitle:@"预   约" forState:UIControlStateNormal];
    [_appointmentBtn addTarget:self action:@selector(appointmentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    _appointmentBtn.layer.cornerRadius = 5;
    [bottomView addSubview:_appointmentBtn];
    [_appointmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView);
        make.left.mas_equalTo(bottomView).with.offset(PXFIT_WIDTH(24));
        make.right.mas_equalTo(bottomView).with.offset(-PXFIT_WIDTH(24));
        make.top.mas_equalTo(bottomView).with.offset(PXFIT_HEIGHT(20));
        make.bottom.mas_equalTo(bottomView).with.offset(-PXFIT_HEIGHT(20));
    }];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView.mas_bottom);
    }];
    
    //添加手势
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    singleRecognizer.delegate = self;
    [self.view addGestureRecognizer:singleRecognizer];
    
    _sexWheel = [[HCWheelView alloc] init];
    [self.view addSubview:_sexWheel];
    _sexWheel.hidden = YES;
    _sexWheel.delegate = self;
    _sexWheel.pickerViewContentArr = [NSMutableArray arrayWithArray:@[@"男", @"女"]];
    [_sexWheel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT * 1/3 );
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    _isAppointmentBtnResponse = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self registerKeyboardNotification];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self cancelKeyboardNotification];
}

#pragma mark - UITableViewDataSource & UITabBarControllerDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BaseInfoTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ( [cell respondsToSelector:@selector(setSeparatorInset:)] )
        [cell setSeparatorInset:UIEdgeInsetsZero];
    if ( [cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)] )
        [cell setPreservesSuperviewLayoutMargins:NO];
    if ( [cell respondsToSelector:@selector(setLayoutMargins:)] )
        [cell setLayoutMargins:UIEdgeInsetsZero];
    
    if (indexPath.row == 1)
    {
        cell.iconName = @"dizhis";
        [cell setTextViewText:_location];
        cell.textView.userInteractionEnabled = NO;
        cell.textView.textColor = _isCustomerServerPoint?[UIColor blackColor]:[UIColor colorWithRGBHex:HC_Gray_Text];
        _locationTextView = cell.textView;
    }
    else if (indexPath.row == 0)
    {
        cell.iconName = @"date_icon";
        [cell setTextViewText:_appointmentDateStr];
         cell.textView.userInteractionEnabled = NO;
        cell.textView.textColor = _isTemperaryPoint?[UIColor colorWithRGBHex:HC_Gray_Text]:[UIColor blackColor];
        _appointmentDateTextView = cell.textView;
    }
    else
    {
        cell.iconName = @"phone_icon";
        cell.textView.scrollEnabled = NO;
        cell.textView.keyboardType = UIKeyboardTypeNumberPad;
        if (_customerTestInfo == nil){
            cell.textView.text = gCustomer.linkPhone;
        }else{
            cell.textView.text = _customerTestInfo.linkPhone;
        }
        cell.textView.delegate = self;
        _phoneNumTextView = cell.textView;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //修改预约时间 (移动服务点不可修改)
    if (!_isTemperaryPoint && indexPath.row == 0){
        CloudAppointmentDateVC* cloudAppointmentDateVC = [[CloudAppointmentDateVC alloc] init];
        cloudAppointmentDateVC.choosetDateStr = _appointmentDateStr;
        __weak typeof (self) wself = self;
        [cloudAppointmentDateVC getAppointDateStringWithBlock:^(NSString *dateStr) {
            wself.appointmentDateStr = dateStr;
        }];
        [self.navigationController pushViewController:cloudAppointmentDateVC animated:YES];
        [self hideTheKeyBoard];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PXFIT_HEIGHT(100);
}

#pragma mark - Action
-(void)unLockBtn
{
    _isAppointmentBtnResponse = YES;
}

-(void)appointmentBtnClicked
{
    //处理频繁点击按钮
    if (_isAppointmentBtnResponse == NO)
        return;
    
    _isAppointmentBtnResponse = NO;
    [self performSelector:@selector(unLockBtn) withObject:nil afterDelay:3];
    
    if([HCNetworkReachability getInstance].getCurrentReachabilityState == 0){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"网络连接失败，请检查网络设置" removeDelay:2];
        return;
    }
    
    //先做一次数据有效性检查 to do
    if (_locationTextView.text == nil || [_locationTextView.text isEqualToString:@""]){
        [RzAlertView showAlertLabelWithTarget:self.view Message:InputLocationInfo removeDelay:2];
        return;
    }
    
    if (_appointmentDateTextView.text == nil || [_appointmentDateTextView.text isEqualToString:@""]){
        [RzAlertView showAlertLabelWithTarget:self.view Message:InputDateInfo removeDelay:2];
        return;
    }
    
    if (_phoneNumTextView.text == nil || [_phoneNumTextView.text isEqualToString:@""]){
        [RzAlertView showAlertLabelWithTarget:self.view Message:InputTelephone removeDelay:2];
        return;
    }
    
    if (_healthyCertificateView.name == nil || [_healthyCertificateView.name isEqualToString:@""]){
        [RzAlertView showAlertLabelWithTarget:self.view Message:InputName removeDelay:2];
        return;
    }
    
    if (_healthyCertificateView.gender == nil || [_healthyCertificateView.gender isEqualToString:@""]){
        [RzAlertView showAlertLabelWithTarget:self.view Message:InputGender removeDelay:2];
        return;
    }
    
    if (_healthyCertificateView.workType == nil || [_healthyCertificateView.workType isEqualToString:@""]){
        [RzAlertView showAlertLabelWithTarget:self.view Message:InputIndustry removeDelay:2];
        return;
    }
    
    if (_healthyCertificateView.idCard == nil || [_healthyCertificateView.idCard isEqualToString:@""]){
        [RzAlertView showAlertLabelWithTarget:self.view Message:InputIdCard removeDelay:2];
        return;
    }
    
    if (_isTodoTask){
        //如果是待处理项
    }else{
        //新建的预约
        if (_customerTestInfo == nil){
            _customerTestInfo = [[CustomerTest alloc] init];
            _customerTestInfo.checkCode = nil;
            _customerTestInfo.unitCode = gCustomer.unitCode;
            _customerTestInfo.unitName = gCustomer.unitName;
            _customerTestInfo.custCode = gCustomer.custCode;
            _customerTestInfo.nation = nil;
            _customerTestInfo.checkType = 1; // 1 为 健康证
            _customerTestInfo.testStatus = @"-1";// 客户体检登记状态：-1未检，0签到，1在检，2延期，3完成，9已出报告和健康证
            // 单位合同状态：-1所有员工未开始检查，3所有员工完成体检，4所有员工已出健康证
            _customerTestInfo.printPhoto = nil;
            _customerTestInfo.contractCode = nil;
        }
        if (_isCustomerServerPoint){
            //云预约
            _customerTestInfo.regTime = [_appointmentDateTextView.text convertDateStrWithHourToLongLong]*1000;
            _customerTestInfo.regPosAddr = _locationTextView.text; //预约地点
            _customerTestInfo.regPosLA = self.centerCoordinate.latitude;
            _customerTestInfo.regPosLO = self.centerCoordinate.longitude;
        }else{
            //基于服务点的预约
            if (_sercersPositionInfo != nil){
                if (_sercersPositionInfo.type == 0)
                    _customerTestInfo.regTime = [_appointmentDateTextView.text convertDateStrWithHourToLongLong]*1000;
                _customerTestInfo.regPosLA = _sercersPositionInfo.positionLa;
                _customerTestInfo.regPosLO = _sercersPositionInfo.positionLo;
                _customerTestInfo.hosCode = _sercersPositionInfo.cHostCode;
                //移动服务点 id 固定 cHostCode
                _customerTestInfo.checkSiteID = _sercersPositionInfo.type == 1 ? _sercersPositionInfo.id : _sercersPositionInfo.cHostCode;
            }
        }
    }
    _customerTestInfo.custName = _healthyCertificateView.name;
    _customerTestInfo.sex = [_healthyCertificateView.gender isEqualToString:@"男"]?0:1;
    _customerTestInfo.custIdCard = _healthyCertificateView.idCard;
    _customerTestInfo.bornDate = [_healthyCertificateView.idCard getLongLongBornDate];
    _customerTestInfo.jobDuty = _healthyCertificateView.workType;
    _customerTestInfo.linkPhone = _phoneNumTextView.text;
    _customerTestInfo.regPosAddr = _locationTextView.text;
    _customerTestInfo.cityName = gCurrentCityName; //预约城市
    
    [[HttpNetworkManager getInstance] createOrUpdatePersonalAppointment:_customerTestInfo resultBlock:^(NSDictionary *result, NSError *error) {
        if (error != nil){
            [RzAlertView showAlertLabelWithTarget:self.view Message:MakeAppointmentFailed removeDelay:2];
            return;
        }
        
        MethodResult *methodResult = [MethodResult mj_objectWithKeyValues:result];
        if (methodResult.succeed == NO || [methodResult.object isEqualToString:@"0"]){
            [RzAlertView showAlertLabelWithTarget:self.view Message:methodResult.errorMsg removeDelay:2];
            return;
        }

        //预约成功 获取编号
        if (_isAvatarSet == YES) //如果修改了图片,预约成功后要上传图片
        {
            [[HttpNetworkManager getInstance] customerUploadHealthyCertifyPhoto:self.healthyCertificateView.imageView.image CusCheckCode:methodResult.object resultBlock:^(NSDictionary *result, NSError *error) {
                if (error != nil){
                    [RzAlertView showAlertLabelWithTarget:self.view Message:UploadHealthyPicFailed removeDelay:2];
                    return;
                }
                MethodResult *methodResult = [MethodResult mj_objectWithKeyValues:result];
                if (methodResult.succeed == NO || [methodResult.object isEqualToString:@"0"]){
                    [RzAlertView showAlertLabelWithTarget:self.view Message:UploadHealthyPicFailed removeDelay:2];
                    return;
                }
                // 进入支付界面
                [self orderSuccessed:methodResult.object];
            }];
        }else{
            //如果没有修改图片，就不需要上传图片了 进入支付界面
            [self orderSuccessed:methodResult.object];
        }
    }];

}

-(void)QRScanButtonClicked:(UIButton*)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.showsCameraControls = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"开启摄像头权限后，才能使用该功能" removeDelay:2];
    }
}
#pragma mark - 订单成功之后提示在线支付窗口
// 订单成功提示框
- (void)orderSuccessed:(NSString *)checkcode
{
    __weak typeof(self) weakself = self;
    [[OrdersAlertView getinstance]openWithSuperView:self.view Message:nil withHandle:^(NSInteger flag) {
        if (flag == 1) {
            PayMoneyController *pay = [[PayMoneyController alloc]init];
            pay.chargetype = CUSTOMERTEST;
            pay.checkCode = checkcode;
            pay.cityName = weakself.cityName;
            pay.delegate = weakself;
            [weakself.navigationController pushViewController:pay animated:YES];
        }
        else {
            MyCheckListViewController* mycheckListViewController = [[MyCheckListViewController alloc] init];
            mycheckListViewController.popStyle = POPTO_ROOT;
            [weakself.navigationController pushViewController:mycheckListViewController animated:YES];
        }
    }];
}

#pragma mark -paymoney Delegate 支付款项之后的delegate
/**
 *  支付成功
 */
- (void)payMoneySuccessed{
    MyCheckListViewController* mycheckListViewController = [[MyCheckListViewController alloc] init];
    mycheckListViewController.popStyle = POPTO_ROOT;
    [self.navigationController pushViewController:mycheckListViewController animated:YES];
}
/**
 *  支付取消
 */
- (void)payMoneyCencel{
    MyCheckListViewController* mycheckListViewController = [[MyCheckListViewController alloc] init];
    mycheckListViewController.popStyle = POPTO_ROOT;
    [self.navigationController pushViewController:mycheckListViewController animated:YES];
}
/**
 *  支付失败
 */
- (void)payMoneyFail{
    NSLog(@"预约支付失败");
}


- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer
{
    if (![recognizer.view isKindOfClass:[UITextField class]]){
        [_phoneNumTextView resignFirstResponder];
    }
}

#pragma mark - HCWheelViewDelegate
-(void)sureBtnClicked:(NSString *)wheelText{
    self.healthyCertificateView.gender = wheelText;
    _sexWheel.hidden = YES;
}

-(void)cancelButtonClicked{
    _sexWheel.hidden = YES;
}

#pragma mark - UITextView Delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![self isPureInt:text]){
        return YES;
    }
    if (textView.text.length > 10){
        return NO;
    }else if (textView.text.length == 10){
        return YES;
    }else{
        return YES;
    }

}

#pragma mark - UITextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![self isPureInt:string]){
        return YES;
    }
    if (textField.text.length > 10){
        return NO;
    }else if (textField.text.length == 10){
        return YES;
    }else{
        return YES;
    }
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.isCustomerServerPoint == NO)
        return NO;
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//如果当前是tableView
        //做自己想做的事
        return NO;
    }
    return YES;
}

#pragma mark - HealthyCertificateViewDelegate
-(void)nameBtnClicked:(NSString *)name
{
    EditInfoViewController* editInfoViewController = [[EditInfoViewController alloc] init];
    editInfoViewController.editInfoType = EDITINFO_NAME;
    __weak typeof (self) wself = self;
    [editInfoViewController setEditInfoText:name WithBlock:^(NSString *resultStr) {
        wself.healthyCertificateView.name = resultStr;
    }];
    [self.navigationController pushViewController:editInfoViewController animated:YES];
    [wself hideTheKeyBoard];
}

-(void)sexBtnClicked:(NSString *)gender
{
    NSInteger index = 0;
    for (; index < _sexWheel.pickerViewContentArr.count; ++index){
        if ([gender isEqualToString:_sexWheel.pickerViewContentArr[index]])
            break;
    }
    [_sexWheel.pickerView selectRow:index inComponent:0 animated:NO];
    _sexWheel.hidden = NO;
}

-(void)industryBtnClicked:(NSString *)industry
{
    WorkTypeViewController* workTypeViewController = [[WorkTypeViewController alloc] init];
    workTypeViewController.workTypeStr = self.healthyCertificateView.workType;
    __weak typeof (self) wself = self;
    workTypeViewController.block = ^(NSString* resultStr){
        wself.healthyCertificateView.workType = resultStr;
    };
    [self.navigationController pushViewController:workTypeViewController animated:YES];
    [wself hideTheKeyBoard];
}

-(void)idCardBtnClicked:(NSString *)idCard
{
    EditInfoViewController* editInfoViewController = [[EditInfoViewController alloc] init];
    editInfoViewController.editInfoType = EDITINFO_IDCARD;
    __weak typeof (self) wself = self;
    [editInfoViewController setEditInfoText:idCard WithBlock:^(NSString *resultStr) {
        wself.healthyCertificateView.idCard = resultStr;
    }];
    [self.navigationController pushViewController:editInfoViewController animated:YES];
    [wself hideTheKeyBoard];
}

-(void)healthyImageClicked{
    __weak typeof (self) wself = self;
    [[TakePhoto getInstancetype] takePhotoFromCurrentController:self WithRatioOfWidthAndHeight:3.0/4.0 resultBlock:^(UIImage *photoimage) {
        photoimage = [TakePhoto scaleImage:photoimage withSize:CGSizeMake(wself.healthyCertificateView.imageView.frame.size.width,
                                                                          wself.healthyCertificateView.imageView.frame.size.height)];
        [wself.healthyCertificateView.imageView setImage:photoimage];
        __strong typeof(self) strongSelf = wself;
        strongSelf->_isAvatarSet = YES; //代表修改了健康证图片
    }];
    [wself hideTheKeyBoard];
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
    CGRect keyboardBounds;//UIKeyboardFrameEndUserInfoKey
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    _viewHeight = SCREEN_HEIGHT - keyboardBounds.size.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        if(_isCustomerServerPoint){
            self.parentViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, _viewHeight);
        }
        else {
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, _viewHeight);
        }
        [self.view layoutIfNeeded];
    } completion:NULL];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    CGRect keyboardBounds;//UIKeyboardFrameEndUserInfoKey
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (!_isCustomerServerPoint) {
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, _viewHeight + keyboardBounds.size.height);
        }
        else {
            self.parentViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, _viewHeight + keyboardBounds.size.height);
        }
        [self.view layoutIfNeeded];
    } completion:NULL];
}

-(void)loadData{
    //健康证照片相关
    if (_customerTestInfo != nil){
        //根据预约编号去请求图片
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@customerTest/getPrintPhoto?cCheckCode=%@", [HttpNetworkManager baseURL], _customerTestInfo.checkCode]];
        //这里要添加图片
        [_healthyCertificateView.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Avatar                                                                                                                                                                                                                                                                                                                                                                                                "] options:SDWebImageRefreshCached|SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error!=nil){}
        }];
    }
}

//YMIDCardRecognitionDelegate
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
            typeof(self) strongself = wself;
            if (!strongself->_waitAlertView) {
                strongself->_waitAlertView = [[RzAlertView alloc]initWithSuperView:wself.view Title:@"身份证信息解析中"];
            }
            [strongself->_waitAlertView show];
            [YMIDCardRecognition recongnitionWithCard:image delegate:wself];
        });
    });
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)recongnition:(YMIDCardRecognition *)YMIDCardRecognition didFailWithError:(NSError *)error
{
    [_waitAlertView close];
    [RzAlertView showAlertLabelWithTarget:self.view Message:@"身份证信息解析失败" removeDelay:2];
}
- (void)recongnition:(YMIDCardRecognition *)YMIDCardRecognition didRecognitionResult:(NSArray *)array
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_waitAlertView close];
        self.idCardInfo = array;
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

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

@end
