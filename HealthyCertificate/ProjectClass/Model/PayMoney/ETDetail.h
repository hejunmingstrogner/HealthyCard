//
//  ETDetail.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/4/14.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  支付明细
 */
@interface ETDetail : NSObject

//支付成功状态
@property (nonatomic, assign) char PAY_STATUS_SUCCESS;

//等待支付状态
@property (nonatomic, assign) char PAY_STATUS_WATING;

//我们生成的交易号
@property (nonatomic, copy) NSString* applyTranSN;

//第三方返回的订单号
@property (nonatomic, copy) NSString* elecTranSN;

//宿主号
@property (nonatomic, copy) NSString* hostCode;

//宿主类型  1-个人支付 2-个人体检支付 3-合同支付 4-微信扫码支付 5-批量支付
@property (nonatomic, assign) Byte hostType;

//支付金额(元)
@property (nonatomic, assign) float payMoney;

@end
