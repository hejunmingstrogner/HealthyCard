//
//  HCNetworkReachability.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//
#import "HCNetworkReachability.h"

#import <AFNetworking.h>


@implementation HCNetworkReachability
{
//    BOOL                            _isReachable;
//    AFNetworkReachabilityManager    *_manager;
}

#pragma mark - Public Methods
+(instancetype)getInstance
{
    static HCNetworkReachability* sharedHCNetworkReachability = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedHCNetworkReachability = [[HCNetworkReachability alloc] init];
    });
    return sharedHCNetworkReachability;
}


#pragma mark - Life Circle
-(id)init{
    if (self = [super init]){
//        _manager = [AFNetworkReachabilityManager managerForDomain:@"http://www.baidu.com"];
//        [_manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//            NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
//            _isReachable = status > 0;
//        }];
//        [_manager startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}


#pragma mark - Public Methods
-(BOOL)isReachable{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

@end
