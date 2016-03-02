//
//  PersonalHealthyCController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/25.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "PersonalHealthyCController.h"
#import "Constants.h"
#import "UIFont+Custom.h"
#import "CloudAppointmentDateVC.h"

#import "EditInfoViewController.h"
#import "WorkTypeViewController.h"

#import "TakePhoto.h"
#import "HttpNetworkManager.h"


@interface PersonalHealthyCController()
{
    BOOL        _isAvatarSet;
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
    self.title = @"我的健康证";  // 车辆牌照
    // 返回按钮
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(0, 0, 30, 30);
    [backbtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [backbtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backbtn];
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
    
    
    NSLog(@"修改");
}

- (void)initSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];

    _baseBgScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_baseBgScrollView];
    _baseBgScrollView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:0.9];
    _baseBgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, PXFIT_HEIGHT(460) + 200 + 50 + 90);  // 50待修改 [self labelHeight:介绍]

    _healthCertificateView = [[HealthyCertificateView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, PXFIT_HEIGHT(460))];
    [_baseBgScrollView addSubview:_healthCertificateView];
    _healthCertificateView.layer.masksToBounds = YES;
    _healthCertificateView.delegate = self;
    _healthCertificateView.layer.cornerRadius = 10;

    _orderinforView = [[HealthyCertificateOrderInfoView alloc]initWithFrame:CGRectMake(10, 10+ PXFIT_HEIGHT(460) + 10, self.view.frame.size.width - 20, 200)];
    [_baseBgScrollView addSubview:_orderinforView];

    _introduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10+ PXFIT_HEIGHT(460) + 10 + 210, self.view.frame.size.width - 20, 50)]; // 50待修改 [self labelHeight:介绍]
    [_baseBgScrollView addSubview:_introduceLabel];
    _introduceLabel.text = @"测试使用的随意啊大家咖啡撒";
    _introduceLabel.numberOfLines = 0;
    _introduceLabel.textColor = [UIColor grayColor];
    _introduceLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];

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
        make.top.equalTo(_introduceLabel.mas_bottom).offset(10);
        make.left.equalTo(_orderinforView);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(80);
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
        make.top.equalTo(_centerBtn).offset(-10);
        make.bottom.equalTo(_centerBtn).offset(10);
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
        // 点击地址搜索
        SelectAddressViewController *addressselect = [[SelectAddressViewController alloc]init];
        [addressselect getAddressArrayWithBlock:^(NSString *city, NSString *district, NSString *address, CLLocationCoordinate2D coor) {
            NSLog(@"address: %@", address);
            [addressBtns setTitle:address forState:UIControlStateNormal];
        }];
        [weakself.navigationController pushViewController:addressselect animated:YES];
    }];
    __weak CustomButton *weaktimeBtn = _orderinforView.timeBtn;
    [_orderinforView.timeBtn addClickedBlock:^(UIButton * _Nonnull sender) {
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
            [weaktimeBtn setTitle:dateStr forState:UIControlStateNormal];
        }];
        [weakself.navigationController pushViewController:cloudData animated:YES];
    }];
    [_orderinforView.phoneBtn addClickedBlock:^(UIButton * _Nonnull sender) {
        // 点击电话
        NSLog(@"点击电话");
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
    __weak typeof (self) wself = self;
    [[TakePhoto getInstancetype] takePhotoFromCurrentController:self resultBlock:^(UIImage *photoimage) {
        photoimage = [TakePhoto scaleImage:photoimage withSize:CGSizeMake(wself.healthCertificateView.imageBtn.frame.size.width,
                                                                          wself.healthCertificateView.imageBtn.frame.size.height)];
        [wself.healthCertificateView.imageBtn setBackgroundImage:photoimage forState:UIControlStateNormal];
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
