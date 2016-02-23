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

@interface ServicePositionCarHeadTableViewCell()
@property (nonatomic, strong) UIImageView *carImageView;
@property (nonatomic, strong) UILabel     *carNo;   // 牌照
@property (nonatomic, strong) UILabel     *address;
@property (nonatomic, strong) UILabel     *serviceTime; // 服务时间
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
    _carImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_carImageView];
    [_carImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.bottom.equalTo(self.contentView).offset(-20);
        make.left.equalTo(self.contentView).offset(20);
        make.width.equalTo(_carImageView.mas_height);
    }];

    _carNo = [[UILabel alloc]init];
    _carNo.numberOfLines = 0;
    [self.contentView addSubview:_carNo];
    [_carNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(-10);
        make.left.equalTo(_carImageView.mas_right).offset(50);
        make.height.mas_equalTo(50);
    }];

    UIImageView *quanquan = [[UIImageView alloc]init];
    [self.contentView addSubview:quanquan];
    quanquan.image = [UIImage imageNamed:@"quanquan"];
    [quanquan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_carNo.mas_left);
        make.centerY.equalTo(_carNo);
        make.height.width.mas_equalTo(30);
    }];

    _address = [[UILabel alloc]init];
    [self.contentView addSubview:_address];
    _address.font = [UIFont systemFontOfSize:15];
    _address.numberOfLines = 0;
    _address.textColor = [UIColor grayColor];
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_carNo.mas_bottom);
        make.left.equalTo(quanquan);
        make.right.equalTo(_carNo);
        make.height.mas_equalTo(50);
    }];

    _serviceTime = [[UILabel alloc]init];
    [self.contentView addSubview:_serviceTime];
    _serviceTime.font = [UIFont systemFontOfSize:15];
    _serviceTime.textColor = [UIColor grayColor];
    [_serviceTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_address.mas_bottom);
        make.left.right.equalTo(_address);
        make.height.mas_equalTo(40);
    }];
}

- (void)setCellItem:(ServersPositionAnnotionsModel *)serviceInfo
{
    [_carImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@brVehicle/getPhoto?uid=%@", [HttpNetworkManager baseURL], serviceInfo.brOutCheckArrange.vehicleID]] placeholderImage:[UIImage imageNamed:@"carimage"]];
    _carNo.text = serviceInfo.name;
    if (serviceInfo.type == 1) {
        [_address setText:serviceInfo.address textFont:[UIFont systemFontOfSize:15] WithEndText:@"临" endTextColor:[UIColor redColor]];
    }
    else {
        _address.text = serviceInfo.address;
    }
    if (!serviceInfo.startTime || !serviceInfo.endTime) {
        return ;
    }
    NSString *sdate = [NSString stringWithFormat:@"%@(%@-%@)", [NSDate getYear_Month_DayByDate:serviceInfo.startTime], [NSDate getHour_MinuteByDate:serviceInfo.startTime], [NSDate getHour_MinuteByDate:serviceInfo.endTime]];
    _serviceTime.text = sdate;
}
@end
