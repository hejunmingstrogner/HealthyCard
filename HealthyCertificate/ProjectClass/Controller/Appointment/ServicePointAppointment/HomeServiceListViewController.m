//
//  HomeServiceListViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/4/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "HomeServiceListViewController.h"

#import <Masonry.h>

#import "Constants.h"

#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"
#import "UILabel+Easy.h"

#import "HttpNetworkManager.h"
#import "RzAlertView.h"

#import "ServersPositionAnnotionsModel.h"


@interface HomeServiceListViewController()<UITableViewDelegate, UITableViewDataSource>
@end


@implementation HomeServiceListViewController
{
    NSMutableArray                  *_homeServiceArr;
    UITableView                     *_tableView;
    NSMutableArray                  *_searchArr;
    
    UITextField                     *_textFiled;
    
    
}

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

#pragma mark - UIViewController overrides
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIView* topContainerView = [[UIView alloc] init];
    topContainerView.backgroundColor = [UIColor colorWithRGBHex:HC_Base_BackGround];
    [self.view addSubview:topContainerView];
    [topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(kNavigationBarHeight+kStatusBarHeight);
        make.height.mas_equalTo(PXFIT_HEIGHT(120));
    }];
    
    _textFiled = [[UITextField alloc] init];
    [topContainerView addSubview:_textFiled];
    [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topContainerView);
        make.height.mas_equalTo(PXFIT_HEIGHT(80));
        make.width.mas_equalTo(SCREEN_WIDTH - 40);
    }];
    _textFiled.placeholder = @"请选择服务机构";
    _textFiled.layer.cornerRadius = 5;
    _textFiled.layer.borderColor = [UIColor colorWithRGBHex:HC_Gray_Line].CGColor;
    _textFiled.layer.borderWidth = 0.5;
    _textFiled.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    _textFiled.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)];
    _textFiled.backgroundColor = [UIColor whiteColor];
    _textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFiled.text = _selectedSpModel == nil ? @"" : _selectedSpModel.name;
    
    UILabel* label = [UILabel labelWithText:@"    您附近没有合适的上门体检服务点,请通过快速预约告之您的体检位置和体检时间,我们会及时安排体检车上门为您体检办证!"
                                       font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(26)]
                                  textColor:[UIColor colorWithRGBHex:HC_Gray_Text]];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).with.offset(10);
        make.right.mas_equalTo(self.view).with.offset(-10);
    }];

    
    
    _tableView = [[UITableView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topContainerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _homeServiceArr = [[NSMutableArray alloc] init];
    _searchArr = [[NSMutableArray alloc] init];
    
    [self loadData];
    
    [self initNavgation];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_textFiled];
}


#pragma mark - Private Methods
- (void)initNavgation
{
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    self.title = @"体检机构";
    
    UIButton* sureBtn = [UIButton buttonWithTitle:@"确定"
                                              font:[UIFont fontWithType:UIFontOpenSansRegular size:17]
                                         textColor:[UIColor colorWithRGBHex:HC_Blue_Text]
                                   backgroundColor:[UIColor clearColor]];
    [sureBtn addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:sureBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

}

-(void)loadData
{
    [RzAlertView ShowWaitAlertWithTitle:@"获取机构列表中..."];
    [[HttpNetworkManager getInstance] getFixedSizeCheckSites:gCurrentCityName Coordinate2D:_centerCoordinate resultBlock:^(NSArray *result, NSError *error) {
        [RzAlertView CloseWaitAlert];
        if (error || result.count == 0){
            _tableView.hidden = YES;
            return;
        }
        
        [_homeServiceArr removeAllObjects];
        for (ServersPositionAnnotionsModel* spModel in result){
            if (spModel.type == 0 && (spModel.checkMode & 4) != 0){
                [_homeServiceArr addObject:spModel];
            }
        }
        
        if (_homeServiceArr.count == 0){
            _tableView.hidden = YES;
            return;
        }else{
            [self searchContent:_selectedSpModel == nil ? @"" : _selectedSpModel.name];
        }
        
        _tableView.hidden = NO;
    }];
}

-(void)searchContent:(NSString*)content
{
    [_searchArr removeAllObjects];
    NSString *resultStr = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (resultStr.length == 0){
        for (ServersPositionAnnotionsModel* spModel in _homeServiceArr){
            [_searchArr addObject:spModel];
        }
        [_tableView reloadData];
        return;
    }
    
    for (ServersPositionAnnotionsModel* spModel in _homeServiceArr){
        if ([spModel.name containsString:content]){
            [_searchArr addObject:spModel];
        }
    }
    
    BOOL flag = NO;
    for (ServersPositionAnnotionsModel* spModel in _searchArr){
        if (flag == NO && _selectedSpModel != nil && [_selectedSpModel.id isEqualToString:spModel.id])
            flag = YES;
    }

    //如果已经有勾选的，且没有筛选出来，就强制加入
    if (_selectedSpModel != nil && flag == NO){
        [_searchArr insertObject:_selectedSpModel atIndex:0];
    }
    
    [_tableView reloadData];
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    [self searchContent:textField.text];
}

#pragma mark - Action
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sureBtnClicked:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(choosedServerPoint:)]){
        [_delegate choosedServerPoint:_selectedSpModel];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _searchArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeServiceListViewController class])];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([HomeServiceListViewController class])];
    }
    cell.textLabel.text = ((ServersPositionAnnotionsModel*)_searchArr[indexPath.row]).name;
    cell.detailTextLabel.text = ((ServersPositionAnnotionsModel*)_searchArr[indexPath.row]).address;
    
    cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)];
    cell.detailTextLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(22)];
    cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
    
    if (_selectedSpModel != nil && [_selectedSpModel.id isEqualToString:((ServersPositionAnnotionsModel*)_searchArr[indexPath.row]).id]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellStyleDefault;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PXFIT_HEIGHT(100);
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_selectedSpModel.id isEqualToString:((ServersPositionAnnotionsModel*)_searchArr[indexPath.row]).id]){
        _textFiled.text = @"";
        _selectedSpModel = nil;
    }else{
        _textFiled.text = ((ServersPositionAnnotionsModel*)_searchArr[indexPath.row]).name;
        _selectedSpModel = _searchArr[indexPath.row];
    }
    [self searchContent:_textFiled.text];
}

@end
