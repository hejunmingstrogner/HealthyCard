//
//  CheckListPayMoneyCell.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/12.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckListPayMoneyCell : UITableViewCell
@property (nonatomic, strong) UIButton *cancelAppointBtn;   //  取消预约按钮
@property (nonatomic, strong) UIButton *payMoneyBtn;        // 在线支付按钮
@property (nonatomic, assign) float    payMoney;

@end
