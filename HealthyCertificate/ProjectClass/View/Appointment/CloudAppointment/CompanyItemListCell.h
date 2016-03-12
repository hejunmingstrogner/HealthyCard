//
//  CompanyItemListCell.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/11.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyItemListCell : UITableViewCell

typedef NS_ENUM(NSInteger, CompanyItemListTextViewType)
{
        //体检地址
        CDA_EXAMADDRESS,
        //体检时间
        CDA_EXAMTIME,
        //预约地址
        CDA_APPOINTMENTADDRESS,
        //预约时间
        CDA_APPOINTMENTTIME
};

@property (nonatomic, strong) UITextView* textView;

@property (nonatomic, assign) CompanyItemListTextViewType itemType;

-(void)setTextViewText:(NSString *)textViewText;

@end
