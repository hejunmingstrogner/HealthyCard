//
//  ChargeBusinessObjForBatch.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/4/14.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ChargeBusinessObjForBatch.h"
#import "ChargeType.h"

@implementation ChargeBusinessObjForBatch

-(id)init
{
    if (self = [super init]){
        self.enumType = BatchCharge;
    }
    return self;
}

@end
