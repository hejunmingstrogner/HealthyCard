//
//  DetailImageView.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/24.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "DetailImageView.h"

#import <Masonry.h>

#import "UIFont+Custom.h"
#import "UILabel+Easy.h"

#import "Constants.h"

@implementation DetailImageView

#define ImageWidth (SCREEN_WIDTH - PXFIT_WIDTH(50))


-(instancetype)initWithImage:(UIImage*)image TotalCount:(NSString*)totalCount MonthCount:(NSString*)monthCount Frame:(CGRect)frame;{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        UIView* backGoundView = [[UIView alloc] init];
        backGoundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backGoundView];
        [backGoundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.mas_equalTo(ImageWidth);
            make.height.mas_equalTo(ImageWidth+50);
        }];
        backGoundView.layer.cornerRadius = 5;
        
        UIImageView* imageView = [[UIImageView alloc] init];
        imageView.image = image;
        [backGoundView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(backGoundView);
            make.top.mas_equalTo(backGoundView);
            make.width.mas_equalTo(ImageWidth);
            make.height.mas_equalTo(ImageWidth);
        }];
        
        UILabel* monthCountLabelTitle = [UILabel labelWithText:@"当月服务人数："
                                                          font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)]
                                                     textColor:[UIColor blackColor]];
        [backGoundView addSubview:monthCountLabelTitle];
        [monthCountLabelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backGoundView).with.offset(15);
            make.top.mas_equalTo(imageView.mas_bottom);
        }];
        
        UILabel* monthCountLabel = [UILabel labelWithText:monthCount
                                                     font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)]
                                                textColor:[UIColor blackColor]];
        [backGoundView addSubview:monthCountLabel];
        [monthCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(monthCountLabelTitle.mas_right);
            make.centerY.mas_equalTo(monthCountLabelTitle);
        }];
        
        
        //累积服务人数
        UILabel* totalCountLabelTitle = [UILabel labelWithText:@"累积服务人数："
                                                          font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)]
                                                     textColor:[UIColor blackColor]];
        [backGoundView addSubview:totalCountLabelTitle];
        [totalCountLabelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backGoundView).with.offset(15);
            make.top.mas_equalTo(monthCountLabelTitle.mas_bottom).with.offset(5);
        }];
        
        UILabel* totalCountLabel = [UILabel labelWithText:totalCount
                                                     font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)]
                                                textColor:[UIColor blackColor]];
        [backGoundView addSubview:totalCountLabel];
        [totalCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(totalCountLabelTitle.mas_right);
            make.centerY.mas_equalTo(totalCountLabelTitle);
        }];
    }
    return self;
}
@end
