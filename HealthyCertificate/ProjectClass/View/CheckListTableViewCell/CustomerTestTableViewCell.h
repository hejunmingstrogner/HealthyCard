//
//  CustomerTestTableViewCell.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerTest.h"

@interface CustomerTestTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setCellItemWithTest:(CustomerTest *)customerTest;

@property (nonatomic, strong) UIButton *cancelAppointBtn;   //  取消预约按钮
@property (nonatomic, strong) UIButton *payMoneyBtn;        // 在线支付按钮
@property (nonatomic, assign) float    payMoney;

@end
