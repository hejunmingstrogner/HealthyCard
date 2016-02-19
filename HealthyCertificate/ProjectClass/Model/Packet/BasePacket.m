//
//  BasePacket.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "BasePacket.h"

@implementation BasePacket

#pragma mark - Public Methods

-(void)writeData:(NSData *)data{
}

-(NSMutableData*)readData{
    NSMutableData* data = [[NSMutableData alloc] init];
    return data;
}

-(void)writeData:(NSData*)data Index:(NSInteger*)index
{}

@end

