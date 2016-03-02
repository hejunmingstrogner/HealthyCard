//
//  WorkTypeInfoModel.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/1.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

//行业信息
@interface WorkTypeInfoModel : NSObject

//编号
@property (nonatomic, copy) NSString* id;

//名称
@property (nonatomic, copy) NSString* name;

//数据类型
@property (nonatomic, copy) NSString* dataItemName;

//次序
@property (nonatomic, assign) int sortOrder;

//描述
@property (nonatomic, readwrite) NSString* description;

@end
