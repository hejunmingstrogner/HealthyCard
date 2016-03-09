//
//  CustomerTest.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CustomerTest.h"

@implementation CustomerTest


-(ServersPositionAnnotionsModel*)servicePoint{
    if (_servicePoint == nil){
        _servicePoint = [[ServersPositionAnnotionsModel alloc] init];
    }
    
    return _servicePoint;
}

@end
