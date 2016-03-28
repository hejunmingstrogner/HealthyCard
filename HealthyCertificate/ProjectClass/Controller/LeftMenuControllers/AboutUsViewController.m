//
//  AboutUsViewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "AboutUsViewController.h"

#import <Masonry.h>

#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UILabel+Easy.h"

#import "Constants.h"
#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@implementation AboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initSubviews];
}

- (void)initNavgation
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于我们";
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
    _titleArray = [NSMutableArray arrayWithObjects:@"软件版本", @"最新版本", @"官方网址", @"微信公众号", nil];

    // 当前版本号
//    NSString *currentVision = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *currentVision = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    // 最新版本号
    NSString *newVision = currentVision;

    NSString *theUrl = @"www.zeekstar.com";

    _detialArray = [NSMutableArray arrayWithObjects:currentVision, newVision, theUrl, @"健康证在线", nil];
    
    UIImageView* titleImageView = [[UIImageView alloc] init];
    titleImageView.image = [UIImage imageNamed:@"AboutUs"];
    [self.view addSubview:titleImageView];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(10 + kNavigationBarHeight + kStatusBarHeight);
        make.centerX.mas_equalTo(self.view);
    }];
    
    UILabel* titleLabel = [UILabel labelWithText:@"健康证在线"
                                       font:[UIFont fontWithType:UIFontOpenSansBold size:FIT_FONTSIZE(32)]
                                  textColor:[UIColor grayColor]];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleImageView.mas_bottom).with.offset(10);
        make.centerX.mas_equalTo(self.view);
    }];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(10);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self cellhieght];
    }
    return 44;
}

- (CGFloat)cellhieght
{
    UIFont *fnt = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)];
    NSString *text = @"        健康证在线是一款体检、就诊以及办理健康证为一体的操作APP。由知康科技有限公司和智行电子科技有限公司共同开发。";

    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];
    return tmpRect.size.height + 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)];
        cell.detailTextLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(23)];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }

    if (indexPath.section == 0) {
        cell.textLabel.text = @"        健康证在线是一款体检、就诊以及办理健康证为一体的操作APP。由知康科技有限公司和智行电子科技有限公司共同开发。";
    }
    else
    {
        cell.textLabel.text = _titleArray[indexPath.row];
        cell.detailTextLabel.text = _detialArray[indexPath.row];
    }

    return cell;
}
@end
