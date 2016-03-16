//
//  LauchScreenController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/9.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "LauchScreenController.h"

#import <Masonry.h>

#import "Constants.h"
#import "HMNetworkEngine.h"
#import "HttpNetworkManager.h"
#import "RzAlertView.h"

#import "QueueServerInfo.h"
#import "LoginController.h"
#import "IndexViewController.h"

#import "NSDate+Custom.h"



@interface LauchScreenController()<HMNetworkEngineDelegate>
{
    LoginController     *_loginViewController;
    IndexViewController *_indexViewController;
}

@end


@implementation LauchScreenController


#pragma mark - Life Circle
-(void)viewDidLoad{
    [super viewDidLoad];
    
    UIImageView* bckImageView = [[UIImageView alloc] init];
    bckImageView.image = [UIImage imageNamed:@"hclaunchscreen"];
    [self.view addSubview:bckImageView];
    [bckImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];

    [[HMNetworkEngine getInstance] startControl];
    [HMNetworkEngine getInstance].delegate = self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


#pragma mark - HMNetworkEngine Delegate
-(void)setUpControlSucceed{
    [[HMNetworkEngine getInstance] queryServerList];
}


-(void)setUpControlFailed{
    //to do连接socket服务器即代理服务器失败
    dispatch_async(dispatch_get_main_queue(), ^{
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"网络连接错误，请检查网络设置" removeDelay:3];
    });
}

-(void)queueServerListResult:(NSData *)data Index:(NSInteger *)index{
    NSString* listString =  [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(*index, data.length-*index)] encoding:NSUTF8StringEncoding];
    //return format tijian-510100-ZXQueueServer1,武汉国药阳光体检中心,描述:知名体检中心;tijian-510100-ZXQueueServer1,武汉国药阳光体检中心,描述:知名体检中心
    NSArray *array = [listString componentsSeparatedByString:@";"];
    
    //返回的数据按理应该是一个，所以如果不为空，只取第一条数据
    if (array.count != 0){
        if ([array[0] isEqualToString:@""])
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"远端服务器关闭" removeDelay:2];
        
        QueueServerInfo* info = [[QueueServerInfo alloc] initWithString:array[0]];
        [HMNetworkEngine getInstance].serverID = info.serverID;
        //这里才代表连接上了中心控制服务器
        dispatch_async(dispatch_get_main_queue(), ^{

            if ( GetUuid != nil && ![GetUuid isEqualToString:@""]){
                //如果保存有Uuid 判断是否过期
                
                if ([GetLastLoginTime longLongValue] + [GetUuidTimeOut longLongValue] < [[NSDate date] convertToLongLong]){
                    //uuid过期
                    [self loadLoginViewController];
                    return;
                }else{
                    [[HttpNetworkManager getInstance] loginWithUuid:GetUuid UuidTimeOut:GetUuidTimeOut resultBlock:^(NSDictionary *result, NSError *error) {
                        if (error != nil){
                            //to do
                            [self loadLoginViewController];
                            return;
                        }
                        
                        if ([[result objectForKey:@"code"] integerValue] != 0){
                            //to do uuid登录失败
                            [self loadLoginViewController];
                            return;
                        }
                      
                        NSDictionary* dataDic = [result objectForKey:@"data"];
                        if (dataDic[@"code"] != 0){
                            //to do
                        }else{
                            //暂时先将socket的连接操作放在这里
                            [[HMNetworkEngine getInstance] askLoginInfo:GetPhoneNumber];
                        }
                    }];
                }
            }else{
                [self loadLoginViewController];
            }
        });
    }
}

-(void)getLoginInfoSucceed{
    //因为现在是异步队列，所以不能在该函数里面操作ui线程
    dispatch_async(dispatch_get_main_queue(), ^{
        _indexViewController = [[IndexViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_indexViewController];
        [self presentViewController:nav animated:YES completion:nil];
    });
}


-(void)loadLoginViewController
{
    _loginViewController = [[LoginController alloc] init];
    [self presentViewController:_loginViewController animated:NO completion:nil];
}

@end
