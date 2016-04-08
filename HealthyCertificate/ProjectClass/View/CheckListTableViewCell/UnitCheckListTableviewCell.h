//
//  UnitCheckListTableviewCell.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/4/8.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRContract.h"

@interface UnitCheckListTableviewCell : UITableViewCell

@property (nonatomic, strong) BRContract *brContract;
@property (nonatomic, strong) UIButton *cancelOrderBtn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
