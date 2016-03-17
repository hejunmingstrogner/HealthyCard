//
//  CloudAppointmentDateVC.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CloudAppointmentDateVC.h"

#import "Constants.h"
#import "HCWheelView.h"
#import "HealthyCertificateView.h"

#import <Masonry.h>

#import "NSDate+Custom.h"
#import "NSString+Custom.h"
#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UIColor+Expanded.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

#define Text_Font FIT_FONTSIZE(24)
#define Btn_Font FIT_FONTSIZE(23)

@interface CloudAppointmentDateVC()<UITableViewDataSource,UITableViewDelegate,HCWheelViewDelegate>
{
    HCWheelView             *_beginDateWheelView;
    HCWheelView             *_endDateWheelView;
    UITableView             *_tableView;

    bool                     _isBeginDate;
    
    NSMutableArray          *_beginWheelArr;
    NSMutableArray          *_endWheelArr;
}
@end


@implementation CloudAppointmentDateVC
#pragma mark - Setter & Getter
-(void)setBeginDateString:(NSString *)beginDateString{
    _beginDateString = beginDateString;
    NSDate* nextDay = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([[NSDate date] timeIntervalSinceReferenceDate] + 24*3600)];
    _beginWheelArr = [nextDay nextServerDays:7];
}

-(void)setEndDateString:(NSString *)endDateString{
    _endDateString = endDateString;
    NSDate* nextDay = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:
                       ([[NSDate formatDateFromChineseString:_beginDateString] timeIntervalSinceReferenceDate])];
    _endWheelArr = [nextDay nextServerDays:7];
}

-(void)initData
{
    _beginDateWheelView.pickerViewContentArr = _beginWheelArr;
    _endDateWheelView.pickerViewContentArr = _endWheelArr;
    
    for (NSInteger index = 0; index < _beginDateWheelView.pickerViewContentArr.count; ++index){
        if ([_beginDateWheelView.pickerViewContentArr[index] isEqualToString:_beginDateString]){
            [_beginDateWheelView.pickerView selectRow:index inComponent:0 animated:NO];
            break;
        }
    }
    
    for (NSInteger index = 0; index < _endDateWheelView.pickerViewContentArr.count; ++index){
        if ([_endDateWheelView.pickerViewContentArr[index] isEqualToString:_endDateString]){
            [_endDateWheelView.pickerView selectRow:index inComponent:0 animated:NO];
            break;
        }
    }
}


#pragma mark - Public Methods
-(void)getAppointDateStringWithBlock:(AppointmentDateStringBlock)block;
{
    _appointmentBlock = block;
}

#pragma mark - Life Circle
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self initNavgation];
    
    _tableView = [[UITableView alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.layer.borderWidth = 1;
    _tableView.layer.borderColor = MO_RGBCOLOR(240, 240, 240).CGColor;
    _tableView.backgroundColor = MO_RGBCOLOR(250, 250, 250);
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.mas_equalTo(self.view);
//        make.height.mas_equalTo(SCREEN_HEIGHT - kNavigationBarHeight - kStatusBarHeight);
        make.top.mas_equalTo(self.view).with.offset(FIT_HEIGHT(20));
        make.left.right.bottom.mas_equalTo(self.view);
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
    [self initData];
}

- (void)initNavgation
{
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(dateBackBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    self.title = @"预约日期选择";
    
    
    UIButton* rightBtn = [UIButton buttonWithTitle:@"确定"
                                              font:[UIFont fontWithType:UIFontOpenSansRegular size:17]
                                         textColor:[UIColor colorWithRGBHex:HC_Blue_Text]
                                   backgroundColor:[UIColor clearColor]];
    [rightBtn addTarget:self action:@selector(dateSureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
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
    cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:Text_Font];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:Text_Font];
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

#pragma mark - NavViewDelegate
-(void)dateBackBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dateSureBtnClicked:(id)sender{
    _appointmentBlock([NSString combineString:_beginDateString And:_endDateString With:@"~"]);
    [self.navigationController popViewControllerAnimated:YES];
}

//改变footerview的颜色
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = MO_RGBCOLOR(250, 250, 250);
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





@end
