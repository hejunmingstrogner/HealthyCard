//
//  CloudCompanyAppointmentCell.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CloudCompanyAppointmentTextFieldType)
{
    CDA_CONTACTPERSON,
    CDA_CONTACTPHONE,
    CDA_PERSON
};


@interface CloudCompanyAppointmentCell : UITableViewCell

@property (nonatomic, strong) UITextField* textField;

@property (nonatomic, assign) CloudCompanyAppointmentTextFieldType textFieldType;

@end
