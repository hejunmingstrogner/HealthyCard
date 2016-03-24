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

#import "TakePhoto.h"
#import "HttpNetworkManager.h"
#import "PositionUtil.h"
#import "UIColor+Expanded.h"
#import "NSDate+Custom.h"
#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "AppointmentInfoView.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface PersonalHealthyCController()
{
    BOOL        _isAvatarSet;
    RzAlertView *waitAlertView;

    UIView      *containView;
    UILabel     *warmingLabel;

    BOOL        isChanged;

    UIImageView *tipIamgeView;
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
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    
    UIButton* editBtn = [UIButton buttonWithTitle:@"保存"
                                              font:[UIFont fontWithType:UIFontOpenSansRegular size:17]
                                         textColor:[UIColor colorWithRGBHex:HC_Blue_Text]
                                   backgroundColor:[UIColor clearColor]];
    [editBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
// 返回前一页
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if (_resultblock) {
        _resultblock(isChanged, _indexpathSection);
    }
}

- (void)dealloc
{
    NSLog(@"personhealthy dealloc");
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
    _customerTestInfo.regBeginDate = _regbegindate;
    _customerTestInfo.regEndDate = _regenddate;
    _customerTestInfo.sex = [_healthCertificateView.gender isEqualToString:@"男"]? 0 : 1;

    if(_isAvatarSet == YES){
        if(!waitAlertView){
            waitAlertView = [[RzAlertView alloc]initWithSuperView:self.view Title:@""];
        }
        waitAlertView.titleLabel.text = @"图片上传中...";
        [waitAlertView show];
        [[HttpNetworkManager getInstance]customerUploadHealthyCertifyPhoto:_healthCertificateView.imageView.image CusCheckCode:_customerTestInfo.checkCode resultBlock:^(NSDictionary *result, NSError *error) {
            sender.enabled = YES;
            if (!error) {
                [waitAlertView close];
                _isAvatarSet = NO;
                isChanged = YES;
                [[HttpNetworkManager getInstance]createOrUpdatePersonalAppointment:_customerTestInfo resultBlock:^(NSDictionary *result, NSError *error) {
                    if (!error) {
                        [RzAlertView showAlertLabelWithTarget:self.view Message:@"修改成功" removeDelay:2];
                    }
                    else {
                        [RzAlertView showAlertLabelWithTarget:self.view Message:@"修改失败,请检查网络后重试" removeDelay:2];
                    }
                }];
            }
            else {
                waitAlertView.titleLabel.text = @"图片上传失败，请检查网络后重试";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [waitAlertView close];
                });
            }
        }];
    }
    else {
        [[HttpNetworkManager getInstance]createOrUpdatePersonalAppointment:_customerTestInfo resultBlock:^(NSDictionary *result, NSError *error) {
            sender.enabled = YES;
            if (!error) {
                [RzAlertView showAlertLabelWithTarget:self.view Message:@"修改成功" removeDelay:2];
                isChanged = YES;
            }
            else {
                [RzAlertView showAlertLabelWithTarget:self.view Message:@"修改失败,请检查网络后重试" removeDelay:2];
            }
        }];
    }
}

