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
    NONE = -1,           //
    NULLNONE = 0,
    CUSTOMER = 1,       //
    CUSTOMERTEST = 2,   // 个人客户预约
    BRCONTRACT = 3     // 单位预约
};


@property (nonatomic, assign) NSInteger value;

@end
