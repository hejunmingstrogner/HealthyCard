//
//  HMDataOperate.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/14.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "HMDataOperate.h"

#import "Constants.h"

@implementation HMDataOperate

#pragma mark - 为发送到代理服务器的包添加包头信息
-(void)addProxyLayerWith:(BasePacket*) packet To:(NSMutableData*)data
{
    [[HMDataOperate getInstance] writeInt:PACKAGE_LENGTH + (int)[packet readData].length To:data];
    [data appendData:[packet readData]];
}


#pragma mark - 为发送到排队服务器的包添加包头信息
-(void)addQueueLayerWith:(BasePacket*) packet To:(NSMutableData*)data
{}


+(instancetype)getInstance{
    static HMDataOperate* nsDataOperateInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        nsDataOperateInstance = [[self alloc] init];
    });
    return nsDataOperateInstance;
}

#pragma mark - read tool

-(Byte)readByte:(NSData *)data Index:(NSInteger*)index{
    Byte byte;
    [data getBytes:&byte range:NSMakeRange(*index, BYTE_TYPE_BYTE)];
    (*index) += BYTE_TYPE_BYTE;
    return byte;
}

-(short)readShort:(NSData*)data Index:(NSInteger*)index{
    short shortSmall;
    [data getBytes:&shortSmall range:NSMakeRange(*index, SHORT_TYPE_BYTE)];
    (*index) += SHORT_TYPE_BYTE;
    return NSSwapHostShortToBig(shortSmall);
}

-(int)readInt:(NSData*)data Index:(NSInteger*)index{
    int intSmall;
    [data getBytes:&intSmall range:NSMakeRange(*index, INT_TYPE_BYTE)];
    (*index) += INT_TYPE_BYTE;
    return NSSwapHostIntToBig(intSmall);
}

-(NSString*)read256String:(NSData *)data Index:(NSInteger*)index{
    NSString* resultStr = @"";
    Byte length = [self readByte:data Index:index];
    if (length != 0){
        resultStr = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(*index, length)] encoding:NSUTF8StringEncoding];
        (*index) += length;
    }
    return resultStr;
}

-(NSString *)readString:(NSData *)data range:(NSRange)range{
    return [[NSString alloc] initWithData:[data subdataWithRange:range] encoding:NSUTF8StringEncoding];
}

-(NSString *)readShortString:(NSData*)data Index:(NSInteger*)index{
    NSString* resultStr = @"";
    NSInteger length = [self readShort:data Index:index];
    if (length != 0){
        resultStr = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(*index, length)] encoding:NSUTF8StringEncoding];
        (*index) += length;
    }
    return resultStr;
}

-(NSDate*)readDate:(NSData *)data Index:(NSInteger *)index{
    long timeT;
    [data getBytes:&timeT range:NSMakeRange(*index, LONG_TYPE_BYTE)];
    timeT = NSSwapHostLongToBig(timeT);
    (*index) += LONG_TYPE_BYTE;
    return [[NSDate alloc] initWithTimeIntervalSince1970:timeT/1000];
}

-(Boolean)readBoolean:(NSData*)data Index:(NSInteger *)index{
    Byte result = [self readByte:data Index:index];
    return result == 0 ? NO : YES;
}

-(float)readFloat:(NSData *)data Index:(NSInteger *)index{
    float result;
    [data getBytes:&result range:NSMakeRange(*index, sizeof(float))];
    (*index) += sizeof(float);
    return NSConvertSwappedFloatToHost(NSSwapHostFloatToBig(result));
}

#pragma mark - wirte tool
-(void)write256String:(NSString*)value To:(NSMutableData*)data{
    Byte length = value.length;
    [data appendBytes:&length length:BYTE_TYPE_BYTE];
    [data appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void)writeShortString:(NSString*)value To:(NSMutableData*)data{
    short length = value.length;
    [data appendBytes:&length length:SHORT_TYPE_BYTE];
    [data appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void)writeString:(NSString*)value To:(NSMutableData*)data{
    [data appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void)writeByte:(Byte)value To:(NSMutableData*)data{
    [data appendBytes:&value length:BYTE_TYPE_BYTE];
}

-(void)writeShort:(short)value To:(NSMutableData*) data{
    short valueBig = NSSwapBigShortToHost(value);
    [data appendBytes:&valueBig length:SHORT_TYPE_BYTE];
}

-(void)writeInt:(int)value To:(NSMutableData*)data{
    int valueBig = NSSwapHostIntToBig(value);
    [data appendBytes:&valueBig length:INT_TYPE_BYTE];
}

-(void)writeDate:(NSDate *)value To:(NSMutableData *)data{
    long time;
    time = value.timeIntervalSince1970 * 1000;
    time = NSSwapHostLongToBig(time);
    [data appendBytes:&time length:LONG_TYPE_BYTE];
}

-(void)writeBoolean:(Boolean)value To:(NSMutableData*)data{
    Byte result = (value == YES)?1:0;
    [self writeByte:result To:data];
}

-(void)writeFloat:(float)value To:(NSMutableData *)data{
    NSSwappedFloat result = NSSwapHostFloatToBig(value);
    [data appendData:[NSData dataWithBytes:&result length:sizeof(NSSwappedFloat)]];
}

@end
