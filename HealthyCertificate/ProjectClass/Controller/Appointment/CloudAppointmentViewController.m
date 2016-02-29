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

#import "UIButton+Easy.h"
#import "UIColor+Expanded.h"
#import "UIFont+Custom.h"
#import "NSString+Custom.h"
#import "NSDate+Custom.h"
#import "NSString+Custom.h"
#import "UIScreen+Type.h"
#import "NSString+Custom.h"

#import "BaseInfoTableViewCell.h"
#import "CloudAppointmentDateVC.h"
#import "SelectAddressViewController.h"

#import "HealthyCertificateView.h"
#import "AppointmentInfoView.h"
#import "CloudAppointmentDateVC.h"
#import "EditInfoViewController.h"
#import "HCWheelView.h"

#import "HttpNetworkManager.h"
#import "PositionUtil.h"



#define Button_Size 26

@interface CloudAppointmentViewController()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,HealthyCertificateViewDelegate,HCWheelViewDelegate>
{
    AppointmentInfoView     *_appointmentInfoView;
    
    UITextField             *_phoneNumTextField;
//    UITextField             *_locationTextField;
    UITextField             *_appointmentDateTextField;
    
    UITableView             *_baseInfoTableView;
    
    //键盘相关
    BOOL                    _isFirstShown;
    CGFloat                 _viewHeight;
    
    //性别选择器
    HCWheelView             *_sexWheel;
    
}

@property (nonatomic, strong) HealthyCertificateView* healthyCertificateView;
@property (nonatomic, strong) UITextField* locationTextField;

@end


@implementation CloudAppointmentViewController

#pragma mark - Public Methods
-(void)hideTheKeyBoard{
    [_phoneNumTextField resignFirstResponder];
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
    cell.textField.text = appointmentDateStr;
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
}

#pragma mark - Life Circle
- (void)initNavgation
{
    // 返回按钮
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(0, 0, 30, 30);
    [backbtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backbtn.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 10);
    [backbtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    self.title = _sercersPositionInfo.name;
}
// 返回前一页
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
        make.right.mas_equalTo(containerView).with.offset(-10);
       // make.width.mas_equalTo(SCREEN_WIDTH-20);
        make.height.mas_equalTo(PXFIT_HEIGHT(96)*3);
    }];
    

    _healthyCertificateView = [[HealthyCertificateView alloc] init];
    _healthyCertificateView.layer.cornerRadius = 10;
    _healthyCertificateView.layer.borderColor = MO_RGBCOLOR(0, 168, 234).CGColor;
    _healthyCertificateView.layer.borderWidth = 1;
    _healthyCertificateView.delegate = self;
    _healthyCertificateView.personInfoPacket = gPersonInfo;
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
    
    UIButton* appointmentBtn = [UIButton buttonWithTitle:@"预 约"
                                                    font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Button_Size)]
                                               textColor:MO_RGBCOLOR(70, 180, 240)
                                         backgroundColor:[UIColor whiteColor]];
    appointmentBtn.layer.cornerRadius = 5;
    appointmentBtn.layer.borderWidth = 2;
    appointmentBtn.layer.borderColor = MO_RGBCOLOR(70, 180, 240).CGColor;
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
        cell.textField.text = _location;
        cell.textField.enabled = NO;
        _locationTextField = cell.textField;
    }else if (indexPath.row == 1){
        cell.iconName = @"date_icon";
        
        if (self.isCustomerServerPoint == NO){
            cell.textField.text = _appointmentDateStr;
            cell.textField.enabled = NO;
        }else{
            cell.textField.text = [NSString combineString:[[NSDate date] formatDateToChineseString]
                                                      And:[[NSDate date] getDateStringWithInternel:1]
                                                     With:@"~"];
            cell.textField.enabled = NO;
        }
        _appointmentDateTextField = cell.textField;
    }else{
        cell.iconName = @"phone_icon";
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textField.text = gPersonInfo.StrTel;
        cell.textField.delegate = self;
        _phoneNumTextField = cell.textField;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果是自主服务点,那么就不可以修改日期和地址
    if (self.isCustomerServerPoint == NO)
    {
        [_phoneNumTextField resignFirstResponder];
        return;
    }
    
    
    if (indexPath.row == 0){
        //跳转地址
        SelectAddressViewController* selectAddressViewController = [[SelectAddressViewController alloc] init];
        selectAddressViewController.addressStr = _location;
        __weak typeof (self) wself = self;
        [selectAddressViewController getAddressArrayWithBlock:^(NSString *city, NSString *district, NSString *address, CLLocationCoordinate2D coor) {
            wself.cityName = city;
            wself.locationTextField.text = address;
            wself.centerCoordinate = coor;
        }];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:selectAddressViewController];
        [self.parentViewController presentViewController:nav animated:YES completion:nil];
    }else if (indexPath.row == 1){
        if (self.navigationController == nil){
            [self.parentViewController performSegueWithIdentifier:@"ChooseDateIdentifier" sender:self];
        }else{
            CloudAppointmentDateVC* vc = [[CloudAppointmentDateVC alloc] init];
            vc.view.backgroundColor = [UIColor whiteColor];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }else{
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PXFIT_HEIGHT(96);
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
                cell.textField.text = dateStr;
            }];
        }
    }
}

