//
//  BRContract.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "BRContract.h"

@implementation BRContract

- (instancetype)init {
    if (self = [super init]) {
        _regCheckNum = -1;
        _factCheckNum = -1;
        _regPosLO = -1;
        _regPosLA = -1;
    }
    return self;
}

@end
