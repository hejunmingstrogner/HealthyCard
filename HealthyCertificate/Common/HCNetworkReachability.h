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

//针对RealReachability 进行的二次封装

+(instancetype)getInstance;

- (ReachabilityStatus)getCurrentReachabilityState;

@end
