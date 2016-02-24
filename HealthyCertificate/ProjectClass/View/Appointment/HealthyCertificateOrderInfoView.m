//
//  HealthyCertificateOrderInfoView.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "HealthyCertificateOrderInfoView.h"

@interface HealthyCertificateOrderInfoView()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation HealthyCertificateOrderInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame WithTitles:(NSArray *)titleArray
{
    if(self = [self initWithFrame:frame])
    {
        _titleArray = titleArray;
    }
    return self;
}

- (void)initSubviews
{
    _segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"预约信息", @"服务点信息"]];
    [self addSubview:_segmentControl];
    [_segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset((self.frame.size.height/4-40)/2);
        make.width.mas_equalTo(self.frame.size.width/2);
        make.height.mas_equalTo(40);
    }];
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.tintColor = [UIColor colorWithRed:30/255.0 green:150/255.0 blue:200/255.0 alpha:1];
    _segmentControl.layer.masksToBounds = YES;
    _segmentControl.layer.cornerRadius = 5;
    [_segmentControl addTarget:self action:@selector(segmentControlClicked:) forControlEvents:UIControlEventEditingChanged];

    _addressBtn = [[CustomButton alloc]init];
    [self addSubview:_addressBtn];
    
}

- (void)segmentControlClicked:(UISegmentedControl *)sender
{

}
@end
