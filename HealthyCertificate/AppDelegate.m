//
//  AppDelegate.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/14.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "AppDelegate.h"

#include "HMNetworkEngine.h"
#import "QueueServerInfo.h"

#import "UIFont+Custom.h"

#import "LoginController.h"



@interface AppDelegate ()<HMNetworkEngineDelegate>

@end

@implementation AppDelegate


-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:( NSDictionary *)launchOptions{
    
    return YES;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    _mapManager = [[BMKMapManager alloc]init];

    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont fontWithType:UIFontOpenSansRegular size:19], NSFontAttributeName, nil]];

    BOOL ret = [_mapManager start:@"cRqr5CbUVzB2GkCbYXWXZXp8" generalDelegate:nil];
    if (!ret) {
        NSLog(@"百度地图使用错误");
    }
    // Override point for customization after application launch.
    //
   // UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.window = [[UIWindow alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[HMNetworkEngine getInstance] startControl];
    [HMNetworkEngine getInstance].delegate = self;
    
//    [NSThread sleepForTimeInterval:3.0];
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

#pragma mark - HMNetworkEngine Delegate
-(void)setUpControlSucceed{
    [[HMNetworkEngine getInstance] queryServerList];
}


-(void)setUpControlFailed{
    //to do连接socket服务器即代理服务器失败
}

-(void)queueServerListResult:(NSData *)data Index:(NSInteger *)index{
    NSString* listString =  [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(*index, data.length-*index)] encoding:NSUTF8StringEncoding];
    //return format tijian-510100-ZXQueueServer1,武汉国药阳光体检中心,描述:知名体检中心;tijian-510100-ZXQueueServer1,武汉国药阳光体检中心,描述:知名体检中心
    NSArray *array = [listString componentsSeparatedByString:@";"];
    
    //返回的数据按理应该是一个，所以如果不为空，只取第一条数据
    if (array.count != 0){
        QueueServerInfo* info = [[QueueServerInfo alloc] initWithString:array[0]];
        [HMNetworkEngine getInstance].serverID = info.serverID;
        //这里才代表连接上了中心控制服务器
        dispatch_async(dispatch_get_main_queue(), ^{
            // [self performSegueWithIdentifier:@"LoginIdentifier" sender:self];
            LoginController *loginViewController = [[LoginController alloc] init];
            //self.window = [[UIWindow alloc] init];
            self.window.rootViewController = loginViewController;
            [self.window makeKeyAndVisible];
        });
        
    }
}

@end
