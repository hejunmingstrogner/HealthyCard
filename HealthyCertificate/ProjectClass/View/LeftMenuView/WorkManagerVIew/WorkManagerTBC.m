//
//  WorkManagerTBC.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/25.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "WorkManagerTBC.h"
#import <Masonry.h>
#import "UIFont+Custom.h"

#pragma mark -员工管理的模型
@implementation WorkManagerTBCItem

- (instancetype)initWithName:(NSString *)name sex:(NSString *)sex tel:(NSString *)telPhoneNo Type:(WorkManagerCellType)type Customer:(Customer *)customer
{
    if (self = [super init]) {
        _name = [NSString stringWithFormat:@"%@", name];
        _sex = sex;
        _telPhoneNo = telPhoneNo;
        _type = type;
        _customer = customer;
    }
    return self;
}

@end


#pragma mark -员工管理的cell
@interface WorkManagerTBC()
{
    UILabel *_nameLabel;
    
    UILabel *_telPhoneLabel;
}
@end;

@implementation WorkManagerTBC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViewscell];
    }
    return self;
}

- (void)initSubViewscell
{
    _nameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.width.mas_equalTo(100);
        make.top.centerY.bottom.equalTo(self.contentView);
    }];

    _sexLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_sexLabel];
    _sexLabel.textColor = [UIColor grayColor];
    _sexLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    [_sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.centerY.equalTo(_nameLabel);
        make.width.mas_equalTo(50);
        make.left.equalTo(_nameLabel.mas_right);
    }];

    _telPhoneLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_telPhoneLabel];
    _telPhoneLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    [_telPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.centerY.equalTo(_nameLabel);
        make.left.equalTo(_sexLabel.mas_right);
        make.right.equalTo(self.contentView).offset(-20);
    }];
}
- (void)setCellItem:(WorkManagerTBCItem *)cellItem
{
    _nameLabel.text = cellItem.name;
    _sexLabel.text = cellItem.sex;
    _telPhoneLabel.text = cellItem.telPhoneNo;
}
@end
