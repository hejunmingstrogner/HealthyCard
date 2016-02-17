//
//  QueueServerInfo.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueueServerInfo : NSObject

@property (nonatomic, copy)  NSString* type;
//@property (nonatomic, copy)  NSString* provinceName;
//@property (nonatomic, copy)  NSString* cityName;
//@property (nonatomic, copy)  NSString* districtName;
@property (nonatomic, copy)  NSString* serverID;
@property (nonatomic, copy)  NSString* serverName;
@property (nonatomic, assign)float longitude;
@property (nonatomic, assign)float latitude;

@property (nonatomic, copy)  NSString* descriptionInfo;
@property (nonatomic, copy)  NSString* areaCode;


-(instancetype)initWithString:(NSString*)stringInfo;

@end