- (void)setCustomerTestInfo:(CustomerTest *)customerTestInfo
{
    _customerTestInfo = customerTestInfo;
    _city = customerTestInfo.cityName;
    _address = customerTestInfo.regPosAddr;
    _posLo = customerTestInfo.regPosLO;
    _posLa = customerTestInfo.regPosLA;
    _linkerPhone = customerTestInfo.linkPhone;
    _regbegindate = customerTestInfo.regBeginDate;
    _regenddate = customerTestInfo.regEndDate;
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
        make.top.left.equalTo(containView).offset(10);
        make.width.equalTo(containView).offset(-20);
        make.height.mas_equalTo(PXFIT_HEIGHT(470));
    }];
    _healthCertificateView.layer.masksToBounds = YES;
    _healthCertificateView.delegate = self;
    _healthCertificateView.layer.cornerRadius = 10;

    // 预约信息
    _orderinforView = [[HealthyCertificateOrderInfoView alloc]initWithFrame:CGRectMake(10, 10+ PXFIT_HEIGHT(470) + 10, self.view.frame.size.width - 20, 200)];
    [containView addSubview:_orderinforView];
    [_orderinforView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_healthCertificateView);
        make.top.equalTo(_healthCertificateView.mas_bottom).offset(10);
        make.height.mas_equalTo(200);
    }];

    // 按钮的背景色
    UIView *btnBgView = [[UIView alloc]init];
    [containView addSubview:btnBgView];
    btnBgView.backgroundColor = [UIColor whiteColor];
    [btnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderinforView.mas_bottom).offset(10);
        make.left.right.equalTo(containView);
        make.height.mas_equalTo(80);
    }];
    // 按钮底部的分割线
    UILabel *fengexian = [[UILabel alloc]init];
    [btnBgView addSubview:fengexian];
    fengexian.backgroundColor = [UIColor colorWithRGBHex:HC_Gray_Egdes];
    [fengexian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnBgView).offset(20);
        make.right.equalTo(btnBgView).offset(-20);
        make.center.equalTo(btnBgView);
        make.height.mas_equalTo(1);
    }];

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

    // 详情介绍
    AppointmentInfoView *introduceView = [[AppointmentInfoView alloc]initWithFrame:CGRectMake(0, 10+ PXFIT_HEIGHT(470) + 10 + 210 , self.view.frame.size.width, 100)];
    [containView addSubview:introduceView];
    [introduceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(warmingLabel.mas_bottom).offset(10);
        make.left.right.equalTo(containView);
//        make.height.mas_equalTo(100);
        make.bottom.equalTo(containView).offset(-10);
    }];

    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.layer.masksToBounds = YES;
    _leftBtn.layer.cornerRadius = 4;
    [btnBgView addSubview:_leftBtn];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderinforView);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(80);
        make.centerY.equalTo(btnBgView);
    }];
    _leftBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [_leftBtn setTitle:@"已签到" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];

    tipIamgeView = [[UIImageView alloc]init];
    [containView addSubview:tipIamgeView];
    tipIamgeView.image = [UIImage imageNamed:@"tip"];
    [tipIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(21);
        make.height.mas_equalTo(10);
        make.centerX.equalTo(_leftBtn);
        make.bottom.equalTo(warmingLabel.mas_top).offset(1);
    }];

    _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _centerBtn.layer.masksToBounds = YES;
    _centerBtn.layer.cornerRadius = 4;
    [btnBgView addSubview:_centerBtn];
    [_centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_leftBtn);
        make.centerX.equalTo(btnBgView);
        make.width.equalTo(_leftBtn);
        make.height.mas_equalTo(35);
    }];
    _centerBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [_centerBtn setTitle:@"待检查" forState:UIControlStateNormal];
    [_centerBtn setTitleColor:[UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];

    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBgView addSubview:_rightBtn];
    _rightBtn.layer.masksToBounds = YES;
    _rightBtn.layer.cornerRadius = 4;
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_leftBtn);
        make.right.equalTo(_orderinforView);
        make.height.width.equalTo(_leftBtn);
    }];
    [_rightBtn setTitle:@"检查中" forState:UIControlStateNormal];
    _rightBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [_rightBtn setTitleColor:[UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
}

- (CGFloat)labelheigh:(NSString *)text
{
    UIFont *fnt = [UIFont systemFontOfSize:15];
    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];
    CGFloat he = tmpRect.size.height+15;
    return fmaxf(he, 20);
}

