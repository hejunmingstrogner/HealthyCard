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
@property (nonatomic, strong) NSString * custCode;
/**
 * 客户单位编号。
 */
@property (nonatomic, strong) NSString * unitCode;
/**
 * 单位地址。
 */
@property (nonatomic, strong) NSString * unitAdrr;
/**
 * 单位名称。
 */
@property (nonatomic, strong) NSString * unitName;
/**
 * 所属行业。
 */
@property (nonatomic, strong) NSString * custType;
/**
 * 客户姓名。
 */
@property (nonatomic, strong) NSString * custName;
/**
 * 性别。
 */
@property (nonatomic, assign) Byte  sex;
@property (nonatomic, copy) NSString *sexflag;
/**
 * 民族
 */
@property (nonatomic, strong) NSString * nation;
/**
 * 住址。
 */
@property (nonatomic, strong) NSString * addr;
/**
 * 出生日期。
 */
@property (nonatomic, strong) NSDate * bornDate;
/**
 * 是否已婚。
 */
@property (nonatomic, strong) NSString * marryFlag;
/**
 * 身份证号码。
 */
@property (nonatomic, strong) NSString * idCard;
/**
 * 电话
 */
@property (nonatomic, strong) NSString * tel;
/**
 * 联系人电话
 */
@property (nonatomic, strong) NSString * linkPhone;
/**
 * 邮件地址。
 */
@property (nonatomic, strong) NSString * email;
/**
 * 个人照片。
 */
//@property (nonatomic, strong) byte[] cCustPhoto;
/**
 *
 */
@property (nonatomic, strong) NSString * cardNo;
/**
 *
 */
@property (nonatomic, strong) NSString * operdate;
/**
 * 同步时间。
 */
@property (nonatomic, strong) NSDate * synTime;

/**
 * 上一次体检时间。
 */
@property (nonatomic, assign) long long lastCheckTime;

@end
