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
#import <MJExtension.h>

#import "Constants.h"

#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "NSDate+Custom.h"
#import "UILabel+Easy.h"
#import "NSString+Custom.h"
#import "UIView+borderWidth.h"

#import "BaseInfoTableViewCell.h"
#import "CloudCompanyAppointmentCell.h"
#import "CloudCompanyAppointmentStaffCell.h"

#import "AppointmentInfoView.h"

#import "SelectAddressViewController.h"
#import "AddWorkerViewController.h"
#import "MyCheckListViewController.h"
#import "QRController.h"
#import "StaffStateViewController.h"

#import "Customer.h"
#import "PositionUtil.h"
#import "HttpNetworkManager.h"
#import "HCNetworkReachability.h"
#import "WZFlashButton.h"

#import "MethodResult.h"

#define Button_Size 26

#define Cell_Font 24
#define Cell_Font_Samll 23

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)


@interface CloudAppointmentCompanyViewController() <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UITextViewDelegate>
{
    UITableView         *_baseInfoTableView;
    UITableView         *_companyInfoTableView;
    
    NSString            *_dateString;
    
    UITextField         *_contactPersonField;
    UITextField         *_phoneNumField;
    
    //键盘收缩相关
    BOOL                 _isFirstShown;
    CGFloat              _viewHeight;

    UITextView         *_dateStrTextView;
    
    
    //体检信息相关
    UITextView          *_examinationAddressTextView; //体检地址
    UITextField         *_examinationTimeTextField;   //体检时间
    UITextField         *_exminationCountField;       //体检人数
    
    UITextView          *_companyAddressTextView;

    UIView              *_lineView;
    
    UILabel             *_exampleLabel;
    
    
    BOOL                _isChanged;
}

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


//选择的员工列表
@property (nonatomic, strong) NSArray* customerArr;
@property (nonatomic ,strong) UITableView* staffTableView;

@end

@implementation CloudAppointmentCompanyViewController

#pragma mark - Setter & Getter

-(void)setBrContract:(BRContract *)brContract
{
    _brContract = brContract;
    
    [[HttpNetworkManager getInstance] getCustomerListByBRContract:_brContract.code resultBlock:^(NSArray *result, NSError *error) {
        if (error != nil){
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"查询单位员工失败" removeDelay:3];
            return;
        }
        _customerArr = result;
    }];
}