- (void)initData
{
    __weak PersonalHealthyCController *weakself = self;
    _healthCertificateView.customerTest = _customerTestInfo;
    _orderinforView.cutomerTest = _customerTestInfo;

    [_orderinforView.addressBtn addClickedBlock:^(UIButton * _Nonnull sender) {
        if (weakself.customerTestInfo.checkSiteID) {
            return ;
        }
        // 待检状态下可以修改信息，否则不可修改
        if (![weakself.customerTestInfo.testStatus isEqualToString:@"-1"]) {
            [RzAlertView showAlertLabelWithTarget:weakself.view Message:@"当前状态不能修改信息" removeDelay:3];
            return ;
        }
        // 服务点信息不可修改
        if (_orderinforView.segmentControl.selectedSegmentIndex != 0) {
            [RzAlertView showAlertLabelWithTarget:weakself.view Message:@"不能修改服务点信息" removeDelay:3];
            return ;
        }
        // 点击地址搜索
        [weakself selectAddress];
    }];
    [_orderinforView.timeBtn addClickedBlock:^(UIButton * _Nonnull sender) {
        if (weakself.customerTestInfo.checkSiteID) {
            return ;
        }
        // 待检状态下可以修改信息，否则不可修改
        if (![weakself.customerTestInfo.testStatus isEqualToString:@"-1"]) {
            [RzAlertView showAlertLabelWithTarget:weakself.view Message:@"当前状态不能修改信息" removeDelay:3];
            return ;
        }
        // 服务点信息不可修改
        if (_orderinforView.segmentControl.selectedSegmentIndex != 0) {
            [RzAlertView showAlertLabelWithTarget:weakself.view Message:@"不能修改服务点信息" removeDelay:3];
            return ;
        }
        // 点击时间
        CloudAppointmentDateVC *cloudData = [[CloudAppointmentDateVC alloc]init];
        // 时间
        NSArray *timearray = [sender.titleLabel.text componentsSeparatedByString:@"~"];
        if (timearray.count == 2) {
            cloudData.beginDateString = timearray[0];
            cloudData.endDateString = timearray[1];
        }
        else {
            cloudData.beginDateString =[[NSDate date] getDateStringWithInternel:1];
            cloudData.endDateString = [[NSDate date]getDateStringWithInternel:2];
        }
        [cloudData getAppointDateStringWithBlock:^(NSString *dateStr) {

            NSArray *timeslist = [dateStr componentsSeparatedByString:@"~"];
            weakself.regbegindate = [[NSDate formatDateFromChineseString:timeslist[0]] convertToLongLong]*1000;
            weakself.regenddate = [[NSDate formatDateFromChineseString:timeslist[1]] convertToLongLong]*1000;
            [sender setTitle:dateStr forState:UIControlStateNormal];
        }];
        [weakself.navigationController pushViewController:cloudData animated:YES];
    }];
    [_orderinforView.phoneBtn addClickedBlock:^(UIButton * _Nonnull sender) {
        // 点击电话
        NSLog(@"点击电话");
        // 待检状态下可以修改信息，否则不可修改
        if (![weakself.customerTestInfo.testStatus isEqualToString:@"-1"]) {
            [RzAlertView showAlertLabelWithTarget:weakself.view Message:@"当前状态不能修改信息" removeDelay:3];
            return ;
        }
        // 服务点信息不可修改
        if (_orderinforView.segmentControl.selectedSegmentIndex != 0) {
            [RzAlertView showAlertLabelWithTarget:weakself.view Message:@"不能修改服务点信息" removeDelay:3];
            return ;
        }
        EditInfoViewController* editInfoViewController = [[EditInfoViewController alloc] init];
        editInfoViewController.editInfoType = EDITINFO_LINKPHONE;
        [editInfoViewController setEditInfoText:weakself.linkerPhone WithBlock:^(NSString *resultStr) {
            weakself.linkerPhone = resultStr;
            [sender setTitle:resultStr forState:UIControlStateNormal];
        }];
        [weakself.navigationController pushViewController:editInfoViewController animated:YES];
    }];

    // 设置体检状态
    CustomerTestStatusItem *status = [_customerTestInfo getTestStatusWithTestStatus:_customerTestInfo.testStatus];

    [_leftBtn setTitle:status.leftText forState:UIControlStateNormal];
    [_centerBtn setTitle:status.centerText forState:UIControlStateNormal];
    [_rightBtn setTitle:status.rigthText forState:UIControlStateNormal];
    warmingLabel.text = status.warmingText;
    // 设置按钮颜色，以及提示信息
    switch (status.status) {
        case LEFT_STATUS:{
            [_leftBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue]];
            [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        }
        case CENTER_STATUS:{
            [_centerBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue]];
            [_centerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [tipIamgeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_centerBtn);
            }];
            break;
        }
        case RIGHT_STATUS:{
            [_rightBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue]];
            [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [tipIamgeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_rightBtn);
            }];
            break;
        }
        default:
            break;
    }

}

