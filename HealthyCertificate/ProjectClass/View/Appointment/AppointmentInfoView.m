//
//  AppointmentInfoView.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "AppointmentInfoView.h"

#import "Constants.h"

#import <Masonry.h>
#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"

#define font_color 0xe0e0e0

@implementation AppointmentInfoView

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel* titleInfo = [[UILabel alloc] init];
        titleInfo.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(23)];
        titleInfo.text = @"注意事项";
        [self addSubview:titleInfo];
        [titleInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).with.offset(PXFIT_HEIGHT(20));
            make.left.mas_equalTo(self).with.offset(PXFIT_WIDTH(10));
        }];
        
        UILabel* firstItemLabel = [[UILabel alloc] init];
        //设置自动行数与字符换行
        [firstItemLabel setNumberOfLines:0];
        firstItemLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(23)];
        firstItemLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
        firstItemLabel.text = @"1、云预约时请确认预约体检地点和联系人电话有效性,以便我们方便联系您并为您提供优质的体检服务。";
        [self addSubview:firstItemLabel];
        [firstItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).with.offset(PXFIT_WIDTH(10));
            make.right.mas_equalTo(self).with.offset(-PXFIT_WIDTH(10));
            make.top.mas_equalTo(titleInfo.mas_bottom).with.offset(PXFIT_HEIGHT(10));
        }];
        
        UILabel* secondItemLabel = [[UILabel alloc] init];
        [secondItemLabel setNumberOfLines:0];
        secondItemLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(23)];
        secondItemLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
        secondItemLabel.text = @"2、选定（指定）服务点后请按时到指定位置体检，以免错过时间给您带来不便。";
        [self addSubview:secondItemLabel];
        [secondItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).with.offset(PXFIT_WIDTH(10));
            make.right.mas_equalTo(self).with.offset(-PXFIT_WIDTH(10));
            make.top.mas_equalTo(firstItemLabel.mas_bottom).with.offset(PXFIT_HEIGHT(10));
            make.bottom.mas_equalTo(self);
        }];
    }
    return self;
}

@end
