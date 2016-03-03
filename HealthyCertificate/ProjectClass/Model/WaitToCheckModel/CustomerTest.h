//
//  CustomerTest.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServersPositionAnnotionsModel.h"
#import "Customer.h"

/**
 * 体检登记类
 *
 * @author hk
 *
 */
@interface CustomerTest : NSObject

#pragma mark -新的数据



#pragma mark - 老的数据
/**
 * 体检编号
 */
@property (nonatomic, strong) NSString * checkCode;
/**
 * 客户编号
 */
@property (nonatomic, strong) NSString * custCode;
/**
 * 单位编号
 */
@property (nonatomic, strong) NSString * unitCode;
/**
 * 单位名称
 */
@property (nonatomic, strong) NSString * unitName;

@property (nonatomic, strong) NSString * cardNo;
/**
 * 姓名
 */
@property (nonatomic, strong) NSString * custName;
/**
 * 性别
 */
@property (nonatomic, assign) Byte  sex;
/**
 * 民族
 */
@property (nonatomic, strong) NSString * nation;
/**
 * 出生日期
 */
@property (nonatomic, assign) long long bornDate;
/**
 * VIP标志
 */
@property (nonatomic, strong) NSString * custVIPFlag;
/**
 * 身份证号
 */
@property (nonatomic, strong) NSString * custIdCard;
/**
 * 联系电话
 */
@property (nonatomic, strong) NSString * linkPhone;
/**
 * 岗位类型
 */
@property (nonatomic, strong) NSString * jobDuty;
/**
 * 体检类型
 */
@property (nonatomic, assign) int checkType;   // 健康证类型：1   默认－1
/**
 * 近期照片
 */
@property (nonatomic, strong) NSDate * printPhoto;
/**
 * 所属体检合同
 */
@property (nonatomic, strong) NSString * contractCode;
/**
 * 体检服务点
 */
@property (nonatomic, strong) NSString * checkSiteID;
/**
 * 预约经度
 */
@property (nonatomic, assign) long long regPosLO;
/**
 * 预约纬度
 */
@property (nonatomic, assign) long long regPosLA;
/**
 * 预约地址
 */
@property (nonatomic, strong) NSString * regPosAddr;
/**
 * 开始日期
 */
@property (nonatomic, assign) long long regBeginDate;
/**
 * 结束日期
 */
@property (nonatomic, assign) long long regEndDate;
/**
 * 预约时间
 */
@property (nonatomic, assign) long long regTime;

@property (nonatomic, assign) long long reservdate;


@property (nonatomic, strong) NSString * priority;
@property (nonatomic, strong) NSString * hosCode;
@property (nonatomic, assign) int totalLineTime;
@property (nonatomic, assign) int totalWaitTime;
@property (nonatomic, assign) int totalCheckTime;
@property (nonatomic, strong) NSString * checkTime;
@property (nonatomic, strong) NSString * checkINTime;
@property (nonatomic, strong) NSString * endTime;
/**
 *
 */
@property (nonatomic, strong) NSString * testStatus;        // -1待检 0签到 1在检 2延期 3待出证
@property (nonatomic, assign) int mainItemNum;
@property (nonatomic, strong) NSString * rfidNo;
@property (nonatomic, strong) NSDate * synTime;
@property (nonatomic, assign) float ages;
@property (nonatomic, strong) NSString * marryFlag;
@property (nonatomic, strong) NSString * affirmdate;
@property (nonatomic, strong) NSString * operdate;
@property (nonatomic, assign) float regPrice;
@property (nonatomic, strong) NSString * packNo;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString * zoneCode;
/**
 * 所属城市
 */
@property (nonatomic, strong) NSString * cityName;
/**
 * 所属套餐编号。
 */
@property (nonatomic, strong) NSString * suitCode;

/**
 * 绑定合同套餐编号
 */
@property (nonatomic, strong) NSString * unitSuitCode;
/**
 * 地址
 */
// @property (nonatomic, strong) NSString * sAddr;
/**
 * 关联的OutCheckSite到达时间
 */
// @property (nonatomic, strong) NSDate * sarriveTime;
/**
 * 关联的OutCheckSit离开时间
 */
// @property (nonatomic, strong) NSDate * sleaveTime;
/**
 * 关联的OutCheckSite安排的联系方式 【非数据库字段】
 */
// @property (nonatomic, strong) NSString * slinkPhone;

/**
 * 体验预约绑定的客户信息。 【非数据库字段】
 */
@property (nonatomic, strong) Customer *customer;
/**
 * 所有体验项。 【非数据库字段】
 */
@property (nonatomic, strong) NSMutableArray * testItems;  // CustomerTestItem

/**
 * 关联的服务点 【非数据库字段】
 */
@property (nonatomic, strong) ServersPositionAnnotionsModel *servicePoint;

/**
 * 单位地址 【非数据库字段】
 */
@property (nonatomic, strong) NSString * unitAddr;
/**
 * 年龄 【非数据库字段】
 */
@property (nonatomic, assign)  int age;

@end
