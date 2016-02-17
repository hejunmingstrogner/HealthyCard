//
//  LeftMenuView.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuCellItem.h"
#import "Constants.h"

@interface LeftMenuView : UIView

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *menuItemArray;    // 菜单列

@property (nonatomic, strong) NSMutableArray *settingItemArray;

- (instancetype)init;

- (instancetype)initWithFrame:(CGRect)frame;

@end
