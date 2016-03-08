//
//  CloudCompanyAppointmentCell.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CloudCompanyAppointmentCell.h"

#import "UIFont+Custom.h"
#import "Constants.h"

#import <Masonry.h>

#define Cell_Font 23

@interface CloudCompanyAppointmentCell()
{
    UILabel*            _titleLabel;
}

@end


@implementation CloudCompanyAppointmentCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
        self.textField = [[UITextField alloc] init];
        self.textField.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
        [self addSubview:_titleLabel];
        [self addSubview:self.textField];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(self).with.offset(10);
            make.height.mas_equalTo(self);
        }];
        [_titleLabel setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];

        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(_titleLabel.mas_right).with.offset(10);
            make.right.lessThanOrEqualTo(self).offset(-10);
        }];
    }
    return self;
}

-(void)setTextFieldType:(CloudCompanyAppointmentTextFieldType)textFieldType{
    switch (textFieldType) {
        case CDA_CONTACTPERSON:
        {
//            NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                           [UIFont systemFontOfSize:15.0],nil];
            NSString* htmlStr = [NSString stringWithFormat:@"联&#8194系&#8194人"];
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)] range:NSMakeRange(0,5)];
            _titleLabel.attributedText = attrStr;
           // _titleLabel.text = [NSString stringWithFormat:@"联 系 人"];
            self.textField.placeholder = @"请输入单位联系人";
        }
            break;
        case CDA_CONTACTPHONE:
        {
            _titleLabel.text = @"联系电话";
            self.textField.placeholder = @"请输入单位联系号码";
        }
            break;
        case CDA_PERSON:
        {
            _titleLabel.text = @"预约人数";
            self.textField.placeholder = @"请输入预约人数";
        }
        default:
            break;
    }
}

@end
