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
#import "NSDate+Custom.h"

#import <Masonry.h>

#import "ServicePointCell.h"
#import "ServersPositionAnnotionsModel.h"

#import "TemperaryServicePDeViewController.h"
#import "ServicePointDetailViewController.h"
#import "CloudAppointmentViewController.h"
#import "CloudAppointmentCompanyViewController.h"



@interface ServicePointApointmentViewController()<UITableViewDataSource,UITableViewDelegate>
{
}
@end


@implementation ServicePointApointmentViewController

#pragma mark - Public Methods
-(void)hideTheKeyBoard{
    //[_phoneNumTextField resignFirstResponder];
}

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
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServicePointCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ServicePointCell class])];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor colorWithRGBHex:0xe0e0e0].CGColor;
    __weak typeof (self) wself = self;
    cell.serviceAppointmentBtnClickedBlock = ^(){
        //服务点详情
        ServersPositionAnnotionsModel* servicePositionAnnotionsModel = [[ServersPositionAnnotionsModel alloc] init];
        servicePositionAnnotionsModel = _serverPointList[indexPath.section];
        if (servicePositionAnnotionsModel.type == 0){
            //固定服务点
            ServicePointDetailViewController* fixedServicePointVC = [[ServicePointDetailViewController alloc] init];
            fixedServicePointVC.serverPositionItem = servicePositionAnnotionsModel;
//            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:fixedServicePointVC];
//            [wself.parentViewController presentViewController:nav animated:YES completion:nil];
            [wself.navigationController pushViewController:fixedServicePointVC animated:YES];
        }else{
            //移动服务点
            TemperaryServicePDeViewController* movingServicePointVC = [[TemperaryServicePDeViewController alloc] init];
            movingServicePointVC.servicePositionItem = servicePositionAnnotionsModel;
//            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:movingServicePointVC];
//            [wself.parentViewController presentViewController:nav animated:YES completion:nil];
            [wself.navigationController pushViewController:movingServicePointVC animated:YES];
        }
    };
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
    ServersPositionAnnotionsModel* serverPoint = (ServersPositionAnnotionsModel*)_serverPointList[indexPath.section];
    
    if (GetUserType == 1){
        //个人
        CloudAppointmentViewController *cloudAppoint = [[CloudAppointmentViewController alloc]init];
        cloudAppoint.sercersPositionInfo = serverPoint;
        if (serverPoint.type == 1){
            //临时服务点
            cloudAppoint.appointmentDateStr = [NSString stringWithFormat:@"%@(%@~%@)",
                                               [NSDate getYear_Month_DayByDate:serverPoint.startTime],
                                               [NSDate getHour_MinuteByDate:serverPoint.startTime],
                                               [NSDate getHour_MinuteByDate:serverPoint.endTime]];
        }else{
            cloudAppoint.appointmentDateStr = [NSString stringWithFormat:@"工作日(%@~%@)",
                                               [NSDate getHour_MinuteByDate:serverPoint.startTime],
                                               [NSDate getHour_MinuteByDate:serverPoint.endTime]];
        }
        cloudAppoint.isCustomerServerPoint = NO; //如果是基于现有的服务点预约
        [self.navigationController pushViewController:cloudAppoint animated:YES];
    }else{
        //单位
        CloudAppointmentCompanyViewController* companyCloudAppointment = [[CloudAppointmentCompanyViewController alloc] init];
        companyCloudAppointment.sercersPositionInfo = serverPoint;
        if (serverPoint.type == 1){
            //临时服务点
            companyCloudAppointment.appointmentDateStr = [NSString stringWithFormat:@"%@(%@~%@)",
                                               [NSDate getYear_Month_DayByDate:serverPoint.startTime],
                                               [NSDate getHour_MinuteByDate:serverPoint.startTime],
                                               [NSDate getHour_MinuteByDate:serverPoint.endTime]];
        }else{
            companyCloudAppointment.appointmentDateStr = [NSString stringWithFormat:@"工作日(%@~%@)",
                                               [NSDate getHour_MinuteByDate:serverPoint.startTime],
                                               [NSDate getHour_MinuteByDate:serverPoint.endTime]];
        }
        companyCloudAppointment.isCustomerServerPoint = NO; //如果是基于现有的服务点预约
        [self.navigationController pushViewController:companyCloudAppointment animated:YES];
    }
    
   
}




@end
