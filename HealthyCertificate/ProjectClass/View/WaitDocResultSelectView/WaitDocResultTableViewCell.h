//
//  WaitDocResultTableViewCell.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitDocResultSelectItem.h"

@interface WaitDocResultTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;                  // 项目明细
@property (nonatomic, strong) UILabel *countAndTimeLabel;           // 人数／时间
@property (nonatomic, strong) UILabel *statusLabel;                 // 状态

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setCellItem:(WaitDocResultSelectItem *)waitItem;

@end
