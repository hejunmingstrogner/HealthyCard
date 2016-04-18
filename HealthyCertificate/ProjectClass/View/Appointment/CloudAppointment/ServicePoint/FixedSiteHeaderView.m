//
//  FixedSiteHeaderView.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/4/18.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "FixedSiteHeaderView.h"

#import "Constants.h"

#import <Masonry.h>

#import "UIFont+Custom.h"
#import "UILabel+Easy.h"
#import "UIColor+Expanded.h"
#import "UILabel+FontColor.h"

@implementation FixedSiteHeaderView

#define TitleFont FIT_FONTSIZE(23)

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        UIView* containerView = [[UIView alloc] init];
        containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:containerView];
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        UIImageView* hotTipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hotTip"]];
        [containerView addSubview:hotTipImageView];
        [hotTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(containerView).with.offset(PXFIT_WIDTH(24));
            make.centerY.equalTo(containerView);
        }];
        
        UILabel* titleLabel = [UILabel labelWithText:@"提供上门体检送证上门"
                                                font:[UIFont fontWithType:UIFontOpenSansRegular size:TitleFont] textColor:[UIColor blackColor]];
        [containerView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(hotTipImageView.mas_right).with.offset(PXFIT_WIDTH(24));
            make.centerY.equalTo(containerView);
        }];
    }
    return self;
}


@end
