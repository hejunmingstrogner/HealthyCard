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

#import "UnitCheckListVIewController.h"
#import "PersonalCheckListViewContrller.h"
#import "HomeServiceListViewController.h"

#import "QRController.h"
#import "StaffStateViewController.h"

#import "Customer.h"
#import "PositionUtil.h"
#import "HttpNetworkManager.h"
#import "HCNetworkReachability.h"
#import "HCBackgroundColorButton.h"

#import "MethodResult.h"

#define Button_Size 26

#define Cell_Font 23
#define Cell_Font_Samll 23

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)


@interface CloudAppointmentCompanyViewController() <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,HomeServiceListViewControllerDelegate>
{
    UITableView         *_baseInfoTableView;
    UITableView         *_companyInfoTableView;
    UITableView         *_examTableView;
    
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
    
    BOOL                _isAppointmentBtnResponse;
    
    //移动服务点(YES) 固定服务点(NO)
    BOOL                _isTemperaryPoint;
    
    
    //是待处理项(YES) 新建的预约(No)
    BOOL                    _isTodoTask;
    
    
    ServersPositionAnnotionsModel   *_choosedFixedSp;
    
    NSInteger           _payedCount;
}

typedef NS_ENUM(NSInteger, TABLIEVIEWTAG)
{
    TABLEVIEW_BASEINFO = 1001,
    TABLEVIEW_COMPANYINFO,
    TABLEVIEW_EXAM
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
    _isTodoTask =YES;
    
    [[HttpNetworkManager getInstance] findCustomerTestByContract:_brContract.code resultBlock:^(NSArray *result, NSError *error) {
        if (error != nil){
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"查询单位员工失败" removeDelay:3];
            return;
        }
        NSIndexPath *index =  [NSIndexPath indexPathForItem:2 inSection:0];
        CloudCompanyAppointmentStaffCell *cell =  [_companyInfoTableView cellForRowAtIndexPath:index];
        if (cell){
            cell.staffCount = _customerArr.count;
        }
        [_companyInfoTableView reloadData];
        _customerArr = result;
    }];
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
        _appointmentDateStr = [NSString stringWithFormat:@"%@,%@:00", [[NSDate date] getDateStringWithInternel:1], [[[NSDate alloc] initWithTimeIntervalSince1970:sercersPositionInfo.startTime/1000] getHour]];
        _isTemperaryPoint = NO;
    }
    else {
        _appointmentDateStr = [NSString stringWithFormat:@"%@(%@~%@)",  [NSDate getYear_Month_DayByDate:sercersPositionInfo.startTime/1000], [NSDate getHour_MinuteByDate:sercersPositionInfo.startTime/1000], [NSDate getHour_MinuteByDate:sercersPositionInfo.endTime/1000]];
        _isTemperaryPoint = YES;
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
    
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor colorWithRGBHex:HC_Base_BackGround];
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
    
    UILabel* titleLabel = [UILabel labelWithText:gUnitInfo.unitName
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
    
    UILabel* examinationAddressLabel = [UILabel labelWithText:@"体检位置"
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
    
   
    //体检时间
    UILabel* examinationTimeLabel = [UILabel labelWithText:@"体检时间"
                                                         font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)]
                                                    textColor:[UIColor blackColor]];
    [examinationContainerView addSubview:examinationTimeLabel];
    
    _examinationTimeTextField = [[UITextField alloc] init];
    _examinationTimeTextField.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
    [examinationContainerView addSubview:_examinationTimeTextField];
     _appointmentDateStr = (_appointmentDateStr == nil) ? [NSString stringWithFormat:@"%@,08:00", [[NSDate date] getDateStringWithInternel:1]] : _appointmentDateStr;
    //合同时间
    if (_brContract){
        
        if (_brContract.servicePoint && _brContract.servicePoint.type == 1){
            NSString *year = [NSDate getYear_Month_DayByDate:_brContract.servicePoint.startTime/1000];
            NSString *start = [NSDate getHour_MinuteByDate:_brContract.servicePoint.startTime/1000];
            NSString *end = [NSDate getHour_MinuteByDate:_brContract.servicePoint.endTime/1000];
            _appointmentDateStr = [NSString stringWithFormat:@"%@(%@~%@)", year, start, end];
        }else{
            _appointmentDateStr = [NSString stringWithFormat:@"%@", [NSDate converLongLongToChineseStringDateWithHour:_brContract.regTime/1000]];
        }
    }
    _examinationTimeTextField.text = _appointmentDateStr;
    [examinationTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(PXFIT_HEIGHT(96));
        make.left.mas_equalTo(examinationContainerView).with.offset(PXFIT_WIDTH(20));
        make.top.mas_equalTo(examinationContainerView);
        make.width.mas_equalTo(labelTextWidth);
    }];
    
    
    [_examinationTimeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(examinationTimeLabel.mas_right).with.offset(PXFIT_WIDTH(20));
        make.right.mas_equalTo(examinationContainerView).with.offset(-PXFIT_WIDTH(20));
        make.centerY.mas_equalTo(examinationTimeLabel);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithRGBHex:0xe8e8e8];
    [examinationContainerView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(examinationContainerView).with.offset(PXFIT_WIDTH(25));
        make.right.mas_equalTo(examinationContainerView).with.offset(-PXFIT_WIDTH(25));
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(examinationTimeLabel.mas_bottom);
    }];
    
    
    [examinationAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(examinationContainerView).with.offset(PXFIT_WIDTH(20));
        make.top.mas_equalTo(_lineView.mas_bottom);
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
    
    UIButton* timeBtn = [[UIButton alloc] init];
    timeBtn.backgroundColor = [UIColor clearColor];
    [examinationContainerView addSubview:timeBtn];
    [timeBtn addTarget:self action:@selector(timeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(examinationContainerView);
        make.height.mas_equalTo(PXFIT_HEIGHT(96));
    }];
    
    UIButton* addressBtn = [[UIButton alloc] init];
    addressBtn.backgroundColor = [UIColor clearColor];
    [examinationContainerView addSubview:addressBtn];
    [addressBtn addTarget:self action:@selector(addressBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lineView.mas_bottom);
        make.left.right.mas_equalTo(examinationContainerView);
        make.height.mas_equalTo(examinationAddressLabel);
    }];
    
    //横线
    UIView* secondLineView = [[UIView alloc] init];
    secondLineView.backgroundColor = [UIColor colorWithRGBHex:0xe8e8e8];
    [examinationContainerView addSubview:secondLineView];
    [secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(examinationContainerView).with.offset(PXFIT_WIDTH(25));
        make.right.mas_equalTo(examinationContainerView).with.offset(-PXFIT_WIDTH(25));
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(examinationAddressLabel.mas_bottom);
    }];
    
    //体检人数
    UILabel* examinationCountLabel = [UILabel labelWithText:@"预约人数"
                                                      font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)]
                                                 textColor:[UIColor blackColor]];
    [examinationContainerView addSubview:examinationCountLabel];
    [examinationCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(secondLineView.mas_bottom);
        make.left.mas_equalTo(examinationContainerView).with.offset(PXFIT_WIDTH(20));
        make.height.mas_equalTo(PXFIT_HEIGHT(96));
    }];
    _exminationCountField = [[UITextField alloc] init];
    _exminationCountField.keyboardType = UIKeyboardTypeNumberPad;
    _exminationCountField.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
    [examinationContainerView addSubview:_exminationCountField];
    [_exminationCountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(examinationCountLabel.mas_right).with.offset(PXFIT_WIDTH(20));
        make.right.mas_equalTo(examinationContainerView).with.offset(-PXFIT_WIDTH(20));
        make.centerY.mas_equalTo(examinationCountLabel);
    }];
    if (_brContract){
        _exminationCountField.text = [NSString stringWithFormat:@"%ld",(long)_brContract.regCheckNum];
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
        todoContract.layer.borderColor = [UIColor colorWithRGBHex:0xe8e8e8].CGColor;
        todoContract.layer.borderWidth = 1;
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
        
        //合同未生效
        if (_brContract.checkSiteID == nil || [_brContract.checkSiteID isEqualToString:@""]){
            //移动服务点
            UILabel* noticeLabel = [UILabel labelWithText:@"温馨提示"
                                                     font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(23)]
                                                textColor:[UIColor blackColor]];
            [containerView addSubview:noticeLabel];
            [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(containerView).with.offset(10);
                make.top.mas_equalTo(todoContract.mas_bottom).with.offset(10);
            }];
            
            NSString* tipInfo;
            tipInfo = [NSString stringWithFormat:@"当您的付费人员达到16个以后该服务点生效。现在还差%ld人。", 16 - _payedCount];
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
            
            [RzAlertView ShowWaitAlertWithTitle:@"获取付款人数中..."];
            [[HttpNetworkManager getInstance] getChargedCountByContactCode:_brContract.code resultBlock:^(NSInteger result, NSError *error) {
                [RzAlertView CloseWaitAlert];
                if (error){
                    [RzAlertView showAlertLabelWithMessage:@"获取付款人数失败" removewDelay:3];
                }else{
                    itemLabel.text = [NSString stringWithFormat:@"当您的付费人员达到16个以后该服务点生效。现在还差%ld人。", 16 - _payedCount];
                }
            }];
            
        }else{
            [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(todoContract.mas_bottom);
            }];
        }
    }else{
        _examTableView = [[UITableView alloc] init];
        [containerView addSubview:_examTableView];
        _examTableView.dataSource = self;
        _examTableView.delegate = self;
        _examTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _examTableView.separatorColor = [UIColor colorWithRGBHex:0xe8e8e8];
        _examTableView.layer.borderColor = [UIColor colorWithRGBHex:0xe8e8e8].CGColor;
        _examTableView.layer.borderWidth = 1;
        _examTableView.tag = TABLEVIEW_EXAM;
        [_examTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(containerView);
            make.top.equalTo(_companyInfoTableView.mas_bottom).with.offset(10);
            make.height.mas_equalTo(PXFIT_HEIGHT(100)*(1 + ((_sercersPositionInfo == nil) ? 1 : 0)));
        }];
        
        UILabel* noticeLabel = [UILabel labelWithText:@"温馨提示"
                                                 font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)]
                                            textColor:[UIColor blackColor]];
        [containerView addSubview:noticeLabel];
        [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(containerView).with.offset(10);
            make.top.mas_equalTo(_examTableView.mas_bottom).with.offset(10);
        }];
        
        NSString* tipInfo;
        if (_isCustomerServerPoint == YES){
            tipInfo = @"您附近如果没有合适的体检服务点,请通过快速预约告之您的体检位置和体检时间,我们会及时安排体检车上门为您体检办证!";
        }else{
            tipInfo = @"请确认在体检车离开前按时到达服务点,以免给您带来不便!";
        }
        if (_sercersPositionInfo == nil){
            tipInfo = @"当您的付费人员达到16个以后该合同生效。邀请您附近有体检的人员都来参加吧!";
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
        bottomView.backgroundColor = [UIColor clearColor];
        [containerView addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(containerView);
            make.top.mas_equalTo(itemLabel.mas_bottom);
            make.height.mas_equalTo(PXFIT_HEIGHT(136));
        }];
        
        HCBackgroundColorButton* appointmentBtn = [[HCBackgroundColorButton alloc] init];
        [appointmentBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue] forState:UIControlStateNormal];
        [appointmentBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue_Pressed] forState:UIControlStateHighlighted];
        [appointmentBtn setTitle:@"预 约" forState:UIControlStateNormal];
        appointmentBtn.titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Button_Size)];
        appointmentBtn.layer.cornerRadius = 5;
        [appointmentBtn addTarget:self action:@selector(appointmentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _isAppointmentBtnResponse = YES;
    
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
    
    //导航栏点击事件
    UITapGestureRecognizer* tapRecon = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(toggleMenu)];
    tapRecon.delegate = self;
    tapRecon.numberOfTapsRequired = 1;
    [self.navigationController.navigationBar addGestureRecognizer:tapRecon];
    
    _examinationAddressTextView.userInteractionEnabled = NO;
    _examinationTimeTextField.userInteractionEnabled = NO;
 
    if (_brContract != nil){
        //待处理项目 & 历史记录
        
        if (_brContract.servicePoint == nil){
            _examinationAddressTextView.textColor = [UIColor blackColor];
            _examinationTimeTextField.textColor = [UIColor blackColor];
            addressBtn.enabled = YES;
            timeBtn.enabled = YES;
        }else{
            UIColor *color = _brContract.servicePoint.type == 1 ? [UIColor colorWithRGBHex:HC_Gray_Text]:[UIColor blackColor];
            bool enable = _brContract.servicePoint.type == 1 ? NO : YES;
            _examinationTimeTextField.textColor = color;
            timeBtn.enabled = enable;
            
            _examinationAddressTextView.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
            addressBtn.enabled = NO;
        }
        if (![_brContract.testStatus isEqualToString:@"-1"]){
            _examinationAddressTextView.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
            _examinationTimeTextField.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
            timeBtn.enabled = NO;
            addressBtn.enabled = NO;
        }
    }else{
        //云预约 & 服务点预约
        if (_isCustomerServerPoint){
            _examinationAddressTextView.textColor = [UIColor blackColor];
            _examinationTimeTextField.textColor = [UIColor blackColor];
            addressBtn.enabled = YES;
            timeBtn.enabled = YES;
        }else{
            _examinationAddressTextView.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
            addressBtn.enabled = NO;
            _examinationTimeTextField.textColor =  _isTemperaryPoint==YES?[UIColor colorWithRGBHex:HC_Gray_Text]:[UIColor blackColor];
            timeBtn.enabled = !_isTemperaryPoint;
        }
    }
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
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.tag = 4001;
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    
    self.title = _brContract.name;
    
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
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    self.title = _sercersPositionInfo == nil ? @"自建体检点":_sercersPositionInfo.name;
}

