//
//  HMNetworkEngine.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/14.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol HMNetworkEngineDelegate <NSObject>

@optional
-(void)setUpControlSucceed;
-(void)setUpControlFailed;

@end

@interface HMNetworkEngine : NSObject

+(instancetype)getInstance;


/**
 *  setup the socket, connect to server
 */
-(void)startControl;

/**
 *  查询得到服务机构列表（只有一个）
 */
-(void)queryServerList;

@end
