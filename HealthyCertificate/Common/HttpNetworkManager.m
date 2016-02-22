//
//  HttpNetworkManager.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "HttpNetworkManager.h"
#import <AFNetworking.h>
#import "ServersPositionAnnotionsModel.h"
#import <MJExtension.h>
#import "PositionUtil.h"

@interface HttpNetworkManager()

@property (nonatomic, strong) AFHTTPRequestOperationManager* manager;

@property (nonatomic, strong) AFHTTPRequestOperationManager *sharedClient;

@end

static NSString * const AFHTTPRequestOperationBaseURLString = @"http://zkwebservice.witaction.com:808/zkwebservice/webservice/";

@implementation HttpNetworkManager


#pragma mark - setter & getter
-(AFHTTPRequestOperationManager*)manager
{
    if (_manager == nil)
    {
        _manager = [[AFHTTPRequestOperationManager alloc] init];
        //_manager.requestSerializer = [NSSet setWithArray:@[@"text/plain",@"text/html",@"text/json"]];
        _manager.requestSerializer=[AFJSONRequestSerializer serializer];
        //_manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/plain",@"text/html",@"text/json"]];
    }
    return _manager;
}

#pragma mark - setter &getter
-(AFHTTPRequestOperationManager *)sharedClient
{
    if (_sharedClient == nil) {
        _sharedClient = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:AFHTTPRequestOperationBaseURLString]];
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return _sharedClient;
}

#pragma mark - baseURL
+ (NSString *)baseURL
{
    return AFHTTPRequestOperationBaseURLString;
}

#pragma mark - Public Methods
+(instancetype)getInstance{
    static HttpNetworkManager* sharedNetworkHttpManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedNetworkHttpManager = [[HttpNetworkManager alloc] init];
    });
    return sharedNetworkHttpManager;
}


#pragma mark - Public Methods
-(void)verifyPhoneNumber:(NSString*)phoneNum resultBlock:(HCDictionaryResultBlock)resultBlock;
{
    NSString *url = [NSString stringWithFormat:@"http://lt.witaction.com:8080/uuc/servlet/login?phone_num=%@&type=auth_code&debug=true",phoneNum];//false
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        resultBlock(responseObject,nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        resultBlock(nil,error);
    }];
}

#pragma mark - 获得当前位置服务点信息
- (void)getNearbyServicePointsWithCLLocation:(CLLocationCoordinate2D)location resultBlock:(void (^)(NSArray *, NSError *))block
{
    NSLog(@"%lf,  %lf", location.longitude, location.latitude);
    NSString *url = [NSString stringWithFormat:@"servicePoint/findByPosition?longitude=%lf&latitude=%lf&tolerance=0.05", location.longitude, location.latitude];
    [self.sharedClient GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableArray *servicePositionsArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in responseObject) {
            ServersPositionAnnotionsModel *servicePosition = [ServersPositionAnnotionsModel mj_objectWithKeyValues:dict];

            // 将gps坐标转换为百度坐标
            PositionUtil *posit = [[PositionUtil alloc]init];
            CLLocationCoordinate2D coor = [posit wgs2bd:servicePosition.positionLa lon:servicePosition.positionLo];
            // 覆盖原先的位置
            servicePosition.positionLa = coor.latitude;
            servicePosition.positionLo = coor.longitude;
            
            [servicePositionsArray addObject:servicePosition];
        }
        if (block) {
            block(servicePositionsArray, nil);
        }

    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (block) {
            block(nil, error);
        }
    }];
}
@end
