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

#define Button_Size 26

typedef NS_ENUM(NSInteger, TABLIEVIEWTAG)
{
    TABLEVIEW_BASEINFO = 1001,
    TABLEVIEW_COMPANYINFO,
    TABLEVIEW_STAFFINFO
};


@interface CloudAppointmentCompanyViewController() <UITableViewDataSource, UITableViewDelegate>
{
    UITableView         *_baseInfoTableView;
    UITableView         *_companyInfoTableView;
    UITableView         *_staffTableView;
    
    NSString            *_dateString;
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
   // [_phoneNumTextField resignFirstResponder];
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
    
}

#pragma mark - Action
-(void)appointmentBtnClicked:(id)sender
{
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
                cell.textField.enabled = NO;
            }else if (indexPath.row == 1){
                cell.textField.placeholder = @"单位地址";
                cell.textField.text = gCompanyInfo.cUnitAddr;
                cell.textField.enabled = NO;
            }else if (indexPath.row == 2){
                cell.textField.placeholder = @"联系人";
                cell.textField.text = gCompanyInfo.cLinkPeople;
                cell.textField.enabled = YES;
            }else if (indexPath.row == 3){
                cell.textField.placeholder = @"请输入手机号码";
                cell.textField.text = gCompanyInfo.cLinkPhone;
                cell.textField.enabled = YES;
            }else{
                cell.textField.placeholder = @"体检人数";
                cell.textField.enabled = YES;
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
            }else{
                [self.parentViewController performSegueWithIdentifier:@"ChooseDateIdentifier" sender:self];
            }
        }
            break;
        case TABLEVIEW_COMPANYINFO:
        {}
            break;
        case TABLEVIEW_STAFFINFO:
        {}
            break;
        default:
            break;
    }
}

#pragma mark - Storyboard Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"ChooseDateIdentifier"]){
//        UIViewController* destinationViewController = segue.destinationViewController;
//        if ([destinationViewController isKindOfClass:[CloudAppointmentDateVC class]])
//        {
//            CloudAppointmentDateVC* cloudAppointmentDateVC = (CloudAppointmentDateVC*)destinationViewController;
//            [cloudAppointmentDateVC getAppointDateStringWithBlock:^(NSString *dateStr) {
//                BaseInfoTableViewCell* cell = [_baseInfoTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//                cell.textField.text = dateStr;
//            }];
//        }
//    }
}

@end
