//
//  HistoryInformationVController.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/3.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryInformationVController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *historyArray;

@property (nonatomic, assign) NSInteger userType;   // 用户当前type  1个人，2单位

@end
