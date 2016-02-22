//
//  CloudAppointmentViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/17.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CloudAppointmentViewController.h"
#import "Constants.h"

#import <Masonry.h>

#import "UIButton+Easy.h"
#import "UIColor+Expanded.h"

#import "BaseInfoTableViewCell.h"
#import "CloudAppointmentDateVC.h"

#import "HealthyCertificateView.h"
#import "AppointmentInfoView.h"

@interface CloudAppointmentViewController()<UITableViewDataSource,UITableViewDelegate>
{
    HealthyCertificateView* _healthyCertificateView;
    AppointmentInfoView*    _appointmentInfoView;
}
@end


@implementation CloudAppointmentViewController

#pragma mark - Setter & Getter
-(void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate{
    _centerCoordinate = centerCoordinate;
}

-(void)setLocation:(NSString *)location{
    _location = location;
}

#pragma mark - Life Circle
-(void)viewDidLoad{
    [super viewDidLoad];
    
    UIView* bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).with.offset(SCREEN_HEIGHT-PXFIT_HEIGHT(136)-kNavigationBarHeight);
        make.height.mas_equalTo(PXFIT_HEIGHT(136));
    }];
    
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = MO_RGBCOLOR(250, 250, 250);
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(bottomView.mas_top);
    }];
    
    
    UIView* containerView = [[UIView alloc] init];
    [scrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];

    
    UITableView* baseInfoTableView = [[UITableView alloc] init];
    baseInfoTableView.delegate = self;
    baseInfoTableView.dataSource = self;
    baseInfoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    baseInfoTableView.separatorColor = [UIColor colorWithRGBHex:0xe8e8e8];
    baseInfoTableView.layer.borderWidth = 1;
    baseInfoTableView.layer.borderColor = [UIColor colorWithRGBHex:0xe8e8e8].CGColor;
    baseInfoTableView.layer.cornerRadius = 10.0f;
    baseInfoTableView.scrollEnabled = NO;
    [baseInfoTableView registerClass:[BaseInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BaseInfoTableViewCell class])];
    [containerView addSubview:baseInfoTableView];
    [baseInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(containerView).with.offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH-20);
        make.height.mas_equalTo(PXFIT_HEIGHT(96)*3);
    }];
    

    _healthyCertificateView = [[HealthyCertificateView alloc] init];
    _healthyCertificateView.layer.cornerRadius = 10;
    _healthyCertificateView.layer.borderColor = MO_RGBCOLOR(0, 168, 234).CGColor;
    _healthyCertificateView.layer.borderWidth = 1;
    [containerView addSubview:_healthyCertificateView];
    [_healthyCertificateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView).with.offset(10);
       // make.left.right.mas_equalTo(containerView);
        make.top.mas_equalTo(baseInfoTableView.mas_bottom).with.offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH-20);
        make.height.mas_equalTo(PXFIT_HEIGHT(460));
    }];
    
    
    _appointmentInfoView = [[AppointmentInfoView alloc] init];
    [containerView addSubview:_appointmentInfoView];
    [_appointmentInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(_healthyCertificateView.mas_bottom).with.offset(10);
    }];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_appointmentInfoView.mas_bottom);
    }];
}

#pragma mark - UITableViewDataSource & UITabBarControllerDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BaseInfoTableViewCell class])];
    
    if ( [cell respondsToSelector:@selector(setSeparatorInset:)] )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ( [cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)] )
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ( [cell respondsToSelector:@selector(setLayoutMargins:)] )
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if (indexPath.row == 0){
        cell.iconName = @"search_icon";
        cell.textField.text = _location;
        cell.textField.enabled = NO;
    }else if (indexPath.row == 1){
        cell.iconName = @"date_icon";
        cell.textField.enabled = NO;
    }else{
        cell.iconName = @"phone_icon";
        cell.textField.text = gPersonInfo.StrTel;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.parentViewController performSegueWithIdentifier:@"ChooseDateIdentifier" sender:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PXFIT_HEIGHT(96);
}

#pragma mark - Storyboard Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"ChooseDateIdentifier"]){
//        UIViewController* destinationViewController = segue.destinationViewController;
//        if ([destinationViewController isKindOfClass:[CloudAppointmentDateVC class]])
//        {
////            UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
////            returnButtonItem.title = @"";
////            self.navigationItem.backBarButtonItem = returnButtonItem;
////            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//        }
//    }
}


@end
