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
#import "NSDate+Custom.h"

#import "BaseInfoTableViewCell.h"
#import "CloudCompanyAppointmentCell.h"
#import "CloudCompanyAppointmentStaffCell.h"

#import "AppointmentInfoView.h"

#import "SelectAddressViewController.h"
#import "AddWorkerViewController.h"

#define Button_Size 26

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

@interface CloudAppointmentCompanyViewController() <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UITableView         *_baseInfoTableView;
    UITableView         *_companyInfoTableView;
    UITableView         *_staffTableView;
    
    NSString            *_dateString;
    
    UITextField         *_contactPersonField;
    UITextField         *_phoneNumField;
    UITextField         *_exminationCountField;
    
    BOOL                    _isFirstShown;
    CGFloat                 _viewHeight;
}
@end

@implementation CloudAppointmentCompanyViewController

#pragma mark - Setter & Getter
-(void)setLocation:(NSString *)location{
    _location = location;
    [_baseInfoTableView reloadData];
}

-(void)setAppointmentDateStr:(NSString *)appointmentDateStr{
    BaseInfoTableViewCell* cell = [_baseInfoTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.textField.text = appointmentDateStr;
    _appointmentDateStr = appointmentDateStr;
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
    
    _baseInfoTableView = [[UITableView alloc] init];
    _baseInfoTableView.tag = TABLEVIEW_BASEINFO;
    _baseInfoTableView.delegate = self;
    _baseInfoTableView.dataSource = self;
    _baseInfoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _baseInfoTableView.separatorColor = [UIColor colorWithRGBHex:0xe8e8e8];
    _baseInfoTableView.scrollEnabled = NO;
    [_baseInfoTableView registerClass:[BaseInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BaseInfoTableViewCell class])];
    _baseInfoTableView.layer.borderColor = [UIColor colorWithRGBHex:0xe8e8e8].CGColor;
    _baseInfoTableView.layer.borderWidth = 1;
    _baseInfoTableView.layer.cornerRadius = 5;
    [containerView addSubview:_baseInfoTableView];
    [_baseInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(containerView);
        make.height.mas_equalTo(PXFIT_HEIGHT(96)*2);
    }];
    
    
    _companyInfoTableView = [[UITableView alloc] init];
    _companyInfoTableView.tag = TABLEVIEW_COMPANYINFO;
    _companyInfoTableView.delegate = self;
    _companyInfoTableView.dataSource = self;
    _companyInfoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _companyInfoTableView.separatorColor = [UIColor colorWithRGBHex:0xe8e8e8];
    _companyInfoTableView.scrollEnabled = NO;
    [_companyInfoTableView registerClass:[CloudCompanyAppointmentCell class] forCellReuseIdentifier:NSStringFromClass([CloudCompanyAppointmentCell class])];
    _companyInfoTableView.layer.borderColor = [UIColor colorWithRGBHex:0xe8e8e8].CGColor;
    _companyInfoTableView.layer.borderWidth = 1;
    _companyInfoTableView.layer.cornerRadius = 5;
    [containerView addSubview:_companyInfoTableView];
    [_companyInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containerView);
        make.top.mas_equalTo(_baseInfoTableView.mas_bottom).with.offset(PXFIT_HEIGHT(20));
        make.height.mas_equalTo(PXFIT_HEIGHT(96)*5);
    }];

    _staffTableView = [[UITableView alloc] init];
    _staffTableView.tag = TABLEVIEW_STAFFINFO;
    _staffTableView.delegate = self;
    _staffTableView.dataSource = self;
    _staffTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _staffTableView.separatorColor = [UIColor colorWithRGBHex:0xe8e8e8];
    _staffTableView.scrollEnabled = NO;
    [_staffTableView registerClass:[CloudCompanyAppointmentCell class] forCellReuseIdentifier:NSStringFromClass([CloudCompanyAppointmentCell class])];
    _staffTableView.layer.borderColor = [UIColor colorWithRGBHex:0xe8e8e8].CGColor;
    _staffTableView.layer.borderWidth = 1;
    _staffTableView.layer.cornerRadius = 5;
    [containerView addSubview:_staffTableView];
    [_staffTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containerView);
        make.top.mas_equalTo(_companyInfoTableView.mas_bottom).with.offset(PXFIT_HEIGHT(20));
        make.height.mas_equalTo(PXFIT_HEIGHT(96));
    }];
    
    AppointmentInfoView* infoView = [[AppointmentInfoView alloc] init];
    [containerView addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containerView);
        make.top.mas_equalTo(_staffTableView.mas_bottom).with.offset(PXFIT_HEIGHT(20));
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self registerKeyboardNotification];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self cancelKeyboardNotification];
}


