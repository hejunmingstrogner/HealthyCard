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
#import "NSDate+Custom.h"

#import "YMIDCardRecognition.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)
#define CloudController (GetUserType == 1 ? _cloudAppointmentViewController : _cloudAppointmentCompanyViewController)
#define HideKeyBoard (GetUserType == 1 ? [_cloudAppointmentViewController hideTheKeyBoard]: [_cloudAppointmentCompanyViewController hideTheKeyBoard])

@interface AppointmentViewController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate,YMIDCardRecognitionDelegate>
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
    QRScanButton.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [QRScanButton addTarget:self action:@selector(QRScanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:QRScanButton];
    [QRScanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(navView);
        make.right.mas_equalTo(navView.mas_right).with.offset(-8);
    }];
    
    self.currentView = [[UIView alloc] init];
    self.currentView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.currentView];
    [self.currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    _cloudAppointmentViewController = [[CloudAppointmentViewController alloc] init];
    _cloudAppointmentViewController.location = _location;
    _cloudAppointmentViewController.centerCoordinate = _centerCoordinate;
    _cloudAppointmentViewController.isCustomerServerPoint = YES;
    
    _servicePointAppointmentViewController = [[ServicePointApointmentViewController alloc] init];
    _servicePointAppointmentViewController.serverPointList = _nearbyServicePointsArray;
    
    _cloudAppointmentCompanyViewController = [[CloudAppointmentCompanyViewController alloc] init];
    _cloudAppointmentCompanyViewController.location = _location;
    _cloudAppointmentCompanyViewController.centerCoordinate = _centerCoordinate;
    _cloudAppointmentCompanyViewController.isCustomerServerPoint = YES;
    
    [self addChildViewController:CloudController];
    [self addChildViewController:_servicePointAppointmentViewController];
    
    [self.currentView addSubview:CloudController.view];
    [self.currentView addSubview:_servicePointAppointmentViewController.view];
    
    [CloudController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.currentView);
    }];
    [_servicePointAppointmentViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.currentView);
    }];
    [_servicePointAppointmentViewController.view setHidden:YES];
    self.currentVC = CloudController;
}

#pragma mark - Action
-(void)didClicksegmentedControlAction:(UISegmentedControl *)seg
{
    if (self.currentVC == CloudController && seg.selectedSegmentIndex == 0)
        return;
    if (self.currentVC == _servicePointAppointmentViewController && seg.selectedSegmentIndex == 1)
        return;
    HideKeyBoard;
    NSInteger index = seg.selectedSegmentIndex;
    switch (index) {
        case 0:
        {
            [CloudController.view setHidden:NO];
            [_servicePointAppointmentViewController.view setHidden:YES];
            self.currentVC = CloudController;
        }
            break;
        case 1:
        {
            [CloudController.view setHidden:YES];
            [_servicePointAppointmentViewController.view setHidden:NO];
            self.currentVC = _servicePointAppointmentViewController;
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

-(void)QRScanButtonClicked:(UIButton*)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.showsCameraControls = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"由于您的设备暂不支持摄像头，您无法使用该功能!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
//        [alertView show];
    }
}

#pragma mark - Storyboard Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ChooseDateIdentifier"]){
        UIViewController* destinationViewController = segue.destinationViewController;
        if ([destinationViewController isKindOfClass:[CloudAppointmentDateVC class]])
        {
            CloudAppointmentDateVC* cloudAppointmentDateVC = (CloudAppointmentDateVC*)destinationViewController;
            if (GetUserType == 1){
                if (_cloudAppointmentViewController.appointmentDateStr == nil){
                    cloudAppointmentDateVC.beginDateString = [[NSDate date] getDateStringWithInternel:1];
                    cloudAppointmentDateVC.endDateString = [[NSDate date] getDateStringWithInternel:2];
                }
                else{
                    cloudAppointmentDateVC.beginDateString = [_cloudAppointmentViewController.appointmentDateStr componentsSeparatedByString:@"~"][0];
                    cloudAppointmentDateVC.endDateString = [_cloudAppointmentViewController.appointmentDateStr componentsSeparatedByString:@"~"][1];
                }
            }else{
                if (_cloudAppointmentCompanyViewController.appointmentDateStr == nil){
                    cloudAppointmentDateVC.beginDateString = [[NSDate date] getDateStringWithInternel:1];
                    cloudAppointmentDateVC.endDateString = [[NSDate date] getDateStringWithInternel:2];
                }
                else{
                    cloudAppointmentDateVC.beginDateString = [_cloudAppointmentCompanyViewController.appointmentDateStr componentsSeparatedByString:@"~"][0];
                    cloudAppointmentDateVC.endDateString = [_cloudAppointmentCompanyViewController.appointmentDateStr componentsSeparatedByString:@"~"][1];
                }
            }
            
            [cloudAppointmentDateVC getAppointDateStringWithBlock:^(NSString *dateStr) {
                if (GetUserType == 1){
                    [_cloudAppointmentViewController setAppointmentDateStr:dateStr];
                }else{
                    [_cloudAppointmentCompanyViewController setAppointmentDateStr:dateStr];
                }
                
            }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //取得照片
    UIImage *image;
    //	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    CGImageRef imRef = [image CGImage];
    
    UIImageOrientation orientation = [image imageOrientation];
    
    NSInteger texWidth = CGImageGetWidth(imRef);
    NSInteger texHeight = CGImageGetHeight(imRef);
    
    float imageScale = 1;
    
    if(orientation == UIImageOrientationUp && texWidth < texHeight)
        image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationLeft];
    else if((orientation == UIImageOrientationUp && texWidth > texHeight) || orientation == UIImageOrientationRight)
        image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationUp];
    else if(orientation == UIImageOrientationDown)
        image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationDown];
    else if(orientation == UIImageOrientationLeft)
        image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationUp];
    
    NSLog(@"originalImage width = %f height = %f",image.size.width,image.size.height);
    [YMIDCardRecognition recongnitionWithCard:image delegate:self];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)recongnition:(YMIDCardRecognition *)YMIDCardRecognition didFailWithError:(NSError *)error
{
//    UIAlertView *a=[[UIAlertView alloc]initWithTitle:@"提示" message:error.domain delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
//    [a show];
//    NSLog(@"%@", error.domain);
}
- (void)recongnition:(YMIDCardRecognition *)YMIDCardRecognition didRecognitionResult:(NSArray *)array
{
  //  [self performSelectorOnMainThread:@selector(recongnitionResult:) withObject:array waitUntilDone:YES];
    _cloudAppointmentViewController.idCardInfo = array;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)getCancelProcess
{
    return NO;
}

- (void)setCancelProcess:(BOOL)isCance
{
    //self.isProgressCanceled = isCance;
}

@end
