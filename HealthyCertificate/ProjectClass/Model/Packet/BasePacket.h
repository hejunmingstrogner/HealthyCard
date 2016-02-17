//
//  BasePacket.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  the root class of packet
 */

@interface BasePacket : NSObject

@property (nonatomic, assign) short protocalNum;

/**
 *  construct from the data stream
 *
 *  @param data data stream
 */
-(void)writeData:(NSData*)data;


/**
 *  convert to data stream
 *
 *  @return data stream
 */
-(NSMutableData*)readData;

@end
