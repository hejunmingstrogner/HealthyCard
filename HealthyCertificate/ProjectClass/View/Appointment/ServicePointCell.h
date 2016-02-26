//
//  ServicePointCell.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServersPositionAnnotionsModel.h"

@interface ServicePointCell : UITableViewCell

typedef void(^ServicePointCellBtnClickedBlock)();

@property (nonatomic, strong) ServersPositionAnnotionsModel* servicePoint;
@property (nonatomic ,copy) ServicePointCellBtnClickedBlock serviceAppointmentBtnClickedBlock;

@end
