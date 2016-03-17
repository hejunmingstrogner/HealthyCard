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
#import <UIImageView+WebCache.h>

#import "HttpNetworkManager.h"

#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"
#import "UILabel+Easy.h"
#import "NSString+QRCode.h"

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
    self.view.backgroundColor = [UIColor colorWithRGBHex:HC_Base_BackGround];
    
    
    UILabel* tipLabel = [UILabel labelWithText:@"二维码生成中..."
                                          font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(26)]
                                     textColor:[UIColor blackColor]];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(TOP_MARGIN + kNavigationBarHeight + kStatusBarHeight);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo((NSInteger)(SCREEN_WIDTH - 2 * H_MARTIN));
        make.width.mas_equalTo((NSInteger)(SCREEN_WIDTH - 2 * H_MARTIN));
    }];
    
    _qrImageView = [[UIImageView alloc] init];
    [self.view addSubview:_qrImageView];
    [_qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(TOP_MARGIN + kNavigationBarHeight + kStatusBarHeight);
        make.centerX.mas_equalTo(self.view);
    }];
    
    _qrImageView.image = [_qrContent qrcodeImageWithSize:SCREEN_WIDTH - 2 * H_MARTIN];
    
    
    UIImageView* shareImageView = [[UIImageView alloc] init];
    NSString *str = [NSString stringWithFormat:@"%@customer/getPhoto?cCustCode=%@", [HttpNetworkManager baseURL], gPersonInfo.mCustCode];
    [shareImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil options:SDWebImageRefreshCached|SDWebImageRetryFailed];
    shareImageView.layer.masksToBounds = YES;
    shareImageView.layer.cornerRadius = 25;
    [self.view addSubview:shareImageView];
    [shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_qrImageView);
        make.height.mas_equalTo( (SCREEN_WIDTH-2*H_MARTIN) / 4);
        make.width.mas_equalTo((SCREEN_WIDTH-2*H_MARTIN) / 4);
    }];
    
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
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    [UMSocialData defaultData].extConfig.qqData.shareImage = _qrImageView.image;
  //  [UMSocialData defaultData].extConfig.qqData.title = @"qq消息";
    
    [UMSocialData defaultData].extConfig.qzoneData.shareImage = _qrImageView.image;
    
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeImage;
    [UMSocialData defaultData].extConfig.wechatSessionData.shareImage = _qrImageView.image;
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeImage;
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage = _qrImageView.image;

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



@end
