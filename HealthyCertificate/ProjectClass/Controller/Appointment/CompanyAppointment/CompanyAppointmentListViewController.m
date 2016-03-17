//
//  CompanyAppointmentListViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/11.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CompanyAppointmentListViewController.h"

#import <Masonry.h>
#import <MJExtension.h>

#import "UIFont+Custom.h"
#import "UIButton+HitTest.h"
#import "UIButton+Easy.h"
#import "UIColor+Expanded.h"
#import "NSDate+Custom.h"
#import "NSString+Custom.h"

#import "Constants.h"

#import "HttpNetworkManager.h"

#import "MethodResult.h"

#import "StaffStateViewController.h"
#import "QRController.h"
#import "SelectAddressViewController.h"
#import "AddWorkerViewController.h"
#import "CloudAppointmentDateVC.h"
#import "CloudCompanyAppointmentStaffCell.h"
#import "CloudCompanyAppointmentCell.h"
#import "CompanyItemListCell.h"
#import "CompanyItemStaffStateCell.h"


@interface CompanyAppointmentListViewController()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UITextField *_contactPersonField;
    UITextField *_phoneNumField;
    UITextField *_exminationCountField;
    CGFloat      _viewHeight;
    
    UITextView  *_addressTextView;
    UITextView  *_dateTextView;
    
    UITableView *_tableView;
    
    CLLocationCoordinate2D _centerCoordinate;
    
    //预约/体检 地址
    NSString    *_address;
    // 预约/体检 时间
    NSString    *_date;
    // 联系人
    NSString    *_linkPerson;
    // 联系电话
    NSString    *_linkPhone;
    // 预约人数
    NSString    *_appointmentCount;
    //单位员工
    NSInteger   _staffCount;
}

@property (nonatomic, copy) NSMutableArray* customerArr;

@property (nonatomic, copy) NSArray* originArr;

@end


@implementation CompanyAppointmentListViewController

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-5, -5, -5, -5)
#define TopMargin FIT_FONTSIZE(20)

typedef NS_ENUM(NSInteger, CompanyListTextField)
{
    CompanyList_LinkPerson,
    CompanyList_LinePhone,
    CompanyList_AppointmentCount
};

#pragma mark - Life Circle
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigation];
    
    self.view.backgroundColor = [UIColor colorWithRGBHex:HC_Base_BackGround];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [_tableView registerClass:[CloudCompanyAppointmentStaffCell class] forCellReuseIdentifier:NSStringFromClass([CloudCompanyAppointmentStaffCell class])];
    [_tableView registerClass:[CloudCompanyAppointmentCell class] forCellReuseIdentifier:NSStringFromClass([CloudCompanyAppointmentCell class])];
    [_tableView registerClass:[CompanyItemListCell class] forCellReuseIdentifier:NSStringFromClass([CompanyItemListCell class])];
    [_tableView registerClass:[CompanyItemStaffStateCell class] forCellReuseIdentifier:NSStringFromClass([CompanyItemStaffStateCell class])];
    
    //界面点击事件
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    singleRecognizer.delegate = self;
    [self.view addGestureRecognizer:singleRecognizer];
    
    //导航栏点击事件
    UITapGestureRecognizer* tapRecon = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(toggleMenu)];
    tapRecon.delegate = self;
    tapRecon.numberOfTapsRequired = 1;
    [self.navigationController.navigationBar addGestureRecognizer:tapRecon];
}

-(void)initNavigation
{
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    //backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    self.title = @"我的合同";
    
    UIButton* editBtn = [UIButton buttonWithTitle:@"修改"
                                             font:[UIFont fontWithType:UIFontOpenSansRegular size:17]
                                        textColor:[UIColor colorWithRGBHex:HC_Blue_Text]
                                  backgroundColor:[UIColor clearColor]];
    [editBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerKeyboardNotification];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self cancelKeyboardNotification];
}

#pragma mark - Setter & Getter
-(NSArray*)customerArr{
    if (_customerArr == nil)
        _customerArr = [[NSMutableArray alloc] init];
    return _customerArr;
}

