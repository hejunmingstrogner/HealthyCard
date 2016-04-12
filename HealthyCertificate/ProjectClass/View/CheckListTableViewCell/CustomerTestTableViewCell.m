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
#import "UIColor+Expanded.h"
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

    _payMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_payMoneyBtn];
    [_payMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.height.equalTo(@25);
        make.width.mas_equalTo(80);
    }];
    _payMoneyBtn.titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:16];
    _payMoneyBtn.layer.masksToBounds = YES;
    _payMoneyBtn.layer.cornerRadius = 4;

    _cancelAppointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_cancelAppointBtn];
    [_cancelAppointBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(_payMoneyBtn);
        make.right.equalTo(_payMoneyBtn.mas_left).offset(-20);
        make.centerY.equalTo(_payMoneyBtn);
    }];
    _cancelAppointBtn.titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:16];
    _cancelAppointBtn.layer.masksToBounds = YES;
    _cancelAppointBtn.layer.cornerRadius = 4;
    [_cancelAppointBtn setTitle:@"取消预约" forState:UIControlStateNormal];
    [_cancelAppointBtn setBackgroundColor:[UIColor colorWithRGBHex:0xff4200]];

}

- (void)setCellItemWithTest:(CustomerTest *)customerTest
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@customerTest/getPrintPhoto?cCheckCode=%@", [HttpNetworkManager baseURL], customerTest.checkCode]];
    [headerimageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"headimage"] options:SDWebImageRefreshCached | SDWebImageRetryFailed];
    [nameLabel setText:@"姓名: "
                  Font:[UIFont fontWithType:UIFontOpenSansRegular size:15]
           WithEndText:customerTest.custName==nil?@"":customerTest.custName
          endTextColor:[UIColor grayColor]];
    [sexLabel setText:@"性别: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:customerTest.sex == 0 ? @"男" : @"女" endTextColor:[UIColor grayColor]];
    [oldLabel setText:@"年龄: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:[NSString getOldYears:customerTest.custIdCard] endTextColor:[UIColor grayColor]];
//    nameLabel.text = customerTest.custName;
//    sexLabel.text = customerTest.sex == 0 ? @"男" : @"女";
//    oldLabel.text = [NSString getOldYears:customerTest.custIdCard];
    
    
    if(customerTest.servicePoint == nil){
        //单位统一预约
        [serviceAddressLabel setText:@"体检地址: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:customerTest.regPosAddr endTextColor:[UIColor grayColor]];
        [serviceTimeLabel setText:@"体检时间: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15]
                      WithEndText:[NSDate converLongLongToChineseStringDateWithHour:customerTest.regTime/1000]
                     endTextColor:[UIColor grayColor]];
    }else{
        [serviceAddressLabel setText:@"体检地址: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:customerTest.servicePoint.address endTextColor:[UIColor grayColor]];
        if (customerTest.servicePoint.type == 0){
            //固定服务点
            [serviceTimeLabel setText:@"体检时间: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15]
                          WithEndText:[NSDate converLongLongToChineseStringDateWithHour:customerTest.regTime/1000]
                         endTextColor:[UIColor grayColor]];
        }else{
            //移动服务点
            NSString *year = [NSDate getYearMonthDayByDate:customerTest.servicePoint.startTime/1000];
            NSString *hour1 = [NSDate getHour_MinuteByDate:customerTest.servicePoint.startTime/1000];
            NSString *end = [NSDate getHour_MinuteByDate:customerTest.servicePoint.endTime/1000];
            NSString *time = [NSString stringWithFormat:@"%@(%@~%@)",year, hour1, end];
            [serviceTimeLabel setText:@"体检时间: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:time endTextColor:[UIColor grayColor]];
        }
    }

//    if(customerTest.checkSiteID) // 服务点预约
//    {
//        [serviceAddressLabel setText:@"体检地址: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:customerTest.servicePoint.address endTextColor:[UIColor grayColor]];
//        if (!customerTest.servicePoint.startTime || !customerTest.servicePoint.endTime) {
//            [serviceTimeLabel setText:@"体检时间: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:@"" endTextColor:[UIColor grayColor]];
//            [serviceAddressLabel setText:@"体检地址: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:@"获取失败" endTextColor:[UIColor grayColor]];
//        }
//        else {
//            if (customerTest.servicePoint.type == 0){
//                [serviceTimeLabel setText:@"体检时间: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15]
//                              WithEndText:[NSDate converLongLongToChineseStringDateWithHour:customerTest.regTime/1000]
//                             endTextColor:[UIColor grayColor]];
//            }else{
//                NSString *year = [NSDate getYearMonthDayByDate:customerTest.servicePoint.startTime/1000];
//                NSString *hour1 = [NSDate getHour_MinuteByDate:customerTest.servicePoint.startTime/1000];
//                NSString *end = [NSDate getHour_MinuteByDate:customerTest.servicePoint.endTime/1000];
//                NSString *time = [NSString stringWithFormat:@"%@(%@~%@)",year, hour1, end];
//                [serviceTimeLabel setText:@"体检时间: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:time endTextColor:[UIColor grayColor]];
//            }
//        }
//
//    }
//    else {  // 云预约
////        serviceAddressLabel.text = customerTest.regPosAddr;
//         [serviceAddressLabel setText:@"体检地址: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:customerTest.regPosAddr endTextColor:[UIColor grayColor]];
//        if (!customerTest.regBeginDate || !customerTest.regEndDate) {
////            serviceTimeLabel.text = @"";
////            serviceAddressLabel.text = @"获取失败";
//            [serviceTimeLabel setText:@"体检时间: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:@"" endTextColor:[UIColor grayColor]];
//            [serviceAddressLabel setText:@"体检地址: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:@"获取失败" endTextColor:[UIColor grayColor]];
//        }
//        else {
//            NSString *startyear = [NSDate getYearMonthDayByDate:customerTest.regBeginDate/1000];
//            NSString *endyear = [NSDate getYearMonthDayByDate:customerTest.regEndDate/1000];
//            NSString *time = [NSString stringWithFormat:@"%@~%@",startyear, endyear];
////            serviceTimeLabel.text = time;
//            [serviceTimeLabel setText:@"体检时间: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:15] WithEndText:time endTextColor:[UIColor grayColor]];
//        }
//    }
}

- (void)setPayMoney:(float)payMoney
{
    _payMoney = payMoney;

    if (payMoney > 0) {
        [_payMoneyBtn setTitle:@"已支付" forState:UIControlStateNormal];
        [_payMoneyBtn setBackgroundColor:[UIColor colorWithRed:95/255.0 green:177/255.0 blue:58/255.0 alpha:1]];
        _payMoneyBtn.tag = -1;
    }
    else {
        [_payMoneyBtn setTitle:@"在线支付" forState:UIControlStateNormal];
        [_payMoneyBtn setBackgroundColor:[UIColor colorWithRed:1 green:155/255.0 blue:18/255.0 alpha:1]];
    }
}
@end
