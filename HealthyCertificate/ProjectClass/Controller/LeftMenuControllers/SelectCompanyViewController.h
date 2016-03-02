//
//  SelectCompanyViewController.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/2.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRServiceUnit.h"

@interface SelectCompanyViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) NSString *companyName;

@property (nonatomic, strong) NSMutableArray *companysArray;

typedef void(^updataCompany)(NSString *text);

@property (nonatomic, strong) updataCompany updata;

- (void)isupdataCompany:(updataCompany )block;

@end
