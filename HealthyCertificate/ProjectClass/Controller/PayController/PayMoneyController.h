//
//  PayMoneyController.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/8.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@property (nonatomic, strong) id<PayMoneyDelegate>delegate;

@end
