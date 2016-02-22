//
//  CloudAppointmentDateVC.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CloudAppointmentDateVC.h"

#import "NavView.h"
#import "Constants.h"
#import "HCWheelView.h"
#import "HealthyCertificateView.h"

#import <Masonry.h>

#import "NSDate+Custom.h"


@interface CloudAppointmentDateVC()<UITableViewDataSource,UITableViewDelegate,HCWheelViewDelegate>
{
    HCWheelView             *_beginDateWheelView;
    HCWheelView             *_endDateWheelView;
    UITableView             *_tableView;

    bool                     _isBeginDate;
}
@end


@implementation CloudAppointmentDateVC

#pragma mark - Life Circle
-(void)viewDidLoad{
    [super viewDidLoad];
    
    NavView* navView = [[NavView alloc] init];
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(kStatusBarHeight);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(kNavigationBarHeight);
    }];
    [navView setNavTitle:@"预约日期选择"];
    
    _tableView = [[UITableView alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.layer.borderWidth = 1;
    _tableView.layer.borderColor = MO_RGBCOLOR(240, 240, 240).CGColor;
    _tableView.backgroundColor = MO_RGBCOLOR(250, 250, 250);
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT - kNavigationBarHeight - kStatusBarHeight);
    }];
    
    _beginDateWheelView = [[HCWheelView alloc] init];
    [self.view addSubview:_beginDateWheelView];
    _beginDateWheelView.hidden = YES;
    _beginDateWheelView.delegate = self;
    [_beginDateWheelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT*1/3);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    _endDateWheelView = [[HCWheelView alloc] init];
    [self.view addSubview:_endDateWheelView];
    _endDateWheelView.hidden = YES;
    _endDateWheelView.delegate = self;
    [_endDateWheelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT*1/3);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
<<<<<<< HEAD
    [self loadData];
}

#pragma mark - HCWheelViewDelegate
-(void)sureBtnClicked:(NSString*)wheelText
{
    if (_isBeginDate){
        //更改enddate的值
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSDate *beginDate=[formatter dateFromString:wheelText];
        //起始日期一改变，则将终止日期的wheel内容改变
        _endDateWheelView.pickerViewContentArr = [beginDate nextServerDays:7];
        
        _beginDateWheelView.hidden = YES;
        _beginDateString = wheelText;
        
        NSDate* endDate = [formatter dateFromString:_endDateString];
        NSDate* maxDate = [formatter dateFromString:_endDateWheelView.pickerViewContentArr[6]];
        //如果设置起始日期大于终止日期 将显示的内容改变
        if ([beginDate compare:endDate] == NSOrderedDescending || [endDate compare:maxDate] == NSOrderedDescending){
            _endDateString = _endDateWheelView.pickerViewContentArr[1];
            [_tableView reloadData];
        }
        
    }else{
        _endDateWheelView.hidden = YES;
        
        _endDateString = wheelText;
    }
    
    [_tableView reloadData];
}

-(void)cancelButtonClicked
{
    if (_isBeginDate){
        _beginDateWheelView.hidden = YES;
    }else{
        _endDateWheelView.hidden = YES;
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return PXFIT_HEIGHT(20);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"CloudAppointmentDateCell";
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = MO_RGBCOLOR(240, 240, 240).CGColor;
    if (indexPath.section == 0){
        cell.textLabel.text = @"预约起始日期";
        cell.detailTextLabel.text = _beginDateString;
    }else{
        cell.textLabel.text = @"预约截止日期";
        cell.detailTextLabel.text = _endDateString;
    }
    return cell;
}

//改变footerview的颜色
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = MO_RGBCOLOR(250, 250, 250);
}

#pragma mark - Setter & Getter
-(NSString*)beginDateString{
    if (_beginDateString == nil)
        _beginDateString = [[NSString alloc] init];
    return _beginDateString;
}

-(NSString*)endDateString{
    if (_endDateString == nil)
        _endDateString = [[NSString alloc] init];
    return _endDateString;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        _isBeginDate = YES;
        NSInteger index = 0;
        for (; index < _beginDateWheelView.pickerViewContentArr.count; ++index){
            if ([_beginDateWheelView.pickerViewContentArr[index] isEqualToString:_beginDateString])
                break;
        }
        [_beginDateWheelView.pickerView selectRow:index inComponent:0 animated:NO];
        
        _beginDateWheelView.hidden = NO;
        _endDateWheelView.hidden = YES;
    }else{
        _isBeginDate = NO;
        NSInteger index = 0;
        for (; index < _endDateWheelView.pickerViewContentArr.count; ++index){
            if ([_endDateWheelView.pickerViewContentArr[index] isEqualToString:_endDateString])
                break;
        }
        [_endDateWheelView.pickerView selectRow:index inComponent:0 animated:NO];
        _endDateWheelView.hidden = NO;
        _beginDateWheelView.hidden = YES;
    }
}

#pragma mark - Private Methods
-(void)loadData
{
    NSMutableArray* beginWheelArr = [[NSMutableArray alloc] init];
    NSDate* nextDay = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([[NSDate date] timeIntervalSinceReferenceDate] + 24*3600)];
    beginWheelArr = [nextDay nextServerDays:7];
    _beginDateWheelView.pickerViewContentArr = beginWheelArr;
    _beginDateString = _beginDateWheelView.pickerViewContentArr[0];
=======
    UILabel* endDateLabelTitle = [[UILabel alloc] init];
    [self.view addSubview:endDateLabelTitle];
>>>>>>> rztime/master
    
    NSMutableArray* endWheelArra = [[NSMutableArray alloc] init];
    NSDate* afterDay = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([nextDay timeIntervalSinceReferenceDate] + 24*3600)];
    endWheelArra = [afterDay nextServerDays:7];
    _endDateWheelView.pickerViewContentArr = endWheelArra;
    _endDateString = _endDateWheelView.pickerViewContentArr[0];
}

@end
