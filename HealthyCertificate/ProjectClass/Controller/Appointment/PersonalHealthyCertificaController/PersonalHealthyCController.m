//
//  PersonalHealthyCController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/25.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//
#import <UIImageView+WebCache.h>

#import "PersonalHealthyCController.h"
#import "Constants.h"

#import "CloudAppointmentDateVC.h"
#import "EditInfoViewController.h"
#import "WorkTypeViewController.h"
#import "AppointmentInfoView.h"
#import "ScanImageViewController.h"
#import "TextViewTableViewCell.h"
#import "TemperaryServicePDeViewController.h"
#import "ServicePointDetailViewController.h"

#import "UIColor+Expanded.h"
#import "NSDate+Custom.h"
#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "NSString+Custom.h"

#import "HttpNetworkManager.h"
#import "PositionUtil.h"
#import "TakePhoto.h"
#import "MethodResult.h"
#import "PayMoneyController.h"

#import <MJExtension.h>

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface PersonalHealthyCController()<ScanImageViewDelegate, PayMoneyDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BOOL        _isAvatarSet;

    UIView      *containView;
    UILabel     *warmingLabel;

    BOOL        isChanged;

    UIImageView *tipIamgeView;
    
    BOOL        _nameChanged;
    BOOL        _sexChanged;
    BOOL        _idCardChanged;
    BOOL        _workTypeChanged;
    BOOL        _regTimeChanged;
    BOOL        _linkPhoneChanged;
    BOOL        _avarChanged;
    
    UITableView *_tableView;
}

@property (nonatomic, strong) UIButton                       *leftBtn;          // 左侧按钮
@property (nonatomic, strong) UIButton                       *centerBtn;   // 中间按钮
@property (nonatomic, strong) UIButton                       *rightBtn;      // 右侧按钮

@end

@implementation PersonalHealthyCController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initSubViews];

    [self initData];

    wheelView = [[HCWheelView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*2/3, self.view.frame.size.width, self.view.frame.size.height/3)];
    wheelView.pickerViewContentArr = [NSMutableArray arrayWithArray:@[@"男", @"女"]];
    wheelView.delegate = self;
    wheelView.hidden = YES;
    [self.view addSubview:wheelView];

    isChanged = NO;
}

