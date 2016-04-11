//
//  UnitCheckListTableviewCell.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/4/8.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "UnitCheckListTableviewCell.h"
#import "UIFont+Custom.h"
#import "UILabel+FontColor.h"
#import "UIColor+Expanded.h"
#import "Constants.h"
#import <Masonry.h>
#import "NSDate+Custom.h"

@interface UnitCheckListTableviewCell ()

@property (nonatomic, strong) UILabel *unitNameLabel;       // 单位名称
@property (nonatomic, strong) UILabel *addressLabel;        // 体检地址
@property (nonatomic, strong) UILabel *timeslabel;          // 体检时间

@property (nonatomic, strong) UILabel *statelabel;          // 状态
@property (nonatomic, strong) UILabel *orderedLabel;        // 已预约
@property (nonatomic, strong) UILabel *checkedLabel;        // 已检查

@end


@implementation UnitCheckListTableviewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    UILabel *name = [[UILabel alloc]init];
    [self.contentView addSubview:name];
    name.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    name.text = @"合同名称";
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo(@60);
        make.height.equalTo(@35);
    }];

    UILabel *address = [[UILabel alloc]init];
    [self.contentView addSubview:address];
    address.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    address.text = @"体检地址";
    [address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(name.mas_bottom);
        make.left.height.width.equalTo(name);
    }];

    UILabel *time = [[UILabel alloc]init];
    [self.contentView addSubview:time];
    time.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    time.text = @"体检时间";
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(address.mas_bottom);
        make.left.height.width.equalTo(name);
    }];

    _unitNameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_unitNameLabel];
    _unitNameLabel.textAlignment = NSTextAlignmentRight;
    _unitNameLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:14];
    _unitNameLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
    [_unitNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(name);
        make.left.equalTo(name.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];


    _addressLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_addressLabel];
    _addressLabel.textAlignment = NSTextAlignmentRight;
    _addressLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:14];
    _addressLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.width.equalTo(_unitNameLabel);
        make.top.equalTo(_unitNameLabel.mas_bottom);
    }];

    _timeslabel = [[UILabel alloc]init];
    [self.contentView addSubview:_timeslabel];
    _timeslabel.textAlignment = NSTextAlignmentRight;
    _timeslabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:14];
    _timeslabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
    [_timeslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.width.equalTo(_addressLabel);
        make.top.equalTo(_addressLabel.mas_bottom);
    }];


    // 状态栏
    _statelabel = [[UILabel alloc]init];
    [self.contentView addSubview:_statelabel];
    _statelabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:13];
    [_statelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(time.mas_bottom);
        make.left.height.equalTo(name);
        make.width.mas_equalTo(80);
    }];

    _orderedLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_orderedLabel];
    _orderedLabel.textAlignment = NSTextAlignmentRight;
    [_orderedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_statelabel);
        make.left.equalTo(self.contentView.mas_centerX).offset(-20);
        make.width.mas_equalTo(80);
    }];

    _checkedLabel = [[UILabel alloc]init];
    _checkedLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_checkedLabel];
    [_checkedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_orderedLabel);
        make.right.equalTo(self.contentView).offset(-15);
        make.left.equalTo(_orderedLabel.mas_right).offset(10);
    }];

    _cancelOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelOrderBtn.titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:16];
    _cancelOrderBtn.layer.masksToBounds = YES;
    _cancelOrderBtn.layer.cornerRadius = 4;
    [_cancelOrderBtn setTitle:@"取消预约" forState:UIControlStateNormal];
    [_cancelOrderBtn setBackgroundColor:[UIColor colorWithRGBHex:0xff4200]];
    [self.contentView addSubview:_cancelOrderBtn];

    [_cancelOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(25);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    _cancelOrderBtn.hidden = YES;
}

- (void)setBrContract:(BRContract *)brContract
{
    _brContract = brContract;

    // 单位名称
    _unitNameLabel.text = brContract.name;
    // 体检地址 体检时间
    NSString *dizhi;
    NSString *shijian;

    //错误条件 checksideid 不为空 但 servicepoint为空
    BOOL conditionFirst = (brContract.checkSiteID != nil && ![brContract.checkSiteID isEqualToString:@""]) && (brContract.servicePoint == nil);
    if (conditionFirst){
        //数据异常
        dizhi = @"获取失败";
        shijian = @"获取失败";

    }
    else
    {
        dizhi = brContract.regPosAddr;

        NSString *timestatus;
        if (brContract.servicePoint != nil) {
            if (!brContract.servicePoint.startTime || !brContract.servicePoint.endTime) {
                timestatus = @"获取时间出错";
            }
            else {
                if (brContract.servicePoint.type == 0){
                    timestatus = [NSDate converLongLongToChineseStringDateWithHour:brContract.regTime/1000];
                }else{
                    NSString *year = [NSDate getYear_Month_DayByDate:brContract.servicePoint.startTime/1000];
                    NSString *start = [NSDate getHour_MinuteByDate:brContract.servicePoint.startTime/1000];
                    NSString *end = [NSDate getHour_MinuteByDate:brContract.servicePoint.endTime/1000];
                    timestatus = [NSString stringWithFormat:@"%@(%@~%@)", year, start, end];
                }
            }
        }
        else {
            //代表单位云预约
            timestatus = [NSDate converLongLongToChineseStringDateWithHour:brContract.regTime/1000];
        }
        shijian = timestatus;
    }
    _addressLabel.text = dizhi;
    _timeslabel.text = shijian;

    // 体检状态
    NSString *status = [BRContract getTestStatus:brContract.testStatus];    //  得到检查状态
    [_statelabel setText:@"状态: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:13] WithEndText:status endTextColor:[UIColor grayColor]];
    [_orderedLabel setText:@"已预约:" Font:[UIFont fontWithType:UIFontOpenSansRegular size:13] count:brContract.regCheckNum endColor:[UIColor blackColor]];
    [_checkedLabel setText:@"已检查" Font:[UIFont fontWithType:UIFontOpenSansRegular size:13] count:(brContract.factCheckNum <0 ? 0 : brContract.factCheckNum) endColor:[UIColor redColor]];

    // 是否能取消订单
    if ([brContract.testStatus isEqualToString:@"-1"]) {
        _cancelOrderBtn.hidden = NO;
    }
    else {
        _cancelOrderBtn.hidden = YES;
    }
}
@end
