//
//  PersonalCheckListViewContrller.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/4/10.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM (NSInteger, POP_STYLE){
    POPTO_LSAT,
    POPTO_ROOT
};

@interface PersonalCheckListViewContrller : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *checkDataArray;           // 预约数据

@property (nonatomic, assign) NSInteger userType;

@property (nonatomic, assign) POP_STYLE popStyle;

@end