#pragma mark - HealthyCertificateViewDelegate
//点击姓名
-(void)nameBtnClicked:(NSString*)name
{
    if (![_customerTestInfo.testStatus isEqualToString:@"-1"]) {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"当前状态不能修改信息" removeDelay:3];
        return ;
    }
    EditInfoViewController* editInfoViewController = [[EditInfoViewController alloc] init];
    editInfoViewController.editInfoType = EDITINFO_NAME;
    __weak typeof (self) wself = self;
    [editInfoViewController setEditInfoText:name WithBlock:^(NSString *resultStr) {
        wself.healthCertificateView.name = resultStr;
    }];
    [self.navigationController pushViewController:editInfoViewController animated:YES];
}
//点击性别
-(void)sexBtnClicked:(NSString*)gender{
    if (![_customerTestInfo.testStatus isEqualToString:@"-1"]) {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"当前状态不能修改信息" removeDelay:3];
        return ;
    }

    NSInteger index = 0;
    for (; index < wheelView.pickerViewContentArr.count; ++index){
        if ([gender isEqualToString:wheelView.pickerViewContentArr[index]])
            break;
    }
    [wheelView.pickerView selectRow:index inComponent:0 animated:NO];
    wheelView.hidden = NO;
}

//点击行业
-(void)industryBtnClicked:(NSString*)industry{
    if (![_customerTestInfo.testStatus isEqualToString:@"-1"]) {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"当前状态不能修改信息" removeDelay:3];
        return ;
    }

    WorkTypeViewController* workTypeViewController = [[WorkTypeViewController alloc] init];
    __weak typeof (self) wself = self;
    workTypeViewController.block = ^(NSString* resultStr){
        wself.healthCertificateView.workType = resultStr;
    };
    [self.navigationController pushViewController:workTypeViewController animated:YES];
}
//点击身份证
-(void)idCardBtnClicked:(NSString*)idCard
{
    if (![_customerTestInfo.testStatus isEqualToString:@"-1"]) {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"当前状态不能修改信息" removeDelay:3];
        return ;
    }

    EditInfoViewController* editInfoViewController = [[EditInfoViewController alloc] init];
    editInfoViewController.editInfoType = EDITINFO_IDCARD;
    __weak typeof (self) wself = self;
    [editInfoViewController setEditInfoText:idCard WithBlock:^(NSString *resultStr) {
        wself.healthCertificateView.idCard = resultStr;
    }];
    [self.navigationController pushViewController:editInfoViewController animated:YES];
}

//点击健康证图片
-(void)healthyImageClicked;
{
    if (![_customerTestInfo.testStatus isEqualToString:@"-1"]) {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"当前状态不能修改信息" removeDelay:3];
        return ;
    }

    __weak typeof (self) wself = self;

    [[TakePhoto getInstancetype] takePhotoFromCurrentController:self WithRatioOfWidthAndHeight:3.0/4.0 resultBlock:^(UIImage *photoimage) {
        wself.healthCertificateView.imageView.image = photoimage;
        _isAvatarSet = YES; //代表修改了健康证图片
    }];
}

#pragma mark - HCWheelViewDelegate
-(void)sureBtnClicked:(NSString *)wheelText{
    self.healthCertificateView.gender = wheelText;
    wheelView.hidden = YES;
}

-(void)cancelButtonClicked{
    wheelView.hidden = YES;
}

- (void)selectAddress
{
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
@end
