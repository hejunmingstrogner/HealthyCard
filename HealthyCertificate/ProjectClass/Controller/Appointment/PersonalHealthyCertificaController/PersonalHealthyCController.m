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
}

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
}

- (void)initNavgation
{
    self.title = @"我的健康证";
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;

    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setTitle:@"修改" forState:UIControlStateNormal];
    right.frame = CGRectMake(0, 0, 40, 40);
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:17];
    [right addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBtn;
}
// 返回前一页
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked:(id)sender
{
    if (![_customerTestInfo.testStatus isEqualToString:@"-1"] || _customerTestInfo == nil) {
        [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"对不起，现在不能修改信息" ActionTitle:@"明白了" ActionStyle:UIAlertActionStyleDefault];
        return ;
    }
    _customerTestInfo.custName = _healthCertificateView.name;
    _customerTestInfo.custIdCard = _healthCertificateView.idCard;
    _customerTestInfo.linkPhone = _linkerPhone;
    _customerTestInfo.jobDuty = _healthCertificateView.workType;
    _customerTestInfo.regPosLO = _posLo;
    _customerTestInfo.regPosLA = _posLa;
    _customerTestInfo.regBeginDate = _regbegindate;
    _customerTestInfo.regEndDate = _regenddate;
    _customerTestInfo.sex = [_healthCertificateView.gender isEqualToString:@"男"]? '0':'1';

    if(_isAvatarSet == YES){
        if(!waitAlertView){
            waitAlertView = [[RzAlertView alloc]initWithSuperView:self.view Title:@""];
        }
        waitAlertView.titleLabel.text = @"图片上传中...";
        [waitAlertView show];
        [[HttpNetworkManager getInstance]customerUploadHealthyCertifyPhoto:_healthCertificateView.imageView.image CusCheckCode:_customerTestInfo.checkCode resultBlock:^(NSDictionary *result, NSError *error) {
            if (!error) {
                [waitAlertView close];
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
            if (!error) {
                [RzAlertView showAlertLabelWithTarget:self.view Message:@"修改成功" removeDelay:2];
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

    // 详情介绍
    AppointmentInfoView *introduceView = [[AppointmentInfoView alloc]initWithFrame:CGRectMake(0, 10+ PXFIT_HEIGHT(460) + 10 + 210 , self.view.frame.size.width, 100)];

    CGFloat heights = introduceView.frame.size.height + 10;
    _baseBgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, PXFIT_HEIGHT(460) + 200 + heights + 90);  // 80待修改 [self labelHeight:介绍]

    _healthCertificateView = [[HealthyCertificateView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, PXFIT_HEIGHT(460))];
    [_baseBgScrollView addSubview:_healthCertificateView];
    _healthCertificateView.layer.masksToBounds = YES;
    _healthCertificateView.delegate = self;
    _healthCertificateView.layer.cornerRadius = 10;

    _orderinforView = [[HealthyCertificateOrderInfoView alloc]initWithFrame:CGRectMake(10, 10+ PXFIT_HEIGHT(460) + 10, self.view.frame.size.width - 20, 200)];
    [_baseBgScrollView addSubview:_orderinforView];


    [_baseBgScrollView addSubview:introduceView];

    // 按钮的背景色
    UIView *btnBgView = [[UIView alloc]init];
    [_baseBgScrollView addSubview:btnBgView];
    btnBgView.backgroundColor = [UIColor whiteColor];
    // 按钮底部的分割线
    UILabel *fengexian = [[UILabel alloc]init];
    [_baseBgScrollView addSubview:fengexian];
    fengexian.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];

    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.layer.masksToBounds = YES;
    _leftBtn.layer.cornerRadius = 4;
    [_baseBgScrollView addSubview:_leftBtn];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderinforView);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(80);
        make.centerY.equalTo(btnBgView);
    }];
    _leftBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [_leftBtn setTitle:@"已签到" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];

    _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _centerBtn.layer.masksToBounds = YES;
    _centerBtn.layer.cornerRadius = 4;
    [_baseBgScrollView addSubview:_centerBtn];
    [_centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_leftBtn);
        make.centerX.equalTo(_baseBgScrollView);
        make.width.equalTo(_leftBtn);
        make.height.mas_equalTo(45);
    }];
    _centerBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [_centerBtn setTitle:@"待检查" forState:UIControlStateNormal];
    [_centerBtn setTitleColor:[UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];

    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_baseBgScrollView addSubview:_rightBtn];
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


    [btnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_centerBtn);
        make.left.right.equalTo(self.view);
        make.top.equalTo(introduceView.mas_bottom);
