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

#import <Masonry.h>

#import "NSDate+Custom.h"
#import "NSString+Custom.h"
#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UIColor+Expanded.h"

#import "HCDateWheelView.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

#define Text_Font FIT_FONTSIZE(24)
#define Btn_Font FIT_FONTSIZE(23)

@interface CloudAppointmentDateVC()<UITableViewDataSource,UITableViewDelegate,HCDateWheelViewDelegate>
{
    UITableView             *_tableView;
    
    HCDateWheelView         *_dateWheelView;
}
@end


@implementation CloudAppointmentDateVC
#pragma mark - Setter & Getter
-(void)initData
{
    _dateWheelView.hContentArr = @[@"8点",@"9点", @"10点",@"11点",@"12点",@"13点",@"14点",@"15点",@"16点",@"17点"];
    NSDate* nextDay = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([[NSDate date] timeIntervalSinceReferenceDate] + 24*3600)];
    _dateWheelView.ymdContentArr = [nextDay nextServerDays:7];
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
        make.top.mas_equalTo(self.view).with.offset(FIT_HEIGHT(20));
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    _dateWheelView = [[HCDateWheelView alloc] init];
    [self.view addSubview:_dateWheelView];
    _dateWheelView.hidden = YES;
    _dateWheelView.delegate = self;
    [_dateWheelView mas_makeConstraints:^(MASConstraintMaker *make) {
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



#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
    cell.textLabel.text = @"预约日期";
    cell.detailTextLabel.text = _choosetDateStr;
    return cell;
}

#pragma mark - HCDateWheelViewDelegate
-(void)choosetDateStr:(NSString *)ymdStr HourStr:(NSString *)hourStr
{
    _choosetDateStr = [NSString stringWithFormat:@"%@%@", ymdStr, hourStr];
    [_tableView reloadData];
    _dateWheelView.hidden = YES;
}

-(void)cancelChoose
{
    _dateWheelView.hidden = YES;
}


#pragma mark - NavViewDelegate
-(void)dateBackBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dateSureBtnClicked:(id)sender{
    _appointmentBlock(_choosetDateStr);
    [self.navigationController popViewControllerAnimated:YES];
}

//改变footerview的颜色
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = MO_RGBCOLOR(250, 250, 250);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSRange range = [_choosetDateStr rangeOfString:@"日"];
    _dateWheelView.currentYMD = [_choosetDateStr substringToIndex:range.location+1];
    _dateWheelView.currentHour = [_choosetDateStr substringWithRange:NSMakeRange(range.location+1,_choosetDateStr.length-range.location-1)];
    _dateWheelView.hidden = NO;
    
}

@end
