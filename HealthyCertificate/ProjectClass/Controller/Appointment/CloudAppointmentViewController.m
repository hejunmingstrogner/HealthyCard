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

#import "HttpNetworkManager.h"
#import "PositionUtil.h"
#import "TakePhoto.h"
#import "RzAlertView.h"

#import "MethodResult.h"


#define Button_Size 26
#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface CloudAppointmentViewController()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,HealthyCertificateViewDelegate,HCWheelViewDelegate>
{
    AppointmentInfoView     *_appointmentInfoView;
    
    UITextView             *_phoneNumTextView;
//    UITextField             *_locationTextField;
    UITextView             *_appointmentDateTextView;
    
    UITableView             *_baseInfoTableView;
    
    //键盘相关
    BOOL                    _isFirstShown;
    CGFloat                 _viewHeight;
    
    //性别选择器
    HCWheelView             *_sexWheel;
    
    
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
-(void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate{
    _centerCoordinate = centerCoordinate;
}

-(void)setLocation:(NSString *)location{
    _location = location;
}

-(void)setAppointmentDateStr:(NSString *)appointmentDateStr
{
    BaseInfoTableViewCell* cell = [_baseInfoTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.textView.text = appointmentDateStr;
    _appointmentDateStr = appointmentDateStr;
}

-(void)setIdCardInfo:(NSArray *)idCardInfo{
    _healthyCertificateView.name = idCardInfo[0];
    _healthyCertificateView.idCard = idCardInfo[1];
    _healthyCertificateView.gender = idCardInfo[2];
}

- (void)setSercersPositionInfo:(ServersPositionAnnotionsModel *)sercersPositionInfo
{
    _sercersPositionInfo = sercersPositionInfo;
    _location = sercersPositionInfo.address;
    
    if (sercersPositionInfo.type == 0) {
        _appointmentDateStr = [NSString stringWithFormat:@"工作日(%@~%@)", [NSDate getHour_MinuteByDate:sercersPositionInfo.startTime/1000], [NSDate getHour_MinuteByDate:sercersPositionInfo.endTime/1000]];
    }
    else {
        _appointmentDateStr = [NSString stringWithFormat:@"%@(%@~%@)",  [NSDate getYear_Month_DayByDate:sercersPositionInfo.startTime/1000], [NSDate getHour_MinuteByDate:sercersPositionInfo.startTime/1000], [NSDate getHour_MinuteByDate:sercersPositionInfo.endTime/1000]];
    }
}

#pragma mark - Life Circle
- (void)initNavgation
{
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    self.title = _sercersPositionInfo.name;
}
// 返回前一页
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initNavgation];

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
       // make.width.mas_equalTo(SCREEN_WIDTH-20);
        make.height.mas_equalTo(PXFIT_HEIGHT(96)*3);
    }];
    

    _healthyCertificateView = [[HealthyCertificateView alloc] init];
    _healthyCertificateView.layer.cornerRadius = 10;
    _healthyCertificateView.layer.borderColor = MO_RGBCOLOR(0, 168, 234).CGColor;
    _healthyCertificateView.layer.borderWidth = 1;
    _healthyCertificateView.delegate = self;
    if (_customerTestInfo == nil){
        _healthyCertificateView.personInfoPacket = gPersonInfo;
    }else{
        _healthyCertificateView.customerTest = _customerTestInfo;
    }
    
    [containerView addSubview:_healthyCertificateView];
    [_healthyCertificateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView).with.offset(10);
        make.right.mas_equalTo(containerView).with.offset(-10);
        make.top.mas_equalTo(_baseInfoTableView.mas_bottom).with.offset(10);
        make.height.mas_equalTo(PXFIT_HEIGHT(460));
    }];
    
    _appointmentInfoView = [[AppointmentInfoView alloc] init];
    [containerView addSubview:_appointmentInfoView];
    [_appointmentInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containerView);
        make.top.mas_equalTo(_healthyCertificateView.mas_bottom).with.offset(10);
    }];
    
    
    UIView* bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containerView);
        make.top.mas_equalTo(_appointmentInfoView.mas_bottom);
        make.height.mas_equalTo(PXFIT_HEIGHT(136));
    }];
    
    UIButton* appointmentBtn = [UIButton buttonWithTitle:@"预   约"
                                                    font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Button_Size)]
                                               textColor:[UIColor whiteColor]
                                         backgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue]];
    appointmentBtn.layer.cornerRadius = 5;
