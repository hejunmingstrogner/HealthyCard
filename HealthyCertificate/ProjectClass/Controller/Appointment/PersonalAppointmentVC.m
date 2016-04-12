//
//  PersonalAppointmentVC.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/4/7.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "PersonalAppointmentVC.h"

#import "Constants.h"

#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"

#import <Masonry.h>

#import "ServicePointApointmentViewController.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface PersonalAppointmentVC()<UINavigationControllerDelegate>

@end


@implementation PersonalAppointmentVC
{
    UIViewController    *_currentVC;
    
    ServicePointApointmentViewController    *_outCheckAppointmentVC;
    ServicePointApointmentViewController    *_fixedPointVC;
}


#pragma mark - UIViewController overrides
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self initNavgation];
    
    UIView* contentView = [[UIView alloc] init];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _outCheckAppointmentVC = [[ServicePointApointmentViewController alloc] init];
    _outCheckAppointmentVC.serverPointList = _outCheckServicePoint;
    [_outCheckAppointmentVC.view setFrame:self.view.frame];
    [self addChildViewController:_outCheckAppointmentVC];
    
    _fixedPointVC = [[ServicePointApointmentViewController alloc] init];
    _fixedPointVC.serverPointList = _fixedServicePoint;
    [_fixedPointVC.view setFrame:self.view.frame];
    [self addChildViewController:_fixedPointVC];
    
    _currentVC = _outCheckAppointmentVC;
    [self.view addSubview:_outCheckAppointmentVC.view];
}


#pragma mark - view initializations
-(void)initNavgation
{
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    NSArray* segArr = [[NSArray alloc] initWithObjects:@"上门体检", @"到院体检", nil];
    UISegmentedControl* segment = [[UISegmentedControl alloc] initWithItems:segArr];
    segment.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 30);
    segment.selectedSegmentIndex = 0;//默认索引
    segment.tintColor = MO_RGBCOLOR(0, 169, 234);
    UIFont *font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [segment setTitleTextAttributes:attributes
                           forState:UIControlStateNormal];
    [segment addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
}

#pragma mark - Action
-(void)didClicksegmentedControlAction:(UISegmentedControl *)seg
{
    if (_currentVC == _outCheckAppointmentVC && seg.selectedSegmentIndex == 0)
        return;
    
    if (_currentVC == _fixedPointVC && seg.selectedSegmentIndex == 1)
        return;
    
    if (seg.selectedSegmentIndex == 0){
        [self replaceController:_currentVC newController:_outCheckAppointmentVC];
    }else{
        [self replaceController:_currentVC newController:_fixedPointVC];
    }
}

- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Private Methods
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            _currentVC = newController;
        }else{
            _currentVC = oldController;
        }
    }];
}



@end
