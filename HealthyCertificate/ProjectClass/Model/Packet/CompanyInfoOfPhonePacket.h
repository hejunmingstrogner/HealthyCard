//
//  CompanyInfoOfPhonePacket.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/17.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "BasePacket.h"

@interface CompanyInfoOfPhonePacket : BasePacket

    /**
     * 单位编号
     */
    @property (nonatomic, copy) NSString* cUnitCode;
    /**
     * 单位名称
     */
    @property (nonatomic, copy) NSString* cUnitName;
    /**
     * 单位简称
     */
    @property (nonatomic, copy) NSString* cUnitShotName;
    /**
     * 256string 单位地址
     */
    @property (nonatomic, copy) NSString* cUnitAddr;
    /**
     * 单位联系人
     */
    @property (nonatomic, copy) NSString* cLinkPeople;
    /**
     * 固定联系电话
     */
    @property (nonatomic, copy) NSString* cLinkTel;
    /**
     * 256string 移动联系电话
     */
    @property (nonatomic, copy) NSString* cLinkPhone;
    /**
     * 256string 电子邮箱
     */
    @property (nonatomic, copy) NSString* cEmail;
    /**
     * 256string 传真
     */
    @property (nonatomic, copy) NSString* cLinkFax;
    /**
     * 256string 单位类型
     */
    @property (nonatomic, copy) NSString* cUnitType;
    /**
     * 256string 单位网址
     */
    @property (nonatomic, copy) NSString* cUnitURL;
    /**
     * 256 string 单位银行帐号
     */
    @property (nonatomic, copy) NSString* cAccountNo;
    /**
     * 256 string 单位开户行
     */
    @property (nonatomic, copy) NSString* cAccountBank;
    /**
     * 256 string 单位照片
     */
    @property (nonatomic, copy) NSString* cUnitPhto;

@end
