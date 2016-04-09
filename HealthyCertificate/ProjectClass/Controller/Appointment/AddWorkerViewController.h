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

@property (nonatomic, strong) NSString *cUnitCode;      // 合同号

@property (nonatomic, strong) NSMutableArray *selectedWorkerArray;  // 已经选择过的员工

//@property (nonatomic, copy) NSArray     *needcanlceWorkersArray;  // 需要过滤掉的员工


@property (nonatomic, strong) AddWorkerComfirmClicked block;

- (void)getWorkerArrayWithBlock:(AddWorkerComfirmClicked )block;

@end
