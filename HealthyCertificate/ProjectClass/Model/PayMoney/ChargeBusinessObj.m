//
//  ChargeBusinessObj.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/10.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ChargeBusinessObj.h"
/**
 * 支付关联的业务对象。
 *
 * @author liuyixin
 *
 */
@implementation ChargeBusinessObj

- (void)setEnumType:(chargetype)enumType
{
    _enumType = enumType;
    switch (_enumType) {
        case NONE:
        {
            _type = @"NONE";
            break;
        }
        case CUSTOMER:
        {
            _type = @"Customer";
            break;
        }case CUSTOMERTEST:
        {
            _type = @"CustomerTest";
            break;
        }case BRCONTRACT:
        {
            _type = @"Brcontract";
            break;
        }
        default:
        break;
    }
}

@end