//    appointmentBtn.layer.borderWidth = 2;
//    appointmentBtn.layer.borderColor = MO_RGBCOLOR(70, 180, 240).CGColor;
    [appointmentBtn addTarget:self action:@selector(appointmentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:appointmentBtn];
    [appointmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self registerKeyboardNotification];
    
    [self loadData];
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
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ( [cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)] )
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ( [cell respondsToSelector:@selector(setLayoutMargins:)] )
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if (indexPath.row == 0){
        cell.iconName = @"search_icon";
        cell.textViewText = _location;
        //cell.textView.text = _location;
        cell.textView.userInteractionEnabled = NO;
        _locationTextView = cell.textView;
    }else if (indexPath.row == 1){
        cell.iconName = @"date_icon";
        
        if (self.isCustomerServerPoint == NO){
            cell.textView.text = _appointmentDateStr;
            cell.textView.userInteractionEnabled = NO;
        }else{
            cell.textView.text = [NSString combineString:[[NSDate date] getDateStringWithInternel:1]
                                                      And:[[NSDate date] getDateStringWithInternel:2]
                                                     With:@"~"];
            cell.textView.userInteractionEnabled = NO;
        }
        _appointmentDateTextView = cell.textView;
    }else{
        cell.iconName = @"phone_icon";
        cell.textView.keyboardType = UIKeyboardTypeNumberPad;
        if (_customerTestInfo == nil){
            cell.textView.text = gPersonInfo.StrTel;
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
    //如果是自主服务点,那么就不可以修改日期和地址
    if (self.isCustomerServerPoint == NO)
    {
        [_phoneNumTextView resignFirstResponder];
        return;
    }
    
    
    if (indexPath.row == 0){
        //跳转地址
        SelectAddressViewController* selectAddressViewController = [[SelectAddressViewController alloc] init];
        selectAddressViewController.addressStr = _location;
        __weak typeof (self) wself = self;
        [selectAddressViewController getAddressArrayWithBlock:^(NSString *city, NSString *district, NSString *address, CLLocationCoordinate2D coor) {
            wself.cityName = city;
            wself.locationTextView.text = address;
            wself.centerCoordinate = coor;
        }];
        [self.navigationController pushViewController:selectAddressViewController animated:YES];
    }else if (indexPath.row == 1){
        CloudAppointmentDateVC* cloudAppointmentDateVC = [[CloudAppointmentDateVC alloc] init];
        if (self.appointmentDateStr == nil){
            cloudAppointmentDateVC.beginDateString = [[NSDate date] getDateStringWithInternel:1];
            cloudAppointmentDateVC.endDateString = [[NSDate date] getDateStringWithInternel:2];
        }
        else{
            cloudAppointmentDateVC.beginDateString = [self.appointmentDateStr componentsSeparatedByString:@"~"][0];
            cloudAppointmentDateVC.endDateString = [self.appointmentDateStr componentsSeparatedByString:@"~"][1];
        }
        
        [cloudAppointmentDateVC getAppointDateStringWithBlock:^(NSString *dateStr) {
            _appointmentDateStr = dateStr;
            BaseInfoTableViewCell* cell = [_baseInfoTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            cell.textView.text = dateStr;
        }];
        [self.navigationController pushViewController:cloudAppointmentDateVC animated:YES];
    }else{
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PXFIT_HEIGHT(100);
}

#pragma mark - Storyboard Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ChooseDateIdentifier"]){
        UIViewController* destinationViewController = segue.destinationViewController;
        if ([destinationViewController isKindOfClass:[CloudAppointmentDateVC class]])
        {
            CloudAppointmentDateVC* cloudAppointmentDateVC = (CloudAppointmentDateVC*)destinationViewController;
            [cloudAppointmentDateVC getAppointDateStringWithBlock:^(NSString *dateStr) {
               BaseInfoTableViewCell* cell = [_baseInfoTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                cell.textView.text = dateStr;
            }];
        }
    }
}

#pragma mark - Action
-(void)appointmentBtnClicked:(id)sender
{
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
    
    if (_customerTestInfo == nil){
        _customerTestInfo = [[CustomerTest alloc] init];
        _customerTestInfo.checkCode = nil;
        _customerTestInfo.unitCode = gPersonInfo.cUnitCode;
        _customerTestInfo.unitName = gPersonInfo.cUnitName;
        _customerTestInfo.custCode = gPersonInfo.mCustCode;
        _customerTestInfo.nation = nil;
        _customerTestInfo.checkType = 1; // 1 为 健康证
        _customerTestInfo.testStatus = @"-1";// 客户体检登记状态：-1未检，0签到，1在检，2延期，3完成，9已出报告和健康证
								// 单位合同状态：-1所有员工未开始检查，3所有员工完成体检，4所有员工已出健康证
        _customerTestInfo.printPhoto = nil;
        _customerTestInfo.contractCode = nil;
        
    }
    
    //如果是待处理项
    _customerTestInfo.custName = _healthyCertificateView.name;
    _customerTestInfo.sex = [_healthyCertificateView.gender isEqualToString:@"男"]?0:1;
    _customerTestInfo.custIdCard = _healthyCertificateView.idCard;
    _customerTestInfo.bornDate = [_healthyCertificateView.idCard getLongLongBornDate];
    _customerTestInfo.jobDuty = _healthyCertificateView.workType;

    if (_isCustomerServerPoint){
        //如果是新建的预约 云预约
        
        NSArray* array = [_appointmentDateTextView.text  componentsSeparatedByString:@"~"];
        _customerTestInfo.regBeginDate = [array[0] convertDateStrToLongLong];
        _customerTestInfo.regEndDate = [array[0] convertDateStrToLongLong];
        _customerTestInfo.regPosAddr = _locationTextView.text; //预约地点
        
        PositionUtil *posit = [[PositionUtil alloc] init];
        CLLocationCoordinate2D coor = [posit bd2wgs:self.centerCoordinate.latitude lon:self.centerCoordinate.longitude];
        _customerTestInfo.regPosLA = coor.latitude;
        _customerTestInfo.regPosLO = coor.longitude;
        _customerTestInfo.linkPhone = _phoneNumTextView.text;
        
    }else{
        //如果是基于已有服务点的预约
        if (_sercersPositionInfo != nil){
            _customerTestInfo.regTime = _sercersPositionInfo.startTime;
            _customerTestInfo.hosCode = _sercersPositionInfo.cHostCode;
            //移动服务点 id 固定 cHostCode
            _customerTestInfo.checkSiteID = _sercersPositionInfo.type == 1 ? _sercersPositionInfo.id : _sercersPositionInfo.cHostCode;
            _customerTestInfo.servicePoint = _sercersPositionInfo;
        }
    }
    _customerTestInfo.cityName = self.cityName; //预约城市
    
    __weak typeof (self) wself = self;
    [[HttpNetworkManager getInstance] createOrUpdatePersonalAppointment:_customerTestInfo resultBlock:^(NSDictionary *result, NSError *error) {
        
        if (error != nil){
            //预约失败，主要是http的失败
            [RzAlertView showAlertLabelWithTarget:self.view Message:MakeAppointmentFailed removeDelay:2];
            return;
        }
        
        MethodResult *methodResult = [MethodResult mj_objectWithKeyValues:result];
        if (methodResult.succeed == NO || [methodResult.object isEqualToString:@"0"]){
            [RzAlertView showAlertLabelWithTarget:self.view Message:MakeAppointmentFailed removeDelay:2];
            return;
            //预约失败
        }
        
        //预约成功 获取编号
        if (_isAvatarSet == YES) //如果修改了图片,预约成功后要上传图片
        {
            [[HttpNetworkManager getInstance] customerUploadHealthyCertifyPhoto:wself.healthyCertificateView.imageView.image CusCheckCode:methodResult.object resultBlock:^(NSDictionary *result, NSError *error) {
                if (error != nil){
                    //失败 to do
                    [RzAlertView showAlertLabelWithTarget:self.view Message:UploadHealthyPicFailed removeDelay:2];
                    return;
                }
                MethodResult *methodResult = [MethodResult mj_objectWithKeyValues:result];
                if (methodResult.succeed == NO || [methodResult.object isEqualToString:@"0"]){
                    //预约失败 to do
                    [RzAlertView showAlertLabelWithTarget:self.view Message:UploadHealthyPicFailed removeDelay:2];
                    return;
                }
                
                MyCheckListViewController* mycheckListViewController = [[MyCheckListViewController alloc] init];
                mycheckListViewController.popStyle = POPTO_ROOT;
                [self.navigationController pushViewController:mycheckListViewController animated:YES];
            }];
        }else{
            //如果没有修改图片，就不需要上传图片了
            MyCheckListViewController* mycheckListViewController = [[MyCheckListViewController alloc] init];
            mycheckListViewController.popStyle = POPTO_ROOT;
            [self.navigationController pushViewController:mycheckListViewController animated:YES];
        }
    }];

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
    __weak typeof (self) wself = self;
    workTypeViewController.block = ^(NSString* resultStr){
        wself.healthyCertificateView.workType = resultStr;
    };
    [self.navigationController pushViewController:workTypeViewController animated:YES];
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

}

-(void)healthyImageClicked{
    __weak typeof (self) wself = self;
    [[TakePhoto getInstancetype] takePhotoFromCurrentController:self WithRatioOfWidthAndHeight:3.0/4.0 resultBlock:^(UIImage *photoimage) {
        photoimage = [TakePhoto scaleImage:photoimage withSize:CGSizeMake(wself.healthyCertificateView.imageView.frame.size.width,
                                                                          wself.healthyCertificateView.imageView.frame.size.height)];
        [wself.healthyCertificateView.imageView setImage:photoimage];
        _isAvatarSet = YES; //代表修改了健康证图片

    }];
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
        if(_isCustomerServerPoint)
        {
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
        //服务点预约
        
        //根据预约编号去请求图片
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@customerTest/getPrintPhoto?cCheckCode=%@", [HttpNetworkManager baseURL], _customerTestInfo.checkCode]];
        [_healthyCertificateView.imageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error!=nil){}
        }];
        
    }else{
        //云预约
        //_isAvatarSet = NO;
    }
}
@end
