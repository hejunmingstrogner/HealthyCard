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
#import "QRcodeViewController.h"
#import "ScanImageViewController.h"

#import <Masonry.h>
#import "Constants.h"

#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UIFont+Custom.h"
#import "NSDate+Custom.h"

#import "RzAlertView.h"
#import "YMIDCardRecognition.h"
#import "HCNavigationBackButton.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)
#define CloudController (GetUserType == 1 ? _cloudAppointmentViewController : _cloudAppointmentCompanyViewController)
#define HideKeyBoard (GetUserType == 1 ? [_cloudAppointmentViewController hideTheKeyBoard]: [_cloudAppointmentCompanyViewController hideTheKeyBoard])

@interface AppointmentViewController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate, YMIDCardRecognitionDelegate>
{
    //个人云预约
    CloudAppointmentViewController              *_cloudAppointmentViewController;
    //单位云预约
    CloudAppointmentCompanyViewController       *_cloudAppointmentCompanyViewController;
    
    ServicePointApointmentViewController        *_servicePointAppointmentViewController;
    
    HCNavigationBackButton                      *_QRScanButton;
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

-(void)setCityName:(NSString *)cityName{
    _cityName = cityName;
}


#pragma mark - Life Circle
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavgation];

    //加载界面布局
    self.currentView = [[UIView alloc] init];
    [self.view addSubview:self.currentView];
    [self.currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
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
    
    [self loadData];
}

- (void)initNavgation{
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
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


    _QRScanButton = [[HCNavigationBackButton alloc] initWithText:@"识别"];
    _QRScanButton.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [_QRScanButton addTarget:self action:@selector(QRScanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_QRScanButton];
    self.navigationItem.rightBarButtonItem = rightItem;

    if (GetUserType == 1){
        _QRScanButton.hidden = NO;
    }else{
        _QRScanButton.hidden = YES;
    }
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
            if (GetUserType == 1)
                _QRScanButton.hidden = NO;
            [_servicePointAppointmentViewController.view setHidden:YES];
            self.currentVC = CloudController;
        }
            break;
        case 1:
        {
            _QRScanButton.hidden = YES;
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)QRScanButtonClicked:(UIButton*)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.videoQuality=UIImagePickerControllerQualityTypeLow;
        imagePicker.delegate = self;
        imagePicker.showsCameraControls = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"开启摄像头权限后，才能使用该功能" removeDelay:2];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    __weak typeof (self) wself = self;
    UIImage *originImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [wself reSizeImage:originImage toSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [picker dismissViewControllerAnimated:YES completion:nil];

            [RzAlertView ShowWaitAlertWithTitle:@"身份证信息解析中"];


            [YMIDCardRecognition recongnitionWithCard:image delegate:wself];
        });
    });
}

- (void)recongnition:(YMIDCardRecognition *)YMIDCardRecognition didFailWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [RzAlertView CloseWaitAlert];
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"身份信息解析失败，请重试" removeDelay:3];
    });
    NSLog(@"身份证解析失败：%@", error.domain);
}
- (void)recongnition:(YMIDCardRecognition *)YMIDCardRecognition didRecognitionResult:(NSArray *)array
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [RzAlertView CloseWaitAlert];
        _cloudAppointmentViewController.idCardInfo = array;
    });
}

- (BOOL)getCancelProcess
{
    return NO;
}

- (void)setCancelProcess:(BOOL)isCance
{
    //self.isProgressCanceled = isCance;
}

#pragma mark - Public Methods
-(void)loadData
{
    _cloudAppointmentCompanyViewController.cityName = _cityName;
    _cloudAppointmentViewController.cityName = _cityName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}




@end
