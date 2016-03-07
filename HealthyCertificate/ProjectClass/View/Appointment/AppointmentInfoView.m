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
    CGFloat heigh = [self viewHeight];
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, heigh)]){
        
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

- (CGFloat)viewHeight
{
    UIFont *fnt = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(23)];
    CGRect tmpRect = [@"注意事项" boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];

    CGRect tmpRect1 = [@"1、云预约时请确认预约体检地点和联系人电话有效性,以便我们方便联系您并为您提供优质的体检服务。" boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];

    CGRect tmpRect2 = [@"2、选定（指定）服务点后请按时到指定位置体检，以免错过时间给您带来不便。" boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];
    return tmpRect.size.height + PXFIT_HEIGHT(20) + tmpRect1.size.height + PXFIT_WIDTH(10) + tmpRect2.size.height + PXFIT_WIDTH(10);
}

@end
