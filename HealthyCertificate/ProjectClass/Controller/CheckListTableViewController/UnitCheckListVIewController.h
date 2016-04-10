//
//  UnitCheckListVIewController.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/4/10.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalCheckListViewContrller.h"

/**
 *  单位未完成待处理项
 */
@interface UnitCheckListVIewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *companyDataArray;         // 单位预约数据
@property (nonatomic, strong) NSMutableArray *checkDataArray;           // 预约数据
@property (nonatomic, assign) NSInteger userType;

@property (nonatomic, assign) POP_STYLE popStyle;

@end
