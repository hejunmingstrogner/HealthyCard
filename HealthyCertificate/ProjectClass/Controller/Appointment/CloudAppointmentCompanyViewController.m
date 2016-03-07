//
//  CloudAppointmentCompanyViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CloudAppointmentCompanyViewController.h"
#import "CloudAppointmentDateVC.h"

#import <Masonry.h>

#import "Constants.h"

#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "NSDate+Custom.h"
#import "UILabel+Easy.h"
#import "NSString+Custom.h"
#import "BaseInfoTableViewCell.h"
#import "CloudCompanyAppointmentCell.h"
#import "CloudCompanyAppointmentStaffCell.h"

#import "AppointmentInfoView.h"

#import "SelectAddressViewController.h"
#import "AddWorkerViewController.h"

#import "Customer.h"
#import "PositionUtil.h"
#import "HttpNetworkManager.h"

#define Button_Size 26

#define Cell_Font 24
#define Cell_Font_Samll 23

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

typedef NS_ENUM(NSInteger, TABLIEVIEWTAG)
{
    TABLEVIEW_BASEINFO = 1001,
    TABLEVIEW_COMPANYINFO,
    TABLEVIEW_STAFFINFO
};

typedef NS_ENUM(NSInteger, TEXTFILEDTAG)
{
    TEXTFIELD_CONTACT = 2001,
    TEXTFIELD_PHONE,
    TEXTFIELD_CONTACTCOUNT
};

@interface CloudAppointmentCompanyViewController() <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UITextViewDelegate>
{
    UITableView         *_baseInfoTableView;
    UITableView         *_companyInfoTableView;
    //UITableView         *_staffTableView;
    
    NSString            *_dateString;
    
    UITextField         *_contactPersonField;
    UITextField         *_phoneNumField;
    UITextField         *_exminationCountField;
    
    //键盘收缩相关
    BOOL                 _isFirstShown;
    CGFloat              _viewHeight;

    UITextView         *_dateStrTextView;
    
    
    //单位信息相关
    UITextView          *_companyNameTextView;
    UITextView          *_companyAddressTextView;
    
    UIView              *_companyInfoContainerView;
    UIView              *_lineView;
    
    UILabel             *_exampleLabel;
}

//选择的员工列表
@property (nonatomic, strong) NSArray* customerArr;
@property (nonatomic ,strong) UITableView* staffTableView;

@end

@implementation CloudAppointmentCompanyViewController

#pragma mark - Setter & Getter
-(void)setLocation:(NSString *)location{
    _location = location;
    [_baseInfoTableView reloadData];
}

