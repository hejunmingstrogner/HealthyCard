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
#import "UIFont+Custom.h"
#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface AddWorkerViewController()
{
    NSMutableArray *_workerData;       // 原始的员工数据
    NSMutableArray *_needCanleWorkerDateArray;  // 封装的需要过滤的员工数据
    NSMutableArray *_workerArray;      // 封装的员工数据
    NSMutableArray *_selectWorkerArray;    // 选择的员工   返回的选择的数据
    
    UILabel        *_seletingCountLabel;
    RzAlertView    *_waitAlertView;
    
    UITableView    *_tableView;
    
    UIButton       *_comfirmBtn; // 确定
}
@end

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
    
    _seletingCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    _seletingCountLabel.textAlignment = NSTextAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_seletingCountLabel];
    [_seletingCountLabel setText:@"已添加" Font:[UIFont systemFontOfSize:17] count:_selectedWorkerArray.count endColor:[UIColor blueColor]];
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
    // 对选择过的员工进行筛选
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (Customer *custom in _selectWorkerArray) {
        [array addObject:custom.custCode];
    }
    
    [[HttpNetworkManager getInstance] getUnitsCustomersWithoutCheck:_cUnitCode resultBlock:^(NSArray *result, NSError *error) {
        [_waitAlertView close];
        if (!error) {
            if(result.count == 0)
            {
                [RzAlertView showAlertLabelWithTarget:self.view Message:@"没有员工数据..." removeDelay:3];
                return ;
            }
            // 对员工进行排序
            _workerData = [NSMutableArray arrayWithArray:[self sortWorkList:result]];
            //            // 过滤掉已经选择过的员工
            //            if (_needcanlceWorkersArray.count != 0) {
            //                _needCanleWorkerDateArray = [[NSMutableArray alloc]init];
            //                for (int i = 0; i< _needcanlceWorkersArray.count; i++) {
            //                    Customer *customer = _needcanlceWorkersArray[i];
            //                    AddWorkerCellItem *cellItem = [[AddWorkerCellItem alloc]initWithName:customer.custName phone:customer.linkPhone endDate:customer.lastCheckTime selectFlag:1];
            //                    [_needCanleWorkerDateArray addObject:cellItem];
            //                    for (int j = 0; j < _workerData.count; j++) {
            //                        if ([((Customer *)_workerData[j]).custCode isEqualToString:((Customer *)_needcanlceWorkersArray[i]).custCode]) {
            //                            [_workerData removeObjectAtIndex:j];
            //                            break;
            //                        }
            //                    }
            //                }
            //            }
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
    }];
}
#pragma mark -对得到的员工进行排序
// 对得到的员工进行排序
- (NSArray *)sortWorkList:(NSArray *)works
{
    NSMutableArray *worksArray = [NSMutableArray arrayWithArray:works];
    [worksArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Customer *customer1 = (Customer *)obj1;
        Customer *customer2 = (Customer *)obj2;
        return customer1.lastCheckTime > customer2.lastCheckTime;
    }];
    
    return [NSArray arrayWithArray:worksArray];
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
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
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
    return 1;
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
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *uiview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerview"];
    if (!uiview) {
        uiview = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"headerview"];
        AddWorkerTableViewCell *cell = [[AddWorkerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"haed"];
        cell.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        cell.nameLabel.text = @"姓名";
        cell.phoneLabel.text = @"电话";
        cell.endDateLabel.text = @"到期时间";
        cell.selectImageView.hidden = YES;
        [uiview addSubview:cell];
    }
    return uiview;
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
