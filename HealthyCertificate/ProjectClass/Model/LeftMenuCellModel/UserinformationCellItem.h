//
//  UserinformationCellItem.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    USERINFORMATION_HEADERIMAGE = 0,
    USERINFORMATION_NAME,
    USERINFORMATION_GENDER,
    USERINFORMATION_OLD,
    USERINFORMATION_TELPHONENO,
    USERINFORMATION_IDCARD,
    USERINFORMATION_CALLING,
    USERINFORMATION_WORKUNITNAME,
    USERINFORMATION_WORKUNITADRESS,
    USERINFORMATION_WORKUNITCONTACTS
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
