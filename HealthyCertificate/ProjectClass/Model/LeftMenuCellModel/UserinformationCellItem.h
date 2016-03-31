//
//  UserinformationCellItem.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, UserinformCellItemType) {
    PERSON_HEADERIMAGE = 0,     // 头像
    PERSON_NAME,                // 个人姓名
    PERSON_GENDER,              // 性别
    PERSON_AGE,                 //年龄
    PERSON_TELPHONE,            // 电话
    PERSON_IDCARD,              // 身份证
    PERSON_CALLING,             // 行业
    PERSON_COMPANY_NAME,        // 单位名称

    COMPANY_NAME,               // 公司名字
    COMPANY_ADDRESS,            // 公司地址
    COMPANY_CONTACT,            // 联系人
    COMPANY_LINKPHONE,          // 联系电话
    COMPANY_CALLING,            // 公司行业
    COMPANY_INDUSTRY_CODE,      // 工商编号
    COMPANY_BELONG_CITY,        // 注册城市
};

@interface UserinformationCellItem : NSObject

@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, strong) NSString *titleLabelText;
@property (nonatomic, strong) NSString *detialLabelText;
@property (nonatomic, assign) UserinformCellItemType itemType;

/**
 *  初始化item
 *
 *  @param name   图片的名字
 *  @param title
 *  @param detial
 *  @param type
 *
 *  @return
 */
- (instancetype)initWithiconName:(NSString *)name titleLabelText:(NSString *)title detialLabelText:(NSString *)detial itemtype:(UserinformCellItemType)type;

@end
