//
//  ServicePositionCarHeadTableViewCell.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServersPositionAnnotionsModel.h"

@interface ServicePositionCarHeadTableViewCell : UITableViewCell

// 高 120
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setCellItem:(ServersPositionAnnotionsModel *)serviceInfo;

@end
