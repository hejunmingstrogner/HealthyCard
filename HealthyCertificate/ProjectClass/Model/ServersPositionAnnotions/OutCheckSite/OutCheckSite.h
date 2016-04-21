//
//  OutCheckSite.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/4/21.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BROutCheckArrange;
@interface OutCheckSite : NSObject
/**
 * 未生效状态。  = 0
 */
@property (nonatomic, assign) int STATUS_INACTIVE;
/**
 * 未开始  = 10
 */
@property (nonatomic, assign) int STATUS_NOTSTARTED;
/**
 * 已到达。  = 20
 */
@property (nonatomic, assign) int STATUS_ARRIVED;
/**
 * 已停止。 = 30
 */
@property (nonatomic, assign) int STATUS_STOPED;
/**
 * 失效的。 = 99
 */
@property (nonatomic, assign) int STATUS_INVALID;

/**
 * 服务点类型。
 * <ul>
 * <li>0：个人自建。</li>
 * <li>1：单位自建。</li>
 * <li>2：平台设定。</li>
 * </ul>
 */
@property (nonatomic, assign) Byte SITETYPE_BYPERSON;
@property (nonatomic, assign) Byte SITETYPE_BYUNIT;
@property (nonatomic, assign) Byte SITETYPE_OURPLAT;
/**
 * UID
 */
@property (nonatomic, strong) NSString * uid;
/**
 * 服务点名称。
 */
@property (nonatomic, strong) NSString * name;
/**
 * 服务点地址。
 */
@property (nonatomic, strong) NSString * checkAdrr;
/**
 * 服务点经度。 = -1
 */
@property (nonatomic, assign) double positionLo;
/**
 * 服务点纬度。 = -1
 */
@property (nonatomic, assign) double positionLa;
/**
 * 外出安排。 【非数据库字段】
 */
@property (nonatomic, strong) BROutCheckArrange * outcheckArrange;
/**
 * 外出安排ID。
 */
@property (nonatomic, strong) NSString * outCheckArrangeID;
/**
 * 预计到达时间 。
 */
@property (nonatomic, assign) long long arriveTime;
/**
 * 预计离开时间。
 */
@property (nonatomic, assign) long long leaveTime;
/**
 * 预约人数。 = -1
 */
@property (nonatomic, assign) int oppointmentNum;
/**
 * 已经支付的数量。
 */
@property (nonatomic, assign) int chargedNum;
/**
 * 检查人数。 = -1
 */
@property (nonatomic, assign) int checkinNum;
/**
 * 所属机构编号。
 */
@property (nonatomic, strong) NSString * hosCode;
/**
 * 服务点所属城市。
 *
 * @since 2016.04.09
 */
@property (nonatomic, strong) NSString * cityName;
/**
 * 0待生效 <br>
 * 10未开始<br>
 * 20已到达 <br>
 * 30停止预约。
 * 99 已失效
 */
@property (nonatomic, assign) int testStatus;

/**
 * 服务点类型。
 * <ul>
 * <li>0：个人自建。</li>
 * <li>1：单位自建。</li>
 * <li>2：平台设定。</li>
 * </ul>
 */
@property (nonatomic, assign) Byte siteType;

/**
 * 最大允许人数。 = -1
 */
@property (nonatomic, assign) int maxNum;

/**
 * 是否接受散客。 0：不接受 1：接受
 */
@property (nonatomic, assign) Byte freeRegFlag;
/**
 * 操作人员编号。 【特指内部工作人员】
 */
@property (nonatomic, strong) NSString * operCode;
@end
