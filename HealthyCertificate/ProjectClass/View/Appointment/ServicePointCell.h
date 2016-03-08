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
typedef void(^ServericePointCellPhoneNumBtnBlock)(NSString* phoneNum);

@property (nonatomic, strong) ServersPositionAnnotionsModel* servicePoint;

//点击详情过后的回调
@property (nonatomic ,copy) ServicePointCellBtnClickedBlock serviceAppointmentBtnClickedBlock;


//点击拨号后的回调
@property (nonatomic ,copy)ServericePointCellPhoneNumBtnBlock servicePointCellPhoneNumBtnBlock;

@end