- (void)backToPre:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if (sender.tag == 4001){
        if (_resultblock) {
            _resultblock(_isChanged, _indexPath);
        }
    }
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
    
    if([[HCNetworkReachability getInstance] isReachable] == NO){
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
    
    if (_isTodoTask){
        //如果是待处理项
        if (_brContract.servicePoint != nil){
            if (customercount > _brContract.servicePoint.maxNum - _brContract.servicePoint.oppointmentNum && _brContract.servicePoint.type == 1){
                [RzAlertView showAlertLabelWithTarget:self.view Message:@"服务点预约人数过多" removeDelay:3];
                return ;
            }
        }
    }else{
        //新建的预约
        if(_brContract == nil)
        {            _brContract = [[BRContract alloc]init];
            _brContract.unitCode = gUnitInfo.unitCode;
            _brContract.unitName = gUnitInfo.unitName;
        }
        
        if (_sercersPositionInfo == nil)
        {
            //云预约
            if ([_examinationTimeTextField.text isEqualToString:@""] || _examinationTimeTextField.text == nil){
                [RzAlertView showAlertLabelWithTarget:self.view Message:@"你还未填写预约时间" removeDelay:3];
                return ;
            }
            _brContract.regTime = [_examinationTimeTextField.text convertDateStrWithHourToLongLong]*1000;
            _brContract.regPosLA = _centerCoordinate.latitude;
            _brContract.regPosLO = _centerCoordinate.longitude;
            _brContract.regPosAddr = _location;
            if (_choosedFixedSp != nil){
                _brContract.hosCode = _choosedFixedSp.hosCode;
            }
        }
        else
        {
            if(customercount > _sercersPositionInfo.maxNum - _sercersPositionInfo.oppointmentNum && _sercersPositionInfo.type == 1){
                [RzAlertView showAlertLabelWithTarget:self.view Message:@"服务点预约人数过多" removeDelay:3];
                return ;
            }
            
            if (_sercersPositionInfo.type == 0){
                _brContract.regTime = [_examinationTimeTextField.text convertDateStrWithHourToLongLong]*1000;
            }else{
                _brContract.regTime = _sercersPositionInfo.startTime;
            }
            //基于服务点预约
            _brContract.servicePoint = _sercersPositionInfo;
            _brContract.regBeginDate = _sercersPositionInfo.startTime;
            _brContract.regEndDate = _sercersPositionInfo.endTime;
            _brContract.regPosAddr = _sercersPositionInfo.address;
            _brContract.regPosLA = _sercersPositionInfo.positionLa;
            _brContract.regPosLO = _sercersPositionInfo.positionLo;
            _brContract.hosCode = _sercersPositionInfo.hosCode;
            //移动服务点 id 固定 cHostCode
            _brContract.checkSiteID = _sercersPositionInfo.type == 1 ? _sercersPositionInfo.id : _sercersPositionInfo.hosCode;
        }
    }
    _brContract.linkUser = _contactPersonField.text;
    _brContract.linkPhone = _phoneNumField.text;
    _brContract.checkType = @"1";// 1为健康证
    _brContract.testStatus = @"-1"; // -1未检，0签到，1在检，2延期，3完成，9已出报告和健康证
    _brContract.regCheckNum = customercount;
    _brContract.cityName = gCurrentCityName;
    _brContract.name = [NSString stringWithFormat:@"%@单位体检", _brContract.unitName];
 

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

        if (GetUserType == 1) {
            PersonalCheckListViewContrller *checkVC = [[PersonalCheckListViewContrller alloc]init];
            checkVC.popStyle = POPTO_ROOT;
            [self.navigationController pushViewController:checkVC animated:YES];
        }
        else {
            UnitCheckListVIewController *checkVe = [[UnitCheckListVIewController alloc]init];
            checkVe.popStyle = POPTO_ROOT;
            [self.navigationController pushViewController:checkVe animated:YES];
        }
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
    //如果基于固定服务点
    SelectAddressViewController* selectAddressViewController = [[SelectAddressViewController alloc] init];
    selectAddressViewController.addressStr = _location;
    __weak typeof(self) weakself = self;
    [selectAddressViewController getAddressArrayWithBlock:^(NSString *city, NSString *district, NSString *address, CLLocationCoordinate2D coor) {
        weakself.cityName = city;
        weakself.location = address;
        weakself.centerCoordinate = coor;
        typeof(self)strongself = weakself;
        strongself->_examinationAddressTextView.text = weakself.location;
    }];
    [self.navigationController pushViewController:selectAddressViewController animated:YES];
    [self inputWidgetResign];
}

