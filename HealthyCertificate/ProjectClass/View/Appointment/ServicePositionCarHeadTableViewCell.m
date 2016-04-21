//
//  ServicePositionCarHeadTableViewCell.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ServicePositionCarHeadTableViewCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "HttpNetworkManager.h"
#import "NSDate+Custom.h"
#import "UILabel+FontColor.h"
#import "UIFont+Custom.h"
#import "Constants.h"
@interface ServicePositionCarHeadTableViewCell()

@property (nonatomic, strong) UILabel     *carNo;   // 牌照
@property (nonatomic, strong) UILabel     *address;
@property (nonatomic, strong) UILabel     *serviceTime; // 服务时间
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView       *container;  // 背景容器view

@property (nonatomic, strong) UILabel    *statusLabel;  // 状态

@end

@implementation ServicePositionCarHeadTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    _scrollView = [[UIScrollView alloc]init];
    [self.contentView addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.contentView).offset(10);
    }];

    _container = [UIView new];
    [_scrollView addSubview:_container];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];

    UIImageView *quanquan = [[UIImageView alloc]init];
    [_container addSubview:quanquan];

    // 标题
    _carNo = [[UILabel alloc]init];
    _carNo.numberOfLines = 0;
    [_container addSubview:_carNo];
    _carNo.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)];
    [_carNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container).offset(10);
        make.right.equalTo(_container);
        make.left.equalTo(quanquan.mas_right);
        make.height.mas_equalTo(40);
    }];

    quanquan.image = [UIImage imageNamed:@"quanquan"];
    [quanquan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_carNo.mas_left);
        make.centerY.equalTo(_carNo);
        make.left.equalTo(_container);
        make.height.width.mas_equalTo(15);
    }];

    // 服务时间
    _serviceTime = [[UILabel alloc]init];
    [_container addSubview:_serviceTime];
    _serviceTime.numberOfLines = 0;
    _serviceTime.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(23)];
    _serviceTime.textColor = [UIColor grayColor];
    [_serviceTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_carNo.mas_bottom).offset(10);
        make.left.right.equalTo(_container);
        make.height.mas_equalTo(40);
    }];
    
    // 地址
    _address = [[UILabel alloc]init];
    [_container addSubview:_address];
    _address.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(23)];
    _address.numberOfLines = 0;
    _address.textColor = [UIColor grayColor];
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_serviceTime.mas_bottom).offset(10);
        make.left.right.equalTo(_serviceTime);
        make.height.mas_equalTo(30);
    }];

    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_address.mas_bottom).offset(20);
    }];
}

- (void)setCellItem:(ServersPositionAnnotionsModel *)serviceInfo
{
//    if (serviceInfo.type == 0) {
//        [_carNo setText:serviceInfo.name Font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)] WithEndText:@"" endTextColor:[UIColor redColor]];
//    }
//    else {
//        [_carNo setText:serviceInfo.name Font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)] WithEndText:[NSString stringWithFormat:@"(%d人办证)", serviceInfo.oppointmentNum < 0? 0:serviceInfo.oppointmentNum] endTextColor:[UIColor redColor]];
//    }
    _carNo.text = serviceInfo.name;
    // 重新设置头高
    int carHeight = [self titleHeight:[NSString stringWithFormat:@"%@(%d人办证)", serviceInfo.name, serviceInfo.oppointmentNum] fontSize:FIT_FONTSIZE(24)];
    [_carNo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(carHeight);
    }];

    _address.text = serviceInfo.address;
    int addrHeight = [self Textheight:_address.text fontSize:FIT_FONTSIZE(23)];
    [_address mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(addrHeight);
    }];

    NSString* sdate;
    if (serviceInfo.startTime == 0 || serviceInfo.endTime == 0) {
        sdate = nil;
    }
    else{
        if(serviceInfo.type == 0){
            //固定服务点
            sdate = [NSString stringWithFormat:@"工作日(%@-%@)", [NSDate getHour_MinuteByDate:serviceInfo.startTime/1000], [NSDate getHour_MinuteByDate:serviceInfo.endTime/1000]];
        }else{
            sdate = [NSString stringWithFormat:@"%@(%@-%@)", [NSDate getYear_Month_DayByDate:serviceInfo.startTime/1000], [NSDate getHour_MinuteByDate:serviceInfo.startTime/1000], [NSDate getHour_MinuteByDate:serviceInfo.endTime/1000]];
        }
    }
 
    _serviceTime.text = sdate;

    int serHeight = [self Textheight:sdate fontSize:FIT_FONTSIZE(23)];
    [_serviceTime mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(serHeight);
    }];
    [_container mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_address.mas_bottom).offset(20);
    }];

    if(serviceInfo.type == 1){
        if (!_statusLabel) {
            _statusLabel = [[UILabel alloc]init];
            [self.contentView addSubview:_statusLabel];
            [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(10);
                make.bottom.equalTo(self.contentView).offset(-10);
                make.right.equalTo(self.contentView);
                make.width.equalTo(@40);
            }];
            _statusLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:16];
            _statusLabel.numberOfLines = 0;
            _statusLabel.textAlignment = NSTextAlignmentCenter;

            UILabel *fengexian = [[UILabel alloc]init];
            [self.contentView addSubview:fengexian];
            [fengexian mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(_statusLabel);
                make.right.equalTo(_statusLabel.mas_left);
                make.width.equalTo(@1);
            }];
            fengexian.backgroundColor = [UIColor lightGrayColor];

            [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-45);
            }];
        }
        // 设置状态值
        _statusLabel.text = [serviceInfo.outCheckSitePartInfo getOutCheckSitePartInfoTestStatus];
        _statusLabel.textColor = [serviceInfo.outCheckSitePartInfo  getOutCheckSitePartInfoTestStatusLabelColor];// 设置文本颜色
    }
}

- (CGFloat)Textheight:(NSString *)text fontSize:(NSInteger)size
{
    UIFont *fnt = [UIFont fontWithType:UIFontOpenSansRegular size:size];
    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 120, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];
    CGFloat he = tmpRect.size.height+5;
    return he;
}

- (CGFloat)titleHeight:(NSString *)text fontSize:(NSInteger)size
{
    UIFont *fnt = [UIFont fontWithType:UIFontOpenSansRegular size:size];
    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40 - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];
    CGFloat he = tmpRect.size.height+5;
    return he;
}
@end
