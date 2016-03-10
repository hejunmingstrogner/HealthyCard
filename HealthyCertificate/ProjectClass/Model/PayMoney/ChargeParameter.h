//
//  ChargeParameter.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/10.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChargeParameter : NSObject

/**
 * 商户订单号，适配每个渠道对此参数的要求，必须在商户系统内唯一。(alipay: 1-64 位， wx: 1-32 位，bfb: 1-20 位，upacp: 8-40 位，yeepay_wap:1-50 位，jdpay_wap:1-30 位，cnp_u:8-20
 * 位，cnp_f:8-20 位，推荐使用 8-20 位，要求数字或字母，不允许特殊字符)。
 *
 * <p>
 * 客户端生成时不传。
 * </p>
 */
@property (nonatomic, copy) NSString *order_no;

/**
 * 支付使用的 app 对象的 id，请登陆管理平台查看。
 */
@property (nonatomic, copy) NSString *appId;

/**
 * 订单总金额, 单位为对应币种的最小货币单位，例如：人民币为分（如订单总金额为 1 元，此处请填 100）。
 */
@property (nonatomic, assign) int amount;

/**
 * 支付渠道。
 */
@property (nonatomic, copy) NSString * channel;

/**
 * 客户端IP。
 * <p>
 * 客户端生成时不传。
 * </p>
 */
@property (nonatomic, copy) NSString * client_ip;

/**
 * 三位 ISO 货币代码，目前仅支持人民币 cny。
 */
@property (nonatomic, copy) NSString * currency;
/**
 * 商品的标题，该参数最长为 32 个 Unicode 字符，银联全渠道（upacp/upacp_wap）限制在 32 个字节。
 */
@property (nonatomic, copy) NSString * subject;

/**
 * 商品的描述信息，该参数最长为 128 个 Unicode 字符，yeepay_wap 对于该参数长度限制为 100 个 Unicode 字符。
 */
@property (nonatomic, copy) NSString * body;

/**
 * 特定渠道发起交易时需要的额外参数以及部分渠道支付成功返回的额外参数。
 */
@property (nonatomic, copy) NSString * extra;

/**
 * 订单附加说明，最多 255 个 Unicode 字符。
 */
@property (nonatomic, copy) NSString * _description;

/**
 * 关联的业务对象。 支付成功后，涉及后续处理。
 */
//@property (nonatomic, copy) ChargeBusinessObj businessObj;
- (instancetype)init;

@end
