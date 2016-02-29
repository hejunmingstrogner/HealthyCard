//
//  LeftMenuViewHeaderinfoCell.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/29.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuCellItem.h"

@interface LeftMenuViewHeaderinfoCell : UITableViewCell

@property (nonatomic, strong) LeftMenuCellItem *leftMenuCellItem;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setLeftMenuCellItem:(LeftMenuCellItem *)leftMenuCellItem;
@end
