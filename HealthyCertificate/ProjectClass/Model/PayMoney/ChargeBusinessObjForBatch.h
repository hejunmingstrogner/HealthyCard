//
//  ChargeBusinessObjForBatch.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/4/14.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ChargeBusinessObj.h"


/**
 *  批量支付
 */
@interface ChargeBusinessObjForBatch : ChargeBusinessObj

//支付明细 存放ETDetail
@property (nonatomic, strong) NSMutableArray* details;

@end