-(void)setLocation:(NSString *)location{
    _location = location;
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

- (void)changedInformationWithResultBlock:(resultBlock)blcok
{
    _resultblock = blcok;
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
    
    if (_brContract){
        [self initNavigationContact];
    }else{
        [self initNavgation];
    }
    
    self.view.backgroundColor = [UIColor colorWithRGBHex:HC_Base_BackGround];
    
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
    containerView.backgroundColor = [UIColor colorWithRGBHex:HC_Base_BackGround];
    [scrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    UILabel* titleLabel = [UILabel labelWithText:gCompanyInfo.cUnitName
                                            font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)]
                                       textColor:[UIColor colorWithRGBHex:HC_Gray_Text]];
    titleLabel.backgroundColor = [UIColor colorWithRGBHex:HC_Base_BackGround];
    [containerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView).with.offset(10);
        make.top.mas_equalTo(containerView).with.offset(10);
    }];
    
    //第一个板块 预约地址 & 预约时间 & 体检人数
    //体检地址 多行处理
    UIView* examinationContainerView = [[UIView alloc] init];
    examinationContainerView.layer.borderWidth = 1;
    examinationContainerView.layer.borderColor = [UIColor colorWithRGBHex:0xe8e8e8].CGColor;
    examinationContainerView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:examinationContainerView];
    
    UILabel* examinationAddressLabel = [UILabel labelWithText:@"体检地址"
                                                  font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)]
                                             textColor:[UIColor blackColor]];
    NSDictionary* attribute = @{NSFontAttributeName:examinationAddressLabel.font};
    CGSize size = [examinationAddressLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, PXFIT_HEIGHT(96)) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    //获得label的宽度
    CGFloat labelTextWidth = size.width + 1;
    //获得TextView的宽度
    CGFloat textViewWidth = SCREEN_WIDTH - labelTextWidth - PXFIT_WIDTH(20) * 3;
    
    _examinationAddressTextView = [[UITextView alloc] init];
    if (_brContract){
        _examinationAddressTextView.text = _brContract.regPosAddr;
    }else{
        _examinationAddressTextView.text = _location;
    }
    _examinationAddressTextView.scrollEnabled = NO;
    _examinationAddressTextView.userInteractionEnabled = NO;
    _examinationAddressTextView.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
    _examinationAddressTextView.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
    _examinationAddressTextView.delegate = self;
    _examinationAddressTextView.returnKeyType = UIReturnKeyDone;
    
    [examinationContainerView addSubview:examinationAddressLabel];
    [examinationContainerView addSubview:_examinationAddressTextView];
    
    //获得单位名称的高度 http://www.360doc.com/content/15/0608/16/11417867_476582625.shtml
    size = [_examinationAddressTextView sizeThatFits:CGSizeMake(textViewWidth, MAXFLOAT)];
    CGFloat nameTextViewHeight = size.height;
    CGFloat containerViewHeight = (nameTextViewHeight < PXFIT_HEIGHT(96) ? PXFIT_HEIGHT(96) : nameTextViewHeight) + PXFIT_HEIGHT(96) * 2;
    
    [examinationContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containerView);
        make.height.mas_equalTo(containerViewHeight + 2);
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(PXFIT_HEIGHT(20));
    }];
    
   
    [examinationAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(examinationContainerView).with.offset(PXFIT_WIDTH(20));
        make.top.mas_equalTo(examinationContainerView);
        make.height.mas_equalTo(nameTextViewHeight < PXFIT_HEIGHT(96)?PXFIT_HEIGHT(96):nameTextViewHeight);
        make.width.mas_equalTo(labelTextWidth);
    }];
    [examinationAddressLabel setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
    [_examinationAddressTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(examinationAddressLabel.mas_right).with.offset(PXFIT_WIDTH(20));
        make.right.mas_equalTo(examinationContainerView).with.offset(-PXFIT_WIDTH(20));
        make.centerY.mas_equalTo(examinationAddressLabel);
        make.height.mas_equalTo( nameTextViewHeight);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithRGBHex:0xe8e8e8];
    [examinationContainerView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(examinationContainerView).with.offset(PXFIT_WIDTH(25));
        make.right.mas_equalTo(examinationContainerView).with.offset(-PXFIT_WIDTH(25));
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(examinationAddressLabel.mas_bottom);
    }];
    
    //体检时间
    UILabel* examinationTimeLabel = [UILabel labelWithText:@"体检时间"
                                                         font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)]
                                                    textColor:[UIColor blackColor]];
    [examinationContainerView addSubview:examinationTimeLabel];
    [examinationTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lineView.mas_bottom);
        make.left.mas_equalTo(examinationContainerView).with.offset(PXFIT_WIDTH(20));
        make.width.mas_equalTo(labelTextWidth);
        make.height.mas_equalTo(PXFIT_HEIGHT(96));
    }];
    
    _examinationTimeTextField = [[UITextField alloc] init];
    _examinationTimeTextField.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
    [examinationContainerView addSubview:_examinationTimeTextField];
    
    //合同时间
    if (_brContract){
        if (_brContract.checkSiteID == nil || [_brContract.checkSiteID isEqualToString:@""]){
            
            _examinationTimeTextField.text = [NSString stringWithFormat:@"%@~%@", [NSDate converLongLongToChineseStringDate:_brContract.regBeginDate/1000],
                     [NSDate converLongLongToChineseStringDate:_brContract.regEndDate/1000]];
        }else{
            //基于服务点(移动+固定)
            if ([_brContract.hosCode isEqualToString:_brContract.checkSiteID]){
                //固定
                _examinationTimeTextField.text = [NSString stringWithFormat:@"工作日(%@~%@)", [NSDate getHour_MinuteByDate:_brContract.servicePoint.startTime/1000],
                         [NSDate getHour_MinuteByDate:_brContract.servicePoint.endTime/1000]];
            }else{
                NSString *year = [NSDate getYear_Month_DayByDate:_brContract.servicePoint.startTime/1000];
                NSString *start = [NSDate getHour_MinuteByDate:_brContract.servicePoint.startTime/1000];
                NSString *end = [NSDate getHour_MinuteByDate:_brContract.servicePoint.endTime/1000];
                _examinationTimeTextField.text = [NSString stringWithFormat:@"%@(%@~%@)", year, start, end];
            }
        }
    }else{
        if (_isCustomerServerPoint == NO)
            _examinationTimeTextField.text = _appointmentDateStr;
        else
            _examinationTimeTextField.text = _dateString;
    }
    
    [_examinationTimeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(examinationTimeLabel.mas_right).with.offset(PXFIT_WIDTH(20));
        make.right.mas_equalTo(examinationContainerView).with.offset(-PXFIT_WIDTH(20));
        make.centerY.mas_equalTo(examinationTimeLabel);
    }];
    
    UIButton* addressBtn = [[UIButton alloc] init];
    addressBtn.backgroundColor = [UIColor clearColor];
    [examinationContainerView addSubview:addressBtn];
    [addressBtn addTarget:self action:@selector(addressBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(examinationContainerView);
        make.bottom.mas_equalTo(_lineView.mas_top);
    }];
    
    UIButton* timeBtn = [[UIButton alloc] init];
    timeBtn.backgroundColor = [UIColor clearColor];
    [examinationContainerView addSubview:timeBtn];
    [timeBtn addTarget:self action:@selector(timeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(examinationContainerView);
        make.top.mas_equalTo(_lineView.mas_bottom);
    }];
    
    //横线
    UIView* secondLineView = [[UIView alloc] init];
    secondLineView.backgroundColor = [UIColor colorWithRGBHex:0xe8e8e8];
    [examinationContainerView addSubview:secondLineView];
    [secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(examinationContainerView).with.offset(PXFIT_WIDTH(25));
        make.right.mas_equalTo(examinationContainerView).with.offset(-PXFIT_WIDTH(25));
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(examinationTimeLabel.mas_bottom);
    }];
    
    //体检人数
    UILabel* examinationCountLabel = [UILabel labelWithText:@"体检人数"
                                                      font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)]
                                                 textColor:[UIColor blackColor]];
    [examinationContainerView addSubview:examinationCountLabel];
    [examinationCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(secondLineView.mas_bottom);
        make.left.mas_equalTo(examinationContainerView).with.offset(PXFIT_WIDTH(20));
        make.height.mas_equalTo(PXFIT_HEIGHT(96));
    }];
    _exminationCountField = [[UITextField alloc] init];
    _exminationCountField.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
    [examinationContainerView addSubview:_exminationCountField];
    [_exminationCountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(examinationCountLabel.mas_right).with.offset(PXFIT_WIDTH(20));
        make.right.mas_equalTo(examinationContainerView).with.offset(-PXFIT_WIDTH(20));
        make.centerY.mas_equalTo(examinationCountLabel);
    }];
    if (_brContract){
        _exminationCountField.text = [NSString stringWithFormat:@"%ld",_brContract.regCheckNum];
    }else{
        _exminationCountField.text = @"0";
    }
    
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
        make.top.mas_equalTo(examinationContainerView.mas_bottom).with.offset(PXFIT_HEIGHT(20));
        make.height.mas_equalTo(PXFIT_HEIGHT(96)*3);
    }];

    if (_brContract){
        UITableView* todoContract = [[UITableView alloc] init];
        todoContract.tag = TABLEVIEW_BASEINFO;
        todoContract.dataSource = self;
        todoContract.delegate = self;
        todoContract.scrollEnabled = NO;
        [todoContract registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [containerView addSubview:todoContract];
        [todoContract mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_companyInfoTableView.mas_bottom);
            make.left.right.mas_equalTo(containerView);
            make.height.mas_equalTo(PXFIT_HEIGHT(100)*2 + PXFIT_HEIGHT(20)*2);
        }];
        
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(todoContract.mas_bottom);
        }];
    }else{
        AppointmentInfoView* infoView = [[AppointmentInfoView alloc] init];
        [infoView addBordersToEdge:UIRectEdgeTop withColor:[UIColor colorWithRGBHex:0Xe8e8e8] andWidth:1];
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
        
        WZFlashButton* appointmentBtn = [[WZFlashButton alloc] init];
        appointmentBtn.backgroundColor = [UIColor colorWithRGBHex:HC_Base_Blue];
        appointmentBtn.flashColor = [UIColor colorWithRGBHex:HC_Base_Blue_Pressed];
        appointmentBtn.timeInterval = 3;
        [appointmentBtn setText:@"预 约" withTextColor:[UIColor whiteColor]];
        appointmentBtn.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Button_Size)];
        appointmentBtn.layer.cornerRadius = 5;
        __weak typeof (self) wself = self;
        appointmentBtn.clickBlock = ^(){
            [wself appointmentBtnClicked];
        };
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
    }
    
    //添加手势
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    singleRecognizer.delegate = self;
    [self.view addGestureRecognizer:singleRecognizer];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self registerKeyboardNotification];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self cancelKeyboardNotification];
}

