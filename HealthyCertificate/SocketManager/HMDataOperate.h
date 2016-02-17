//
//  HMDataOperate.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/14.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BasePacket.h"

@interface HMDataOperate : NSObject

+(instancetype)getInstance;

#pragma mark - 为发送到代理服务器的包添加包头信息
/**
 *  add proxy layer to packet and convert it to NSData
 *
 *  @param packet the source packet
 *  @param data   the result NSData
 */
-(void)addProxyLayerWith:(BasePacket*) packet To:(NSMutableData*)data;


#pragma mark - 为发送到排队服务器的包添加包头信息
/**
 *  add queue layer to packet and convert it to NSData
 *
 *  @param packet the source packet
 *  @param data   the result NSData
 */
-(void)addQueueLayerWith:(BasePacket*) packet To:(NSMutableData*)data;

#pragma mark - read tools

-(Byte)readByte:(NSData*)data Index:(NSInteger*)index;

-(short)readShort:(NSData*)data Index:(NSInteger*)index;

-(int)readInt:(NSData*)data Index:(NSInteger*)index;

-(NSString*)read256String:(NSData *)data Index:(NSInteger*)index;

-(NSString *)readString:(NSData *)data range:(NSRange)range;

-(NSString *)readShortString:(NSData*)data Index:(NSInteger*)index;

-(NSDate*)readDate:(NSData*)data Index:(NSInteger*)index;

-(Boolean)readBoolean:(NSData*)data Index:(NSInteger *)index;

-(float)readFloat:(NSData*)data Index:(NSInteger*)index;

#pragma mark - write tools

-(void)writeByte:(Byte)value To:(NSMutableData*)data;

-(void)writeShort:(short)value To:(NSMutableData*) data;

-(void)writeInt:(int)value To:(NSMutableData*)data;

-(void)write256String:(NSString*)value To:(NSMutableData*)data;

-(void)writeShortString:(NSString*)value To:(NSMutableData*)data;

-(void)writeString:(NSString*)value To:(NSMutableData*)data;

-(void)writeDate:(NSDate*)value To:(NSMutableData*)data;

-(void)writeBoolean:(Boolean)value To:(NSMutableData*)data;

-(void)writeFloat:(float)value To:(NSMutableData*)data;

@end
