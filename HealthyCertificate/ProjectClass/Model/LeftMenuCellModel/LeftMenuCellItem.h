//
//  LeftMenuCellItem.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LEFTMENUCELL_USERINFOR = 0, // 用户信息
    LEFTMENUCELL_HISTORYRECORD, // 历史记录
    LEFTMENUCELL_ERWEIMA,       // 二维码
    LEFTMENUCELL_USERTYPE,      // 用户类型
    LEFTMENUCELL_SETTING,       // 设置
    LEFTMENUCELL_NOTICE,        // 注意事项
    LEFTMENUCELL_SHARE,         // 分享
    LEFTMENUCELL_LOGIN,         // 注册
    LEFTMENUCELL_ABOUTUS,       // 关于我们
    LEFTMENUCELL_ADVICE,        // 意见建议
    LEFTMENUCELL_EXIT,          // 退出当前账号

    LEFTMENUCELL_PERSON_APPOINT, // 我的预约
    LEFTMENUCELL_PERSON_ERWEIMA, // 我的二维码
    LEFTMENUCELL_PERSON_UNITLOGIN,// 单位注册

    LEFTMENUCELL_UNIT_APPOINT,  // 单位预约
    LEFTMENUCELL_UNIT_ERWEIMA,  // 单位二维码
    LEFTMENUCELL_UNIT_WORKERMANAGE,// 单位员工管理
} LeftMenuCellItemType;

@interface LeftMenuCellItem : NSObject

@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, strong) NSString *titleLabelText;
@property (nonatomic, strong) NSString *detialLabelText;
@property (nonatomic, assign) LeftMenuCellItemType itemType;
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
- (instancetype)initWithiconName:(NSString *)name titleLabelText:(NSString *)title detialLabelText:(NSString *)detial itemtype:(LeftMenuCellItemType)type;

@end
