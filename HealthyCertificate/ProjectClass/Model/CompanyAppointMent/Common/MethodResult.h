//
//  MethodResult.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/29.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MethodResult : NSObject


@property (nonatomic, assign) BOOL succeed;

@property (nonatomic, copy) NSString* errorMsg;

@property (nonatomic, copy) NSString* object;

@end
