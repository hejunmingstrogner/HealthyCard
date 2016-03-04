//
//  CustomerTestTableViewCell.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CustomerTestTableViewCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

#import "HttpNetworkManager.h"
#import "Constants.h"
#import "NSString+Count.h"
#import "NSDate+Custom.h"
#import "UIFont+Custom.h"

@interface CustomerTestTableViewCell()
{
    UIImageView *headerimageView;
    UILabel     *nameLabel;
    UILabel     *sexLabel;
    UILabel     *oldLabel;
    UILabel     *serviceAddressLabel;
    UILabel     *serviceTimeLabel;
}
@end

@implementation CustomerTestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews
{
    headerimageView = [[UIImageView alloc]init];
    [self.contentView addSubview:headerimageView];
    [headerimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.width.equalTo(headerimageView.mas_height);
    }];
    headerimageView.layer.masksToBounds = YES;
    headerimageView.layer.cornerRadius = 45;


    UIView *bgview = [[UIView alloc]init];
    [self.contentView addSubview:bgview];
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.contentView);
        make.left.equalTo(headerimageView.mas_right).offset(5);
    }];

    UILabel *sex = [[UILabel alloc]init];
    [bgview addSubview:sex];
    sex.text = @"性别:";
    sex.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)];
    [sex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgview);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(21);
        make.top.equalTo(bgview).offset(5);
    }];
    sexLabel = [[UILabel alloc]init];
    [bgview addSubview:sexLabel];
    sexLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(23)];
    sexLabel.textColor = [UIColor grayColor];
    [sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sex);
        make.width.mas_equalTo(21);
        make.height.equalTo(sex);
        make.left.equalTo(sex.mas_right);
    }];

    oldLabel = [[UILabel alloc]init];
    [bgview addSubview:oldLabel];
    oldLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(23)];;
    oldLabel.textColor = [UIColor grayColor];
    [oldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sex);
        make.right.equalTo(bgview).offset(-5);
        make.width.mas_equalTo(25);
        make.height.equalTo(sex);
    }];

    UILabel *old = [[UILabel alloc]init];
    old.text = @"年龄:";
    old.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)];
    [bgview addSubview:old];
    [old mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sex);
        make.width.height.equalTo(sex);
        make.right.equalTo(oldLabel.mas_left);
    }];

    UILabel *name = [[UILabel alloc]init];
    name.text = @"姓名:";
    [bgview addSubview:name];
    name.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sex);
        make.width.height.equalTo(sex);
        make.left.equalTo(bgview);
    }];

    nameLabel = [[UILabel alloc]init];
    [bgview addSubview:nameLabel];
    nameLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(23)];;
    nameLabel.textColor = [UIColor grayColor];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sex);
        make.left.equalTo(name.mas_right);
        make.right.equalTo(sex.mas_left);
        make.height.equalTo(sex);
    }];


    UILabel *serviceDate = [[UILabel alloc]init];
    serviceDate.text = @"服务时间:";
    serviceDate.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)];
    [bgview addSubview:serviceDate];
    [serviceDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgview).offset(-5);
        make.height.left.equalTo(name);
        make.width.mas_equalTo(70);
    }];
    serviceTimeLabel = [[UILabel alloc]init];
    serviceTimeLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)];;
    serviceTimeLabel.textColor = [UIColor grayColor];
    [bgview addSubview:serviceTimeLabel];
    [serviceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(serviceDate);
        make.left.equalTo(serviceDate.mas_right).offset(5);
        make.right.equalTo(oldLabel);
    }];


    UILabel *serviceAddress = [[UILabel alloc]init];
    serviceAddress.text = @"服务地址:";
    serviceAddress.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)];
    [bgview addSubview:serviceAddress];
    [serviceAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(name.mas_bottom).offset(5);
        make.bottom.equalTo(serviceDate.mas_top).offset(-5);
        make.width.mas_equalTo(serviceDate);
        make.left.equalTo(serviceDate);
    }];

    serviceAddressLabel = [[UILabel alloc]init];
    [bgview addSubview:serviceAddressLabel];
    serviceAddressLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(23)];;
    serviceAddressLabel.textColor = [UIColor grayColor];
    [serviceAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(serviceAddress);
        make.left.right.equalTo(serviceTimeLabel);
    }];
    serviceTimeLabel.numberOfLines = 0;
    serviceAddressLabel.numberOfLines = 0;
}

- (void)setCellItemWithTest:(CustomerTest *)customerTest
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@customerTest/getPrintPhoto?cCheckCode=%@", [HttpNetworkManager baseURL], customerTest.checkCode]];
    [headerimageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"headimage"] options:SDWebImageRefreshCached];
    nameLabel.text = customerTest.custName;
    sexLabel.text = customerTest.sex == 0 ? @"男" : @"女";
    oldLabel.text = [NSString getOldYears:customerTest.custIdCard];

    // 服务时间为空时，不显示
    if (!customerTest.servicePoint.startTime || !customerTest.servicePoint.endTime) {
        serviceAddressLabel.text = @"现场体检";
        return;
    }
    serviceAddressLabel.text = customerTest.servicePoint.address;
    serviceTimeLabel.text = [NSString stringWithFormat:@"%@(%@~%@)", [NSDate getYear_Month_DayByDate:customerTest.servicePoint.startTime], [NSDate getHour_MinuteByDate:customerTest.servicePoint.startTime], [NSDate getHour_MinuteByDate:customerTest.servicePoint.endTime]];
}
@end
