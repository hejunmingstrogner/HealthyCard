//
//  CloudAppointmentCompanyViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CloudAppointmentCompanyViewController.h"

#import <Masonry.h>

#import "Constants.h"

#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"
#import "UIButton+Easy.h"

#import "BaseInfoTableViewCell.h"
#import "CloudCompanyAppointmentCell.h"
#import "CloudCompanyAppointmentStaffCell.h"

#import "AppointmentInfoView.h"

#define Button_Size 26


@interface CloudAppointmentCompanyViewController() <UITableViewDataSource, UITableViewDelegate>
{
}
@end

@implementation CloudAppointmentCompanyViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    UIView* bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).with.offset(SCREEN_HEIGHT-PXFIT_HEIGHT(136)-kNavigationBarHeight-kStatusBarHeight);
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
    
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = MO_RGBCOLOR(250, 250, 250);
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(bottomView.mas_top);
    }];
    
    UIView* containerView = [[UIView alloc] init];
    [scrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    

    UITableView* baseInfoTableView = [[UITableView alloc] init];
    baseInfoTableView.delegate = self;
    baseInfoTableView.dataSource = self;
    baseInfoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    baseInfoTableView.separatorColor = [UIColor colorWithRGBHex:0xe8e8e8];
//    baseInfoTableView.layer.borderWidth = 1;
//    baseInfoTableView.layer.borderColor = [UIColor colorWithRGBHex:0xe8e8e8].CGColor;
//    baseInfoTableView.layer.cornerRadius = 5.0f;
    baseInfoTableView.scrollEnabled = NO;
    [baseInfoTableView registerClass:[BaseInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BaseInfoTableViewCell class])];
    [containerView addSubview:baseInfoTableView];
    [baseInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(containerView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(PXFIT_HEIGHT(96)*8+PXFIT_HEIGHT(20)*3);
    }];
    
    AppointmentInfoView* infoView = [[AppointmentInfoView alloc] init];
    [containerView addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(baseInfoTableView.mas_bottom).with.offset(PXFIT_HEIGHT(20));
    }];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(infoView.mas_bottom);
    }];
}

#pragma mark - Action
-(void)appointmentBtnClicked:(id)sender
{
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 5;
            break;
        case 2:
            return 1;
        default:
            break;
    }
    return 0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            static NSString* firstSectionCellIdentifier = @"firstSectionCellIdentifier";
            BaseInfoTableViewCell* cell = [[BaseInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstSectionCellIdentifier];
            if (indexPath.row == 0){
                cell.iconName = @"search_icon";
                cell.textField.text = _location;
            }else{
                cell.iconName = @"date_icon";
                cell.textField.text = @"2016年02月24日~2016年02月25日";
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
            break;
        case 1:
        {
            static NSString* secondSectionCellIdentifier = @"secondSectionCellIdentifier";
          //  CloudCompanyAppointmentCell* cell = [tableView dequeueReusableCellWithIdentifier:secondSectionCellIdentifier forIndexPath:indexPath];
            CloudCompanyAppointmentCell* cell = [[CloudCompanyAppointmentCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                   reuseIdentifier:secondSectionCellIdentifier];
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
            break;
            
        case 2:
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
            break;
        default:
            break;
    }
    return nil;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PXFIT_HEIGHT(96);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return PXFIT_HEIGHT(20);
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = MO_RGBCOLOR(250, 250, 250);
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0){
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.borderColor = [UIColor greenColor].CGColor;
//        maskLayer.frame = cell.bounds;
//        maskLayer.path = maskPath.CGPath;
////        cell.layer.mask = maskLayer;
////        cell.layer.borderColor = [UIColor colorWithRGBHex:0xe0e0e0].CGColor;
////        cell.layer.borderWidth = 1;
//    }
//
//}

//-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0){
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
//            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//            maskLayer.borderColor = [UIColor greenColor].CGColor;
//            maskLayer.frame = cell.bounds;
//            maskLayer.path = maskPath.CGPath;
//        });
//        //        cell.layer.mask = maskLayer;
//        //        cell.layer.borderColor = [UIColor colorWithRGBHex:0xe0e0e0].CGColor;
//        //        cell.layer.borderWidth = 1;
//    }
//}
@end
