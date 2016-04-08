//
//  CustomerHistoryTBVCell.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/3.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CustomerHistoryTBVCell.h"

#import <Masonry.h>
#import <UIImageView+WebCache.h>

#import "UIFont+Custom.h"
#import "NSString+Count.h"
#import "UILabel+FontColor.h"
#import "NSDate+Custom.h"

#import "Constants.h"
#import "HttpNetworkManager.h"

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
        make.top.equalTo(self.contentView).offset(10);
        make.width.height.equalTo(@60);
    }];
    headerimageView.layer.masksToBounds = YES;
    headerimageView.layer.cornerRadius = 30;

    headerimageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    [self.contentView addSubview:headerimageView];
    [headerimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(60);
    }];
    headerimageView.layer.masksToBounds = YES;
    headerimageView.layer.cornerRadius = 30;

    // 姓名
    nameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerimageView);
        make.left.equalTo(headerimageView.mas_right).offset(10);
        make.bottom.equalTo(headerimageView.mas_centerY);
        make.right.equalTo(self.contentView).offset(-10);
    }];

    sexLabel = [[UILabel alloc]init];
    [self.contentView addSubview:sexLabel];
    [sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom);
        make.bottom.equalTo(headerimageView);
        make.left.equalTo(nameLabel);
        make.right.equalTo(self.contentView.mas_centerX);
    }];

    oldLabel = [[UILabel alloc]init];
    [self.contentView addSubview:oldLabel];
    [oldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sexLabel.mas_right);
        make.top.bottom.equalTo(sexLabel);
        make.right.equalTo(nameLabel);
    }];

    phoneLabel = [[UILabel alloc]init];
    [self.contentView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerimageView.mas_bottom).offset(10);
        make.left.equalTo(headerimageView);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(20);
    }];

    dueTimeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:dueTimeLabel];
    [dueTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLabel.mas_bottom).offset(5);
        make.left.right.height.equalTo(phoneLabel);
    }];

    reportBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:reportBtn];
    [reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(80);
    }];
    [reportBtn setTitle:@"报告" forState:UIControlStateNormal];
    reportBtn.layer.masksToBounds = YES;
    reportBtn.layer.cornerRadius = 4;
    reportBtn.titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    [reportBtn setBackgroundColor:[UIColor colorWithRed:30/255.0 green:180/255.0 blue:240/255.0 alpha:1]];
}

- (void)setCustomerTest:(CustomerTest *)customerTest
{

    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@customerTest/getPrintPhoto?cCheckCode=%@", [HttpNetworkManager baseURL], customerTest.checkCode]];
    [headerimageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"headimage"] options:SDWebImageRefreshCached | SDWebImageRetryFailed];
    [nameLabel setText:@"姓名: "
                  Font:[UIFont fontWithType:UIFontOpenSansRegular size:15]
           WithEndText:customerTest.custName==nil?@"":customerTest.custName
          endTextColor:[UIColor grayColor]];
    [sexLabel setText:@"性别: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:customerTest.sex == 0 ? @"男" : @"女" endTextColor:[UIColor grayColor]];
    [oldLabel setText:@"年龄: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:[NSString getOldYears:customerTest.custIdCard] endTextColor:[UIColor grayColor]];

    [phoneLabel setText:@"联系电话: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:customerTest.linkPhone endTextColor:[UIColor grayColor]];

//    long long valDate = customerTest.affirmdat
    //nextYear
    NSDate *dateTime = [[NSDate alloc] initWithTimeIntervalSince1970:customerTest.affirmdate];
    [dueTimeLabel setText:@"有效期至: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:[[dateTime nextYear] formatDateToChineseString] endTextColor:[UIColor grayColor]];
}


@end
