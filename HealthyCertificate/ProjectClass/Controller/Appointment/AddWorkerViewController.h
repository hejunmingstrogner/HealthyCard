//
//  AddWorkerViewController.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/24.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RzAlertView.h"

typedef void(^AddWorkerComfirmClicked)(NSArray *workerArray);

/**
 *  添加员工列表
 */
@interface AddWorkerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton    *comfirmBtn; // 确定

@property (nonatomic, strong) NSMutableArray *workerData;       // 原始的员工数据

@property (nonatomic, strong) NSMutableArray *workerArray;      // 封装的员工数据

@property (nonatomic, strong) UILabel     *seletingCountLabel;

@property (nonatomic, strong) NSMutableArray *selectWorkerArray;

@property (nonatomic, strong) RzAlertView *waitAlertView;

@property (nonatomic, strong) AddWorkerComfirmClicked block;

- (void)getWorkerArrayWithBlock:(AddWorkerComfirmClicked )block;

@end