//        make.bottom.equalTo(_centerBtn).offset(10);
        make.height.mas_equalTo(80);
    }];
    [fengexian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftBtn.mas_right).offset(-5);
        make.right.equalTo(_rightBtn.mas_left).offset(5);
        make.center.equalTo(_centerBtn);
        make.height.mas_equalTo(2);
    }];
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

    __weak CustomButton *addressBtns = _orderinforView.addressBtn;
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
        SelectAddressViewController *addressselect = [[SelectAddressViewController alloc]init];
        [addressselect getAddressArrayWithBlock:^(NSString *city, NSString *district, NSString *address, CLLocationCoordinate2D coor) {
            weakself.city = city;
            weakself.address = [NSString stringWithFormat:@"%@%@%@", city, district, address];
            // 地址转换为gps坐标
            PositionUtil *position = [[PositionUtil alloc]init];
            coor = [position bd2wgs:coor.latitude lon:coor.longitude];
            weakself.posLa = coor.latitude;
            weakself.posLo = coor.longitude;
            [addressBtns setTitle:address forState:UIControlStateNormal];
        }];
        [weakself.navigationController pushViewController:addressselect animated:YES];
    }];
    __weak CustomButton *weaktimeBtn = _orderinforView.timeBtn;
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
        NSArray *timearray = [weaktimeBtn.titleLabel.text componentsSeparatedByString:@"~"];
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
            weakself.regbegindate = [[NSDate formatDateFromChineseString:timeslist[0]] convertToLongLong];
            weakself.regenddate = [[NSDate formatDateFromChineseString:timeslist[1]] convertToLongLong];
            [weaktimeBtn setTitle:dateStr forState:UIControlStateNormal];
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
        }];
        [weakself.navigationController pushViewController:editInfoViewController animated:YES];
    }];

    NSArray *arry0 = @[@"待检查", @"已签到", @"检查中"];
    NSArray *arry1 = @[@"待检查", @"已签到", @"检查中"];
    NSArray *arry2 = @[@"已签到", @"检查中", @"延期"];
    NSArray *arry3 = @[@"检查中", @"延期", @"待出证"];
    NSArray *arry4 = @[@"检查中", @"延期", @"待出证"];
    NSArray *arry = [NSArray arrayWithObjects:arry0, arry1, arry2, arry3, arry4, nil];
    int statu = [_customerTestInfo.testStatus integerValue] + 1;
    NSArray *status = [NSArray arrayWithArray: arry[statu]];

    [_leftBtn setTitle:status[0] forState:UIControlStateNormal];
    [_centerBtn setTitle:status[1] forState:UIControlStateNormal];
    [_rightBtn setTitle:status[2] forState:UIControlStateNormal];

    switch (statu) {
        case 0:
            [_leftBtn setBackgroundColor:[UIColor colorWithRed:31/255.0 green:183/255.0 blue:238/255.0 alpha:1]];
            [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case 1:
            [_centerBtn setBackgroundColor:[UIColor colorWithRed:31/255.0 green:183/255.0 blue:238/255.0 alpha:1]];
            [_centerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case 2:
            [_rightBtn setBackgroundColor:[UIColor colorWithRed:31/255.0 green:183/255.0 blue:238/255.0 alpha:1]];
            [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}
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
@end
