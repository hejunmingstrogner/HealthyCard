//
//  AddWorkerViewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/24.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "AddWorkerViewController.h"
#import <Masonry.h>
#import "AddWorkerTableViewCell.h"
#import "HttpNetworkManager.h"
#import "Constants.h"

#import "UILabel+FontColor.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UIColor+Expanded.h"
#import "NSDate+Custom.h"
#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@implementation AddWorkerViewController

typedef NS_ENUM(NSInteger, CompanyListTextFiledTag)
{
    CompanyList_PhoneNumber = 3001,
    CompanyList_LinkPerson
};


- (void)viewDidLoad
{
    [super viewDidLoad];

    _workerData = [NSMutableArray array];
    _workerArray = [NSMutableArray array];
    _selectWorkerArray = [NSMutableArray arrayWithArray:_selectedWorkerArray];

    [self initNavgation];

    [self initSubViews];

    [self getData];
}

- (void)initNavgation
{
    self.title = @"添加员工列表";  // 车辆牌照
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;

    _seletingCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 44)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_seletingCountLabel];
    [_seletingCountLabel setText:@"已添加" Font:[UIFont systemFontOfSize:17] count:_selectWorkerArray.count endColor:[UIColor blueColor]];
}
// 返回前一页
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getWorkerArrayWithBlock:(AddWorkerComfirmClicked)block
{
    _block = block;
}

- (void)getData
{
    if (!_waitAlertView) {
        _waitAlertView = [[RzAlertView alloc]initWithSuperView:self.view Title:@"数据获取中..."];
    }
    [_waitAlertView show];

    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (Customer *custom in _selectWorkerArray) {
        [array addObject:custom.custCode];
    }

    [[HttpNetworkManager getInstance] getWorkerCustomerDataWithcUnitCode:gCompanyInfo.cUnitCode resultBlock:^(NSArray *result, NSError *error) {
        if(result.count == 0)
        {
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"没有员工数据..." removeDelay:3];
        }
        if (!error) {
            _workerData = [NSMutableArray arrayWithArray:result];
            // 过滤掉已经选择过的员工
            if (_needcanlceWorkersArray.count != 0) {
                for (int i = 0; i< _needcanlceWorkersArray.count; i++) {
                    for (int j = 0; j < _workerData.count; j++) {
                        if ([((Customer *)_workerData[j]).custCode isEqualToString:((Customer *)_needcanlceWorkersArray[i]).custCode]) {
                            [_workerData removeObjectAtIndex:j];
                            break;
                        }
                    }
                }
            }
            [_workerArray removeAllObjects];
            for (Customer *customer in _workerData) {
                AddWorkerCellItem *cellItem;
                if ([array containsObject:customer.custCode]) {
                    cellItem = [[AddWorkerCellItem alloc]initWithName:customer.custName phone:customer.linkPhone endDate:customer.lastCheckTime selectFlag:1];
                }
                else{
                    cellItem = [[AddWorkerCellItem alloc]initWithName:customer.custName phone:customer.linkPhone endDate:customer.lastCheckTime selectFlag:0];
                }
                [_workerArray addObject:cellItem];
            }
            [_tableView reloadData];
        }
        else {
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"数据获取失败，请检查网络后重试" removeDelay:3];
        }
        [_waitAlertView close];
    }];
}

- (void)initSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    _comfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_comfirmBtn];
    [_comfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.bottom.equalTo(self.view).offset(-10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(40);
    }];
    _comfirmBtn.layer.masksToBounds = YES;
    _comfirmBtn.layer.cornerRadius = 5;
    [_comfirmBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue]];
    [_comfirmBtn setTitle:@"确   定" forState:UIControlStateNormal];
    [_comfirmBtn setTitleColor:[UIColor colorWithWhite:0.99 alpha:1] forState:UIControlStateNormal];
    [_comfirmBtn addTarget:self action:@selector(comfirmBtnCliked:) forControlEvents:UIControlEventTouchUpInside];

    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(_comfirmBtn.mas_top).offset(-10);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    UILabel *fenge = [[UILabel alloc]init];
    [self.view addSubview:fenge];
    [fenge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom).offset(1);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(1);
    }];
    fenge.layer.borderColor = [UIColor lightGrayColor].CGColor;
    fenge.layer.borderWidth = 1;
}

- (void)comfirmBtnCliked:(UIButton *)sender
{
    if (_block) {
        _block(_selectWorkerArray);
    }

    [self backToPre:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_workerArray.count != 0) {
        return 1;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _workerArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AddWorkerTableViewCell *cell = [[AddWorkerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"haed"];
    cell.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    cell.nameLabel.text = @"姓名";
    cell.phoneLabel.text = @"电话";
    cell.endDateLabel.text = @"到期时间";
    cell.selectImageView.hidden = YES;
    UILabel *label = [[UILabel alloc]init];
    label.text = @"选择";
    label.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cell.selectImageView);
        make.left.equalTo(cell.selectImageView).offset(-10);
        make.right.equalTo(cell.selectImageView).offset(10);
        make.top.bottom.equalTo(cell.contentView);
    }];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddWorkerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AddWorkerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell setCellItem:(AddWorkerCellItem *)_workerArray[indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddWorkerTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell changeSelectStatus:(AddWorkerCellItem *)_workerArray[indexPath.row]];

    [_selectWorkerArray removeAllObjects];
    for (int i = 0; i < _workerArray.count; i++) {
        if (((AddWorkerCellItem *)_workerArray[i]).isSelectFlag == 1) {
            [_selectWorkerArray addObject:_workerData[i]];
        }
    }
    [_seletingCountLabel setText:@"已添加" Font:[UIFont systemFontOfSize:17] count:_selectWorkerArray.count endColor:[UIColor blueColor]];
}
@end
