//
//  HealthyCertificateOrderInfoView.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RzAlertView.h"
#import "BRContract.h"
#import "NSDate+Custom.h"
#import "CustomerTest.h"

@interface HealthyCertificateOrderInfoView : UIView

@property (nonatomic, strong) UISegmentedControl *segmentControl;

@property (nonatomic, strong) NSArray *titleArray;  // 标题数组
@property (nonatomic, strong) CustomButton *addressBtn;
@property (nonatomic, strong) CustomButton *timeBtn;
@property (nonatomic, strong) CustomButton *phoneBtn;

@property (nonatomic, strong) BRContract   *brContract;

@property (nonatomic, strong) CustomerTest *cutomerTest;

- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame WithTitles:(NSArray *)titleArray;

- (instancetype)init;

- (void)setCutomerTest:(CustomerTest *)cutomerTest;

- (void)setBrContract:(BRContract *)brContract;

@end
