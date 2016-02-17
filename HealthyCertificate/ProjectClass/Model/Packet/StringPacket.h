//
//  StringPacket.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "BasePacket.h"

@interface StringPacket : BasePacket

/**
 *  initialization
 *
 *  @param str  string
 *  @param type protocol Tye
 *
 *  @return StringPacket
 */
-(instancetype)initWith:(NSString*) str Type:(short)type; //因为StringPacket是通用的包，所以type改为构造函数传入，而不是默认添加协议

@end
