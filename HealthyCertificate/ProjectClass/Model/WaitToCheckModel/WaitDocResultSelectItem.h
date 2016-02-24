//
//  WaitDocResultSelectItem.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaitDocResultSelectItem : NSObject

@property (nonatomic, strong) NSString *proDetail;
@property (nonatomic, strong) NSString *countAndTime;
@property (nonatomic, strong) NSString *status;

- (instancetype)initWithProjectDetail:(NSString *)detail countAndTime:(NSString *)countTime status:(NSString *)status;

@end
