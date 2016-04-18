//
//  CompanySearchViewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/4/18.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CompanySearchViewController.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearchOption.h>
#import <Masonry.h>

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface CompanySearchViewController()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, BMKPoiSearchDelegate>
{
    UISearchBar *_searchBar;
    UITableView *_tableView;
    NSMutableArray *_resultArray;

    BMKPoiSearch *_searcher;
}
@end

@implementation CompanySearchViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initSubviews];

    [self initSearcher];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification  object:nil];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardBounds;//UIKeyboardFrameEndUserInfoKey
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).with.offset(-keyboardBounds.size.height);
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
    }];
}

- (void)initNavgation
{
    self.title =@"输入单位名称";
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;

    self.view.backgroundColor = [UIColor whiteColor];

//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [rightBtn setTitle:@"确认" forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    UIBarButtonItem *rigthBarItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClicked:)];
    self.navigationItem.rightBarButtonItem = rigthBarItem;
}
// 返回前一页
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSubviews
{
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];

    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(70);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];

    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchBar.mas_bottom).offset(10);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)initSearcher
{
    _searcher = [[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_resultArray.count == 0) {
        return nil;
    }
    return @"其他结果";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = ((BMKPoiInfo *)_resultArray[indexPath.row]).name;
    cell.detailTextLabel.text = ((BMKPoiInfo *)_resultArray[indexPath.row]).address;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(theCompanySearchResult:address:)]  && _delegate) {
        [_delegate theCompanySearchResult:((BMKPoiInfo *)_resultArray[indexPath.row]).name address:((BMKPoiInfo *)_resultArray[indexPath.row]).address];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightBtnClicked:(UIBarButtonItem *)sender
{
    if ([_delegate respondsToSelector:@selector(theCompanySearchResult:address:)]  && _delegate) {
        [_delegate theCompanySearchResult:_searchBar.text address:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -搜索 delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText   // called when text changes (including clear)
{
    BMKCitySearchOption *option = [[BMKCitySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.keyword = searchText;

    [_searcher poiSearchInCity:option];
}

#pragma mark - poi 结果delegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    _resultArray = [[NSMutableArray alloc]init];

    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        [_resultArray addObjectsFromArray:poiResult.poiInfoList];
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }

    [_tableView reloadData];
}
@end