-(void)initNavigationContact
{
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    self.title = @"单位合同";
    
    UIButton* editBtn = [UIButton buttonWithTitle:@"保存"
                                             font:[UIFont fontWithType:UIFontOpenSansRegular size:17]
                                        textColor:[UIColor colorWithRGBHex:HC_Blue_Text]
                                  backgroundColor:[UIColor clearColor]];
    [editBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
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
-(void)appointmentBtnClicked
{
    if([HCNetworkReachability getInstance].getCurrentReachabilityState == 0){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"网络连接失败，请检查网络设置" removeDelay:2];
        return;
    }
    
    if (_location == nil || [_location isEqualToString:@""])
    {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"体检地址不存在，请选择一个地址" removeDelay:3];
        return ;
    }
    
    if (_contactPersonField.text.length == 0)
    {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"请输入联系人" removeDelay:3];
        return ;
    }
    
    if (_phoneNumField.text.length != 11)
    {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"请输入正确的电话号码" removeDelay:3];
        return;
    }
    
    NSInteger customercount;
    @try {
        customercount = [_exminationCountField.text integerValue];
    }
    @catch (NSException *e){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"请输入正确的预约人数" removeDelay:2];
        return ;
    }
    if(customercount <= 0){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"预约人数不能为 0" removeDelay:3];
        return ;
    }
    if (customercount < _customerArr.count) {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"预约人数必须大于所选员工数" removeDelay:3];
        return ;
    }
    
    if(_brContract == nil)
    {
        _brContract = [[BRContract alloc]init];
        _brContract.unitCode = gCompanyInfo.cUnitCode;
        _brContract.unitName = gCompanyInfo.cUnitName;
    }
    
    if (_sercersPositionInfo == nil)
    {
        //云预约
        NSArray *dateArray = [_examinationTimeTextField.text componentsSeparatedByString:@"~"];
        if (dateArray.count == 0) {
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"你还未填写预约时间" removeDelay:3];
            return ;
        }
        _brContract.regBeginDate = [dateArray[0] convertDateStrToLongLong]*1000;
        _brContract.regEndDate = [dateArray[1] convertDateStrToLongLong]*1000;
        _brContract.regPosLA = _centerCoordinate.latitude;
        _brContract.regPosLO = _centerCoordinate.longitude;
        _brContract.regPosAddr = _location;
    }
    else
    {
        //基于服务点预约
        _brContract.servicePoint = _sercersPositionInfo;
        _brContract.regTime = _sercersPositionInfo.startTime;
        _brContract.regBeginDate = _sercersPositionInfo.startTime;
        _brContract.regEndDate = _sercersPositionInfo.endTime;
        _brContract.regPosAddr = _sercersPositionInfo.address;
        _brContract.regPosLA = _sercersPositionInfo.positionLa;
        _brContract.regPosLO = _sercersPositionInfo.positionLo;
        _brContract.hosCode = _sercersPositionInfo.cHostCode;
        //移动服务点 id 固定 cHostCode
         _brContract.checkSiteID = _sercersPositionInfo.type == 1 ? _sercersPositionInfo.id : _sercersPositionInfo.cHostCode;
    }

    
    _brContract.linkUser = _contactPersonField.text;
    _brContract.linkPhone = _phoneNumField.text;
    _brContract.checkType = @"1";// 1为健康证
    _brContract.testStatus = @"-1"; // -1未检，0签到，1在检，2延期，3完成，9已出报告和健康证
    _brContract.regCheckNum = customercount;
    _brContract.cityName = gCurrentCityName;
 
    
    [[HttpNetworkManager getInstance] createOrUpdateBRCoontract:_brContract employees:_customerArr reslutBlock:^(NSDictionary *result, NSError *error) {
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
        
        MyCheckListViewController* mycheckListVC = [[MyCheckListViewController alloc] init];
        mycheckListVC.popStyle = POPTO_ROOT;
        [self.navigationController pushViewController:mycheckListVC animated:YES];
    }];
}

- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer
{
    //AddressClickTag
    if(recognizer.view.tag != TEXTFIELD_CONTACTCOUNT && recognizer.view.tag != TEXTFIELD_PHONE && recognizer.view.tag != TEXTFIELD_CONTACT){
        [_contactPersonField resignFirstResponder];
        [_phoneNumField resignFirstResponder];
        [_exminationCountField resignFirstResponder];
    }
}

-(void)addressBtnClicked:(UIButton*)sender
{
    //不可修改的情况
    
    //如果基于固定服务点
    if (self.isCustomerServerPoint == NO)
        return;
    SelectAddressViewController* selectAddressViewController = [[SelectAddressViewController alloc] init];
    selectAddressViewController.addressStr = _location;
    [selectAddressViewController getAddressArrayWithBlock:^(NSString *city, NSString *district, NSString *address, CLLocationCoordinate2D coor) {
        _cityName = city;
        _location = address;
        _centerCoordinate = coor;
        _examinationAddressTextView.text = _location;
    }];
    [self.navigationController pushViewController:selectAddressViewController animated:YES];
    [self inputWidgetResign];
}

-(void)timeBtnClicked:(UIButton*)sender
{
    //只有云预约才可以修改
    if (_isCustomerServerPoint == NO)
        return;
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
        _examinationTimeTextField.text = dateStr;
        _dateString = dateStr;
    }];
    [self.navigationController pushViewController:cloudAppointmentDateVC animated:YES];
    [self inputWidgetResign];
}

