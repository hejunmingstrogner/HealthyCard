//
//  BRServiceUnit.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRServiceUnit : NSObject

/**
 * 单位编号。
 */
@property (nonatomic, strong) NSString * unitCode;
/**
 * 索引。
 */
@property (nonatomic, strong) NSString * searchIndex;
/**
 * ???
 */
@property (nonatomic, strong) NSString * stopTag;
/**
 * 单位经度。
 */
@property (nonatomic, assign) double positionLO;
/**
 * 单位纬度。
 */
@property (nonatomic, assign) double positonLA;
/**
 * 单位名称。
 */
@property (nonatomic, strong) NSString * unitName;
/**
 * 单位简称。
 */
@property (nonatomic, strong) NSString * UnitShotName;
/**
 * 单位地址。
 */
@property (nonatomic, strong) NSString * addr;
/**
 * 单位联系人。
 */
@property (nonatomic, strong) NSString * linkPeople;

/**
 * 固定电话
 */
@property (nonatomic, strong) NSString * linkTel;
/**
 * 联系人手机号码。
 */
@property (nonatomic, strong) NSString * linkPhone;
/**
 * 邮箱。
 */
@property (nonatomic, strong) NSString * email;
/**
 * 传真。
 */
@property (nonatomic, strong) NSString * linkFax;
/**
 * 单位类型。
 */
@property (nonatomic, strong) NSString * unitType;
/**
 * 单位网址。
 */
@property (nonatomic, strong) NSString * unitURL;
/**
 * 单位银行账号。
 */
@property (nonatomic, strong) NSString * accountNo;
/**
 * 单位开户银行。
 */
@property (nonatomic, strong) NSString * accountBank;
/**
 * 单位图片。
 */
@property (nonatomic, strong) NSData * unitPhoto;
/**
 * 备注。
 */
@property (nonatomic, strong) NSString * memo;
/**
 * 注册日期。
 */
@property (nonatomic, strong) NSDate * operdate;
/**
 * 登记机构编号。
 */
@property (nonatomic, strong) NSString * auditHosCode;

/**
 * 注册码
 */
@property (nonatomic, strong) NSString * operCode;
/**
 * 城市名
 */
@property (nonatomic, strong) NSString * cityName;
@property (nonatomic, strong) NSDate * synTime;
/**
 * 领导人员电话列表，以逗号隔开。
 */
@property (nonatomic, strong) NSString * cLeaderPhoneList;

@end