#pragma mark - Action
-(void)appointmentBtnClicked:(id)sender
{
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
            return 5;
        case TABLEVIEW_STAFFINFO:
            return 1;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case TABLEVIEW_BASEINFO:
        {
            BaseInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BaseInfoTableViewCell class])
                                                                          forIndexPath:indexPath];
            if (indexPath.row == 0){
                cell.iconName = @"search_icon";
                cell.textField.text = _location;
                cell.textField.enabled = NO;
            }else{
                cell.iconName = @"date_icon";
                cell.textField.text = _dateString;
                cell.textField.enabled = NO;
            }
            return cell;
        }
        case TABLEVIEW_COMPANYINFO:
        {
            CloudCompanyAppointmentCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CloudCompanyAppointmentCell class])
                                                                          forIndexPath:indexPath];
            if (indexPath.row == 0){
                cell.textField.placeholder = @"单位名称";
                cell.textField.text = gCompanyInfo.cUnitName;
                cell.textField.textColor = [UIColor colorWithRGBHex:0x6e6e6e];
                cell.textField.enabled = NO;
            }else if (indexPath.row == 1){
                cell.textField.placeholder = @"单位地址";
                cell.textField.text = gCompanyInfo.cUnitAddr;
                cell.textField.textColor = [UIColor colorWithRGBHex:0x6e6e6e];
                cell.textField.enabled = NO;
            }else if (indexPath.row == 2){
                cell.textField.placeholder = @"联系人";
                cell.textField.text = gCompanyInfo.cLinkPeople;
                cell.textField.enabled = YES;
                cell.textField.tag = TEXTFIELD_CONTACT;
                _contactPersonField = cell.textField;
            }else if (indexPath.row == 3){
                cell.textField.placeholder = @"请输入手机号码";
                cell.textField.text = gCompanyInfo.cLinkPhone;
                cell.textField.enabled = YES;
                cell.textField.tag = TEXTFIELD_PHONE;
                _phoneNumField = cell.textField;
            }else{
                cell.textField.placeholder = @"体检人数";
                cell.textField.enabled = YES;
                cell.textField.tag = TEXTFIELD_CONTACTCOUNT;
                _exminationCountField = cell.textField;
            }
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
            return cell;
        }
        case TABLEVIEW_STAFFINFO:
        {
            CloudCompanyAppointmentStaffCell* cell = [[CloudCompanyAppointmentStaffCell alloc] init];
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
            if (indexPath.row == 0){
                SelectAddressViewController* selectAddressViewController = [[SelectAddressViewController alloc] init];
                selectAddressViewController.addressStr = _location;
                selectAddressViewController.switchStyle = SWITCH_MISS;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:selectAddressViewController];
                [self.parentViewController presentViewController:nav animated:YES completion:nil];
            }else{
                [self.parentViewController performSegueWithIdentifier:@"ChooseDateIdentifier" sender:self];
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
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:addworkerViewController];
            [self.parentViewController presentViewController:nav animated:YES completion:nil];
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
    if (_isFirstShown == NO){
        _isFirstShown = YES;
        CGRect keyboardBounds;//UIKeyboardFrameEndUserInfoKey
        [[notification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBounds];
        _viewHeight = SCREEN_HEIGHT - keyboardBounds.size.height;
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.parentViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, _viewHeight);
        //self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, _viewHeight);
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
