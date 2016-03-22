//
//  PayMoneyController.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/8.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChargeType.h"
@protocol PayMoneyDelegate <NSObject>
/**
 *  支付成功
 */
- (void)payMoneySuccessed;
/**
 *  支付取消
 */
- (void)payMoneyCencel;
/**
 *  支付失败
 */
- (void)payMoneyFail;

@end

@interface PayMoneyController : UIViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton    *comfirmBtn;
@property (nonatomic, strong) NSString    *money;
#warning -下面类型在初始化时必须填写
@property (nonatomic, strong) NSString *checkCode;      // 体检编号
@property (nonatomic, assign) chargetype chargetype;    // 用户类型
@property (nonatomic, strong) NSString *cityName;       // 城市编号，用于获取体检费用
@property (nonatomic, strong) id<PayMoneyDelegate>delegate;

@end
