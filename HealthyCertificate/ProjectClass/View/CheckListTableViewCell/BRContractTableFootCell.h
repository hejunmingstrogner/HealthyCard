//
//  BRContractTableFootCell.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRContract.h"

@interface BRContractTableFootCell : UITableViewCell

@property (nonatomic, strong)UILabel *orderedLabel;
@property (nonatomic, strong)UILabel *checkedLabel;


- (void)setCellItem:(BRContract *)brContract;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
