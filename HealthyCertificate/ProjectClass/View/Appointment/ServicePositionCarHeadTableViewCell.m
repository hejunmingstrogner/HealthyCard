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

@interface ServicePositionCarHeadTableViewCell()
@property (nonatomic, strong) UIImageView *carImageView;
@property (nonatomic, strong) UILabel     *carNo;   // 牌照
@property (nonatomic, strong) UILabel     *address;
@property (nonatomic, strong) UILabel     *serviceTime; // 服务时间
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView      *viewsBg;

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
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.width.equalTo(_carImageView.mas_height);
    }];

    UIView *bgview = [[UIView alloc]init];
    [self.contentView addSubview:bgview];
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.contentView);
        make.left.equalTo(_carImageView.mas_right);
    }];

    _scrollView = [[UIScrollView alloc]init];
    [bgview addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgview);
    }];
    //_scrollView.contentSize = CGSizeMake(self.contentView.frame.size.width - self.contentView.frame.size.height + 20, 140);
    _scrollView.contentSize = CGSizeMake(0, 140);

    _viewsBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width - 120, 140)];
    [_scrollView addSubview:_viewsBg];

    UIImageView *quanquan = [[UIImageView alloc]init];
    [_viewsBg addSubview:quanquan];

    // 标题
    _carNo = [[UILabel alloc]init];
    _carNo.numberOfLines = 0;
    [_viewsBg addSubview:_carNo];
    _carNo.font = [UIFont fontWithType:UIFontOpenSansRegular size:17];
    [_carNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewsBg).offset(5);
        make.right.equalTo(_viewsBg).offset(-10);
        make.left.equalTo(quanquan.mas_right).offset(5);
        make.height.mas_equalTo(40);
    }];

    quanquan.image = [UIImage imageNamed:@"quanquan"];
    [quanquan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_carNo.mas_left).offset(-5);
        make.centerY.equalTo(_carNo);
        make.left.equalTo(_viewsBg).offset(3);
        make.height.width.mas_equalTo(15);
    }];

    // 地址
    _address = [[UILabel alloc]init];
    [_viewsBg addSubview:_address];
    _address.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    _address.numberOfLines = 0;
    _address.textColor = [UIColor grayColor];
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_carNo.mas_bottom).offset(5);
        make.left.equalTo(_viewsBg).offset(5);
        make.right.equalTo(_viewsBg).offset(-10);
        //make.width.mas_equalTo(self.contentView.frame.size.width - self.contentView.frame.size.height + 10);
        make.height.mas_equalTo(35);
    }];

    // 服务时间
    _serviceTime = [[UILabel alloc]init];
    [_viewsBg addSubview:_serviceTime];
    _serviceTime.numberOfLines = 0;
    _serviceTime.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    _serviceTime.textColor = [UIColor grayColor];
    [_serviceTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_address.mas_bottom).offset(5);
        make.left.right.equalTo(_address);
        make.height.mas_equalTo(40);
    }];
}

- (void)setCellItem:(ServersPositionAnnotionsModel *)serviceInfo
{
    [_carImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@brVehicle/getPhoto?uid=%@", [HttpNetworkManager baseURL], serviceInfo.brOutCheckArrange.vehicleID]] placeholderImage:[UIImage imageNamed:@"carimage"]];

    _carNo.text = serviceInfo.name;

    int carHeight = [self titleHeight:serviceInfo.name fontSize:17];

    [_carNo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(carHeight);
    }];

    if (serviceInfo.type == 1) {
        [_address setText:serviceInfo.address textFont:[UIFont systemFontOfSize:15] WithEndText:@"临" endTextColor:[UIColor redColor]];
    }
    else {
        _address.text = serviceInfo.address;
    }

    int addrHeight = [self Textheight:_address.text fontSize:15];
    [_address mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(addrHeight);
    }];
    if (!serviceInfo.startTime || !serviceInfo.endTime) {
        return ;
    }

    NSString *sdate = [NSString stringWithFormat:@"%@(%@-%@)", [NSDate getYear_Month_DayByDate:serviceInfo.startTime], [NSDate getHour_MinuteByDate:serviceInfo.startTime], [NSDate getHour_MinuteByDate:serviceInfo.endTime]];
    _serviceTime.text = sdate;

    int serHeight = [self Textheight:sdate fontSize:15];
    [_serviceTime mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(serHeight);
    }];

    //_scrollView.contentSize = CGSizeMake(self.contentView.frame.size.width - self.contentView.frame.size.height + 20, carHeight + addrHeight + serHeight + 10);
    _scrollView.contentSize = CGSizeMake(0, carHeight + addrHeight + serHeight + 20);
    _viewsBg.frame = CGRectMake(0, 0, self.contentView.frame.size.width - 120, carHeight + addrHeight + serHeight + 20);
}

- (CGFloat)Textheight:(NSString *)text fontSize:(NSInteger)size
{
    UIFont *fnt = [UIFont systemFontOfSize:size];
    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 140, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];
    CGFloat he = tmpRect.size.height+10;
    return he;
}

- (CGFloat)titleHeight:(NSString *)text fontSize:(NSInteger)size
{
    UIFont *fnt = [UIFont systemFontOfSize:size];
    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 140 - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];
    CGFloat he = tmpRect.size.height+10;
    return he;
}
@end
