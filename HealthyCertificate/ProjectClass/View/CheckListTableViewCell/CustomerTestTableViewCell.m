//
//  CustomerTestTableViewCell.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CustomerTestTableViewCell.h"
#import <Masonry.h>
#import "NSString+Count.h"
#import "NSDate+Custom.h"

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
        make.width.height.mas_equalTo(50);
    }];

    UILabel *name = [[UILabel alloc]init];
    name.text = @"姓名:";
    [self.contentView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.left.equalTo(headerimageView.mas_right).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(40);
    }];

    nameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:nameLabel];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor grayColor];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(name);
        make.left.equalTo(name.mas_right).offset(5);
        make.width.mas_equalTo(60);
    }];

    UILabel *sex = [[UILabel alloc]init];
    [self.contentView addSubview:sex];
    sex.text = @"性别:";
    [sex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(name);
        make.left.equalTo(nameLabel.mas_right).offset(10);
    }];
    sexLabel = [[UILabel alloc]init];
    [self.contentView addSubview:sexLabel];
    sexLabel.font = [UIFont systemFontOfSize:14];
    sexLabel.textColor = [UIColor grayColor];
    [sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(nameLabel);
        make.width.mas_equalTo(21);
        make.left.equalTo(sex.mas_right);
    }];

    UILabel *old = [[UILabel alloc]init];
    old.text = @"年龄:";
    [self.contentView addSubview:old];
    [old mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(name);
        make.left.equalTo(sexLabel.mas_right).offset(10);
    }];

    oldLabel = [[UILabel alloc]init];
    [self.contentView addSubview:oldLabel];
    oldLabel.font = [UIFont systemFontOfSize:14];
    oldLabel.textColor = [UIColor grayColor];
    [oldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(nameLabel);
        make.left.equalTo(old.mas_right);
        make.right.equalTo(self.contentView).offset(-5);
    }];

    UILabel *serviceDate = [[UILabel alloc]init];
    serviceDate.text = @"服务时间:";
    [self.contentView addSubview:serviceDate];
    [serviceDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-5);
        make.height.left.equalTo(name);
        make.width.mas_equalTo(80);
    }];
    serviceTimeLabel = [[UILabel alloc]init];
    serviceTimeLabel.font = [UIFont systemFontOfSize:14];
    serviceTimeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:serviceTimeLabel];
    [serviceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(serviceDate);
        make.left.equalTo(serviceDate.mas_right).offset(5);
        make.right.equalTo(oldLabel);
    }];


    UILabel *serviceAddress = [[UILabel alloc]init];
    serviceAddress.text = @"服务地址:";
    [self.contentView addSubview:serviceAddress];
    [serviceAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(name.mas_bottom).offset(5);
        make.bottom.equalTo(serviceDate.mas_top).offset(-5);
        make.width.mas_equalTo(serviceDate);
        make.left.equalTo(serviceDate);
    }];

    serviceAddressLabel = [[UILabel alloc]init];
    [self.contentView addSubview:serviceAddressLabel];
    serviceAddressLabel.font = [UIFont systemFontOfSize:14];
    serviceAddressLabel.textColor = [UIColor grayColor];
    [serviceAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(serviceAddress);
        make.left.right.equalTo(serviceTimeLabel);
    }];
    serviceTimeLabel.numberOfLines = 0;
}

- (void)setCellItemWithTest:(CustomerTest *)customerTest
{
    headerimageView.image = [UIImage imageNamed:@"headimage"];
    nameLabel.text = customerTest.cCustName;
    sexLabel.text = customerTest.cSex == 0 ? @"男" : @"女";
    oldLabel.text = [NSString getOldYears:customerTest.cCustIdCard];
    serviceAddressLabel.text = customerTest.servicePoint.address;
    // 服务时间为空时，不显示
    if (!customerTest.servicePoint.startTime || !customerTest.servicePoint.endTime) {
        return;
    }
    serviceTimeLabel.text = [NSString stringWithFormat:@"%@(%@~%@)", [NSDate getYear_Month_DayByDate:customerTest.servicePoint.startTime], [NSDate getHour_MinuteByDate:customerTest.servicePoint.startTime], [NSDate getHour_MinuteByDate:customerTest.servicePoint.endTime]];
}
@end
