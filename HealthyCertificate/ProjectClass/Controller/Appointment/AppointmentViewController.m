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
#import "CloudAppointmentCompanyViewController.h"
#import "CloudAppointmentDateVC.h"

#import <Masonry.h>
#import "Constants.h"

#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UIFont+Custom.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)
#define CloudController (GetUserType == 1 ? _cloudAppointmentViewController : _cloudAppointmentCompanyViewController)

@interface AppointmentViewController()
{
    //个人云预约
    CloudAppointmentViewController              *_cloudAppointmentViewController;
    //单位云预约
    CloudAppointmentCompanyViewController       *_cloudAppointmentCompanyViewController;
    
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

-(void)setNearbyServicePointsArray:(NSMutableArray *)nearbyServicePointsArray
{
   _nearbyServicePointsArray = nearbyServicePointsArray;
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
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).with.offset(kStatusBarHeight);
        make.height.mas_equalTo(kNavigationBarHeight);
    }];
    
    UIButton* backBtn = [UIButton buttonWithNormalImageName:@"back" highlightImageName:@"back"];
    [navView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(navView);
        make.left.mas_equalTo(navView.mas_left).with.offset(8);
    }];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    self.view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.currentView];
    [self.currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    _cloudAppointmentViewController = [[CloudAppointmentViewController alloc] init];
    _cloudAppointmentViewController.location = _location;
    _cloudAppointmentViewController.centerCoordinate = _centerCoordinate;
    _servicePointAppointmentViewController = [[ServicePointApointmentViewController alloc] init];
    _servicePointAppointmentViewController.serverPointList = _nearbyServicePointsArray;
    
    _cloudAppointmentCompanyViewController = [[CloudAppointmentCompanyViewController alloc] init];
    
    [self addChildViewController:CloudController];
    [self addChildViewController:_servicePointAppointmentViewController];
    [self.currentView addSubview:CloudController.view];
    [CloudController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.currentView);
    }];
//    [_servicePointAppointmentViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.currentView);
//    }];
    self.currentVC = CloudController;
}

#pragma mark - Action
-(void)didClicksegmentedControlAction:(UISegmentedControl *)seg
{
    if (self.currentVC == CloudController && seg.selectedSegmentIndex == 0)
        return;
    if (self.currentVC == _servicePointAppointmentViewController && seg.selectedSegmentIndex == 1)
        return;
    
    UIViewController* oldVC = self.currentVC;
    NSInteger index = seg.selectedSegmentIndex;
    switch (index) {
        case 0:
        {
            [self transitionFromViewController:self.currentVC
                              toViewController:CloudController
                                      duration:0
                                       options:UIViewAnimationOptionCurveEaseInOut
                                    animations:^{
            } completion:^(BOOL finished) {
                if(finished) {
                    self.currentVC = CloudController;
                    [self.currentView addSubview:CloudController.view];
                    //self.currentView = [[UIView alloc] init];
                   // [self.view addSubview:self.currentView];
                    [self.currentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(self.view.mas_top).with.offset(kNavigationBarHeight+kStatusBarHeight);
                        make.left.right.bottom.mas_equalTo(self.view);
                    }];
                }
                else {
                    self.currentVC = oldVC;
                }
            }];
        }
            break;
        case 1:
        {
            [self transitionFromViewController:self.currentVC
                              toViewController:_servicePointAppointmentViewController
                                      duration:0
                                       options:UIViewAnimationOptionCurveEaseInOut
                                    animations:^{
                
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

-(void)backBtnClicked:(UIButton*)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Storyboard Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ChooseDateIdentifier"]){
        UIViewController* destinationViewController = segue.destinationViewController;
        if ([destinationViewController isKindOfClass:[CloudAppointmentDateVC class]])
        {
            CloudAppointmentDateVC* cloudAppointmentDateVC = (CloudAppointmentDateVC*)destinationViewController;
            [cloudAppointmentDateVC getAppointDateStringWithBlock:^(NSString *dateStr) {
                [_cloudAppointmentViewController setAppointmentDateStr:dateStr];
            }];
            //            BaseInfoTableViewCell* cell = [_baseInfoTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            //            cell.textField.text = [NSString combineString:cloudAppointmentDateVC.beginDateString
            //                                                      And:cloudAppointmentDateVC.endDateString
            //                                                     With:@"~"];
            //            UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
            //            returnButtonItem.title = @"";
            //            self.navigationItem.backBarButtonItem = returnButtonItem;
            //            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        }
    }
}

@end
