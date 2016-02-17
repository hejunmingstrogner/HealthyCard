//
//  PackageOperation.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "PackageOperation.h"
#import "HMDataOperate.h"
#import "Constants.h"

#import "BasePacket.h"
#import "NSString+Count.h"

@implementation PackageOperation

+(instancetype)getInstance{
    static PackageOperation* packageOperationInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        packageOperationInstance = [[self alloc] init];
    });
    return packageOperationInstance;
}



#pragma mark - Public Methods
-(short)outerLayerProtocol:(NSData *)data Index:(NSInteger*)index{
    return [[HMDataOperate getInstance] readShort:data Index:index];
}

#pragma mark - Private Methods


@end
