//
//  TextViewTableViewCell.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/4/21.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "TextViewTableViewCell.h"

#import "Constants.h"

#import "UILabel+Easy.h"
#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"

#import <Masonry.h>

@implementation TextViewTableViewCell
{
    UILabel         *_titleLabel;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        _titleLabel = [UILabel labelWithText:_titleText
                                        font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(25)]
                                   textColor:[UIColor colorWithRGBHex:HC_Gray_Text]];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(5);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo([self labelWidth]);
        }];
        
        _textView = [[UITextView alloc] init];
        _textView.scrollEnabled = NO;
        [self.contentView addSubview:_textView];
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
    _titleLabel.text = titleText;
    _titleLabel.font = font;
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
    UILabel* examinationAddressLabel = [UILabel labelWithText:@"体检时间"
                                                         font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(25)]
                                                    textColor:[UIColor blackColor]];
    NSDictionary* attribute = @{NSFontAttributeName:examinationAddressLabel.font};
    CGSize size = [examinationAddressLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, PXFIT_HEIGHT(100)) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    //获得label的宽度
    return size.width + 1;
}

@end
