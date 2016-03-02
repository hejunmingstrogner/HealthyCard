//
//  PhysicalExaminationViewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "PhysicalExaminationViewController.h"
#import "UIFont+Custom.h"

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
    self.title = @"体检注意事项";
    // 返回按钮
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(0, 0, 30, 30);
    [backbtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [backbtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
}
// 返回前一页
- (void)backToPre:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)initSubviews
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    _titleArray = [NSMutableArray arrayWithObjects:@"体检事项", @"操作注意事项", @"用户协议", nil];
    NSString *test1 = @"    1.体检前几天请注意休息，饮食清淡，不喝酒，不熬夜，体检当天需空腹验血，不要吃早餐也不能喝水。\n    2.体检之前一定要控制情绪，保持好心情也能让体检顺利进行，如果情绪低落或者激动会导致一些检查不准确的。\n    3.体检最好在上午7：00-9：00做，因为抽血项目需要在上午十点之前做完，这样体检效果会比较好。另外，女性体检最好选择非月经期，最好在月经结束一周后检查比较好。\n    4.携带身份证原件，有些医院的体检表需要贴一张近期彩照。";
    NSString *test2 = @"    1.请您填写信息时填写真实信息，方便您在检查时减少填写时间。\n    2.请您使用扫一扫功能时。用身份证进行扫描。获取你的真实信息。\n    3.携带身份证原件。";
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
        if (indexPath.section == 2) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = _detailArray[indexPath.section];
        cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    }
    return cell;
}

- (CGFloat)cellhieght:(NSString *)text
{
    UIFont *fnt = [UIFont systemFontOfSize:16];

    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];
    return tmpRect.size.height + 20;
}
@end