#pragma mark - Action
-(void)appointmentBtnClicked:(id)sender
{
    //先做一次数据有效性检查 to do
    
    if (_customerTestInfo == nil){
        _customerTestInfo = [[CustomerTest alloc] init];
        _customerTestInfo.checkCode = nil;
        _customerTestInfo.unitCode = gPersonInfo.cUnitCode;
        _customerTestInfo.unitName = gPersonInfo.cUnitName;
        _customerTestInfo.custCode = gPersonInfo.mCustCode;
        _customerTestInfo.custName = _healthyCertificateView.name;
        _customerTestInfo.sex = [_healthyCertificateView.gender isEqualToString:@"男"]?0:1;
        _customerTestInfo.nation = nil;
        _customerTestInfo.bornDate = [_healthyCertificateView.idCard getLongLongBornDate]; //一会儿计算
        _customerTestInfo.custIdCard = _healthyCertificateView.idCard;
        _customerTestInfo.jobDuty = _healthyCertificateView.workType;
        _customerTestInfo.checkType = 1; // 1 为 健康证
        _customerTestInfo.testStatus = @"-1";// 客户体检登记状态：-1未检，0签到，1在检，2延期，3完成，9已出报告和健康证
								// 单位合同状态：-1所有员工未开始检查，3所有员工完成体检，4所有员工已出健康证
        _customerTestInfo.linkPhone = _phoneNumTextField.text;
        _customerTestInfo.printPhoto = nil;
        _customerTestInfo.contractCode = nil;
        
        NSArray* array = [_appointmentDateTextField.text  componentsSeparatedByString:@"~"];
        _customerTestInfo.regBeginDate = [array[0] convertDateStrToLongLong];
        _customerTestInfo.regEndDate = [array[0] convertDateStrToLongLong];
        _customerTestInfo.regPosAddr = _locationTextField.text; //预约地点
        _customerTestInfo.cityName = @""; //预约城市
        PositionUtil *posit = [[PositionUtil alloc] init];
        CLLocationCoordinate2D coor = [posit bd2wgs:self.centerCoordinate.latitude lon:self.centerCoordinate.longitude];
        _customerTestInfo.regPosLA = coor.latitude;
        _customerTestInfo.regPosLO = coor.longitude;
    }
}

- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer
{
    if (![recognizer.view isKindOfClass:[UITextField class]]){
        [_phoneNumTextField resignFirstResponder];
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
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:editInfoViewController];
    [self presentViewController:nav animated:YES completion:nil];
    
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
    NSLog(@"industry");
}

-(void)idCardBtnClicked:(NSString *)idCard
{
    EditInfoViewController* editInfoViewController = [[EditInfoViewController alloc] init];
    editInfoViewController.editInfoType = EDITINFO_IDCARD;
    __weak typeof (self) wself = self;
    [editInfoViewController setEditInfoText:idCard WithBlock:^(NSString *resultStr) {
        wself.healthyCertificateView.idCard = resultStr;
    }];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:editInfoViewController];
    [self presentViewController:nav animated:YES completion:nil];

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
        _viewHeight = SCREEN_HEIGHT - keyboardBounds.size.height;
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.parentViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, _viewHeight);
        [self.view layoutIfNeeded];
        
    } completion:NULL];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    CGRect keyboardBounds;//UIKeyboardFrameEndUserInfoKey
    [[notification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBounds];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.parentViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, _viewHeight + keyboardBounds.size.height);
        [self.view layoutIfNeeded];
    } completion:NULL];
}
@end
