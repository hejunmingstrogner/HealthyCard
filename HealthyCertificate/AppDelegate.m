//
//  AppDelegate.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/14.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "AppDelegate.h"

#import <Pingpp.h>

#import "UIFont+Custom.h"
#include "HMNetworkEngine.h"

#import "RzAlertView.h"
#import "QueueServerInfo.h"
#import "LauchScreenController.h"

#import "HCNetworkReachability.h"

#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"

#define bugTagsAppKey @"64cb2c33df5bab3d36ac0ea1ff907adf"
#define BaiDuAppKey @"cRqr5CbUVzB2GkCbYXWXZXp8"


@interface AppDelegate ()<HMNetworkEngineDelegate>

@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:( NSDictionary *)launchOptions{
    [HCNetworkReachability getInstance];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:20/255.0 green:20/255.0 blue:30/255.0 alpha:1], NSForegroundColorAttributeName, [UIFont fontWithType:UIFontOpenSansRegular size:17], NSFontAttributeName, nil]];

    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BaiDuAppKey generalDelegate:nil];
    if (!ret) {
        NSLog(@"百度地图使用错误");
    }
    // ping ++ debug log
    [Pingpp setDebugMode:YES];
    
    [UMSocialData setAppKey:@"56e22bbd67e58e71f9000e8b"];
    [UMSocialQQHandler setQQWithAppId:@"1105172405" appKey:@"Fe18WR9AciIlUZBP" url:@"http://www.zeekkeji.com/"];
    [UMSocialWechatHandler setWXAppId:@"wx8b40ee373b8d6864" appSecret:@"55325d44ba360016ca90d9a7c24b11b4" url:@"http://www.zeekkeji.com/"];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];   
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }

}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0    // 当前支持的sdk版本是否低于8.0
　// ios 8及以下
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation
{
    return [Pingpp handleOpenURL:url withCompletion:nil];
}
#else
// ios 9以上
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    return [Pingpp handleOpenURL:url withCompletion:nil];
}

#endif

@end
