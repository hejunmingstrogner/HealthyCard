//
//  AddWorkerViewController.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/24.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RzAlertView.h"
#import "Constants.h"

typedef void(^AddWorkerComfirmClicked)(NSArray *workerArray);

/**
 *  添加员工列表
 */
@interface AddWorkerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton    *comfirmBtn; // 确定

@property (nonatomic, strong) NSMutableArray *workerData;       // 原始的员工数据

@property (nonatomic, strong) NSMutableArray *workerArray;      // 封装的员工数据

@property (nonatomic, strong) NSMutableArray *selectedWorkerArray;  // 已经选择过的员工

@property (nonatomic, strong) UILabel     *seletingCountLabel;

@property (nonatomic, strong) NSMutableArray *selectWorkerArray;    // 选择的员工

@property (nonatomic, strong) NSArray     *needcanlceWorkersArray;  // 需要过滤掉的员工

@property (nonatomic, strong) RzAlertView *waitAlertView;

@property (nonatomic, strong) AddWorkerComfirmClicked block;

- (void)getWorkerArrayWithBlock:(AddWorkerComfirmClicked )block;

@end