-(void)setAppointmentDateStr:(NSString *)appointmentDateStr{
    BaseInfoTableViewCell* cell = [_baseInfoTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.textView.text = appointmentDateStr;
    _appointmentDateStr = appointmentDateStr;
}

-(NSArray*)customerArr{
    if (_customerArr == nil)
        _customerArr = [[NSArray alloc] init];
    return _customerArr;
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

#pragma mark - Public Methods
-(void)hideTheKeyBoard{
    [_contactPersonField resignFirstResponder];
    [_phoneNumField resignFirstResponder];
    [_exminationCountField resignFirstResponder];
}

#pragma mark - Life Circle
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initNavgation];
    
    _dateString = [NSString stringWithFormat:@"%@~%@",
                   [[NSDate date] getDateStringWithInternel:1],
                   [[NSDate date] getDateStringWithInternel:2]];
   
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
    
    
    //第一个板块 预约地址 & 预约时间
    _baseInfoTableView = [[UITableView alloc] init];
    _baseInfoTableView.tag = TABLEVIEW_BASEINFO;
    _baseInfoTableView.delegate = self;
    _baseInfoTableView.dataSource = self;
    _baseInfoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _baseInfoTableView.separatorColor = [UIColor colorWithRGBHex:0xe8e8e8];
    _baseInfoTableView.scrollEnabled = NO;
    _baseInfoTableView.layer.borderColor = [UIColor colorWithRGBHex:0xe8e8e8].CGColor;
    _baseInfoTableView.layer.borderWidth = 1;
    [_baseInfoTableView registerClass:[BaseInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BaseInfoTableViewCell class])];
    [containerView addSubview:_baseInfoTableView];
    [_baseInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containerView);
        make.top.mas_equalTo(containerView).with.offset(10);
        make.height.mas_equalTo(PXFIT_HEIGHT(96)*2);
    }];
    
    //第二个板块 单位名称 & 单位地址
    UILabel* companyNameLabel = [UILabel labelWithText:@"单位名称"
                                                  font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)]
                                             textColor:[UIColor blackColor]];
    NSDictionary* attribute = @{NSFontAttributeName:companyNameLabel.font};
    CGSize size = [companyNameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, PXFIT_HEIGHT(96)) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    //获得label的宽度
    CGFloat labelTextWidth = size.width + 1;
    CGFloat textViewWidth = SCREEN_WIDTH - labelTextWidth - PXFIT_WIDTH(20) * 3;
    
    
    _companyInfoContainerView = [[UIView alloc] init];
    _companyInfoContainerView.layer.borderWidth = 1;
    _companyInfoContainerView.layer.borderColor = [UIColor colorWithRGBHex:0xe8e8e8].CGColor;
    [containerView addSubview:_companyInfoContainerView];
    
    [_companyInfoContainerView addSubview:companyNameLabel];
    _companyNameTextView = [[UITextView alloc] init];
    _companyNameTextView.text = gCompanyInfo.cUnitName;
    _companyNameTextView.scrollEnabled = NO;
    _companyNameTextView.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
    _companyNameTextView.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];

    [_companyInfoContainerView addSubview:_companyNameTextView];
    
    UILabel* companyAddressLabel = [UILabel labelWithText:@"单位名称"
                                                     font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)]
                                                textColor:[UIColor blackColor]];
    [_companyInfoContainerView addSubview:companyAddressLabel];
    
    _companyAddressTextView = [[UITextView alloc] init];
    _companyAddressTextView.text = gCompanyInfo.cUnitAddr;
    _companyAddressTextView.scrollEnabled = NO;
    _companyAddressTextView.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
    
    
    
    //获得单位名称的高度 http://www.360doc.com/content/15/0608/16/11417867_476582625.shtml
    size = [_companyNameTextView sizeThatFits:CGSizeMake(textViewWidth, MAXFLOAT)];
//    size = [gCompanyInfo.cUnitName boundingRectWithSize:CGSizeMake(textViewWidth, MAXFLOAT)
//                                                options: NSStringDrawingUsesFontLeading
//                                             attributes:@{NSFontAttributeName:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)]}
//                                                context:nil].size;
    CGFloat nameTextViewHeight = size.height;
    
    
    //获得单位地址的高度
