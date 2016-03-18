//
//  ConsumerAgreement.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/18.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ConsumerAgreement.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
@interface ConsumerAgreement()

@end

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@implementation ConsumerAgreement
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initSubviews];
}

- (void)initNavgation
{
    self.title = @"用户协议";
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
}
// 返回前一页
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSubviews
{

}
@end
