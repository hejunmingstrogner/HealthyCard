//
//  BaseInfoTableViewCell.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "BaseInfoTableViewCell.h"
#import <Masonry.h>

#import "UIFont+Custom.h"
#import "Constants.h"

#define Cell_Font 23

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
    
    self.textView = [[UITextView alloc] init];
    self.textView.textColor = [UIColor blackColor];
    self.textView.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
    [self addSubview:self.textView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).with.offset(10);
        make.right.mas_equalTo(self.textView.mas_left).with.offset(-10);
    }];
    [imageView setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
    
   // self.textView.backgroundColor = [UIColor greenColor];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
//        make.right.lessThanOrEqualTo(self.mas_right).with.offset(-10);
        make.width.mas_equalTo(self.frame.size.width-35-imageView.frame.size.width);
       // make.height.mas_equalTo(self.frame.size.height-2);
    }];
}

@end
