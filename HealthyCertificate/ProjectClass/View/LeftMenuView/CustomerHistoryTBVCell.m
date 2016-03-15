//
//  CustomerHistoryTBVCell.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/3.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CustomerHistoryTBVCell.h"
#import <Masonry.h>
#import "UIFont+Custom.h"
#import "Constants.h"
#import "HttpNetworkManager.h"
#import <UIImageView+WebCache.h>
#import "NSString+Count.h"

@interface CustomerHistoryTBVCell()
{
    UIImageView *headerimageView;
    UILabel     *nameLabel;
    UILabel     *sexLabel;
    UILabel     *oldLabel;
    UILabel     *phoneLabel;
    UILabel     *dueTimeLabel;
    CustomButton    *reportBtn;

}
@end

@implementation CustomerHistoryTBVCell

@synthesize reportBtn = reportBtn;

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
    sex.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    [sex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgview);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(21);
        make.top.equalTo(bgview).offset(5);
    }];
    sexLabel = [[UILabel alloc]init];
    [bgview addSubview:sexLabel];
    sexLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:14];
    sexLabel.textColor = [UIColor grayColor];
    [sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sex);
        make.width.mas_equalTo(21);
        make.height.equalTo(sex);
        make.left.equalTo(sex.mas_right);
    }];

    oldLabel = [[UILabel alloc]init];
    [bgview addSubview:oldLabel];
    oldLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:14];;
    oldLabel.textColor = [UIColor grayColor];
    [oldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sex);
        make.right.equalTo(bgview).offset(-5);
        make.width.mas_equalTo(25);
        make.height.equalTo(sex);
    }];

    UILabel *old = [[UILabel alloc]init];
    old.text = @"年龄:";
    old.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    [bgview addSubview:old];
    old.textAlignment = NSTextAlignmentRight;
    [old mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sex);
        make.width.height.equalTo(sex);
        make.right.equalTo(oldLabel.mas_left);
    }];

    UILabel *name = [[UILabel alloc]init];
    name.text = @"姓名:";
    [bgview addSubview:name];
    name.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sex);
        make.width.height.equalTo(sex);
        make.left.equalTo(bgview);
    }];

    nameLabel = [[UILabel alloc]init];
    [bgview addSubview:nameLabel];
    nameLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:14];;
    nameLabel.textColor = [UIColor grayColor];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sex);
        make.left.equalTo(name.mas_right);
        make.right.equalTo(sex.mas_left);
        make.height.equalTo(sex);
    }];

    UILabel *phone = [[UILabel alloc]init];
    phone.text = @"联系电话:";
    phone.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    [bgview addSubview:phone];
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgview);
        make.left.equalTo(name);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];

    phoneLabel = [[UILabel alloc]init];
    [bgview addSubview:phoneLabel];

    reportBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
    [bgview addSubview:reportBtn];
    [reportBtn setTitle:@"报告" forState:UIControlStateNormal];
    reportBtn.layer.masksToBounds = YES;
    reportBtn.layer.cornerRadius = 4;
    reportBtn.titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    [reportBtn setBackgroundColor:[UIColor colorWithRed:30/255.0 green:180/255.0 blue:240/255.0 alpha:1]];
    [reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phone);
        make.right.equalTo(oldLabel);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];

    phoneLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:14];;
    phoneLabel.textColor = [UIColor grayColor];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(phone);
        make.left.equalTo(phone.mas_right);
        make.right.equalTo(reportBtn.mas_left);
    }];

    UILabel *dueToTime = [[UILabel alloc]init];
    dueToTime.text = @"有效期至:";
    dueToTime.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    [bgview addSubview:dueToTime];
    [dueToTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgview).offset(-5);
        make.height.left.equalTo(name);
        make.width.equalTo(phone);
    }];
    dueTimeLabel = [[UILabel alloc]init];
    dueTimeLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:14];;
    dueTimeLabel.textColor = [UIColor grayColor];
    [bgview addSubview:dueTimeLabel];
    [dueTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(dueToTime);
        make.left.equalTo(dueToTime.mas_right).offset(5);
        make.right.equalTo(oldLabel);
    }];
    dueTimeLabel.numberOfLines = 0;
}

- (void)setCustomerTest:(CustomerTest *)customerTest
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@customerTest/getPrintPhoto?cCheckCode=%@", [HttpNetworkManager baseURL], customerTest.checkCode]];
    [headerimageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"headimage"] options:SDWebImageRefreshCached|SDWebImageRetryFailed];
    nameLabel.text = customerTest.custName;
    sexLabel.text = customerTest.sex == 0 ? @"男" : @"女";
    oldLabel.text = [NSString getOldYears:customerTest.custIdCard];

    phoneLabel.text = customerTest.linkPhone;
    dueTimeLabel.text = @"测试有效期至";
}


@end
