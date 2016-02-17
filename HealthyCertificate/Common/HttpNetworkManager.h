//
//  HttpNetworkManager.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>


//http请求后，解析的数据格式的获取采用block的形式来获取
typedef void (^HCDictionaryResultBlock)(NSDictionary* result, NSError* error);

@interface HttpNetworkManager : NSObject

+(instancetype)getInstance;

//执行的http请求

/**
 *  电话号码验证
 *
 *  @param phoneNum 电话号码
 */
-(void)verifyPhoneNumber:(NSString*)phoneNum resultBlock:(HCDictionaryResultBlock)resultBlock;


@end
