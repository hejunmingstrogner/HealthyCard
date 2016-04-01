//
//  UnitRegisterItemCell.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/31.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnitRegisterItemCell : UITableViewCell

@property (nonatomic, strong) UITextView* textView;


@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *content;

@end