-(void)editBtnClicked:(UIButton*)sender
{
    //修改
    [self.view endEditing:YES];
    //如果预约人数 小于 已选员工
    if ([_exminationCountField.text intValue] < _customerArr.count){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"预约人数必须大于所选员工数" removeDelay:3];
        return ;
    }
    
    //非服务点预约才能修改地址和时间
    if (_brContract.checkSiteID == nil || [_brContract.checkSiteID isEqualToString:@""])
    {
        NSArray* array = [_examinationTimeTextField.text  componentsSeparatedByString:@"~"];
        _brContract.regBeginDate = [array[0] convertDateStrToLongLong]*1000;
        _brContract.regEndDate = [array[1] convertDateStrToLongLong]*1000;
        _brContract.regPosAddr = _examinationAddressTextView.text;
        _brContract.regPosLA = _centerCoordinate.latitude;
        _brContract.regPosLO = _centerCoordinate.longitude;
    }
    
    _brContract.linkUser = _contactPersonField.text;
    _brContract.linkPhone = _phoneNumField.text;
    _brContract.regCheckNum = [_exminationCountField.text intValue];
    
    [[HttpNetworkManager getInstance] createOrUpdateBRCoontract:_brContract
                                                      employees:_customerArr
                                                    reslutBlock:^(NSDictionary *result, NSError *error) {
                                                        if (error != nil){
                                                            _brContract = nil;
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
                                                        [RzAlertView showAlertLabelWithTarget:self.view Message:@"修改成功" removeDelay:2];
                                                        _isChanged = YES;
                                                    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case TABLEVIEW_BASEINFO:
            return 1;
        case TABLEVIEW_COMPANYINFO:
            return 4;
        default:
            break;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == TABLEVIEW_BASEINFO){
        return 2;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return tableView.tag == TABLEVIEW_BASEINFO?PXFIT_HEIGHT(20):0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return tableView.tag == TABLEVIEW_BASEINFO?1:0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case TABLEVIEW_BASEINFO:
        {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
            cell.textLabel.textColor = [UIColor blackColor];
            if (indexPath.section == 0){
                cell.textLabel.text = @"体检态势";
            }else{
                cell.textLabel.text = @"二维码";
            }
            return cell;
        }
            
        case TABLEVIEW_COMPANYINFO:
        {
            if (indexPath.row == 2){
                //添加单位员工
                CloudCompanyAppointmentStaffCell* cell = [[CloudCompanyAppointmentStaffCell alloc] init];
                cell.staffCount = _customerArr.count;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
            CloudCompanyAppointmentCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CloudCompanyAppointmentCell class])];
            if (indexPath.row == 0){
                cell.textFieldType = CDA_CONTACTPERSON;
                if (_brContract)
                    cell.textField.text = _brContract.linkUser;
                else
                    cell.textField.text = gCompanyInfo.cLinkPeople;
                cell.textField.enabled = YES;
                cell.textField.tag = TEXTFIELD_CONTACT;
                cell.textField.returnKeyType = UIReturnKeyDone;
                cell.textField.delegate = self;
                _contactPersonField = cell.textField;
            }else if (indexPath.row == 1){
                cell.textFieldType = CDA_CONTACTPHONE;
                if (_brContract)
                    cell.textField.text = _brContract.linkPhone;
                else
                    cell.textField.text = gCompanyInfo.cLinkPhone;
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                cell.textField.enabled = YES;
                cell.textField.tag = TEXTFIELD_PHONE;
                //cell.textField.returnKeyType = UIReturnKeyDone;
                cell.textField.delegate = self;
                _phoneNumField = cell.textField;
            }else if (indexPath.row == 3){
                cell.textFieldType = CDA_PERSON;
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                cell.textField.enabled = YES;
                cell.textField.tag = TEXTFIELD_CONTACTCOUNT;
                cell.textField.returnKeyType = UIReturnKeyDone;
                cell.textField.delegate = self;
                _exminationCountField = cell.textField;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
    default:
            break;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PXFIT_HEIGHT(100);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case TABLEVIEW_BASEINFO:
        {
            if (indexPath.section == 0){
                StaffStateViewController* staffStateVC = [[StaffStateViewController alloc] init];
                staffStateVC.contractCode = _brContract.code;
                [self.navigationController pushViewController:staffStateVC animated:YES];
                [self inputWidgetResign];
            }else{
                QRController* qrController = [[QRController alloc] init];
                qrController.qrContent = [NSString stringWithFormat:@"http://webserver.zeekstar.com/webserver/weixin/staffRegister.jsp?brContractCode=%@", _brContract.code];
                qrController.infoStr = @"您还有员工没有在合同里面？分享二维码给他直接加入。";
                [self.navigationController pushViewController:qrController animated:YES];
                [self inputWidgetResign];
            }
        }
            break;
        case TABLEVIEW_COMPANYINFO:
        {
            if (indexPath.row == 0){
                [_contactPersonField becomeFirstResponder];
                
            }else if (indexPath.row == 1){
                [_phoneNumField becomeFirstResponder];
            }else if (indexPath.row == 3){
                [_exminationCountField becomeFirstResponder];
            }else{
                AddWorkerViewController* addworkerViewController = [[AddWorkerViewController alloc] init];
                if (_brContract)
                    addworkerViewController.cUnitCode = _brContract.unitCode;
                else
                    addworkerViewController.cUnitCode = gCompanyInfo.cUnitCode;
                addworkerViewController.selectedWorkerArray = [NSMutableArray arrayWithArray:self.customerArr];
                __weak CloudAppointmentCompanyViewController * weakSelf = self;
                [addworkerViewController getWorkerArrayWithBlock:^(NSArray *workerArray) {
                    weakSelf.customerArr = workerArray;
                    NSIndexPath *path = [NSIndexPath indexPathForItem:2 inSection:0];
                    [_companyInfoTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
                 
                    if([_exminationCountField.text integerValue] < workerArray.count){
                        _exminationCountField.text = [NSString stringWithFormat:@"%ld", workerArray.count];
                    }
                 
                }];
                [self.navigationController pushViewController:addworkerViewController animated:YES];
                [self inputWidgetResign];
            }
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

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    //判断电话号码
    if (textField.tag == TEXTFIELD_PHONE){
        if (![self isPureInt:string]){
            return YES;
        }
        if (textField.text.length + string.length > 11){
            return NO;
        }else if (textField.text.length == 10){
            return YES;
        }else{
            return YES;
        }
    }
    
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextView Delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
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
    } completion:NULL];
}

-(void)inputWidgetResign
{
    [_companyAddressTextView resignFirstResponder];
    [_contactPersonField resignFirstResponder];
    [_phoneNumField resignFirstResponder];
    [_exminationCountField resignFirstResponder];
}



@end
