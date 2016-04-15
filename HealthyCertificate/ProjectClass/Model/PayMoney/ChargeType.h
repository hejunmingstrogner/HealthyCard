//
//  ChargeType.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/10.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ChargeType : NSObject

typedef NS_ENUM(NSInteger, chargetype) {
    NONE = -1,                  //
    NULLNONE = 0,               //
    CUSTOMER = 1,               //个人支付
    CUSTOMERTEST = 2,           //个人体检支付
    BRCONTRACT = 3,             //合同支付
    WeixinQRCode = 4,           //微信扫码支付
    BatchCharge                 //批量支付
};


@property (nonatomic, assign) NSInteger value;

@end
