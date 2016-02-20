//
//  AppointmentViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/17.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "AppointmentViewController.h"

#import "CloudAppointmentViewController.h"
#import "ServicePointApointmentViewController.h"

#import <Masonry.h>
#import "Constants.h"

#import "UIButton+Easy.h"
#import "UIFont+Custom.h"


@interface AppointmentViewController()
{
    CloudAppointmentViewController              *_cloudAppointmentViewController;
    ServicePointApointmentViewController        *_servicePointAppointmentViewController;
}

@property (nonatomic, strong) UIViewController  *currentVC;
@property (nonatomic, strong) UIView            *currentView;

@end


@implementation AppointmentViewController

#pragma mark - Setter & Getter
-(void)setLocation:(NSString *)location{
    _location = location;
}

-(void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate{
    _centerCoordinate = centerCoordinate;
}


#pragma mark - Life Circle
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = MO_RGBCOLOR(250, 250, 250);
    
    //加载界面布局
    UIView* navView = [[UIView alloc] init];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.mas_equalTo(self.view);
        make.height.mas_equalTo(kNavigationBarHeight);
    }];
    
    UIButton* backBtn = [UIButton buttonWithNormalImageName:@"back" highlightImageName:@"back"];
    [navView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(navView);
        make.left.mas_equalTo(navView.mas_left).with.offset(8);
    }];
    
    
    NSArray* segArr = [[NSArray alloc] initWithObjects:@"云预约", @"服务点", nil];
    UISegmentedControl* segment = [[UISegmentedControl alloc] initWithItems:segArr];
    segment.selectedSegmentIndex = 0;//默认索引
    segment.tintColor = MO_RGBCOLOR(0, 169, 234);
    UIFont *font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(20)];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [segment setTitleTextAttributes:attributes
                               forState:UIControlStateNormal];
    [segment addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH*1/2);
        make.center.mas_equalTo(navView);
    }];
    
    UIButton* QRScanButton = [UIButton buttonWithNormalImageName:@"QRScan" highlightImageName:@"QRScan"];
    [navView addSubview:QRScanButton];
    [QRScanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(navView);
        make.right.mas_equalTo(navView.mas_right).with.offset(-8);
    }];
    
    self.currentView = [[UIView alloc] init];
    [self.view addSubview:self.currentView];
    [self.currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(navView.mas_bottom);
    }];
    
    _cloudAppointmentViewController = [[CloudAppointmentViewController alloc] init];
    _cloudAppointmentViewController.location = _location;
    _cloudAppointmentViewController.centerCoordinate = _centerCoordinate;
    _servicePointAppointmentViewController = [[ServicePointApointmentViewController alloc] init];
    
    [self addChildViewController:_cloudAppointmentViewController];
    [self addChildViewController:_servicePointAppointmentViewController];
    
    [self.currentView addSubview:_cloudAppointmentViewController.view];
    
    self.currentVC = _cloudAppointmentViewController;
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
-(void)didClicksegmentedControlAction:(UISegmentedControl *)seg
{
    if (self.currentVC == _cloudAppointmentViewController && seg.selectedSegmentIndex == 0)
        return;
    if (self.currentVC == _servicePointAppointmentViewController && seg.selectedSegmentIndex == 1)
        return;
    
    UIViewController* oldVC = self.currentVC;
    NSInteger index = seg.selectedSegmentIndex;
    switch (index) {
        case 0:
        {
            [self transitionFromViewController:self.currentVC toViewController:_cloudAppointmentViewController duration:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
            } completion:^(BOOL finished) {
                if(finished) {
                    self.currentVC = _cloudAppointmentViewController;
                }
                else {
                    self.currentVC = oldVC;
                }
            }];
        }
            break;
        case 1:
        {
            [self transitionFromViewController:self.currentVC toViewController:_servicePointAppointmentViewController duration:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
            } completion:^(BOOL finished) {
                if(finished) {
                    self.currentVC = _servicePointAppointmentViewController;
                }
                else {
                    self.currentVC = oldVC;
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

@end
