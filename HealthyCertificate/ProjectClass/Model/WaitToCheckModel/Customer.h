//
//  Customer.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 个人信息类。
 *
 * @author hk
 *
 */
@interface Customer : NSObject

/**
 * 客户编码。
 */
@property (nonatomic, strong) NSString * cCustCode;
/**
 * 客户单位编码。
 */
@property (nonatomic, strong) NSString * cUnitCode;
/**
 * 单位地址。
 */
// @property (nonatomic, strong) NSString * cUnitAdrr;
@property (nonatomic, strong) NSString * cUnitName;
/**
 * 所属行业。
 */
@property (nonatomic, strong) NSString * cCustType;
/**
 * 客户姓名。
 */
@property (nonatomic, strong) NSString * cCustName;
/**
 * 性别。
 */
@property (nonatomic, assign) Byte  cSex;
/**
 * 民族
 */
@property (nonatomic, strong) NSString * cNation;
/**
 * 住址。
 */
@property (nonatomic, strong) NSString * cAddress;
/**
 * 出生日期。
 */
@property (nonatomic, strong) NSDate * dBornDate;
/**
 * 是否已婚。
 */
@property (nonatomic, strong) NSString * cMarryFlag;
/**
 * 证件哑巴。
 */
@property (nonatomic, strong) NSString * cIdCard;
/**
 * 电话
 */
// @property (nonatomic, strong) NSString * cTel;
/**
 * 联系人电话
 */
@property (nonatomic, strong) NSString * cLinkPhone;
/**
 * 邮件地址。
 */
@property (nonatomic, strong) NSString * cEmail;
/**
 * 个人照片。
 */
//@property (nonatomic, strong) byte[] cCustPhoto;
/**
 *
 */
@property (nonatomic, strong) NSString * cCardNo;
/**
 *
 */
@property (nonatomic, strong) NSString * dOperdate;
/**
 * 同步时间。
 */
@property (nonatomic, strong) NSDate * synTime;

/**
 * 上一次体检时间。
 */
@property (nonatomic, strong) NSDate * lastCheckTime;

@end
