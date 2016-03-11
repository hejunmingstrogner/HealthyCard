//
//  QRController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/9.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "QRController.h"

#import <ZXingObjCAztec.h>
#import <ZXMultiFormatWriter.h>
#import <Masonry.h>

#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"

#import "Constants.h"
#import "UMSocial.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

#define TOP_MARGIN FIT_FONTSIZE(40)
#define H_MARTIN FIT_FONTSIZE(72)

@interface QRController()<UMSocialUIDelegate>

{
    UIImageView*       _qrImageView;
    
    UIImage*           _testImage;
}

@end


@implementation QRController

-(void)viewDidLoad{
    [super viewDidLoad];
  //  [UMSocialConfig setSnsPlatformNames:@[UMShareToQQ, nil]];
    
    self.view.backgroundColor = [UIColor colorWithRGBHex:HC_Base_BackGround];
    
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:@"A string to encode"
                                  format:kBarcodeFormatQRCode
                                   width:SCREEN_WIDTH - 2 * H_MARTIN
                                  height:SCREEN_WIDTH - 2 * H_MARTIN
                                   error:&error];
    if (result) {
        _testImage = [UIImage imageWithCGImage: [ZXImage imageWithMatrix:result].cgimage];
        UIImage* image = [UIImage imageWithCGImage: [ZXImage imageWithMatrix:result].cgimage];
        
        _qrImageView = [[UIImageView alloc] initWithImage:image];
        [self.view addSubview:_qrImageView];
        [_qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.center.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view).with.offset(TOP_MARGIN + kNavigationBarHeight + kStatusBarHeight);
            make.centerX.mas_equalTo(self.view);
        }];
        
    } else {
        NSString *errorMessage = [error localizedDescription];
    }
    
    [self initNavgation];
}

- (void)initNavgation
{
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    self.title = @"二维码";
    
    UIButton* shareBtn = [UIButton buttonWithTitle:@"分享"
                                              font:[UIFont fontWithType:UIFontOpenSansRegular size:17]
                                         textColor:[UIColor colorWithRGBHex:HC_Blue_Text]
                                   backgroundColor:[UIColor clearColor]];
    [shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}


-(void)shareBtnClicked:(UIButton*)sender
{
    [UMSocialData defaultData].extConfig.qqData.shareImage = _testImage;
    [UMSocialData defaultData].extConfig.qzoneData.shareImage = _testImage;
    [UMSocialData defaultData].extConfig.wechatSessionData.shareImage = _testImage;
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage = _testImage;

    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"56e22bbd67e58e71f9000e8b"
                                      shareText:@"知康科技"
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:self];
}

// 返回前一页
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

//-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
//    socialData.shareImage = _testImage;
//}


@end