-(void)timeBtnClicked:(UIButton*)sender
{
    //只有云预约才可以修改
    CloudAppointmentDateVC* cloudAppointmentDateVC = [[CloudAppointmentDateVC alloc] init];
    cloudAppointmentDateVC.choosetDateStr = _appointmentDateStr;
    __weak typeof(self) weakself = self;
    [cloudAppointmentDateVC getAppointDateStringWithBlock:^(NSString *dateStr) {
       // weakself.appointmentDateStr = dateStr;
        typeof(self)strongself = weakself;
        strongself->_examinationTimeTextField.text = dateStr;
        strongself->_appointmentDateStr = dateStr;
    }];
    [self.navigationController pushViewController:cloudAppointmentDateVC animated:YES];
    [self inputWidgetResign];
}

-(void)editBtnClicked:(UIButton*)sender
{
    [self.view endEditing:YES];
    if ([[HCNetworkReachability getInstance] isReachable] == NO){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"网络连接失败，请检查网络设置" removeDelay:2];
        return;
    }
    //如果预约人数 小于 已选员工
    if ([_exminationCountField.text intValue] < _customerArr.count){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"预约人数必须大于所选员工数" removeDelay:3];
        return ;
    }
    
    //非服务点预约才能修改地址和时间
    if (_brContract.checkSiteID == nil || [_brContract.checkSiteID isEqualToString:@""])
    {
        _brContract.regTime = [_examinationTimeTextField.text convertDateStrWithHourToLongLong]*1000;
        _brContract.regPosAddr = _examinationAddressTextView.text;
        _brContract.regPosLA = _centerCoordinate.latitude;
        _brContract.regPosLO = _centerCoordinate.longitude;
    }else{
        if (_brContract.servicePoint.type == 0)
            _brContract.regTime = [_examinationTimeTextField.text convertDateStrWithHourToLongLong]*1000;
    }
    
    _brContract.linkUser = _contactPersonField.text;
    _brContract.linkPhone = _phoneNumField.text;
    _brContract.regCheckNum = [_exminationCountField.text intValue];
    
    [[HttpNetworkManager getInstance] createOrUpdateBRCoontract:_brContract
                                                      employees:_customerArr
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
        case TABLEVIEW_EXAM:
            return _sercersPositionInfo == nil ? 2 : 1;
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
//    if (tableView.tag == TABLEVIEW_BASEINFO){
//        return 2;
//    }else if (tableView.tag == TABLEVIEW_COMPANYINFO){
//        return 1;
//    }else{
//        return _sercersPositionInfo == nil ? 2 : 1;
//    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return tableView.tag == TABLEVIEW_BASEINFO?PXFIT_HEIGHT(20):0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return tableView.tag == TABLEVIEW_BASEINFO?1:0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case TABLEVIEW_BASEINFO:
        {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.layer.borderWidth = 1;
            cell.layer.borderColor = [UIColor colorWithRGBHex:0xe8e8e8].CGColor;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
            cell.textLabel.textColor = [UIColor blackColor];
            if (indexPath.section == 0){
                cell.textLabel.text = @"扫码签到";
                cell.imageView.image = [UIImage imageNamed:@"qrIcon"];
            }else{
                cell.textLabel.text = @"体检态势";
                cell.imageView.image = [UIImage imageNamed:@"statusIcon"];
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
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
            
            CloudCompanyAppointmentCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CloudCompanyAppointmentCell class])];
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (indexPath.row == 0){
                cell.textFieldType = CDA_CONTACTPERSON;
                if (_brContract)
                    cell.textField.text = _brContract.linkUser;
                else
                    cell.textField.text = gUnitInfo.linkPeople;
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
                    cell.textField.text = gUnitInfo.linkPhone;
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                cell.textField.enabled = YES;
                cell.textField.tag = TEXTFIELD_PHONE;
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
        case TABLEVIEW_EXAM:
        {
            UITableViewCell* examCell = [tableView dequeueReusableCellWithIdentifier:@"examCell"];
            if (examCell == nil){
                examCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"examCell"];
            }
            examCell.indentationLevel = -10;
            examCell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(23)];
            examCell.detailTextLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(23)];
            examCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (_sercersPositionInfo != nil){
                examCell.textLabel.text = @"体检类型";
                examCell.detailTextLabel.text = @"健康证体检";
                examCell.userInteractionEnabled = NO;
                examCell.textLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
            }else{
                if (indexPath.row == 0){
                    examCell.textLabel.text = @"体检机构";
                    examCell.detailTextLabel.text = _choosedFixedSp == nil ? @"" : _choosedFixedSp.name;
                }else{
                    examCell.textLabel.text = @"体检类型";
                    examCell.detailTextLabel.text = @"健康证类型";
                    examCell.userInteractionEnabled = NO;
                    examCell.textLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
                }
            }
            return examCell;
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
            if (indexPath.section == 1){
                StaffStateViewController* staffStateVC = [[StaffStateViewController alloc] init];
                staffStateVC.contractCode = _brContract.code;
                staffStateVC.cityName = _brContract.cityName;
                [self.navigationController pushViewController:staffStateVC animated:YES];
                [self inputWidgetResign];
            }else{
                QRController* qrController = [[QRController alloc] init];
                qrController.qrContent = [NSString stringWithFormat:@"http://webserver.zeekstar.com/webserver/weixin/staffRegister.jsp?brContractCode=%@", _brContract.code];
                qrController.infoStr = @"将二维码分享给员工,参与单位体检";
                qrController.shareText = @"点击参与员工体验";
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
                if (_brContract){
                    addworkerViewController.unitCode = _brContract.unitCode;
                    addworkerViewController.contarctCode = _brContract.code;
                }
                else
                    addworkerViewController.unitCode = gUnitInfo.unitCode;
                addworkerViewController.selectedWorkerArray = [NSMutableArray arrayWithArray:self.customerArr];
                __weak CloudAppointmentCompanyViewController * weakSelf = self;
                [addworkerViewController getWorkerArrayWithBlock:^(NSArray *workerArray) {
                    weakSelf.customerArr = workerArray;
                    NSIndexPath *path = [NSIndexPath indexPathForItem:2 inSection:0];
                    [_companyInfoTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
                 
                    if([_exminationCountField.text integerValue] < workerArray.count){
                        _exminationCountField.text = [NSString stringWithFormat:@"%ld", (unsigned long)workerArray.count];
                    }
                 
                }];
                [self.navigationController pushViewController:addworkerViewController animated:YES];
                [self inputWidgetResign];
            }
        }
            break;
        case TABLEVIEW_EXAM:
        {
            if (indexPath.row == 0){
                HomeServiceListViewController* homeServiceListVC = [[HomeServiceListViewController alloc] init];
                homeServiceListVC.delegate = self;//_choosedFixedSp
                homeServiceListVC.selectedSpModel = _choosedFixedSp;
                [self.navigationController pushViewController:homeServiceListVC animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - HomeServiceListViewControllerDelegate
-(void)choosedServerPoint:(ServersPositionAnnotionsModel *)sp{
    _choosedFixedSp = sp;
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_examTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
  
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
    CGRect keyboardBounds;
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

-(void)toggleMenu{
    [self inputWidgetResign];
}

-(void)inputWidgetResign
{
    [_companyAddressTextView resignFirstResponder];
    [_contactPersonField resignFirstResponder];
    [_phoneNumField resignFirstResponder];
    [_exminationCountField resignFirstResponder];
}



@end
