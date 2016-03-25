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
#import <UIImageView+AFNetworking.h>
#import "UILabel+FontColor.h"
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

    serviceTimeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:serviceTimeLabel];
    [serviceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerimageView.mas_bottom).offset(10);
        make.left.equalTo(headerimageView);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(20);
    }];

    serviceAddressLabel = [[UILabel alloc]init];
    [self.contentView addSubview:serviceAddressLabel];
    [serviceAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(serviceTimeLabel.mas_bottom).offset(5);
        make.left.right.height.equalTo(serviceTimeLabel);
    }];
}

- (void)setCellItemWithTest:(CustomerTest *)customerTest
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@customerTest/getPrintPhoto?cCheckCode=%@", [HttpNetworkManager baseURL], customerTest.checkCode]];
    [headerimageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"headimage"] options:SDWebImageRefreshCached | SDWebImageRetryFailed];
    [nameLabel setText:@"姓名: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:customerTest.custName endTextColor:[UIColor grayColor]];
    [sexLabel setText:@"性别: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:customerTest.sex == 0 ? @"男" : @"女" endTextColor:[UIColor grayColor]];
    [oldLabel setText:@"年龄: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:[NSString getOldYears:customerTest.custIdCard] endTextColor:[UIColor grayColor]];
//    nameLabel.text = customerTest.custName;
//    sexLabel.text = customerTest.sex == 0 ? @"男" : @"女";
//    oldLabel.text = [NSString getOldYears:customerTest.custIdCard];

    if(customerTest.checkSiteID) // 服务点预约
    {
//        serviceAddressLabel.text = customerTest.servicePoint.address;
        [serviceAddressLabel setText:@"体检地址: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:customerTest.servicePoint.address endTextColor:[UIColor grayColor]];
        if (!customerTest.servicePoint.startTime || !customerTest.servicePoint.endTime) {
//            serviceTimeLabel.text = @"";
//            serviceAddressLabel.text =@"获取失败";
            [serviceTimeLabel setText:@"体检时间: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:@"" endTextColor:[UIColor grayColor]];
            [serviceAddressLabel setText:@"获取失败" Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:@"" endTextColor:[UIColor grayColor]];
        }
        else {
            NSString *year = [NSDate getYearMonthDayByDate:customerTest.servicePoint.startTime/1000];
            NSString *hour1 = [NSDate getHour_MinuteByDate:customerTest.servicePoint.startTime/1000];
            NSString *end = [NSDate getHour_MinuteByDate:customerTest.servicePoint.endTime/1000];
            NSString *time = [NSString stringWithFormat:@"%@(%@~%@)",year, hour1, end];
//            serviceTimeLabel.text = time;
            [serviceTimeLabel setText:@"体检时间: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:time endTextColor:[UIColor grayColor]];
        }

    }
    else {  // 云预约
//        serviceAddressLabel.text = customerTest.regPosAddr;
         [serviceAddressLabel setText:@"体检地址: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:customerTest.regPosAddr endTextColor:[UIColor grayColor]];
        if (!customerTest.regBeginDate || !customerTest.regEndDate) {
//            serviceTimeLabel.text = @"";
//            serviceAddressLabel.text = @"获取失败";
            [serviceTimeLabel setText:@"体检时间: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:@"" endTextColor:[UIColor grayColor]];
            [serviceAddressLabel setText:@"获取失败" Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:@"" endTextColor:[UIColor grayColor]];
        }
        else {
            NSString *startyear = [NSDate getYearMonthDayByDate:customerTest.regBeginDate/1000];
            NSString *endyear = [NSDate getYearMonthDayByDate:customerTest.regEndDate/1000];
            NSString *time = [NSString stringWithFormat:@"%@~%@",startyear, endyear];
//            serviceTimeLabel.text = time;
            [serviceTimeLabel setText:@"体检时间: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:time endTextColor:[UIColor grayColor]];
        }
    }
}
@end
