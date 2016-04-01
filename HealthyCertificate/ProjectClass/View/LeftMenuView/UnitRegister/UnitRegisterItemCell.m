//
//  UnitRegisterItemCell.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/31.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "UnitRegisterItemCell.h"

#import "Constants.h"

#import "UILabel+Easy.h"
#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"

#import <Masonry.h>

@interface UnitRegisterItemCell()

@end

@implementation UnitRegisterItemCell
{
    UILabel         *_titleLabel;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        _titleLabel = [UILabel labelWithText:_titleText
                                        font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(25)]
                                   textColor:[UIColor colorWithRGBHex:HC_Gray_Text]];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(5);
            make.centerY.equalTo(self);
            make.width.mas_equalTo([self labelWidth]);
        }];
        
        _textView = [[UITextView alloc] init];
        _textView.scrollEnabled = NO;
        [self addSubview:_textView];
        _textView.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(25)];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_right).with.offset(5);
            make.right.equalTo(self).with.offset(-5);
            make.height.equalTo(_titleLabel);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - Setter & Getter
-(void)setTitleText:(NSString *)titleText
{
    UIFont *font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(25)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@", @"*", titleText]];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGBHex:HC_Gray_Text] range:NSMakeRange(1, str.length-1)];
    _titleLabel.attributedText = str;
    [_titleLabel sizeToFit];
}

-(void)setContent:(NSString *)content
{
    _textView.text = content;
    CGRect bounds = _textView.bounds;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [_textView sizeThatFits:maxSize];
    bounds.size = newSize;
    _textView.bounds = bounds;
}



#pragma mark - Private Methods
-(CGFloat)labelWidth{
    UILabel* examinationAddressLabel = [UILabel labelWithText:@"* 单位名称"
                                                         font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(25)]
                                                    textColor:[UIColor blackColor]];
    NSDictionary* attribute = @{NSFontAttributeName:examinationAddressLabel.font};
    CGSize size = [examinationAddressLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, PXFIT_HEIGHT(100)) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    //获得label的宽度
    return size.width + 1;
}


@end