- (void)initNavgation
{
    self.title = @"办证详情";
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    if ([_customerTestInfo.testStatus isEqualToString:@"-1"]){
        UIButton* editBtn = [UIButton buttonWithTitle:@"保存"
                                                 font:[UIFont fontWithType:UIFontOpenSansRegular size:17]
                                            textColor:[UIColor colorWithRGBHex:HC_Blue_Text]
                                      backgroundColor:[UIColor clearColor]];
        [editBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if (_resultblock) {
        _resultblock(isChanged, _indexpathSection);
    }
}

- (void)changedInformationWithResultBlock:(ResultBlock)blcok
{
    _resultblock = blcok;
}

- (void)rightBtnClicked:(UIButton *)sender
{
    if (![_customerTestInfo.testStatus isEqualToString:@"-1"] || _customerTestInfo == nil) {
        [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"对不起，现在不能修改信息" ActionTitle:@"明白了" ActionStyle:UIAlertActionStyleDefault];
        return ;
    }
    sender.enabled = NO;

    _customerTestInfo.custName = _healthCertificateView.name;
    _customerTestInfo.custIdCard = _healthCertificateView.idCard;
    _customerTestInfo.linkPhone = _linkerPhone;
    _customerTestInfo.jobDuty = _healthCertificateView.workType;
    _customerTestInfo.regPosLO = _posLo;
    _customerTestInfo.regPosLA = _posLa;
    if (_customerTestInfo.servicePoint.type == 0)
        _customerTestInfo.regTime = _regTime * 1000;
    _customerTestInfo.sex = [_healthCertificateView.gender isEqualToString:@"男"]? 0 : 1;

    if(_isAvatarSet == YES){
        [RzAlertView ShowWaitAlertWithTitle:@"图片上传中..."];
        [[HttpNetworkManager getInstance]customerUploadHealthyCertifyPhoto:_healthCertificateView.imageView.image CusCheckCode:_customerTestInfo.checkCode resultBlock:^(NSDictionary *result, NSError *error) {
            sender.enabled = YES;
            if (!error) {
                [RzAlertView CloseWaitAlert];
                isChanged = YES;
                _avarChanged = NO;
                [[HttpNetworkManager getInstance]createOrUpdatePersonalAppointment:_customerTestInfo resultBlock:^(NSDictionary *result, NSError *error) {
                    [self resetStatus];
                    if (!error) {
                        MethodResult *resultdict = [MethodResult mj_objectWithKeyValues:result];
                        if (resultdict.succeed){
                            [RzAlertView showAlertLabelWithTarget:self.view Message:@"修改成功" removeDelay:2];
                        }else{
                            if ([resultdict.object isEqualToString:@"0"]) {
                                [RzAlertView showAlertLabelWithTarget:self.view Message:@"异常失败，请重试" removeDelay:2];
                            }
                            else if([resultdict.object isEqualToString:@"1"]){
                                [RzAlertView showAlertLabelWithTarget:self.view Message:@"修改次数已达上限" removeDelay:2];
                            }else{
                                [RzAlertView showAlertLabelWithTarget:self.view Message:@"更新体检信息失败" removeDelay:2];
                            }
                        }

                    }
                    else {
                        [RzAlertView showAlertLabelWithTarget:self.view Message:@"修改失败,请检查网络后重试" removeDelay:2];
                    }
                }];
            }
            else {
                [RzAlertView CloseWaitAlert];
                [RzAlertView showAlertLabelWithMessage:@"图片上传失败，请检查网络后重试" removewDelay:3];
                _isAvatarSet = NO;
            }
        }];
    }
    else {
        [[HttpNetworkManager getInstance]createOrUpdatePersonalAppointment:_customerTestInfo resultBlock:^(NSDictionary *result, NSError *error) {
            sender.enabled = YES;
            if (!error) {
                MethodResult *resultdict = [MethodResult mj_objectWithKeyValues:result];
                if (resultdict.succeed){
                    [RzAlertView showAlertLabelWithTarget:self.view Message:@"修改成功" removeDelay:2];
                    isChanged = YES;
                }else{
                    if ([resultdict.object isEqualToString:@"0"]) {
                        [RzAlertView showAlertLabelWithTarget:self.view Message:@"异常失败，请重试" removeDelay:2];
                    }
                    else if([resultdict.object isEqualToString:@"1"]){
                        [RzAlertView showAlertLabelWithTarget:self.view Message:@"修改次数已达上限" removeDelay:2];
                    }else{
                        [RzAlertView showAlertLabelWithTarget:self.view Message:@"更新体检信息失败" removeDelay:2];
                    }
                }
            }
            else {
                [RzAlertView showAlertLabelWithTarget:self.view Message:@"修改失败,请检查网络后重试" removeDelay:2];
            }
        }];
    }
}

- (void)initSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];

    _baseBgScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_baseBgScrollView];
    _baseBgScrollView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:0.9];
    [_baseBgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    containView = [[UIView alloc]init];
    containView.backgroundColor = [UIColor clearColor];
    [_baseBgScrollView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_baseBgScrollView);
        make.width.equalTo(_baseBgScrollView);
    }];

    // 健康证信息
    _healthCertificateView = [[HealthyCertificateView alloc]init];
    [containView addSubview:_healthCertificateView];
    [_healthCertificateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containView).offset(10);
        make.left.equalTo(containView).offset(10);
        make.width.equalTo(containView).offset(-20);
        make.height.mas_equalTo(PXFIT_HEIGHT(470));
    }];
    _healthCertificateView.layer.masksToBounds = YES;
    _healthCertificateView.delegate = self;
    _healthCertificateView.layer.cornerRadius = 10;
    
    
    //体检信息
    _tableView = [[UITableView alloc] init];
    [containView addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    [_tableView registerClass:[TextViewTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TextViewTableViewCell class])];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(containView);
        make.top.equalTo(_healthCertificateView.mas_bottom).with.offset(10);
        make.height.mas_equalTo(PXFIT_HEIGHT(100) * 3 + PXFIT_HEIGHT(100) * (_customerTestInfo.servicePoint == nil ? 2 : 3) + 20);
    }];

    // 三个状态按钮的view
    UIView *btnBgView = [[UIView alloc]init];
    [containView addSubview:btnBgView];
    btnBgView.backgroundColor = [UIColor whiteColor];
    [btnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom).offset(10);
        make.left.right.equalTo(containView);
        make.height.mas_equalTo(80);
    }];
    
    UILabel *lineLab = [[UILabel alloc]init];
    [btnBgView addSubview:lineLab];
    lineLab.backgroundColor = [UIColor colorWithRGBHex:HC_Gray_Egdes];
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(btnBgView).with.offset(10);
        make.right.mas_equalTo(btnBgView).with.offset(-10);
        make.center.equalTo(btnBgView);
        make.height.mas_equalTo(1);
    }];
    
    _leftBtn = [[UIButton alloc] init];
    _leftBtn.layer.masksToBounds = YES;
    _leftBtn.layer.cornerRadius = 4;
    [btnBgView addSubview:_leftBtn];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnBgView).with.offset(10);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(80);
        make.centerY.equalTo(btnBgView);
    }];
    
    _centerBtn = [[UIButton alloc] init];
    _centerBtn.layer.masksToBounds = YES;
    _centerBtn.layer.cornerRadius = 4;
    [btnBgView addSubview:_centerBtn];
    [_centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(btnBgView);
        make.width.height.equalTo(_leftBtn);
    }];
    
    _rightBtn = [[UIButton alloc] init];
    [btnBgView addSubview:_rightBtn];
    _rightBtn.layer.masksToBounds = YES;
    _rightBtn.layer.cornerRadius = 4;
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnBgView);
        make.right.equalTo(btnBgView).with.offset(-10);
        make.height.width.equalTo(_leftBtn);
    }];
    _leftBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [_leftBtn setTitleColor:[UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
    
    _centerBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [_centerBtn setTitleColor:[UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
    
    _rightBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [_rightBtn setTitleColor:[UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
    
    UIView *warmBg = [[UIView alloc]init];
    [containView addSubview:warmBg];
    warmBg.layer.masksToBounds = YES;
    warmBg.backgroundColor = [UIColor whiteColor];
    warmBg.layer.cornerRadius = 4;
    warmBg.layer.borderWidth = 1;
    warmBg.layer.borderColor = [UIColor colorWithRGBHex:0xff9d12].CGColor;
    
    // 提示信息label
    warmingLabel = [[UILabel  alloc]init];
    [containView addSubview:warmingLabel];
    warmingLabel.numberOfLines = 0;
    warmingLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:14];
    [warmingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnBgView.mas_bottom);
        make.left.equalTo(btnBgView).offset(10);
        make.right.equalTo(btnBgView).offset(-10);
        make.height.mas_equalTo(70);
    }];
    
    [warmBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(warmingLabel);
        make.left.right.equalTo(containView);
    }];
    
    tipIamgeView = [[UIImageView alloc]init];
    [containView addSubview:tipIamgeView];
    tipIamgeView.image = [UIImage imageNamed:@"tip"];
    [tipIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_leftBtn);
        make.bottom.equalTo(warmingLabel.mas_top).offset(1);
    }];

    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(warmBg.mas_bottom).offset(10);
    }];
}

