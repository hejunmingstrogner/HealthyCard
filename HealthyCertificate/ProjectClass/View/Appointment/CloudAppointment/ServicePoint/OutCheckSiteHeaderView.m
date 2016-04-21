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
#import "NSDate+Custom.h"

#import "ServersPositionAnnotionsModel.h"

#define TitleFont FIT_FONTSIZE(23)

@implementation OutCheckSiteHeaderView
{
    UILabel     *_numberOfPeopleLabel;
    UILabel     *_appointmentPeopleLabel;
    
    UILabel     *_tipLabel;
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
        
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.backgroundColor = [UIColor whiteColor];
        _tipLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:TitleFont];
        _tipLabel.numberOfLines = 0;
        [containerView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(containerView).with.offset(PXFIT_WIDTH(24));
            make.right.equalTo(containerView).with.offset(-PXFIT_WIDTH(24));
            make.top.bottom.equalTo(containerView);
        }];
        _tipLabel.hidden = YES;
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

#pragma mark - Public Methods
-(void)setServerPointInfo:(ServersPositionAnnotionsModel*)spModel
{
    if (spModel.outCheckSitePartInfo != nil && spModel.outCheckSitePartInfo.testStatus == 0){
        //未生效
        NSString *time = [NSDate getYearMonthDayByDate:spModel.startTime/1000];
        NSString *count = [NSString stringWithFormat:@"%d", spModel.outCheckSitePartInfo.chargedNum];
        [_tipLabel setText1:time text1Color:[UIColor redColor] text2:@"之前召集" text2Color:[UIColor blackColor] text3:@"16个" text3Color:[UIColor redColor] text4:@"小伙伴，此体检点生效！ 已召集 "  text4Color:[UIColor blackColor] text5:count text5Color:[UIColor redColor] size:14];
        _tipLabel.hidden = NO;
    }
}



@end
