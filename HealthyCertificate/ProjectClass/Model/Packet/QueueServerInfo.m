//
//  QueueServerInfo.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "QueueServerInfo.h"

@implementation QueueServerInfo
//eg : tijian-510100-ZXQueueServer1,武汉国药阳光体检中心,描述:知名体检中心
-(instancetype)initWithString:(NSString*)stringInfo{
    if (self = [super init]){
        
        NSArray* detailArray = [stringInfo componentsSeparatedByString:@","];
        
        self.serverID = detailArray[0];
        
        NSArray* detainInfoArray = [detailArray[0] componentsSeparatedByString:@"-"];
        self.type = detainInfoArray[0];
        self.areaCode = detainInfoArray[1];
        
        self.serverName = detailArray[1];
        self.descriptionInfo = ([detailArray[2] componentsSeparatedByString:@":"])[1];
    }
    return self;
}



@end