- (void)initData
{
    _healthCertificateView.customerTest = _customerTestInfo;
    
    // 设置体检状态
    CustomerTestStatusItem *status = [_customerTestInfo getTestStatusItem];
    
    [_leftBtn setTitle:status.leftText forState:UIControlStateNormal];
    [_centerBtn setTitle:status.centerText forState:UIControlStateNormal];
    [_rightBtn setTitle:status.rigthText forState:UIControlStateNormal];
    warmingLabel.text = status.warmingText;
    // 设置按钮颜色，以及提示信息
    switch (status.status) {
        case LEFT_STATUS:{
            [_leftBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue]];
            [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            _rightBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
            [_rightBtn setTitleColor:[UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
            
            _centerBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
            [_centerBtn setTitleColor:[UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
            
            [tipIamgeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_leftBtn);
                make.bottom.equalTo(warmingLabel.mas_top).offset(1);
            }];
            break;
        }
        case CENTER_STATUS:{
            [_centerBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue]];
            [_centerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            _rightBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
            [_rightBtn setTitleColor:[UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
            
            _leftBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
            [_leftBtn setTitleColor:[UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
            
            [tipIamgeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_centerBtn);
                make.bottom.equalTo(warmingLabel.mas_top).offset(1);
            }];
            break;
        }
        case RIGHT_STATUS:{
            [_rightBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue]];
            [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            
            _leftBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
            [_leftBtn setTitleColor:[UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
            
            _centerBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
            [_centerBtn setTitleColor:[UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
            [tipIamgeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_rightBtn);
                make.bottom.equalTo(warmingLabel.mas_top).offset(1);
            }];
            break;
        }
        default:
            break;
    }
    
    if (![_customerTestInfo.testStatus isEqualToString:@"-1"]){
        //只要不是待检状态，都不能修改信息
        _healthCertificateView.userInteractionEnabled = NO;
        _healthCertificateView.inputColor = [UIColor colorWithRGBHex:HC_Gray_Text];
        return;
    }
}

#pragma mark - Setter & Getter
- (void)setCustomerTestInfo:(CustomerTest *)customerTestInfo
{
    _customerTestInfo = customerTestInfo;
    _city = customerTestInfo.cityName;
    _address = customerTestInfo.regPosAddr;
    _posLo = customerTestInfo.regPosLO;
    _posLa = customerTestInfo.regPosLA;
    _linkerPhone = customerTestInfo.linkPhone;
    
    if (customerTestInfo.servicePoint.type == 0)
        _regTime = customerTestInfo.regTime;
}


#pragma mark - HealthyCertificateViewDelegate
-(void)nameBtnClicked:(NSString*)name{
    EditInfoViewController* editInfoViewController = [[EditInfoViewController alloc] init];
    editInfoViewController.editInfoType = EDITINFO_NAME;
    __weak typeof (self) wself = self;
    [editInfoViewController setEditInfoText:name WithBlock:^(NSString *resultStr) {
        if (![_customerTestInfo.custName isEqualToString:name]){
            _nameChanged = YES;
        }else{
            _nameChanged = NO;
        }
        wself.healthCertificateView.name = resultStr;
    }];
    [self.navigationController pushViewController:editInfoViewController animated:YES];
}

-(void)sexBtnClicked:(NSString*)gender{
    NSInteger index = 0;
    for (; index < wheelView.pickerViewContentArr.count; ++index){
        if ([gender isEqualToString:wheelView.pickerViewContentArr[index]])
            break;
    }
    [wheelView.pickerView selectRow:index inComponent:0 animated:NO];
    wheelView.hidden = NO;
}

-(void)industryBtnClicked:(NSString*)industry{
    WorkTypeViewController* workTypeViewController = [[WorkTypeViewController alloc] init];
    __weak typeof (self) wself = self;
    workTypeViewController.block = ^(NSString* resultStr){
        if (![_customerTestInfo.jobDuty isEqualToString:resultStr]){
            _workTypeChanged = YES;
        }else{
            _workTypeChanged = NO;
        }
        wself.healthCertificateView.workType = resultStr;
    };
    [self.navigationController pushViewController:workTypeViewController animated:YES];
}

-(void)idCardBtnClicked:(NSString*)idCard{
    EditInfoViewController* editInfoViewController = [[EditInfoViewController alloc] init];
    editInfoViewController.editInfoType = EDITINFO_IDCARD;
    __weak typeof (self) wself = self;
    [editInfoViewController setEditInfoText:idCard WithBlock:^(NSString *resultStr) {
        if (![_customerTestInfo.custIdCard isEqualToString:resultStr]){
            _idCardChanged = YES;
        }else{
            _idCardChanged = NO;
        }
        wself.healthCertificateView.idCard = resultStr;
    }];
    [self.navigationController pushViewController:editInfoViewController animated:YES];
}

-(void)healthyImageClicked{
    __weak typeof (self) wself = self;
    [[TakePhoto getInstancetype] takePhotoFromCurrentController:self WithRatioOfWidthAndHeight:3.0/4.0 resultBlock:^(UIImage *photoimage) {
        wself.healthCertificateView.imageView.image = photoimage;
        _isAvatarSet = YES;
        _avarChanged = YES;
    }];
}

-(void)avatarSetted{
    _isAvatarSet = YES;
}

#pragma mark - HCWheelViewDelegate
-(void)sureBtnClicked:(NSString *)wheelText{
    //Byte 客户性别 0:男 1:女
    Byte gender = [wheelText isEqualToString:@"男"] ? 0 : 1 ;
    if (_customerTestInfo.sex != gender){
        _sexChanged = YES;
    }else{
        _sexChanged = NO;
    }
    self.healthCertificateView.gender = wheelText;
    wheelView.hidden = YES;
}

-(void)cancelButtonClicked{
    wheelView.hidden = YES;
}

- (void)selectAddress{
    SelectAddressViewController *addressselect = [[SelectAddressViewController alloc]init];
    addressselect.addressStr = _orderinforView.addressBtn.titleLabel.text;
    [addressselect getAddressArrayWithBlock:^(NSString *city, NSString *district, NSString *address, CLLocationCoordinate2D coor) {
        self.city = city;
        self.address = [NSString stringWithFormat:@"%@%@%@", city, district, address];
        self.posLa = coor.latitude;
        self.posLo = coor.longitude;
        [_orderinforView.addressBtn setTitle:address forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:addressselect animated:YES];
}


#pragma mark - Action
- (void)codeButtonClicked:(UIButton *)sender
{
    //如果本地有修改，需要先执行保存操作
    if (_nameChanged || _sexChanged || _idCardChanged || _workTypeChanged || _avarChanged || _regTimeChanged || _linkPhoneChanged){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"请保存修改信息后绑定条形码" removeDelay:3];
        return;
    }
    
    //必须上传头像以后才能执行条码的扫描操作
    if (_isAvatarSet == NO){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"请先上传头像" removeDelay:2];
        return;
    }
    
    ScanImageViewController* scanImageVC = [[ScanImageViewController alloc] init];
    scanImageVC.delegate = self;
    [self presentViewController:scanImageVC animated:YES completion:nil];
}

- (void)paymoneyClicked:(UIButton *)sender
{
    if (![_customerTestInfo isNeedToPay]) {
        return;
    }
    PayMoneyController *pay = [[PayMoneyController alloc]init];
    pay.chargetype = CUSTOMERTEST;
    pay.checkCode = _customerTestInfo.checkCode;
    pay.cityName = _customerTestInfo.cityName;
    pay.delegate = self;
    [self.navigationController pushViewController:pay animated:YES];
}

#pragma mark -支付的完成回调
#pragma mark -paymoney Delegate 支付款项之后的delegate
- (void)payMoneySuccessed{
    [RzAlertView showAlertLabelWithTarget:self.view Message:@"您的预约支付已完成" removeDelay:2];
    isChanged = YES;
    
    NSIndexPath *indexPath;
    if (_customerTestInfo.servicePoint != nil){
        indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    }else{
        indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    }
    [_tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"已支付";
    [_tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

- (void)payMoneyCencel{
    [RzAlertView showAlertLabelWithTarget:self.view Message:@"您取消了支付" removeDelay:2];
}

- (void)payMoneyFail{
    NSLog(@"预约支付失败");
}

- (void)payMoneyByOthers
{}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 3;
    }else{
        return _customerTestInfo.servicePoint == nil ? 2 : 3;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PXFIT_HEIGHT(100);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        TextViewTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextViewTableViewCell class])];
        if ( [cell respondsToSelector:@selector(setSeparatorInset:)] )
            [cell setSeparatorInset:UIEdgeInsetsZero];
        if ( [cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)] )
            [cell setPreservesSuperviewLayoutMargins:NO];
        if ( [cell respondsToSelector:@selector(setLayoutMargins:)] )
            [cell setLayoutMargins:UIEdgeInsetsZero];
        cell.textView.userInteractionEnabled = NO;
        if (indexPath.row == 0){
             cell.titleText = @"体检时间";
            if (_customerTestInfo.servicePoint == nil || _customerTestInfo.servicePoint.type == 0){
                //单位统一预约或固定服务点
                cell.textView.text = [NSDate converLongLongToChineseStringDateWithHour:_customerTestInfo.regTime/1000];
                if (_customerTestInfo.servicePoint == nil){
                    //单位统一预约不可修改时间
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.textView.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
                }else{
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textView.textColor = [UIColor blackColor];
                }
            }else{
                NSString *year = [NSDate getYear_Month_DayByDate:_customerTestInfo.servicePoint.startTime/1000];
                NSString *start = [NSDate getHour_MinuteByDate:_customerTestInfo.servicePoint.startTime/1000];
                NSString *end = [NSDate getHour_MinuteByDate:_customerTestInfo.servicePoint.endTime/1000];
                NSString *timestatus = [NSString stringWithFormat:@"%@(%@~%@)", year, start, end];
                cell.textView.text = timestatus;
                cell.textView.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }else if (indexPath.row == 1){
            cell.titleText = @"体检位置";
            cell.textView.text = _customerTestInfo.regPosAddr;
            cell.textView.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
        }else{
            cell.titleText = @"联系电话";
            cell.textView.text = _customerTestInfo.linkPhone;
            cell.textView.textColor = [UIColor blackColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (![_customerTestInfo.testStatus isEqualToString:@"-1"]){
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textView.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
        }
        return cell;
    }else{
        UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        }
        cell.textLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
        if ( [cell respondsToSelector:@selector(setSeparatorInset:)] )
            [cell setSeparatorInset:UIEdgeInsetsZero];
        if ( [cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)] )
            [cell setPreservesSuperviewLayoutMargins:NO];
        if ( [cell respondsToSelector:@selector(setLayoutMargins:)] )
            [cell setLayoutMargins:UIEdgeInsetsZero];
        cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(25)];
        cell.detailTextLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)];
        if (_customerTestInfo.servicePoint != nil){
            if (indexPath.row == 0){
                cell.imageView.image = [UIImage imageNamed:@"ExamServerPoint"];
                cell.textLabel.text = @"体检点详情";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if (indexPath.row == 1){
                cell.imageView.image = [UIImage imageNamed:@"tiaoxingma"];
                cell.textLabel.text = @"条形码绑定";
                cell.detailTextLabel.text = _customerTestInfo.cardNo == nil ? @"" : _customerTestInfo.cardNo;
                if (![_customerTestInfo.testStatus isEqualToString:@"-1"]){
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            }else{
                cell.imageView.image = [UIImage imageNamed:@"zhifuqingkuang"];
                cell.textLabel.text = @"支付情况";
                if ([_customerTestInfo isNeedToPay]){
                    cell.detailTextLabel.text = @"在线支付";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.detailTextLabel.text = @"已支付";
                    cell.accessoryType =  UITableViewCellAccessoryNone;
                }
            }
        }else{
            if (indexPath.row == 0){
                cell.imageView.image = [UIImage imageNamed:@"tiaoxingma"];
                cell.textLabel.text = @"条形码绑定";
                cell.detailTextLabel.text = _customerTestInfo.cardNo == nil ? @"" : _customerTestInfo.cardNo;
                if (![_customerTestInfo.testStatus isEqualToString:@"-1"]){
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            }else{
                cell.imageView.image = [UIImage imageNamed:@"zhifuqingkuang"];
                cell.textLabel.text = @"支付情况";
                if ([_customerTestInfo isNeedToPay]){
                    cell.detailTextLabel.text = @"在线支付";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.detailTextLabel.text = @"已支付";
                    cell.accessoryType =  UITableViewCellAccessoryNone;
                }
            }
        }
        return cell;
    }
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        TextViewTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row == 0){
            if (_customerTestInfo.servicePoint == nil || _customerTestInfo.servicePoint.type == 1){
            }else{
                CloudAppointmentDateVC *cloudData = [[CloudAppointmentDateVC alloc]init];
                cloudData.choosetDateStr = cell.textView.text;
                [cloudData getAppointDateStringWithBlock:^(NSString *dateStr) {
                    cell.textView.text = dateStr;
                    _regTime = [[NSDate formatDateFromChineseStringWithHour:dateStr] convertToLongLong];
                    if (_regTime != _customerTestInfo.regTime)
                        _regTimeChanged = YES;
                    else
                        _regTimeChanged = NO;
                }];
                [self.navigationController pushViewController:cloudData animated:YES];
            }
        }else if (indexPath.row == 2){
            EditInfoViewController* editInfoViewController = [[EditInfoViewController alloc] init];
            editInfoViewController.editInfoType = EDITINFO_LINKPHONE;
            [editInfoViewController setEditInfoText:_linkerPhone WithBlock:^(NSString *resultStr) {
                _linkerPhone = resultStr;
                cell.textView.text = _linkerPhone;
                if (![resultStr isEqualToString:_customerTestInfo.linkPhone]){
                    _linkPhoneChanged = YES;
                }else{
                    _linkPhoneChanged = NO;
                }
            }];
            [self.navigationController pushViewController:editInfoViewController animated:YES];
        }
    }else{
        TextViewTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.textLabel.text isEqualToString:@"体检点详情"]){
            if (_customerTestInfo.servicePoint.type == 0){
                ServicePointDetailViewController* servicePointDetail = [[ServicePointDetailViewController alloc] init];
                servicePointDetail.serverPositionItem = _customerTestInfo.servicePoint;
                servicePointDetail.hideOrderBtn = YES;
                [self.navigationController pushViewController:servicePointDetail animated:YES];
            }else{
                TemperaryServicePDeViewController* temperaryServicePDeViewController = [[TemperaryServicePDeViewController alloc] init];
                temperaryServicePDeViewController.servicePositionItem = _customerTestInfo.servicePoint;
                temperaryServicePDeViewController.hideOrderBtn = YES;
                [self.navigationController pushViewController:temperaryServicePDeViewController animated:YES];
            }
        }else if ([cell.textLabel.text isEqualToString:@"条形码绑定"]){
            if (![_customerTestInfo.testStatus isEqualToString:@"-1"]){
                return;
            }
            //如果本地有修改，需要先执行保存操作
            if (_nameChanged || _sexChanged || _idCardChanged || _workTypeChanged || _avarChanged || _regTimeChanged || _linkPhoneChanged){
                [RzAlertView showAlertLabelWithTarget:self.view Message:@"请保存修改信息后绑定条形码" removeDelay:3];
                return;
            }
            
            //必须上传头像以后才能执行条码的扫描操作
            if (_isAvatarSet == NO){
                [RzAlertView showAlertLabelWithTarget:self.view Message:@"请先上传头像" removeDelay:2];
                return;
            }
            
            ScanImageViewController* scanImageVC = [[ScanImageViewController alloc] init];
            scanImageVC.delegate = self;
            [self presentViewController:scanImageVC animated:YES completion:nil];
        }else{
            if (![_customerTestInfo isNeedToPay]) {
                return;
            }
            PayMoneyController *pay = [[PayMoneyController alloc]init];
            pay.chargetype = CUSTOMERTEST;
            pay.checkCode = _customerTestInfo.checkCode;
            pay.cityName = _customerTestInfo.cityName;
            pay.delegate = self;
            [self.navigationController pushViewController:pay animated:YES];
        }
    }
}




