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
@property (nonatomic, strong) NSString * cUnitCode;
/**
 * 索引。
 */
@property (nonatomic, strong) NSString * csearchIndex;
/**
 * ???
 */
@property (nonatomic, strong) NSString * cStopTag;
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
@property (nonatomic, strong) NSString * cUnitName;
/**
 * 单位简称。
 */
@property (nonatomic, strong) NSString * cUnitShortName;
/**
 * 单位地址。
 */
@property (nonatomic, strong) NSString * cAddr;
/**
 * 单位联系人。
 */
@property (nonatomic, strong) NSString * cLinkPeople;

/**
 * 固定电话
 */
@property (nonatomic, strong) NSString * cLinkTel;
/**
 * 联系人手机号码。
 */
@property (nonatomic, strong) NSString * cLinkPhone;
/**
 * 邮箱。
 */
@property (nonatomic, strong) NSString * cEmail;
/**
 * 传真。
 */
@property (nonatomic, strong) NSString * cLinkFax;
/**
 * 单位类型。
 */
@property (nonatomic, strong) NSString * cUnitType;
/**
 * 单位网址。
 */
@property (nonatomic, strong) NSString * cUnitURL;
/**
 * 单位银行账号。
 */
@property (nonatomic, strong) NSString * cAccountNo;
/**
 * 单位开户银行。
 */
@property (nonatomic, strong) NSString * cAccountBank;
/**
 * 单位图片。
 */
//@property (nonatomic, strong) byte[] cUnitPhoto;
/**
 * 备注。
 */
@property (nonatomic, strong) NSString * cMemo;
/**
 * 注册日期。
 */
@property (nonatomic, strong) NSDate * doperdate;
/**
 * 登记机构编号。
 */
@property (nonatomic, strong) NSString * cAuditHosCode;
@property (nonatomic, strong) NSDate * synTime;
/**
 * 领导人员电话列表，以逗号隔开。
 */
@property (nonatomic, strong) NSString * cLeaderPhoneList;

@end
