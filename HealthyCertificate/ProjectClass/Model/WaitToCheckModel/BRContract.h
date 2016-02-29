//
//  BRContract.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServersPositionAnnotionsModel.h"
#import "BRServiceUnit.h"

/**
 * 合同类
 *
 * @author hk
 *
 */
@interface BRContract : NSObject

/**
 * 合同编号
 */
@property (nonatomic, strong) NSString * code;
/**
 * 合同名称
 */
@property (nonatomic, strong) NSString * name;
/**
 * 单位编号
 */
@property (nonatomic, strong) NSString * unitCode;
/**
 * 单位名称
 */
@property (nonatomic, strong) NSString * unitName;
/**
 * 说明
 */
@property (nonatomic, strong) NSString * memo;
/**
 * 合同状态
 */
@property (nonatomic, strong) NSString * testStatus;
/**
 * 操作人员编号
 */
@property (nonatomic, strong) NSString * operCode;
/**
 * 操作日期
 */
@property (nonatomic, assign) long long operDate;
/**
 * 付款方式
 */
@property (nonatomic, strong) NSString * payMode;
/**
 * 生成年
 */
@property (nonatomic, strong) NSString * checkYear;
/**
 * 机构编号
 */
@property (nonatomic, strong) NSString * hosCode;
/**
 * 检查人员类型
 */
@property (nonatomic, strong) NSString * checkType;

/**
 * 服务点ID
 */
@property (nonatomic, strong) NSString * checkSiteID;
/**
 * 预约人数
 */
@property (nonatomic, assign) int regCheckNum;
/**
 * 已检人数
 */
@property (nonatomic, assign) int factCheckNum;
/**
 * 预约经度
 */
@property (nonatomic, assign) double regPosLO;
/**
 * 预约纬度
 */
@property (nonatomic, assign) double regPosLA;
/**
 * 预约地址
 */
@property (nonatomic, strong) NSString * regPosAddr;
/**
 * 预约时间
 */
@property (nonatomic, assign) long long regTime;
/**
 * 预约开始时间
 */
@property (nonatomic, assign) long long regBeginDate;
/**
 * 预约结束时间
 */
@property (nonatomic, assign) long long regEndDate;

/**
 * 联系人
 */
@property (nonatomic, strong) NSString * linkUser;
/**
 * 联系电话
 */
@property (nonatomic, strong) NSString * linkPhone;
/**
 * 所属城市。
 */
@property (nonatomic, strong) NSString * cityName;

/**
 * 关联的服务点 【非数据库字段】
 */
@property (nonatomic, strong) ServersPositionAnnotionsModel *servicePoint;

/**
 * 所属的单位。 【非数据库字段】
 */
@property (nonatomic, strong) BRServiceUnit *serviceUnit;

@end
