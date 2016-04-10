//
//  AddWorkerTableViewCell.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/24.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddWorkerCellItem.h"
/**
 *  添加员工列表的cell
 */
@interface AddWorkerTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *selectImageView;     // 选中的图片显示
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *phoneLabel;
@property (nonatomic, strong) UILabel     *endDateLabel;        // 到期时间

@property (nonatomic, strong) AddWorkerCellItem *cellitem;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setCellitem:(AddWorkerCellItem *)cellitem;

- (void)changeSelectStatus:(AddWorkerCellItem *)cellitem;

@end
