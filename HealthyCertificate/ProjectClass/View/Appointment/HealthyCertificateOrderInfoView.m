//
//  HealthyCertificateOrderInfoView.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "HealthyCertificateOrderInfoView.h"

@interface HealthyCertificateOrderInfoView()

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
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    self.layer.borderColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:0.3].CGColor;
    self.layer.borderWidth = 0.5;
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
    [_segmentControl addTarget:self action:@selector(segmentControlClicked:) forControlEvents:UIControlEventValueChanged];

    UIView *backview = [[UIView alloc]init];
    [self addSubview:backview];
    backview.backgroundColor = [UIColor grayColor];
    backview.alpha = 0.4;
    [backview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(11);
        make.right.equalTo(self).offset(-11);
        make.top.equalTo(self).offset(self.frame.size.height/4-1);
        make.height.mas_equalTo(self.frame.size.height/2+ 10);
    }];

    _addressBtn = [[CustomButton alloc]init];
    [self addSubview:_addressBtn];
    [_addressBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_addressBtn setBackgroundColor:[UIColor whiteColor]];
    //_addressBtn.contentEdgeInsets = UIEdgeInsetsMake(5, self.frame.size.width - self.frame.size.height/4, 5, 5);
    [_addressBtn setImage:[UIImage imageNamed:@"sousuo"] forState:UIControlStateNormal];
    _addressBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, self.frame.size.width -20 -(self.frame.size.height/4-10) - 5);
    [_addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(self.frame.size.height/4);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(self.frame.size.height/4-1);
    }];

    _timeBtn = [[CustomButton alloc]init];
    [self addSubview:_timeBtn];
    [_timeBtn setBackgroundColor:[UIColor whiteColor]];
    [_timeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_timeBtn setImage:[UIImage imageNamed:@"shijian"] forState:UIControlStateNormal];
    _timeBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, self.frame.size.width -20 -(self.frame.size.height/4-10) - 5);
    //_timeBtn.contentEdgeInsets = UIEdgeInsetsMake(5, self.frame.size.width - self.frame.size.height/4, 5, 5);
    [_timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressBtn.mas_bottom).offset(1);
        make.left.right.height.equalTo(_addressBtn);
    }];

    _phoneBtn = [[CustomButton alloc]init];
    [self addSubview:_phoneBtn];
    [_phoneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_phoneBtn setBackgroundColor:[UIColor whiteColor]];
    _phoneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_phoneBtn setImage:[UIImage imageNamed:@"dianhua"] forState:UIControlStateNormal];
    _phoneBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, self.frame.size.width -20 -(self.frame.size.height/4-10) - 5);
    //_phoneBtn.contentEdgeInsets = UIEdgeInsetsMake(5, self.frame.size.width - self.frame.size.height/4, 5, 5);
    [_phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeBtn.mas_bottom).offset(1);
        make.left.right.height.equalTo(_timeBtn);
    }];
}

- (void)segmentControlClicked:(UISegmentedControl *)sender
{
    [self setItem];
}

- (void)setItemWithInfo:(BRContract *)brcontract{
    _brContract = brcontract;
    [self setItem];
}

- (void)setItem
{
    NSInteger index = _segmentControl.selectedSegmentIndex;
    if (index == 0) {
        [_addressBtn setTitle:_brContract.cRegPosAddr forState:UIControlStateNormal];
        if (!_brContract.cRegBeginDate || !_brContract.cRegEndDate) {

        }
        else {
            NSString *year = [NSDate getYear_Month_DayByDate:_brContract.cRegBeginDate];
            NSString *start = [NSDate getHour_MinuteByDate:_brContract.cRegBeginDate];
            NSString *end = [NSDate getHour_MinuteByDate:_brContract.cRegEndDate];
            NSString *time = [NSString stringWithFormat:@"%@ %@-%@",year, start, end];
            [_timeBtn setTitle:time forState:UIControlStateNormal];
        }

        [_phoneBtn setTitle:_brContract.cLinkPhone forState:UIControlStateNormal];
    }
    else if(index == 1) {
        [_addressBtn setTitle:_brContract.servicePoint.address forState:UIControlStateNormal];
        if (!_brContract.servicePoint.startTime || !_brContract.servicePoint.endTime) {

        }
        else {
            NSString *year = [NSDate getYear_Month_DayByDate:_brContract.servicePoint.startTime];
            NSString *start = [NSDate getHour_MinuteByDate:_brContract.servicePoint.startTime];
            NSString *end = [NSDate getHour_MinuteByDate:_brContract.servicePoint.endTime];
            NSString *time = [NSString stringWithFormat:@"%@ %@-%@",year, start, end];
            [_timeBtn setTitle:time forState:UIControlStateNormal];
        }
        [_phoneBtn setTitle:_brContract.servicePoint.leaderPhone forState:UIControlStateNormal];
    }

    [_phoneBtn setTitle:@"测试" forState:UIControlStateNormal];
}
@end
