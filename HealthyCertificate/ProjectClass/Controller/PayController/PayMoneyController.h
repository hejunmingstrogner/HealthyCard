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

/**
 *  找人代付
 */
- (void)payMoneyByOthers;

@end

@interface PayMoneyController : UIViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton    *comfirmBtn;
@property (nonatomic, strong) NSString    *money;
#warning -下面类型在个人支付 初始化时必须填写
// 个人支付时，需传入此参数
@property (nonatomic, strong) NSString *checkCode;      // 体检编号
@property (nonatomic, assign) chargetype chargetype;    // 用户类型
@property (nonatomic, strong) NSString *cityName;       // 城市编号，用于获取体检费用

@property (nonatomic, strong) id<PayMoneyDelegate>delegate;
#warning -批量支付时，传入当前数组
@property (nonatomic, strong) NSMutableArray *CustomerTestArray;   // 批量支付的用户

@end
