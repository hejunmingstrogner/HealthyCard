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
@property (nonatomic, strong) NSString * cCode;
/**
 * 合同名称
 */
@property (nonatomic, strong) NSString * cName;
/**
 * 单位编号
 */
@property (nonatomic, strong) NSString * cUnitCode;
/**
 * 单位名称
 */
@property (nonatomic, strong) NSString * cUnitName;
/**
 * 说明
 */
@property (nonatomic, strong) NSString * cMemo;
/**
 * 合同状态
 */
@property (nonatomic, strong) NSString * cStatus;
/**
 * 操作人员编号
 */
@property (nonatomic, strong) NSString * cOperCode;
/**
 * 操作日期
 */
@property (nonatomic, strong) NSDate * dOperDate;
/**
 * 付款方式
 */
@property (nonatomic, strong) NSString * cPayMode;
/**
 * 生成年
 */
@property (nonatomic, strong) NSString * cYear;
/**
 * 机构编号
 */
@property (nonatomic, strong) NSString * cHosCode;
/**
 * 检查人员类型
 */
@property (nonatomic, strong) NSString * cCheckType;

/**
 * 服务点ID
 */
@property (nonatomic, strong) NSString * cCheckSiteID;
/**
 * 预约人数
 */
@property (nonatomic, assign) int cRegCheckNum;
/**
 * 已检人数
 */
@property (nonatomic, assign) int cFactCheckNum;
/**
 * 预约经度
 */
@property (nonatomic, strong) NSString * cRegPosLO;
/**
 * 预约纬度
 */
@property (nonatomic, strong) NSString * cRegPosLA;
/**
 * 预约地址
 */
@property (nonatomic, strong) NSString * cRegPosAddr;
/**
 * 预约时间
 */
@property (nonatomic, strong) NSDate * cRegTime;
/**
 * 预约开始时间
 */
@property (nonatomic, strong) NSDate * cRegBeginDate;
/**
 * 预约结束时间
 */
@property (nonatomic, strong) NSDate * cRegEndDate;

/**
 * 联系人
 */
@property (nonatomic, strong) NSString * cLinkUser;
/**
 * 联系电话
 */
@property (nonatomic, strong) NSString * cLinkPhone;
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
