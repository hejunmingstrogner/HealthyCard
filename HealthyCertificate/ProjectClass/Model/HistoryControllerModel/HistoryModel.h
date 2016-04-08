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
#import "BaseTBCellItem.h"

typedef NS_ENUM(NSInteger, HISTORY_TYPE){
    HISTORY_TYPE_NONE = 0,
    HISTORY_PERSONAL_UNFINISHED,        // 个人未完成
    HISTORY_PERSONAL_FINISHED,          // 个人已完成

    HISTORY_UNIT_UNFINISHED,            // 单位未完成
    HISTORY_UNIT_FINISHED               // 单位已完成
};


@interface HistoryModel : NSObject

@property (nonatomic, assign) HISTORY_TYPE  type;       // 类型

@property (nonatomic, assign) NSInteger    rows;       // 行数

#pragma mark -个人
@property (nonatomic, strong) CustomerTest *customer;   // 个人

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

#pragma mark - 单位
@property (nonatomic, strong) BRContract   *brContract; // 单位合同

@property (nonatomic, strong) NSArray      *itemArray;      // 包含三个元素 单位名称 单位时间 单位地址

@property (nonatomic, strong) BaseTBCellItem *unitNames;   // 单位名称
@property (nonatomic, strong) BaseTBCellItem *checkAddress; // 单位时间
@property (nonatomic, strong) BaseTBCellItem *checktimes;   // 单位地址

/**
 *  单位合同初始化模型
 *
 *  @param brcontract brcontract
 *  @param name       单位名称
 *  @param address    体检时间
 *  @param times      体检地址
 *  @param type       体检类型
 *  @param rows       行数
 *
 *  @return 
 */
- (instancetype)initWithBrContract:(BRContract *)brcontract names:(BaseTBCellItem *)name address:(BaseTBCellItem *)address time:(BaseTBCellItem *)times type:(HISTORY_TYPE)type rows:(NSInteger)rows;
@end
