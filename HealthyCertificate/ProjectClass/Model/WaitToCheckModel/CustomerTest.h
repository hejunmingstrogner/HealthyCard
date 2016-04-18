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

typedef NS_ENUM(NSInteger, testStatus){
    NONE_STATUS = 0,
    LEFT_STATUS,
    CENTER_STATUS,
    RIGHT_STATUS
};

@interface CustomerTestStatusItem : NSObject

@property (nonatomic, copy) NSString *leftText;
@property (nonatomic, copy) NSString *centerText;
@property (nonatomic, copy) NSString *rigthText;
@property (nonatomic, assign) testStatus status;
@property (nonatomic, copy) NSString *warmingText;

@end
/**
 * 体检登记类
 *
 * @author hk
 *
 */
@interface CustomerTest : NSObject

#pragma mark - 老的数据
/**
 * 体检编号
 */
@property (nonatomic, copy) NSString * checkCode;
/**
 * 客户编号
 */
@property (nonatomic, copy) NSString * custCode;
/**
 * 单位编号
 */
@property (nonatomic, copy) NSString * unitCode;
/**
 * 单位名称
 */
@property (nonatomic, copy) NSString * unitName;

@property (nonatomic, copy) NSString * cardNo;
/**
 * 姓名
 */
@property (nonatomic, copy) NSString * custName;
/**
 * 性别   
 */
@property (nonatomic, assign) Byte  sex;
/**
 * 民族
 */
@property (nonatomic, copy) NSString * nation;
/**
 * 出生日期
 */
@property (nonatomic, assign) long long bornDate;
/**
 * VIP标志
 */
@property (nonatomic, copy) NSString * custVIPFlag;
/**
 * 身份证号
 */
@property (nonatomic, copy) NSString * custIdCard;
/**
 * 联系电话
 */
@property (nonatomic, copy) NSString * linkPhone;
/**
 * 岗位类型
 */
@property (nonatomic, copy) NSString * jobDuty;
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
@property (nonatomic, copy) NSString * contractCode;
/**
 * 体检服务点  为空是云预约，存在是服务点预约
 */
@property (nonatomic, copy) NSString * checkSiteID;
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
@property (nonatomic, copy) NSString * regPosAddr;
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


@property (nonatomic, copy) NSString * priority;
@property (nonatomic, copy) NSString * hosCode;
@property (nonatomic, assign) int totalLineTime;
@property (nonatomic, assign) int totalWaitTime;
@property (nonatomic, assign) int totalCheckTime;
@property (nonatomic, copy) NSString * checkTime;
@property (nonatomic, copy) NSString * checkINTime;
@property (nonatomic, copy) NSString * endTime;
/**
 *
 */
@property (nonatomic, copy) NSString * testStatus;        // -1未检，0签到，1在检，2延期，3完成，4已通过总检确认，5已打印体检卡，6已打印条码，9已出报告和健康证

/**
 *  是否需要付款  返回 Yes:需要去付款   No,已经付款或者体检了，不需要去付款了
 *
 *  @return Yes:需要去付款   No,已经付款或者体检了，不需要去付款了
 */
- (BOOL)isNeedToPay;

/**
 *  获得当前状态以及两边的状态的数组
 *
 *  @param teststatus 当前合同状态
 *
 *  @return 反回三个状态
 */
- (NSArray *)getTestStatusArrayWithTestStatus:(NSString *)teststatus;

/**
 *  获得当前状态以及两边的状态的数组  新的方法
 *
 *  @param testatus
 *
 *  @return 数组 012:要显示的文本  3：高亮显示的位置  4：提示信息
 */
- (CustomerTestStatusItem *)getTestStatusItem;

/**
 *  是否可以取消订单
 *
 *  @return
 */
- (BOOL)canCancelTheOrder;

@property (nonatomic, assign) int mainItemNum;
@property (nonatomic, copy) NSString * rfidNo;
@property (nonatomic, strong) NSDate * synTime;
@property (nonatomic, assign) float ages;
@property (nonatomic, copy) NSString * marryFlag;
//体检确认时间
@property (nonatomic, assign) long long affirmdate;
@property (nonatomic, copy) NSString * operdate;
@property (nonatomic, assign) float payMoney;
@property (nonatomic, copy) NSString * packNo;
@property (nonatomic, copy) NSString * password;
@property (nonatomic, copy) NSString * zoneCode;
/**
 * 所属城市
 */
@property (nonatomic, copy) NSString * cityName;
/**
 * 所属套餐编号。
 */
@property (nonatomic, copy) NSString * suitCode;

/**
 * 绑定合同套餐编号
 */
@property (nonatomic, copy) NSString * unitSuitCode;
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
@property (nonatomic, copy) NSString * unitAddr;
/**
 * 年龄 【非数据库字段】
 */
@property (nonatomic, assign)  int age;
/**
 * 体检单位名称
 * [非数据库字段]
 */
@property (nonatomic, copy) NSString* hosName;
/**
 * 健康证编号
 */
@property (nonatomic, copy) NSString* healthCardNo;

/**
 *  应付金额
 *  [暂时非数据库字段]
 */
@property (nonatomic, assign) float  needMoney;

/**
 *  获得应付金额
 *
 *  @param
 */
- (void)getNeedMoneyWhenPayFor;

@end
