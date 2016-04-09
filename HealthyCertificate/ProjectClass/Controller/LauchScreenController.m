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

#import <SDWebImageDownloader.h>
#import <SDWebImageManager.h>
#import <MJExtension.h>

@interface LauchScreenController()
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
    
    [self login];
}

#pragma mark - Private Methods
-(void)login{
    if (GetUserName != nil && ![GetUserName isEqualToString:@""]){
        [[HttpNetworkManager getInstance] loginWithToken:GetToken userName:GetUserName resultBlock:^(NSDictionary *result, NSError *error) {
            if (error != nil)
            {
                [self loadLoginViewController];
                return;
            }
            
            if ([[result objectForKey:@"ProResult"] isEqualToString:@"0"]){
                SetUserRole([[result objectForKey:@"Msg"] objectForKey:@"userRole"]);
                SetToken([[result objectForKey:@"Msg"] objectForKey:@"newToken"]);
                
                [[HttpNetworkManager getInstance].sharedClient.requestSerializer setValue:GetUserName forHTTPHeaderField:@"DBKE-UserName"];
                [[HttpNetworkManager getInstance].sharedClient.requestSerializer setValue:@"zeekcustomerapp" forHTTPHeaderField:@"DBKE-ClientType"];
                [[HttpNetworkManager getInstance].sharedClient.requestSerializer setValue:GetToken forHTTPHeaderField:@"DBKE-Token"];
                
                SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
                [manager setValue:GetUserName forHTTPHeaderField:@"DBKE-UserName"];
                [manager setValue:@"zeekcustomerapp" forHTTPHeaderField:@"DBKE-ClientType"];
                [manager setValue:GetToken forHTTPHeaderField:@"DBKE-Token"];
                
                [self getLoginInfo];
            }else{
                [self loadLoginViewController];
            }
        }];
    }else{
        [self loadLoginViewController];
    }
}

-(void)getLoginInfo{
    //http://zkwebserver.witaction.com:8080/webserver/webservice/userInfo/findUserInfoByPhone?mobilePhone=18080961548
    [[HttpNetworkManager getInstance] findUserInfoByPhone:GetUserName resultBlock:^(NSDictionary *result, NSError *error) {
        if (error || result == nil){
            SetUserName(@"");
            SetToken(@"");
            SetUserRole(@"");
            [self loadLoginViewController];
            return;
        }
        NSDictionary* unitInfo = [result objectForKey:@"unitInfo"];
        gUnitInfo = [BRServiceUnit mj_objectWithKeyValues:unitInfo];
        
        NSDictionary* personalInfo = [result objectForKey:@"customer"];
        gCustomer = [Customer mj_objectWithKeyValues:personalInfo];
        
         [self getLoginInfoSucceed];
    }];
}


-(void)getLoginInfoSucceed
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _indexViewController = [[IndexViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_indexViewController];
        [self presentViewController:nav animated:YES completion:nil];

    });
}


-(void)loadLoginViewController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        LoginController* loginViewController = [[LoginController alloc] init];
        [self presentViewController:loginViewController animated:NO completion:nil];

    });
}

@end
