//
//  PersonInfoOfPhonePacket.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/17.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePacket.h"

@interface PersonInfoOfPhonePacket : BasePacket
    /**
     * 客户编号
     */
    @property (nonatomic, copy) NSString* mCustCode;
    /**
     * 256string 客户姓名
     */
    @property (nonatomic, copy) NSString* mCustName;
    /**
     * Byte 客户性别 0:男 1:女
     */
    @property (nonatomic, assign) Byte bGender;
    /**
     * 256string 民族 例如：”汉”
     */
    @property (nonatomic, copy) NSString* cNation;
    /**
     * 256string 地址
     */
    @property (nonatomic, copy) NSString* cAddress;
    /**
     * time_t 出生日期 时间类型
     */
    @property (nonatomic, assign) NSDate* dBornDate;
    /**
     * Byte 婚否标识 1：已婚 2：未婚
     */
    @property (nonatomic, assign) Byte bMarryFlag;
    /**
     * 256string 身份证号
     */
    @property (nonatomic, copy) NSString* CustId;
    /**
     * 256string 电话号码
     */
    @property (nonatomic, copy) NSString* StrTel;
    /**
     * 256string 邮箱
     */
    @property (nonatomic, copy) NSString* cEmail;
    /**
     * 256string 客户照片 图片格式
     */
    @property (nonatomic, copy) NSString* cCustPhoto;
    /**
     * 256string 单位编号
     */
    @property (nonatomic, copy) NSString* cUnitCode;
    /**
     * 256 string 单位名称
     */
    @property (nonatomic, copy) NSString* cUnitName;
    /**
     * 256 string 行业类型
     */
    @property (nonatomic, copy) NSString* cIndustry;

@end