-(NSArray*)originArr{
    if (_originArr == nil)
        _originArr = [[NSArray alloc] init];
    return _originArr;
}

-(void)setBrContract:(BRContract *)brContract
{
    _brContract = brContract;
    
    _address = _brContract.regPosAddr;
    
    if (_brContract.checkSiteID == nil || [_brContract.checkSiteID isEqualToString:@""]){
        
        _date = [NSString stringWithFormat:@"%@~%@", [NSDate converLongLongToChineseStringDate:_brContract.regBeginDate/1000],
                 [NSDate converLongLongToChineseStringDate:_brContract.regEndDate/1000]];
    }else{
        //基于服务点(移动+固定)
        if ([_brContract.hosCode isEqualToString:_brContract.checkSiteID]){
            //固定
            _date = [NSString stringWithFormat:@"工作日(%@~%@)", [NSDate getHour_MinuteByDate:_brContract.servicePoint.startTime/1000],
                     [NSDate getHour_MinuteByDate:_brContract.servicePoint.endTime/1000]];
        }else{
            NSString *year = [NSDate getYear_Month_DayByDate:_brContract.servicePoint.startTime/1000];
            NSString *start = [NSDate getHour_MinuteByDate:_brContract.servicePoint.startTime/1000];
            NSString *end = [NSDate getHour_MinuteByDate:_brContract.servicePoint.endTime/1000];
            _date = [NSString stringWithFormat:@"%@(%@~%@)", year, start, end];
        }
    }
    
    _linkPerson = _brContract.linkUser;
    _linkPhone = _brContract.linkPhone;
    _appointmentCount = [NSString stringWithFormat:@"%ld", _brContract.regCheckNum];
    _staffCount = 0;
    
    __typeof (self) __weak weakSelf = self;
    [[HttpNetworkManager getInstance] getCustomerListByBRContract:_brContract.code resultBlock:^(NSArray *result, NSError *error) {
        if (error != nil){
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"查询单位员工失败" removeDelay:3];
            return;
        }
        weakSelf.originArr = result;
        __typeof (self)  strongSelf = weakSelf; //防止循环引用
        strongSelf->_staffCount = result.count;
        [strongSelf->_tableView reloadData];
//        NSIndexPath *path = [NSIndexPath indexPathForItem:2 inSection:1];
//        [strongSelf->_tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
}

#pragma mark - Action
-(void)editBtnClicked:(UIButton*)sender
{
    //非服务点预约才能修改地址和时间
    if (_brContract.checkSiteID == nil || [_brContract.checkSiteID isEqualToString:@""])
    {
        NSArray* array = [_dateTextView.text  componentsSeparatedByString:@"~"];
        _brContract.regBeginDate = [array[0] convertDateStrToLongLong]*1000;
        _brContract.regEndDate = [array[1] convertDateStrToLongLong]*1000;
        _brContract.regPosAddr = _addressTextView.text;
        _brContract.regPosLA = _centerCoordinate.latitude;
        _brContract.regPosLO = _centerCoordinate.longitude;
    }
    
    _brContract.linkUser = _contactPersonField.text;
    _brContract.linkPhone = _phoneNumField.text;
    _brContract.regCheckNum = [_exminationCountField.text intValue];
    

    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    [array addObjectsFromArray:_customerArr];
    [array addObjectsFromArray:_originArr];
    [[HttpNetworkManager getInstance] createOrUpdateBRCoontract:_brContract
                                                      employees:array
                                                    reslutBlock:^(NSDictionary *result, NSError *error) {
        if (error != nil){
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"预约异常失败，请重试" removeDelay:2];
            return;
        }
        
        MethodResult *methodResult = [MethodResult mj_objectWithKeyValues:result];
        if (methodResult.succeed == NO){
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"预约异常失败，请重试" removeDelay:2];
            return;
        }
        
        if ([methodResult.object isEqualToString:@"0"]){
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"预约异常失败，请重试" removeDelay:2];
            return;
        }
        
        if ([methodResult.object isEqualToString:@"1"]){
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"已达到修改次数上限" removeDelay:2];
            return;
        }
        
                                                        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)backToPre:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer
{
    if(recognizer.view.tag != CompanyList_AppointmentCount && recognizer.view.tag != CompanyList_LinePhone && recognizer.view.tag != CompanyList_LinkPerson){
        [_contactPersonField resignFirstResponder];
        [_phoneNumField resignFirstResponder];
        [_exminationCountField resignFirstResponder];
    }
}

