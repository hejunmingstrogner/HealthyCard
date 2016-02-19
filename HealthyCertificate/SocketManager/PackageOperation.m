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
#import "HMNetworkEngine.h"

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

-(short)innerLayerProtocol:(NSData*)data Index:(NSInteger*)index{
    return [[HMDataOperate getInstance] readShort:data Index:index];
}

#pragma mark - 为发送到代理服务器的包添加包头信息
-(void)addProxyLayerWith:(BasePacket*) packet To:(NSMutableData*)data
{
    [[HMDataOperate getInstance] writeInt:PACKAGE_LENGTH + (int)[packet readData].length To:data];
    [data appendData:[packet readData]];
}

#pragma mark - 为发送到排队服务器的包添加包头信息
//发送的协议格式为  包长度 + 外层协议(2) + server名称 + ip + 包长度 + 内层协议 + 具体内容
-(void)addQueueLayerWith:(BasePacket*) packet To:(NSMutableData*)data
{
    NSMutableData* internalData = [[NSMutableData alloc] init];
    [self addProxyLayerWith:packet To:internalData];
    
    [DataOperate writeInt:(int)(PACKAGE_LENGTH + SHORT_TYPE_BYTE + [[HMNetworkEngine getInstance].serverID get256StingLength] + SHORT_TYPE_BYTE + internalData.length) To:data];
    [DataOperate writeShort:SERVER_PROXY_SERVER_DATA To:data];
    [DataOperate write256String:[HMNetworkEngine getInstance].serverID To:data];
    [DataOperate writeShortString:@"" To:data];
    [data appendData:internalData];
}

-(void)getPersonInfo:(PersonInfoOfPhonePacket*)personInfo
         CompanyInfo:(CompanyInfoOfPhonePacket*)companyInfo
               Index:(NSInteger*)index
                From:(NSData*)data
{
    [personInfo writeData:data Index:index];
    [[HMDataOperate getInstance] readInt:data Index:index];
    [[HMDataOperate getInstance] readShort:data Index:index];
    [companyInfo writeData:data Index:index];
}

#pragma mark - Private Methods


@end
