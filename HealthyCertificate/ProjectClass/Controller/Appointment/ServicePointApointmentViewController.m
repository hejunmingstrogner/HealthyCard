//
//  ServicePointApointmentViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/17.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ServicePointApointmentViewController.h"

#import "Constants.h"
#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"

#import <Masonry.h>

#import "ServicePointCell.h"
#import "ServersPositionAnnotionsModel.h"

@interface ServicePointApointmentViewController()<UITableViewDataSource,UITableViewDelegate>
{
}
@end


@implementation ServicePointApointmentViewController
#pragma mark - Life Circle
-(void)viewDidLoad{
    [super viewDidLoad];
    
    UITableView* tableView = [[UITableView alloc] init];
    
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[ServicePointCell class] forCellReuseIdentifier:NSStringFromClass([ServicePointCell class])];
    tableView.backgroundColor = MO_RGBCOLOR(250, 250, 250);
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.bottom.mas_equalTo(self.view);
    }];
    
    
}

#pragma mark - Setter & Getter
-(void)setServerPointList:(NSMutableArray *)serverPointList{
    _serverPointList = serverPointList;
}


#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _serverPointList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   // return _serverPointList.count;
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServicePointCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ServicePointCell class])];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor colorWithRGBHex:0xe0e0e0].CGColor;
    //cell.servicePoint = (ServersPositionAnnotionsModel*)_serverPointList[indexPath.row];
    ServersPositionAnnotionsModel* serverPoint = (ServersPositionAnnotionsModel*)_serverPointList[indexPath.section];
    cell.servicePoint = serverPoint;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PXFIT_HEIGHT(294);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return PXFIT_HEIGHT(20);
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = MO_RGBCOLOR(250, 250, 250);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}




@end