-(void)toggleMenu
{
    [self inputWidgetResign];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"UITableView"]) {//如果当前是tableView
        return NO; //继续传递
    }
    
    for (UIView* sub in self.navigationController.navigationBar.subviews) {
        NSString *cl = NSStringFromClass([sub class]);
        if ([cl isEqualToString:@"UINavigationItemButtonView"]) {
            CGRect bback = sub.frame;
            CGPoint pointInView = [touch locationInView:gestureRecognizer.view];
            return !CGRectContainsPoint(bback, pointInView);
        }
    }
    
    return YES;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 2;
    }else if (section == 1) {
        return 4;
    }else {
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return PXFIT_HEIGHT(20);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = MO_RGBCOLOR(250, 250, 250);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2){
        CompanyItemStaffStateCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CompanyItemStaffStateCell class])];
        cell.titleText = @"员工状态";
        return cell;
    }
    
    if (indexPath.section == 3){
        CompanyItemStaffStateCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CompanyItemStaffStateCell class])];
        cell.titleText = @"二维码";
        return cell;
    }
    
    if (indexPath.section == 1 && indexPath.row == 2){
        CloudCompanyAppointmentStaffCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CloudCompanyAppointmentStaffCell class])];
        cell.staffCount = _staffCount;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.section == 1)
    {
        CloudCompanyAppointmentCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CloudCompanyAppointmentCell class])];
        if (indexPath.row == 0){
            cell.textFieldType = CDA_CONTACTPERSON;
            cell.textField.text = _linkPerson;
            cell.textField.enabled = YES;
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.delegate = self;
            cell.textField.tag = CompanyList_LinkPerson;
            _contactPersonField = cell.textField;
        }else if (indexPath.row == 1){
            cell.textFieldType = CDA_CONTACTPHONE;
            cell.textField.text = _linkPhone;
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            cell.textField.enabled = YES;
            cell.textField.tag = CompanyList_LinePhone;
            cell.textField.delegate = self;
            _phoneNumField = cell.textField;
        }else if (indexPath.row == 3){
            cell.textFieldType = CDA_PERSON;
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            cell.textField.enabled = YES;
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.delegate = self;
            cell.textField.text = _appointmentCount;
            cell.textField.tag = CompanyList_AppointmentCount;
            _exminationCountField = cell.textField;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    CompanyItemListCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CompanyItemListCell class])];
    cell.textView.userInteractionEnabled = NO;
    if (indexPath.row == 0){
        if (_brContract.checkSiteID == nil || [_brContract.checkSiteID isEqualToString:@""]){
            //代表预约，可以修改
            cell.itemType = CDA_APPOINTMENTADDRESS;
            cell.userInteractionEnabled = YES;
        }else{
            //代表体检，不可修改
            cell.itemType = CDA_EXAMADDRESS;
            cell.userInteractionEnabled = NO;
            cell.textView.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
        }
        [cell setTextViewText:_address];
        _addressTextView = cell.textView;
    }else{
        if (_brContract.checkSiteID == nil || [_brContract.checkSiteID isEqualToString:@""]){
            cell.itemType = CDA_APPOINTMENTTIME;
            cell.userInteractionEnabled = YES;
        }else{
            cell.itemType = CDA_EXAMTIME;
            cell.userInteractionEnabled = NO;
            cell.textView.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
        }
        [cell setTextViewText:_date];
        _dateTextView = cell.textView;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        if (_brContract.checkSiteID == nil || [_brContract.checkSiteID isEqualToString:@""]){
            if (indexPath.row == 0){
                SelectAddressViewController* selectAddressVC = [[SelectAddressViewController alloc] init];
                selectAddressVC.addressStr = _addressTextView.text;
                [selectAddressVC getAddressArrayWithBlock:^(NSString *city, NSString *district, NSString *address, CLLocationCoordinate2D coor) {
                    _addressTextView.text = address;
                    _centerCoordinate = coor;
                }];
                [self.navigationController pushViewController:selectAddressVC animated:YES];
            }else{
                CloudAppointmentDateVC* cloudAppointmentDateVC = [[CloudAppointmentDateVC alloc] init];
                cloudAppointmentDateVC.beginDateString = [_dateTextView.text componentsSeparatedByString:@"~"][0];
                cloudAppointmentDateVC.endDateString = [_dateTextView.text componentsSeparatedByString:@"~"][1];
                [cloudAppointmentDateVC getAppointDateStringWithBlock:^(NSString *dateStr) {
                    _dateTextView.text = dateStr;
                }];
                [self.navigationController pushViewController:cloudAppointmentDateVC animated:YES];
            }
        }
    }else if (indexPath.section == 2){
        StaffStateViewController* staffStateVC = [[StaffStateViewController alloc] init];
        staffStateVC.contractCode = _brContract.code;
        [self.navigationController pushViewController:staffStateVC animated:YES];
         [self inputWidgetResign];
    }else if (indexPath.section == 3){
        QRController* qrController = [[QRController alloc] init];
        qrController.qrContent = [NSString stringWithFormat:@"http://webserver.zeekstar.com/webserver/weixin/staffRegister.jsp?brContractCode=%@", _brContract.code];
        [self.navigationController pushViewController:qrController animated:YES];
        [self inputWidgetResign];
    }else{
        if (indexPath.row == 0){
            [_contactPersonField becomeFirstResponder];
        }else if (indexPath.row == 1){
            [_phoneNumField becomeFirstResponder];
        }else if (indexPath.row == 3){
            [_exminationCountField becomeFirstResponder];
        }else{
            AddWorkerViewController* addWorkerVC = [[AddWorkerViewController alloc] init];
            addWorkerVC.needcanlceWorkersArray = self.originArr;
            addWorkerVC.selectedWorkerArray = [NSMutableArray arrayWithArray:self.customerArr];;
            __typeof (self) __weak weakSelf = self;
            [addWorkerVC getWorkerArrayWithBlock:^(NSArray *workerArray) {
                __typeof (self)  strongSelf = weakSelf; //防止循环引用
                weakSelf.customerArr = [NSMutableArray arrayWithArray:workerArray];
                strongSelf->_staffCount = workerArray.count + _originArr.count;
                NSIndexPath *path = [NSIndexPath indexPathForItem:2 inSection:1];
                [_tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
                if([_exminationCountField.text integerValue] < workerArray.count + _originArr.count){
                    _exminationCountField.text = [NSString stringWithFormat:@"%ld", workerArray.count + _originArr.count];
                    strongSelf->_appointmentCount = [NSString stringWithFormat:@"%ld", workerArray.count + _originArr.count];
                    NSIndexPath *path = [NSIndexPath indexPathForItem:3 inSection:1];
                    [_tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                }
            }];
            [self.navigationController pushViewController:addWorkerVC animated:YES];
            [self inputWidgetResign];
        }
    }
}

#pragma mark - KeyBorad
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
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, _viewHeight);
    } completion:NULL];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    CGRect keyboardBounds;//UIKeyboardFrameEndUserInfoKey
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, _viewHeight + keyboardBounds.size.height);
    } completion:NULL];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag != CompanyList_LinePhone){
        return YES;
    }
    if (![self isPureInt:string]){
        return YES;
    }
    if (textField.text.length + string.length > 11){
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Private Methods
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

-(void)inputWidgetResign
{
    [_addressTextView resignFirstResponder];
    [_dateTextView resignFirstResponder];
    [_contactPersonField resignFirstResponder];
    [_phoneNumField resignFirstResponder];
    [_exminationCountField resignFirstResponder];
}

@end
