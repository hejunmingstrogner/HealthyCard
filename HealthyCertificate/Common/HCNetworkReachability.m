//
//  HCNetworkReachability.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//
#import "HCNetworkReachability.h"

@interface HCNetworkReachability()
{
    RealReachability* _reachAbility;
}

@end


@implementation HCNetworkReachability

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
        [GLobalRealReachability startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(networkChanged:)
                                                     name:kRealReachabilityChangedNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - Action
- (void)networkChanged:(NSNotification *)notification
{
    _reachAbility = (RealReachability *)notification.object;
}


#pragma mark - Private Methods
- (ReachabilityStatus)getCurrentReachabilityState
{
    //如果断网,马上再检测一下网络状态
    if (_reachAbility.currentReachabilityStatus == 0){
        [GLobalRealReachability stopNotifier];
        [GLobalRealReachability startNotifier];
    }
    return [_reachAbility currentReachabilityStatus];
}

@end
