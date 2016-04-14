//
//  OutCheckSiteHeaderView.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/4/13.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "OutCheckSiteHeaderView.h"

#import "Constants.h"

#import <Masonry.h>

#import "UIFont+Custom.h"
#import "UILabel+Easy.h"
#import "UIColor+Expanded.h"
#import "UILabel+FontColor.h"
#import "UIView+borderWidth.h"

#define TitleFont FIT_FONTSIZE(23)

@implementation OutCheckSiteHeaderView
{
    UILabel     *_numberOfPeopleLabel;
    UILabel     *_appointmentPeopleLabel;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        
        UIView* containerView = [[UIView alloc] init];
       // [containerView addBordersToEdge:UIRectEdgeTop withColor:[UIColor colorWithRGBHex:0xe0e0e0] andWidth:1];
        containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:containerView];
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        UILabel* titleLabel = [UILabel labelWithText:@"还可预约"
                                                font:[UIFont fontWithType:UIFontOpenSansRegular size:TitleFont] textColor:[UIColor blackColor]];
        [containerView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(containerView).with.offset(PXFIT_WIDTH(24));
            make.centerY.equalTo(containerView);
        }];
        
        _numberOfPeopleLabel = [[UILabel alloc] init];
        [containerView addSubview:_numberOfPeopleLabel];
        _numberOfPeopleLabel.textColor = [UIColor colorWithRGBHex:HC_Base_Orange_Text];
        [_numberOfPeopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).with.offset(PXFIT_WIDTH(24));
            make.centerY.equalTo(containerView);
        }];
        
        
        _appointmentPeopleLabel = [[UILabel alloc] init];
        [containerView addSubview:_appointmentPeopleLabel];
        _appointmentPeopleLabel.textColor = [UIColor colorWithRGBHex:HC_Base_Green];
        [_appointmentPeopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(containerView).with.offset(-PXFIT_WIDTH(24));
            make.centerY.equalTo(containerView);
        }];
        
        UILabel* appointmentTitleLabel = [UILabel labelWithText:@"已预约"
                                                           font:[UIFont fontWithType:UIFontOpenSansRegular size:TitleFont]
                                                      textColor:[UIColor blackColor]];
        [containerView addSubview:appointmentTitleLabel];
        [appointmentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(containerView);
            make.right.equalTo(_appointmentPeopleLabel.mas_left).with.offset(-PXFIT_WIDTH(24));
        }];
        
    }
    return self;
}

#pragma mark - Setter & Getter
-(void)setCountPeople:(NSInteger)countPeople{
    [_numberOfPeopleLabel setText:[NSString stringWithFormat:@"%ld", countPeople] Font:[UIFont fontWithType:UIFontOpenSansRegular size:TitleFont] WithEndText:@"人" endTextColor:[UIColor blackColor]];
}

-(void)setAppointmentCount:(NSInteger)appointmentCount{
    [_appointmentPeopleLabel setText:[NSString stringWithFormat:@"%ld", appointmentCount] Font:[UIFont fontWithType:UIFontOpenSansRegular size:TitleFont] WithEndText:@"人" endTextColor:[UIColor blackColor]];
}

@end
