//
//  HistoryModel.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/4/7.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerTest.h"
#import "BRContract.h"

typedef NS_ENUM(NSInteger, HISTORY_TYPE){
    HISTORY_TYPE_NONE = 0,
    HISTORY_PERSONAL_UNFINISHED,        // 个人未完成
    HISTORY_PERSONAL_FINISHED,          // 个人已完成

    HISTORY_UNIT_UNFINISHED,            // 单位未完成
    HISTORY_UNIT_FINISHED               // 单位已完成
};


@interface HistoryModel : NSObject

@property (nonatomic, strong) CustomerTest *customer;   // 个人

@property (nonatomic, strong) BRContract   *brContract; // 单位合同

@property (nonatomic, assign) HISTORY_TYPE  type;       // 类型

@property (nonatomic, assign) NSInteger    rows;       // 行数

/**
 *  初始化
 *
 *  @param customer   个人合同的类
 *  @param brcontract 单位合同的类
 *  @param type       类型
 *  @param rows       当前需要显示的行
 *
 *  @return 
 */
- (instancetype)initWithCustomer:(CustomerTest *)customer BRContract:(BRContract *)brcontract type:(HISTORY_TYPE)type rows:(NSInteger)rows;

@end
