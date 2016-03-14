//
//  UserinformationCellItem.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    PERSON_HEADERIMAGE = 0, //
    PERSON_NAME, //
    PERSON_GENDER,//
    PERSON_AGE,//
    PERSON_TELPHONE,//
    PERSON_IDCARD,//
    PERSON_CALLING,//
    PERSON_COMPANY_NAME,//

    COMPANY_NAME,
    COMPANY_ADDRESS,
    COMPANY_CONTACT,
    COMPANY_LINKPHONE,
    COMPANY_CALLING
} UserinformCellItemType;

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
