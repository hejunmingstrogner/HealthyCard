//
//  AdviceViewController.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>

@interface AdviceViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextView *adviceTextView;

@property (nonatomic, strong) NSMutableArray *selectMistakeFlagArray;
@end
