//
//  AboutUsViewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "AboutUsViewController.h"
#import "UIFont+Custom.h"

#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"

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
    NSString *currentVision = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    // 最新版本号
    NSString *newVision = currentVision;

    NSString *theUrl = @"www.zeekstar.com";

    _detialArray = [NSMutableArray arrayWithObjects:currentVision, newVision, theUrl, @"健康证在线", nil];

    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
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
    UIFont *fnt = [UIFont systemFontOfSize:17];

    NSString *text = @"        知康是一款体检、就诊以及办理健康证为一体的操作APP。由知康科技有限公司和智行电子科技有限公司共同开发";

    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];
    return tmpRect.size.height + 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:17];
        cell.detailTextLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:16];
    }

    if (indexPath.section == 0) {
        cell.textLabel.text = @"        知康是一款体检、就诊以及办理健康证为一体的操作APP。由知康科技有限公司和智行电子科技有限公司共同开发";
    }
    else
    {
        cell.textLabel.text = _titleArray[indexPath.row];
        cell.detailTextLabel.text = _detialArray[indexPath.row];
    }

    return cell;
}
@end
