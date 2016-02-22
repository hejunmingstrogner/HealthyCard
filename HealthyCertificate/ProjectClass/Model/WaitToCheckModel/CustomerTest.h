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

/**
 * 体检编号
 */
@property (nonatomic, strong) NSString * cCheckCode;
/**
 * 客户编号
 */
@property (nonatomic, strong) NSString * cCustId;
/**
 * 单位编号
 */
@property (nonatomic, strong) NSString * cUnitCode;
/**
 * 单位名称
 */
@property (nonatomic, strong) NSString * cUnitName;

@property (nonatomic, strong) NSString * cCardNo;
/**
 * 姓名
 */
@property (nonatomic, strong) NSString * cCustName;
/**
 * 性别
 */
@property (nonatomic, assign) Byte  cSex;
/**
 * 民族
 */
@property (nonatomic, strong) NSString * cNation;
/**
 * 出生日期
 */
@property (nonatomic, strong) NSDate * dBornDate;
/**
 * VIP标志
 */
@property (nonatomic, strong) NSString * cCustVIPFlag;
/**
 * 身份证号
 */
@property (nonatomic, strong) NSString * cCustIdCard;
/**
 * 联系电话
 */
@property (nonatomic, strong) NSString * cLinkPhone;
/**
 * 岗位类型
 */
@property (nonatomic, strong) NSString * cJobDuty;
/**
 * 体检类型
 */
@property (nonatomic, assign) int cCheckType;   // 健康证类型：1   默认－1
/**
 * 近期照片
 */
//@property (nonatomic, strong) byte[] cPrintPhoto;
/**
 * 所属体检合同
 */
@property (nonatomic, strong) NSString * cContractCode;
/**
 * 体检服务点
 */
@property (nonatomic, strong) NSString * cCheckSiteID;
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
 * 预约体检开始时间. 格式：2016-01-08
 */
@property (nonatomic, strong) NSDate * cRegBeginDate;
/**
 * 预约体检结束时间 格式：2016-01-08
 */
@property (nonatomic, strong) NSDate * cRegEndDate;
@property (nonatomic, strong) NSString * cCustType;
@property (nonatomic, strong) NSDate * cReservdate;

@property (nonatomic, strong) NSString * cPriority;
@property (nonatomic, strong) NSString * cHosCode;
@property (nonatomic, assign) int cTotalLineTime;
@property (nonatomic, assign) int cTotalWaitTime;
@property (nonatomic, assign) int cTotalCheckTime;
@property (nonatomic, strong) NSString * checkTime;
@property (nonatomic, strong) NSString * checkINTime;
@property (nonatomic, strong) NSString * endTime;
/**
 *
 */
@property (nonatomic, strong) NSString * cTestStatus;
@property (nonatomic, assign) int cMainItemNum;
@property (nonatomic, strong) NSString * rfidNo;
@property (nonatomic, strong) NSDate * synTime;
@property (nonatomic, assign) float iAges;
@property (nonatomic, strong) NSString * cMarryFlag;
@property (nonatomic, strong) NSString * dAffirmdate;
@property (nonatomic, strong) NSString * dOperdate;
@property (nonatomic, assign) float regPrice;
@property (nonatomic, strong) NSString * packNo;
@property (nonatomic, strong) NSString * cPassword;
@property (nonatomic, strong) NSString * zoneCode;
/**
 * 所属城市
 */
@property (nonatomic, strong) NSString * cityName;
/**
 * 所属套餐编号。
 */
@property (nonatomic, strong) NSString * cSuitCode;

/**
 * 绑定合同套餐编号
 */
@property (nonatomic, strong) NSString * cUnitSuitCode;
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
//@property (nonatomic, strong) List<CustomerTestItem> testItems;

/**
 * 关联的服务点 【非数据库字段】
 */
@property (nonatomic, strong) ServersPositionAnnotionsModel *servicePoint;

@end
