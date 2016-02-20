//
//  BaseInfoTableViewCell.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "BaseInfoTableViewCell.h"
#import <Masonry.h>

@implementation BaseInfoTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
    }
    return self;
}

#pragma mark - setter & getter
-(void)setIconName:(NSString *)iconName{
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).with.offset(10);
    }];
    
    self.textField = [[UITextField alloc] init];
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(imageView.mas_right).with.offset(10);
        make.width.mas_equalTo(self.frame.size.width-20-imageView.frame.size.width);
        make.height.mas_equalTo(self.frame.size.height - 2);
    }];
}

@end
