//
//  PhysicalExaminationViewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "PhysicalExaminationViewController.h"

#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"
#import "Constants.h"
#import "ConsumerAgreement.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@implementation PhysicalExaminationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initSubviews];
}

- (void)initNavgation
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注意事项";
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
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    _titleArray = [NSMutableArray arrayWithObjects:@"检查事项", @"操作注意事项", @"用户协议", nil];
    NSString *test1 = @"    1.体检前一天，切勿饮酒、吸烟，不要饮用高蛋白、油腻腥辣性食物，切勿饮用药物，注意休息，以免影响肝功能化验结果。\n\n    2.体检时，女性在生理期期间，可以不用做肛检。\n\n    3.孕妇/准备怀孕者，切忌不要做胸透。\n";
    NSString *test2 = @"    1.请您填写信息时填写真实信息，方便您在检查时减少填写时间。\n\n    2.请您使用扫一扫功能时，用身份证进行扫描，获取你的真实信息。\n\n    3.请携带身份证原件。";
    NSString *test3 = @"";
    _detailArray = [NSMutableArray arrayWithObjects:test1, test2, test3, nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 10;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return [self cellhieght:_detailArray[indexPath.section]];
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.textLabel.numberOfLines = 0;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = _titleArray[indexPath.section];
        cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:17];
        cell.textLabel.textColor = [UIColor blackColor];
        if (indexPath.section == 2) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = _detailArray[indexPath.section];
        cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:16];
        cell.textLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
    }
    return cell;
}

- (CGFloat)cellhieght:(NSString *)text
{
    UIFont *fnt = [UIFont fontWithType:UIFontOpenSansRegular size:16];

    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];
    return tmpRect.size.height + 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 2){
        // 用户协议
        ConsumerAgreement *consumer = [[ConsumerAgreement alloc]init];
        [self.navigationController pushViewController:consumer animated:YES];
    }
}
@end
