//
//  AddWorkerTBC.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/25.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "AddWorkerTBC.h"
#import <Masonry.h>

@implementation AddworkerTBCItem

- (instancetype)initWithTitle:(NSString *)title Message:(NSString *)message type:(addworkerType)type
{
    if (self = [super init]) {
        _title = title;
        _message = message;
        _type = type;
    }
    return self;
}

@end

@implementation AddWorkerTBC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _textField = [[UITextField alloc]init];
        [self.contentView addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.bottom.right.equalTo(self.contentView).offset(-5);
            make.left.equalTo(self.contentView).offset(120);
        }];
    }
    return self;
}

@end
