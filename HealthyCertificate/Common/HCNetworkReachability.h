//
//  HCNetworkReachability.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RealReachability.h>

@interface HCNetworkReachability : NSObject

//typedef NS_ENUM(NSInteger, HCNetworkReachabilityStatus) {
//    ///Direct match with Apple networkStatus, just a force type convert.
//    HCNetworkReachabilityStatusNotReachable = 0,
//    HCNetworkReachabilityStatusViaWWAN = 1,
//    HCNetworkReachabilityStatusViaWiFi = 2
//};

+(instancetype)getInstance;

-(BOOL)isReachable;

@end
