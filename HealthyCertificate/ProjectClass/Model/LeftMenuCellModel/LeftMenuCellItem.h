//
//  LeftMenuCellItem.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LEFTMENUCELL_USERINFOR = 0,
    LEFTMENUCELL_HISTORYRECORD,
    LEFTMENUCELL_SETTING,
    LEFTMENUCELL_NOTICE,
    LEFTMENUCELL_LOGIN,
    LEFTMENUCELL_ABOUTUS,
    LEFTMENUCELL_ADVICE,
    LEFTMENUCELL_EXIT
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
