//
//  PackageOperation.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackageOperation : NSObject

+(instancetype)getInstance;


/**
 *  get the outer layer protocol
 *
 *  @param data receive data
 *
 *  @return the outer layer protocol
 */
-(short)outerLayerProtocol:(NSData*)data Index:(NSInteger*)index;

@end
