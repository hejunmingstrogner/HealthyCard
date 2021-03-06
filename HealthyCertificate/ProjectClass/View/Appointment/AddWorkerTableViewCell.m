//
//  AddWorkerTableViewCell.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/24.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "AddWorkerTableViewCell.h"
#import <Masonry.h>
#import "UIFont+Custom.h"
#import "NSDate+Custom.h"
@implementation AddWorkerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    _selectImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_selectImageView];
    [_selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.height.width.mas_equalTo(30);
    }];
    _nameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(_selectImageView.mas_right).offset(20);
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(60);
    }];
    _nameLabel.font = [UIFont fontWithType:0 size:14];

    _phoneLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_phoneLabel];
    _phoneLabel.textAlignment = NSTextAlignmentLeft;
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(3);
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(100);
    }];
    _phoneLabel.font = [UIFont fontWithType:0 size:14];

    _endDateLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_endDateLabel];
    _endDateLabel.textAlignment = NSTextAlignmentLeft;
    [_endDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_phoneLabel.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    _endDateLabel.font = [UIFont fontWithType:0 size:14];
    _endDateLabel.numberOfLines = 0;
}

- (void)changeSelectStatus:(AddWorkerCellItem *)cellitem
{
    if (cellitem.isSelectFlag == 0) {
        cellitem.isSelectFlag = 1;
        _selectImageView.image = [UIImage imageNamed:@"tuoyuanxuanzhong"];
    }
    else {
        cellitem.isSelectFlag = 0;
        _selectImageView.image = [UIImage imageNamed:@"tuoyuan"];
    }
}

- (void)setCellitem:(AddWorkerCellItem *)cellitem
{
    _cellitem = cellitem;
    if (cellitem.customerTest) {
        _nameLabel.text = cellitem.customerTest.custName;

        if (cellitem.customerTest.linkPhone.length == 0) {
            _phoneLabel.text = @"未查到";
        }
        else {
            _phoneLabel.text = cellitem.customerTest.linkPhone;
        }
        if (cellitem.customerTest.customer.lastCheckTime == 0) {
            _endDateLabel.text = @"无体检记录";
        }
        else {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:cellitem.customerTest.customer.lastCheckTime / 1000];
            NSDate *enddata = [date nextYear];
            //        _endDateLabel.text = [NSDate getYear_Month_DayByDate:cellitem.customer.lastCheckTime / 1000];
            _endDateLabel.text = [enddata formatDateToChineseString];
        }
        if (cellitem.isSelectFlag == 0) {
            _selectImageView.image = [UIImage imageNamed:@"tuoyuan"];
        }
        else {
            _selectImageView.image = [UIImage imageNamed:@"tuoyuanxuanzhong"];
        }
    }
    else {
        _nameLabel.text = cellitem.customer.custName;

        if (cellitem.customer.linkPhone.length == 0) {
            _phoneLabel.text = @"未查到";
        }
        else {
            _phoneLabel.text = cellitem.customer.linkPhone;
        }
        if (cellitem.customer.lastCheckTime == 0) {
            _endDateLabel.text = @"无体检记录";
        }
        else {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:cellitem.customer.lastCheckTime / 1000];
            NSDate *enddata = [date nextYear];
            //        _endDateLabel.text = [NSDate getYear_Month_DayByDate:cellitem.customer.lastCheckTime / 1000];
            _endDateLabel.text = [enddata formatDateToChineseString];
        }
        if (cellitem.isSelectFlag == 0) {
            _selectImageView.image = [UIImage imageNamed:@"tuoyuan"];
        }
        else {
            _selectImageView.image = [UIImage imageNamed:@"tuoyuanxuanzhong"];
        }
    }

}
@end
