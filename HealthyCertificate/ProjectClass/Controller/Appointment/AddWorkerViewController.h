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

#warning 单位编号必须填写， 合同编号可不写（不写时为新建预约，写时是预约成功之后的步骤中可见）
@property (nonatomic, strong) NSString *unitCode;      // 单位编号
@property (nonatomic, strong) NSString *contarctCode;   // 合同编号

#warning 需要传进来的数据
@property (nonatomic, strong) NSMutableArray *selectedWorkerArray;  // 已经选择过的员工



@property (nonatomic, strong) NSMutableArray *selectWorkerArray;   // 现在选择的员工，需要返回给上一层

@property (nonatomic, strong) AddWorkerComfirmClicked block;

- (void)getWorkerArrayWithBlock:(AddWorkerComfirmClicked )block;

@end