#pragma mark - ScanImageViewDelegate
-(void)reportScanResult:(NSString *)resultStr
{
    //条码是14位，规则为前4位为分部编号，接着两位为年份，后面8位为顺序号。
    if (![[resultStr substringWithRange:NSMakeRange(0, 4)] isEqualToString:_customerTestInfo.hosCode] ||
        ![[[[NSDate date] getYear] substringWithRange:NSMakeRange(2, 2)] isEqualToString:[resultStr substringWithRange:NSMakeRange(4, 2)]]){
        [RzAlertView showAlertLabelWithMessage:@"条码格式不匹配" removewDelay:2];
        return;
    }
   [[HttpNetworkManager getInstance] customerAffirmByCardNo:_customerTestInfo.checkCode CardNo:resultStr resultBlock:^(NSDictionary *result, NSError *error) {
       if (error){
          [RzAlertView showAlertLabelWithTarget:self.view Message:@"网络连接错误，请检查设置" removeDelay:2];
           return;
       }
       if (result != nil && error == nil){
           CustomerTest* customerTest = [CustomerTest mj_objectWithKeyValues:result];
           _customerTestInfo = customerTest;
           isChanged = YES;
           [self initData];
           self.navigationItem.rightBarButtonItem = nil;
       }
   }];
}

#pragma mark - Private Methods
-(void)resetStatus
{
    _nameChanged = NO;
    _sexChanged = NO;
    _idCardChanged = NO;
    _workTypeChanged = NO;
    _avarChanged = NO;
    _regTimeChanged = NO;
    _linkPhoneChanged = NO;
}

@end
