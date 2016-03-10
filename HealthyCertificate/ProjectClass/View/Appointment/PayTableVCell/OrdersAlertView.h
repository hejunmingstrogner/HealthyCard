//
//  OrdersAlertView.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/10.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  订单预约成功的提示
 */
@interface OrdersAlertView : UIView

typedef void(^clickedBlock)(NSInteger flag);

@property (nonatomic, strong)clickedBlock resultBlock;

- (instancetype)initWithFrame:(CGRect)frame;

+ (instancetype)getinstance;

/**
 *  开启预约成功 线上支付提示  -1 关闭窗口  0 否  1 是
 *
 *  @param controller 需要显示的controller
 *  @param title      标题头
 *  @param warmtitle  提示信息
 *  @param message    提示信息具体内容
 *  @param block      选择后的回调 flag ＝ -1：关闭窗口  0：否  1：是
 */
- (void)openWithSuperView:(UIView *)superView Title:(NSString *)title  warming:(NSString *)warmtitle Message:(NSString *)message withHandle:(clickedBlock)block;

@end
