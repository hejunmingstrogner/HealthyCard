//
//  ChargeBusinessObj.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/10.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChargeType.h"

/**
 *  员工体检单个支付
 */
@interface ChargeBusinessObj : NSObject

@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) chargetype enumType;

@end
