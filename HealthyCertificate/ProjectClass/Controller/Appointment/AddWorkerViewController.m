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

#import "AddWorkerVController.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface AddWorkerViewController()<AddworkVControllerDelegate>
{
    NSMutableArray *_workersArray;  // 员工数据
    
    UILabel        *_seletingCountLabel;
    
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
    
    [self initNavgation];
    
    [self initSubViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    [RzAlertView ShowWaitAlertWithTitle:@"数据获取中..."];
    _selectWorkerArray = [[NSMutableArray alloc]init];
    _workersArray = [[NSMutableArray alloc]init];
    if(_contarctCode.length != 0){
        // 如果是已经预约过的，则查询获得合同关联的客户
        [[HttpNetworkManager getInstance] findCustomerTestByContract:_contarctCode resultBlock:^(NSArray *result, NSError *error) {
            if(!error){
                // 将得到的数据封装到数组中
                [self setworkersArraywithArray:result selectFlag:SELECT];
            }
            // 同时获得未完成体检的员工
            [[HttpNetworkManager getInstance] getUnitsCustomersWithoutCheck:_unitCode resultBlock:^(NSArray *result, NSError *error) {
                if (!error) {
                    // 将得到的数据封装到数组中
                    [self setworkersArraywithArray:result selectFlag:NOTSELECT];
                }
                [RzAlertView CloseWaitAlert];
                if (_workersArray.count == 0) {
                    [RzAlertView showAlertLabelWithTarget:self.view Message:@"没有数据" removeDelay:2];
                }
                else {
                    // 将已选中的项封装到数组中
                    [self setSelectedWorkerArrayToWorkersArray];
                    [_tableView reloadData];
                }
            }];
        }];
    }
    else {
        // 只获取单位下，未完成体检的员工
        [[HttpNetworkManager getInstance] getUnitsCustomersWithoutCheck:_unitCode resultBlock:^(NSArray *result, NSError *error) {
            [RzAlertView CloseWaitAlert];
            if (!error) {
                // 将得到的数据封装到数组中
                [self setworkersArraywithArray:result selectFlag:NOTSELECT];
            }
            if (_workersArray.count == 0) {
                [RzAlertView showAlertLabelWithTarget:self.view Message:@"没有数据" removeDelay:2];
            }
            else {
                // 将已选中的项封装到数组中
                [self setSelectedWorkerArrayToWorkersArray];
                [_tableView reloadData];
            }
        }];
    }
}
// 将得到的数据封装到数组中
- (void)setworkersArraywithArray:(NSArray *)array selectFlag:(SelectFlag)flag
{
    if (array.count == 0) {
        return;
    }
    NSArray *newarray = [self sortWorkList:array];
    if ([newarray[0] isKindOfClass:[CustomerTest class]]) {
        for (CustomerTest *customertest in newarray) {
            AddWorkerCellItem *item = [[AddWorkerCellItem alloc]initWithCustomer:nil customerTest:customertest selectFlag:flag];
            [_workersArray addObject:item];
        }
    }
    else {
        for (Customer *customer in newarray) {
            AddWorkerCellItem *item = [[AddWorkerCellItem alloc]initWithCustomer:customer customerTest:nil  selectFlag:flag];
            [_workersArray addObject:item];
        }
    }
}

// 将已选择的数据封装到数组中
- (void)setSelectedWorkerArrayToWorkersArray
{
//    if (_contarctCode.length == 0) {
//        return;
//    }
    // 对选择过的员工进行筛选
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (id testitem in _selectedWorkerArray) {
        if ([testitem isKindOfClass:[CustomerTest class]]) {
            [array addObject:((CustomerTest *)testitem).custCode];
        }
        else {
            [array addObject:((Customer *)testitem).custCode];
        }
    }
    for (int i = 0; i < _workersArray.count; i++) {
        AddWorkerCellItem *item = _workersArray[i];
        if (item.customer) {
            if ([array containsObject:item.customer.custCode]) {
                ((AddWorkerCellItem *)_workersArray[i]).isSelectFlag = SELECT;
            }
            else {
                ((AddWorkerCellItem *)_workersArray[i]).isSelectFlag = NOTSELECT;
            }
        }
        else {
            if ([array containsObject:item.customerTest.custCode]) {
                ((AddWorkerCellItem *)_workersArray[i]).isSelectFlag = SELECT;
            }
            else {
                ((AddWorkerCellItem *)_workersArray[i]).isSelectFlag = NOTSELECT;
            }
        }
    }
}

// 对得到的员工进行排序
- (NSArray *)sortWorkList:(NSArray *)works
{
    NSMutableArray *worksArray = [NSMutableArray arrayWithArray:works];
    [worksArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 isKindOfClass:[CustomerTest class]]) {
            CustomerTest *customer1 = (CustomerTest *)obj1;
            CustomerTest *customer2 = (CustomerTest *)obj2;
            return customer1.customer.lastCheckTime > customer2.customer.lastCheckTime;
        }
        else {
            Customer *customer1 = (Customer *)obj1;
            Customer *customer2 = (Customer *)obj2;
            return customer1.lastCheckTime > customer2.lastCheckTime;
        }
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
    return _workersArray.count;
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
    return 44;
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
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *uiview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footView"];
    if (!uiview) {
        uiview = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"footView"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [button setTitle:@"添加员工" forState:UIControlStateNormal];
        [uiview addSubview:button];
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        button.frame = frame;
        [button addTarget:self action:@selector(AddWorkerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return uiview;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddWorkerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AddWorkerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.cellitem = _workersArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(((AddWorkerCellItem *)_workersArray[indexPath.row]).customerTest){
        // 如果 不需要交钱 即  已经交钱，或者已经在体检或者体检完成，则不能去掉勾选
        if(![((AddWorkerCellItem *)_workersArray[indexPath.row]).customerTest isNeedToPay]){
            NSString *messga =[NSString stringWithFormat:@"%@的预约不能被修改",((AddWorkerCellItem *)_workersArray[indexPath.row]).customerTest.custName];
            [RzAlertView showAlertLabelWithTarget:self.view Message:messga removeDelay:2];
            return;
        }
    }
    AddWorkerTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell changeSelectStatus:_workersArray[indexPath.row]];
    
    [_selectWorkerArray removeAllObjects];
    for (int i = 0; i < _workersArray.count; i++) {
        if (((AddWorkerCellItem *)_workersArray[i]).isSelectFlag == 1) {
            if (((AddWorkerCellItem *)_workersArray[i]).customer) {
                [_selectWorkerArray addObject:((AddWorkerCellItem *)_workersArray[i]).customer];
            }
            else {
                [_selectWorkerArray addObject:((AddWorkerCellItem *)_workersArray[i]).customerTest];
            }
        }
    }
    [_seletingCountLabel setText:@"已添加" Font:[UIFont systemFontOfSize:17] count:_selectWorkerArray.count endColor:[UIColor blueColor]];
}

// 添加员工
- (void)AddWorkerBtnClicked:(UIButton *)sender
{
    AddWorkerVController *add = [[AddWorkerVController alloc]init];
    add.delegate = self;
    [self.navigationController pushViewController:add animated:YES];
}

#pragma mark - 添加员工成功的delegate
- (void)creatWorkerSucceed
{
    [RzAlertView showAlertLabelWithTarget:self.view Message:@"添加成功" removeDelay:2];
    [self getData];
}
@end
