//
//  StringPacket.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "StringPacket.h"
#import "Constants.h"
#import "HMDataOperate.h"

@interface StringPacket()
{
    NSString* _dataStr;
    Byte      _protocolType;
}
@end


@implementation StringPacket

-(instancetype)initWith:(NSString *)str Type:(short)type{
    if (self = [super init]){
        _dataStr = str;
        _protocolType = type;
    }
    return self;
}


#pragma mark - Override Methods
-(NSData*)readData{
    NSMutableData* resultData = [[NSMutableData alloc] init];
    [[HMDataOperate getInstance] writeShort:_protocolType To:resultData];
    [[HMDataOperate getInstance] writeString:_dataStr To:resultData];
    return resultData;
}

@end