//    size = [gCompanyInfo.cUnitAddr boundingRectWithSize:CGSizeMake(textViewWidth, MAXFLOAT)
//                                                options: NSStringDrawingUsesFontLeading
//                                             attributes:@{NSFontAttributeName:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)]}
//                                                context:nil].size;
    size = [_companyAddressTextView sizeThatFits:CGSizeMake(textViewWidth, MAXFLOAT)];
    CGFloat addressTextViewHeight = size.height;
    
    CGFloat containerViewHeight = (nameTextViewHeight < PXFIT_HEIGHT(96) ? PXFIT_HEIGHT(96) : nameTextViewHeight) + (addressTextViewHeight < PXFIT_HEIGHT(96) ? PXFIT_HEIGHT(96):addressTextViewHeight);

   // _companyInfoContainerView = [[UIView alloc] init];
    _companyInfoContainerView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:_companyInfoContainerView];
    [_companyInfoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containerView);
        make.height.mas_equalTo(containerViewHeight + 1);
        make.top.mas_equalTo(_baseInfoTableView.mas_bottom).with.offset(PXFIT_HEIGHT(20));
    }];
    
  //  [_companyInfoContainerView addSubview:companyNameLabel];
    [companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_companyInfoContainerView).with.offset(PXFIT_WIDTH(20));
        make.top.mas_equalTo(_companyInfoContainerView);
        make.height.mas_equalTo(nameTextViewHeight < PXFIT_HEIGHT(96)?PXFIT_HEIGHT(96):nameTextViewHeight);
        make.width.mas_equalTo(labelTextWidth);
    }];
    
    [companyNameLabel setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
 //   _companyNameTextView = [[UITextView alloc] init];
       [_companyNameTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(companyNameLabel.mas_right).with.offset(PXFIT_WIDTH(20));
        make.right.mas_equalTo(_companyInfoContainerView).with.offset(-PXFIT_WIDTH(20));
        make.centerY.mas_equalTo(companyNameLabel);
        make.height.mas_equalTo( nameTextViewHeight);
       // make.height.mas_equalTo(PXFIT_HEIGHT(96));
    }];
    
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithRGBHex:0xe8e8e8];
    [_companyInfoContainerView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_companyInfoContainerView).with.offset(PXFIT_WIDTH(25));
        make.right.mas_equalTo(_companyInfoContainerView).with.offset(-PXFIT_WIDTH(25));
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(companyNameLabel.mas_bottom);
    }];
    
    
    [companyAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_companyInfoContainerView).with.offset(PXFIT_WIDTH(20));
        make.top.mas_equalTo(_lineView.mas_bottom);
        make.height.mas_equalTo(addressTextViewHeight);
        //make.height.mas_equalTo(addressTextViewHeight < PXFIT_HEIGHT(96)?PXFIT_HEIGHT(96):addressTextViewHeight);
        make.width.mas_equalTo(labelTextWidth);
    }];
    [companyAddressLabel setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
    
    _companyAddressTextView.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
    [_companyInfoContainerView addSubview:_companyAddressTextView];
    [_companyAddressTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(companyAddressLabel.mas_right).with.offset(PXFIT_WIDTH(20));
        make.right.mas_equalTo(_companyInfoContainerView).with.offset(-PXFIT_WIDTH(20));
        make.top.mas_equalTo(_lineView.mas_bottom);
        make.height.mas_equalTo(addressTextViewHeight < PXFIT_HEIGHT(96)?PXFIT_HEIGHT(96):addressTextViewHeight);
    }];
    
    _companyInfoTableView = [[UITableView alloc] init];
    _companyInfoTableView.tag = TABLEVIEW_COMPANYINFO;
    _companyInfoTableView.delegate = self;
    _companyInfoTableView.dataSource = self;
    _companyInfoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _companyInfoTableView.separatorColor = [UIColor colorWithRGBHex:0xe8e8e8];
    _companyInfoTableView.layer.borderColor = [UIColor colorWithRGBHex:0xe8e8e8].CGColor;
    _companyInfoTableView.layer.borderWidth = 1;
    _companyInfoTableView.scrollEnabled = NO;
    [_companyInfoTableView registerClass:[CloudCompanyAppointmentCell class] forCellReuseIdentifier:NSStringFromClass([CloudCompanyAppointmentCell class])];
    [containerView addSubview:_companyInfoTableView];
    [_companyInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containerView);
        make.top.mas_equalTo(_companyInfoContainerView.mas_bottom).with.offset(PXFIT_HEIGHT(20));
        make.height.mas_equalTo(PXFIT_HEIGHT(96)*4);
    }];

    AppointmentInfoView* infoView = [[AppointmentInfoView alloc] init];
    [containerView addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containerView);
        make.top.mas_equalTo(_companyInfoTableView.mas_bottom).with.offset(PXFIT_HEIGHT(20));
    }];
    
    UIView* bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containerView);
        make.top.mas_equalTo(infoView.mas_bottom);
        make.height.mas_equalTo(PXFIT_HEIGHT(136));
    }];
    
    UIButton* appointmentBtn = [UIButton buttonWithTitle:@"预 约"
                                                    font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Button_Size)]
                                               textColor:[UIColor whiteColor]
                                         backgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue]];
    appointmentBtn.layer.cornerRadius = 5;
    [appointmentBtn addTarget:self action:@selector(appointmentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:appointmentBtn];
    [appointmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView);
        make.left.mas_equalTo(bottomView).with.offset(PXFIT_WIDTH(24));
        make.width.mas_equalTo(SCREEN_WIDTH-2*PXFIT_WIDTH(24));
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
    
}

