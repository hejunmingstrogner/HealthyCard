//
//  PostVeitifyViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/31.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "PostVeitifyViewController.h"

#import "Constants.h"

#import <Masonry.h>
#import <MJExtension.h>

#import "UnitRegisterTitleView.h"
#import "PostVeitifyPicInfoView.h"
#import "HCBackgroundColorButton.h"

#import "UILabel+Easy.h"
#import "UIColor+Expanded.h"
#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UIImage+Rotate.h"

#import "TakePhoto.h"
#import "HttpNetworkManager.h"
#import "RzAlertView.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@implementation PostVeitifyViewController
{
    PostVeitifyPicInfoView      *_businessCard;
    PostVeitifyPicInfoView      *_idCard;
}

#pragma mark - UIViewController overrides
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRGBHex:HC_Base_BackGround];
    
    UnitRegisterTitleView* titleView = [[UnitRegisterTitleView alloc] init];
    titleView.title = @"营业执照";
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kNavigationBarHeight + kStatusBarHeight);
        make.height.mas_equalTo(40);
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
    }];
    
    
    __weak typeof (self) wself = self;
    _businessCard =[[PostVeitifyPicInfoView alloc] init];
    _businessCard.title = @"营业执照";
    [self.view addSubview:_businessCard];
    [_businessCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom).with.offset(15);
        make.left.equalTo(self.view).with.offset(15);
        make.width.mas_equalTo( (SCREEN_WIDTH - 40) / 2);
        make.height.mas_equalTo( (SCREEN_WIDTH - 40) / 2);
    }];
    _businessCard.postVeitifyPicInfoViewBlock = ^(){
        [[TakePhoto getInstancetype] takePhotoFromCurrentController:wself resultBlock:^(UIImage *photoimage) {
            __strong typeof (self) sself = wself;
            UIImage* scaleImage = [wself imageCompressForSize:photoimage targetSize:sself->_businessCard.imageView.frame.size];
            sself->_businessCard.image = scaleImage;
        }];
    };
    
    
    _idCard = [[PostVeitifyPicInfoView alloc] init];
    _idCard.title = @"身份证";
    [self.view addSubview:_idCard];
    [_idCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom).with.offset(15);
        make.left.equalTo(_businessCard.mas_right).with.offset(10);
        make.width.mas_equalTo( (SCREEN_WIDTH - 40) / 2);
        make.height.mas_equalTo( (SCREEN_WIDTH - 40) / 2);
    }];
    _idCard.postVeitifyPicInfoViewBlock = ^(){
        [[TakePhoto getInstancetype] takePhotoFromCurrentController:wself resultBlock:^(UIImage *photoimage) {
            __strong typeof (self) sself = wself;
            UIImage* scaleImage = [wself imageCompressForSize:photoimage targetSize:sself->_businessCard.imageView.frame.size];
            sself->_idCard.image = scaleImage;
        }];
    };
    
    
    
    UILabel* tipLabel = [UILabel labelWithText:@"请保证照片真实清晰"
                                          font:[UIFont fontWithType:UIFontOpenSansRegular
                                                               size:FIT_FONTSIZE(26)]
                                     textColor:[UIColor colorWithRGBHex:HC_Gray_Text]];
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_businessCard.mas_bottom).with.offset(20);
    }];
    
    HCBackgroundColorButton* regBtn = [[HCBackgroundColorButton alloc] init];
    [regBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue] forState:UIControlStateNormal];
    [regBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue_Pressed] forState:UIControlStateHighlighted];
    [regBtn setTitle:@"注册" forState:UIControlStateNormal];
    [regBtn addTarget:self action:@selector(regBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    regBtn.layer.cornerRadius = 5;
    [self.view addSubview:regBtn];
    [regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.top.equalTo(tipLabel.mas_bottom).with.offset(20);
        make.height.mas_equalTo(40);
    }];
    
    [self initNavigation];
}

#pragma mark - Action
-(void)regBtnClicked:(UIButton*)sender
{
//    if (_businessCard.image == nil){
//        [RzAlertView showAlertLabelWithTarget:self.view Message:@"请上传营业执照" removeDelay:2];
//        return;
//    }
//    
//    if (_idCard.image == nil){
//        [RzAlertView showAlertLabelWithTarget:self.view Message:@"请上传身份证" removeDelay:2];
//        return;
//    }
    [RzAlertView ShowWaitAlertWithTitle:@"上传信息中"];

    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
}

-(void)delayMethod
{
    [self reloadLoginInfo];
//    [[HttpNetworkManager getInstance] createOrUpdateBRServiceInformationwithInfor:_brServiceUnit.mj_keyValues resultBlock:^(BOOL successed, NSError *error) {
//        [RzAlertView CloseWaitAlert];
//        if (successed){
//            //返回根界面
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }else{
//            [RzAlertView showAlertLabelWithTarget:self.view Message:@"注册失败" removeDelay:2];
//        }
//    }];
}

-(void)backToPre:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Methods
-(void)reloadLoginInfo
{
    [[HttpNetworkManager getInstance] createOrUpdateBRServiceInformationwithInfor:_brServiceUnit.mj_keyValues resultBlock:^(BOOL successed, NSError *error) {
        [RzAlertView CloseWaitAlert];
        if (successed){
            //返回根界面
            
            //获取登录信息 返回根界面
            [[HttpNetworkManager getInstance] findUserInfoByPhone:GetUserName resultBlock:^(NSDictionary *result, NSError *error) {
                if (error || result == nil){
                    SetUserName(@"");
                    SetToken(@"");
                    SetUserRole(@"");
                    [RzAlertView showAlertLabelWithTarget:self.view Message:@"注册失败" removeDelay:2];
                    return;
                }
                
                NSDictionary* unitInfo = [result objectForKey:@"unitInfo"];
                gUnitInfo = [BRServiceUnit mj_objectWithKeyValues:unitInfo];
                
                NSDictionary* personalInfo = [result objectForKey:@"customer"];
                gCustomer = [Customer mj_objectWithKeyValues:personalInfo];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }else{
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"注册失败" removeDelay:2];
        }
    }];
}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 3.0);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}


-(void)initNavigation
{
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    self.title = @"单位注册";
}



@end
