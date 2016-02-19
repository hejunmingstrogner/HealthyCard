//
//  CloudAppointmentDateVC.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CloudAppointmentDateVC.h"

#import "NavView.h"
#import "Constants.h"

#import <Masonry.h>

@implementation CloudAppointmentDateVC


-(void)viewDidLoad{
    [super viewDidLoad];
    
    NavView* navView = [[NavView alloc] init];
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.right.mas_equalTo(self.view);
        make.height.mas_equalTo(kNavigationBarHeight);
    }];
    [navView setNavTitle:@"预约日期选择"];
    
    UILabel* beginDateLabelTitle = [[UILabel alloc] init];
    [self.view addSubview:beginDateLabelTitle];
    [beginDateLabelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(navView.mas_bottom);
        make.height.mas_equalTo(PXFIT_HEIGHT(96));
    }];
    
    UILabel* beginDateLabel = [[UILabel alloc] init];
    [self.view addSubview:beginDateLabel];
    
    
    UILabel* endDateLabelTitle = [[UILabel alloc] init];
    [self.view addSubview:endDateLabelTitle];
    
    UILabel* endDateLabel = [[UILabel alloc] init];
    [self.view addSubview:endDateLabel];
}

@end