-(void)loadData
{
//    CGFloat containerHeight = _companyInfoContainerView.frame.size.height;
//    
//    _companyNameTextView.text = gCompanyInfo.cUnitName;
//    [_companyNameTextView sizeToFit];
//    CGSize size = [_companyNameTextView sizeThatFits:CGSizeMake(CGRectGetWidth(_companyNameTextView.frame), FIT_HEIGHT(10000))];
////    if (size.height <= PXFIT_HEIGHT(96)){
////        
////    }else{
////        [_companyNameTextView mas_updateConstraints:^(MASConstraintMaker *make) {
////            make.height.mas_equalTo([NSNumber numberWithFloat:size.height]);
////        }];
////    }
//    /*
//     make.left.mas_equalTo(companyAddressLabel.mas_right).with.offset(PXFIT_WIDTH(20));
//     make.right.mas_equalTo(_companyInfoContainerView).with.offset(-PXFIT_WIDTH(20));
//     make.top.mas_equalTo(_lineView.mas_bottom);
//     make.height.mas_equalTo(PXFIT_HEIGHT(96));*/
//    
//    _companyAddressTextView.text = gCompanyInfo.cUnitAddr;
//    [_companyAddressTextView sizeToFit];
//   // CGSize size ;
//    
//    CGFloat testWidth = _companyAddressTextView.frame.size.width;
//    size = [_companyAddressTextView sizeThatFits:CGSizeMake(300, FIT_HEIGHT(10000))];
//    if (size.height <= PXFIT_HEIGHT(96))
//        return;
//    
//    [_companyInfoContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(_companyInfoContainerView.frame.size.height + size.height - PXFIT_HEIGHT(96));
//    }];
//    
//    [_companyAddressTextView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo([NSNumber numberWithFloat:size.height]);
//    }];
//    
//    [self.view setNeedsLayout];
    //[_companyNameTextView]
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self registerKeyboardNotification];
    
 //   [self loadData];
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self cancelKeyboardNotification];
}

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


#pragma mark - Action
-(void)appointmentBtnClicked:(id)sender
{
    if(_brContract == nil)
    {
        _brContract = [[BRContract alloc]init];
    }
    _brContract.unitCode = gCompanyInfo.cUnitCode;
    _brContract.unitName = gCompanyInfo.cUnitName;
    int customercount;
    @try {
       customercount = [_exminationCountField.text integerValue] + _customerArr.count;
    }
    @catch (NSException *e){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"请输入正确的体检人数" removeDelay:2];
        return ;
    }
    if(customercount <= 0){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"体检人数不能为 0" removeDelay:3];
        return ;
    }
    _brContract.regCheckNum = customercount;    // 体检人数

    if(_centerCoordinate.latitude < 0){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"体检地址不存在，请选择一个地址" removeDelay:3];
        return ;
    }
    if (_contactPersonField.text.length == 0) {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"请输入联系人" removeDelay:3];
        return ;
    }
    if (_cityName == nil) {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"体检地址不存在，请选择一个地址" removeDelay:3];
        return ;
    }
    // 将百度地图转为gps地图
    PositionUtil *positionUtil = [[PositionUtil alloc]init];
    CLLocationCoordinate2D gpsCoor = [positionUtil bd2wgs:_centerCoordinate.latitude lon:_centerCoordinate.longitude];
    _brContract.regPosLO = gpsCoor.longitude;
    _brContract.regPosLA = gpsCoor.latitude;
    _brContract.regPosAddr = _location;
    _brContract.regTime = [[NSDate date] timeIntervalSince1970];

    if (_sercersPositionInfo) {
        _brContract.regBeginDate = _sercersPositionInfo.startTime;
        _brContract.regEndDate = _sercersPositionInfo.endTime;
    }
    else {
        NSArray *dateArray = [_dateStrTextView.text componentsSeparatedByString:@"~"];
        if (dateArray.count == 0) {
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"你还未填写预约时间" removeDelay:3];
            return ;
        }
        _brContract.regBeginDate = [dateArray[0] convertDateStrToLongLong];
        _brContract.regEndDate = [dateArray[1] convertDateStrToLongLong];
    }
    _brContract.linkUser = _contactPersonField.text;
    _brContract.linkPhone = gCompanyInfo.cLinkPhone;
    _brContract.cityName = _cityName;
    _brContract.checkType = @"1";
    _brContract.testStatus = @"-1"; // -1未检，0签到，1在检，2延期，3完成，9已出报告和健康证

    [[HttpNetworkManager getInstance]createOrUpdateBRCoontract:_brContract employees:_customerArr reslutBlock:^(BOOL result, NSError *error) {
        if (!error) {
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"预约成功！" removeDelay:3];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self backToPre:nil];
            });
        }
        else {
            NSLog(@"error :%@", error);
        }
    }];
}

- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer
{
    
    if(recognizer.view.tag != TEXTFIELD_CONTACTCOUNT && recognizer.view.tag != TEXTFIELD_PHONE && recognizer.view.tag != TEXTFIELD_CONTACT){
        [_contactPersonField resignFirstResponder];
        [_phoneNumField resignFirstResponder];
        [_exminationCountField resignFirstResponder];
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case TABLEVIEW_BASEINFO:
            return 2;
        case TABLEVIEW_COMPANYINFO:
            return 4;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case TABLEVIEW_BASEINFO:
        {
            BaseInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BaseInfoTableViewCell class])];
            if (indexPath.row == 0){
                cell.iconName = @"search_icon";
                cell.textView.text = _location;
                cell.textView.userInteractionEnabled = NO;
            }else{
                cell.iconName = @"date_icon";
                if (self.isCustomerServerPoint == NO){
                    cell.textView.text = self.appointmentDateStr;
                }else{
                    cell.textView.text = _dateString;
                }
                cell.textView.userInteractionEnabled = NO;
                _dateStrTextView = cell.textView;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case TABLEVIEW_COMPANYINFO:
        {
            if (indexPath.row == 3){
                //添加单位员工
                CloudCompanyAppointmentStaffCell* cell = [[CloudCompanyAppointmentStaffCell alloc] init];
                cell.staffCount = _customerArr.count;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
            CloudCompanyAppointmentCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CloudCompanyAppointmentCell class])];
            if (indexPath.row == 0){
                cell.textFieldType = CDA_CONTACTPERSON;
                cell.textField.text = gCompanyInfo.cLinkPeople;
                cell.textField.enabled = YES;
                _contactPersonField = cell.textField;
                cell.textField.tag = TEXTFIELD_CONTACT;
            }else if (indexPath.row == 1){
                cell.textFieldType = CDA_CONTACTPHONE;
                cell.textField.text = gCompanyInfo.cLinkPhone;
                cell.textField.enabled = YES;
                _phoneNumField = cell.textField;
                cell.textField.tag = TEXTFIELD_PHONE;
            }else if (indexPath.row == 2){
                cell.textFieldType = CDA_PERSON;
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                cell.textField.enabled = YES;
                _exminationCountField = cell.textField;
                cell.textField.tag = TEXTFIELD_CONTACTCOUNT;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        default:
            break;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PXFIT_HEIGHT(96);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case TABLEVIEW_BASEINFO:
        {
            if (self.isCustomerServerPoint == NO)
                return;
            if (indexPath.row == 0){
                SelectAddressViewController* selectAddressViewController = [[SelectAddressViewController alloc] init];
                selectAddressViewController.addressStr = _location;
                selectAddressViewController.switchStyle = SWITCH_MISS;
                [selectAddressViewController getAddressArrayWithBlock:^(NSString *city, NSString *district, NSString *address, CLLocationCoordinate2D coor) {
                    _cityName = city;
                    _location = address;
                    _centerCoordinate = coor;
                    BaseInfoTableViewCell* cell = [_baseInfoTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    cell.textView.text = _location;
                    //[tableView reloadData];
                }];
                [self.navigationController pushViewController:selectAddressViewController animated:YES];
            }else{
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
                    _dateString = dateStr;
                }];
                [self.navigationController pushViewController:cloudAppointmentDateVC animated:YES];
            }
        }
            break;
        case TABLEVIEW_COMPANYINFO:
        {
            [_contactPersonField resignFirstResponder];
            [_phoneNumField resignFirstResponder];
            [_exminationCountField resignFirstResponder];
        }
            break;
        case TABLEVIEW_STAFFINFO:
        {
            AddWorkerViewController* addworkerViewController = [[AddWorkerViewController alloc] init];
            addworkerViewController.switchStyle = SWITCH_MISS;
            addworkerViewController.selectedWorkerArray = [NSMutableArray arrayWithArray:self.customerArr];
            __weak CloudAppointmentCompanyViewController * weakSelf = self;
            [addworkerViewController getWorkerArrayWithBlock:^(NSArray *workerArray) {
                weakSelf.customerArr = workerArray;
                [weakSelf.staffTableView reloadData];
            }];
            [self.navigationController pushViewController:addworkerViewController animated:YES];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//如果当前是tableView
        return NO; //继续传递
    }
    return YES;
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



@end
