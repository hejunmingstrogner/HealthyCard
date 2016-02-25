//
//  ServicePointCell.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ServicePointCell.h"

#import "Constants.h"

#import <Masonry.h>

#import "UIButton+Easy.h"
#import "UIColor+Expanded.h"
#import "UIFont+Custom.h"
#import "UILabel+FontColor.h"
#import "NSDate+Custom.h"

#define Cell_Font 17
#define Cell_Detail_Font 15

@interface ServicePointCell()
{
    UIImageView             *_picImageView;
    UILabel                 *_nameLabel;
    UILabel                 *_distanceLabel;
    UILabel                 *_locationLabel;
    UILabel                 *_timeLabel;
}
//ff4200
@end


@implementation ServicePointCell


/*
 test.name = @"江安门诊部";
 test.address = @"成都市武侯区江安门诊部";
 test.startTime = [NSDate date];
 test.distance = 16.0;
 */

#pragma mark - Setter & Getter
-(void)setServicePoint:(ServersPositionAnnotionsModel *)servicePoint{
    _nameLabel.text = servicePoint.name;
    
    _distanceLabel.text = [NSString stringWithFormat:@"%.1lfkm", servicePoint.distance];
    _distanceLabel.textColor = MO_RGBCOLOR(0, 169, 234);
    
    /*
     _locationLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:Cell_Detail_Font];
     _locationLabel.textColor = [UIColor colorWithRGBHex:0x6e6e6e];
     */
    
    //如果是临时服务点
    if (servicePoint.type == 1){
        [_locationLabel setText:servicePoint.address
                       textFont:[UIFont fontWithType:UIFontOpenSansRegular size:Cell_Detail_Font]
                    WithEndText:@"临"
                   endTextColor:[UIColor redColor]];
        _timeLabel.text = [NSString stringWithFormat:@"%@(%@~%@)",
                           [NSDate getYear_Month_DayByDate:servicePoint.startTime],
                           [NSDate getHour_MinuteByDate:servicePoint.startTime],
                           [NSDate getHour_MinuteByDate:servicePoint.endTime]];
    }
    else{
        _locationLabel.text = servicePoint.address;
        _timeLabel.text = [NSString stringWithFormat:@"每天(%@~%@)",
                               [NSDate getHour_MinuteByDate:servicePoint.startTime],
                               [NSDate getHour_MinuteByDate:servicePoint.endTime]];
        
    }
    //_timeLabel.text = @"每天9:00-17:00";
   // _distanceLabel.text = [NSString stringWithFormat:@"%f", servicePoint.distance];
}

#pragma mark - Life Circle
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        //cell的上半部分界面
        UIView* topView = [[UIView alloc] init];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self);
            make.height.mas_equalTo(PXFIT_HEIGHT(198));
        }];
        
        UIView* imageContainerView = [[UIView alloc] init];
        [topView addSubview:imageContainerView];
        [imageContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(topView);
            make.width.mas_equalTo(PXFIT_WIDTH(168)); // 24 120 24
        }];
        
        _picImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"servicePoint"]];
        [imageContainerView addSubview:_picImageView];
        [_picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(imageContainerView);
        }];
        
        UIView* topRightView = [[UIView alloc] init];
        [topView addSubview:topRightView];
        [topRightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageContainerView.mas_right);
            make.right.top.bottom.mas_equalTo(topView);
        }];
        
        //门诊部名字一栏
        UIView* topRightUpView = [[UIView alloc] init];
        [topRightView addSubview:topRightUpView];
        [topRightUpView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(topRightView);
            make.height.mas_equalTo(PXFIT_HEIGHT(99));
        }];
        
        UIImageView* nameIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nameIcon"]];
        [topRightUpView addSubview:nameIcon];
        
        _nameLabel = [[UILabel alloc] init];
        [topRightUpView addSubview:_nameLabel];
        _distanceLabel = [[UILabel alloc] init];
        [topRightUpView addSubview:_distanceLabel];
        
        [nameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.mas_equalTo(topRightUpView);
            make.left.mas_equalTo(topRightUpView);
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(topRightUpView);
            make.left.mas_equalTo(nameIcon.mas_right);
        }];
        
    
        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(topRightUpView);
            make.right.mas_equalTo(topRightUpView).with.offset(-PXFIT_WIDTH(24));
            make.left.greaterThanOrEqualTo(_nameLabel.mas_right).with.offset(PXFIT_WIDTH(10));
        }];
        [_distanceLabel setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
        
        
        UIView* topRightDownView = [[UIView alloc] init];
        [topRightView addSubview:topRightDownView];
        [topRightDownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(topRightView);
            make.top.mas_equalTo(topRightUpView.mas_bottom);
        }];
        
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [topRightDownView addSubview:_locationLabel];
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(topRightDownView);
            make.height.mas_equalTo(PXFIT_HEIGHT(49));
        }];
        
        _timeLabel = [[UILabel alloc] init];
        [topRightDownView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(topRightDownView);
            make.height.mas_equalTo(PXFIT_HEIGHT(49));
            make.top.mas_equalTo(_locationLabel.mas_bottom);
        }];
        

        UIView* lineView = [[UIView alloc] init];
        lineView.backgroundColor=[UIColor colorWithRGBHex:0xe0e0e0];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).with.offset(PXFIT_WIDTH(24));
            make.right.mas_equalTo(self).with.offset(-PXFIT_WIDTH(24));
            make.top.mas_equalTo(topView.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        
        UIView* bottomView = [[UIView alloc] init];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.top.mas_equalTo(lineView.mas_bottom);
        }];
        
        UIButton* messageBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"message"]
                                                highlightImage:[UIImage imageNamed:@"message"]];
        [messageBtn addTarget:self action:@selector(messageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:messageBtn];
        [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bottomView);
            make.right.mas_equalTo(bottomView).with.offset(-PXFIT_WIDTH(24));
        }];
        
        UIButton* phoneCallBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"phonecall"]
                                                  highlightImage:[UIImage imageNamed:@"phonecall"]];
        [phoneCallBtn addTarget:self action:@selector(phoneCallBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:phoneCallBtn];
        [phoneCallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bottomView);
            make.right.mas_equalTo(messageBtn.mas_left).with.offset(-PXFIT_WIDTH(76));
        }];
        
        UIButton* detailBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"detail"]
                                                  highlightImage:[UIImage imageNamed:@"detail"]];
        [detailBtn addTarget:self action:@selector(detailBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:detailBtn];
        [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bottomView);
            make.right.mas_equalTo(phoneCallBtn.mas_left).with.offset(-PXFIT_WIDTH(76));
        }];
        
        
        //MO_RGBCOLOR(70, 180, 240)
        _nameLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:Cell_Font];
        _distanceLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:Cell_Detail_Font];
        _distanceLabel.textColor = MO_RGBCOLOR(70, 180, 240);
        _timeLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:Cell_Detail_Font];
        _timeLabel.textColor = [UIColor colorWithRGBHex:0x6e6e6e];
        _locationLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:Cell_Detail_Font];
        _locationLabel.textColor = [UIColor colorWithRGBHex:0x6e6e6e];
    }
    return self;
}

#pragma mark - Action
-(void)messageBtnClicked:(id)sender
{}


-(void)phoneCallBtnClicked:(id)sender
{}

-(void)detailBtnClicked:(id)sender
{}

@end
