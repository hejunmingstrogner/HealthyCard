//
//  ExamItemStateCell.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/4/7.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ExamItemStateCell.h"

#import <Masonry.h>

#import "Constants.h"

#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"

#define Cell_Font 23

@implementation ExamItemStateCell
{
    UILabel     *_nameLabel;
    UILabel     *_payStateLabel;
    UILabel     *_examStateLabel;
}

typedef NS_ENUM(NSInteger, ExamItemStateCellLabel)
{
    ExamItemStateCellLabelCenter,
    ExamItemStateCellLabelLeft,
    ExamItemStateCellLabelRight
};

#pragma mark view initializations
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        _nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH / 3);
            make.left.height.centerY.equalTo(self.contentView);
        }];
        
        _payStateLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_payStateLabel];
        [_payStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH / 3);
            make.left.equalTo(_nameLabel.mas_right);
            make.centerY.height.equalTo(self.contentView);
        }];
        
        _examStateLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_examStateLabel];
        [_examStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH / 3);
            make.right.height.centerY.equalTo(self.contentView);
        }];
        
        _nameLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
        _nameLabel.textColor = [UIColor blackColor];
        _payStateLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
        _examStateLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
    }
    return self;
}


#pragma mark - Setter & Getter
-(void)setCustomerTest:(CustomerTest *)customerTest
{
    if (customerTest == nil){
        [self setAttributeStringForPriceLabel:_nameLabel text:@"姓名" Aligment:ExamItemStateCellLabelLeft];
        [self setAttributeStringForPriceLabel:_payStateLabel text:@"付款状态" Aligment:ExamItemStateCellLabelCenter];
        _payStateLabel.textColor = [UIColor blackColor];
        [self setAttributeStringForPriceLabel:_examStateLabel text:@"体检状态" Aligment:ExamItemStateCellLabelRight];
        _examStateLabel.textColor = [UIColor blackColor];
    }else{
        [self setAttributeStringForPriceLabel:_nameLabel text:customerTest.custName Aligment:ExamItemStateCellLabelLeft];
        
        if (customerTest.payMoney <= 0 ){
            [self setAttributeStringForPriceLabel:_payStateLabel text:@"未付" Aligment:ExamItemStateCellLabelCenter];
            _payStateLabel.textColor = [UIColor colorWithRGBHex:HC_Base_Orange_Text];
        }else{
            [self setAttributeStringForPriceLabel:_payStateLabel text:@"已付" Aligment:ExamItemStateCellLabelCenter];
            _payStateLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
        }
        
        int status = [customerTest.testStatus intValue];
        if (status == 5 || status == 6){
            //未检
            [self setAttributeStringForPriceLabel:_examStateLabel text:@"未检" Aligment:ExamItemStateCellLabelRight];
            _examStateLabel.textColor = [UIColor colorWithRGBHex:HC_Base_Orange_Text];
        }
        
        if (status <= 0){
            //未检
            [self setAttributeStringForPriceLabel:_examStateLabel text:@"未检" Aligment:ExamItemStateCellLabelRight];
            _examStateLabel.textColor = [UIColor colorWithRGBHex:HC_Base_Orange_Text];
        }else if (status < 3){
            //在检
            [self setAttributeStringForPriceLabel:_examStateLabel text:@"在检" Aligment:ExamItemStateCellLabelRight];
            _examStateLabel.textColor = [UIColor colorWithRGBHex:HC_Base_Green];
        }else{
            //已检
            [self setAttributeStringForPriceLabel:_examStateLabel text:@"已检" Aligment:ExamItemStateCellLabelRight];
            _examStateLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
        }
    }
}

#pragma mark - Private Methods
- (void)setAttributeStringForPriceLabel:(UILabel *)label text:(NSString *)text Aligment:(ExamItemStateCellLabel)alignment
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString
                                              alloc] initWithString:text];
    NSUInteger length = [text length];
    NSMutableParagraphStyle *
    style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    if (alignment == ExamItemStateCellLabelCenter){
        style.alignment = NSTextAlignmentCenter;//居中显示
    }else if (alignment == ExamItemStateCellLabelLeft){
        style.firstLineHeadIndent = 10; //设置与头部的距离
        style.alignment = NSTextAlignmentLeft;//靠左显示
    }else{
        style.tailIndent = -10; //设置与尾部的距离
        style.alignment = NSTextAlignmentRight;//靠右显示
    }
    [attrString addAttribute:NSParagraphStyleAttributeName value:style
                       range:NSMakeRange(0, length)];
    label.attributedText = attrString;
}

@end
