//
//  HttpNetworkManager.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//http请求后，解析的数据格式的获取采用block的形式来获取
typedef void (^HCDictionaryResultBlock)(NSDictionary* result, NSError* error);

@interface HttpNetworkManager : NSObject

+(instancetype)getInstance;

+ (NSString *)baseURL;
//执行的http请求

/**
 *  电话号码验证
 *
 *  @param phoneNum 电话号码
 */
-(void)verifyPhoneNumber:(NSString*)phoneNum resultBlock:(HCDictionaryResultBlock)resultBlock;


/**
 *  根据当前位置查询服务点信息
 *
 *  @param location 当前查询位置
 *  @param block    获得服务点信息之后的回调
 */
- (void)getNearbyServicePointsWithCLLocation:(CLLocationCoordinate2D)location resultBlock:(void(^)(NSArray *servicePointList, NSError *error))block;

@end
