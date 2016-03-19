//
//  ConsumerAgreement.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/18.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ConsumerAgreement.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "RzAlertView.h"
@interface ConsumerAgreement()<UIWebViewDelegate>
{
    UIWebView *webView;
    RzAlertView *waitAlertView;
    UIButton  *reloadBtn;
}
@end

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@implementation ConsumerAgreement
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initSubviews];

    [self loadURLView];
}

- (void)initNavgation
{
    self.title = @"用户协议";
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
}
// 返回前一页
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSubviews
{
    webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    webView.dataDetectorTypes = UIDataDetectorTypeAll;
    webView.delegate = self;
    [self.view addSubview:webView];

    reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reloadBtn.frame = self.view.frame;
    [self.view addSubview:reloadBtn];
    reloadBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [reloadBtn setTitle:@"点击重新加载" forState:UIControlStateNormal];
    [reloadBtn addTarget:self action:@selector(loadURLView) forControlEvents:UIControlEventTouchUpInside];
    [reloadBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    reloadBtn.hidden = YES;

    if (!waitAlertView) {
        waitAlertView = [[RzAlertView alloc]initWithSuperView:self.view Title:@"加载中..."];
    }
    [waitAlertView show];
}

- (void)loadURLView
{
    NSString *str = @"http://webserver.zeekstar.com/webserver/appProtocol.html";
    NSURL *url = [NSURL URLWithString:str];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [webView loadRequest:request];
}

#pragma mark -web delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    reloadBtn.hidden = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [waitAlertView close];
    reloadBtn.hidden = YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [waitAlertView close];
    reloadBtn.hidden = NO;
    [RzAlertView showAlertLabelWithTarget:self.view Message:@"加载失败，请检查网络后重试" removeDelay:3];
}

@end
