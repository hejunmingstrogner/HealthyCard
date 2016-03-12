//
//  CompanyAppointmentListViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/11.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CompanyAppointmentListViewController.h"

#import <Masonry.h>

#import "UIFont+Custom.h"
#import "UIButton+HitTest.h"
#import "UIButton+Easy.h"
#import "UIColor+Expanded.h"
#import "NSDate+Custom.h"

#import "Constants.h"

#import "CloudCompanyAppointmentStaffCell.h"
#import "CloudCompanyAppointmentCell.h"
#import "CompanyItemListCell.h"


@interface CompanyAppointmentListViewController()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    UITextField *_contactPersonField;
    UITextField *_phoneNumField;
    UITextField *_exminationCountField;
}

@end


@implementation CompanyAppointmentListViewController

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)
#define TopMargin FIT_FONTSIZE(20)

typedef NS_ENUM(NSInteger, TEXTFILEDTAG)
{
    TEXTFIELD_CONTACT = 2001,
    TEXTFIELD_PHONE,
    TEXTFIELD_CONTACTCOUNT
};

#pragma mark - Life Circle
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self initNavigation];
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.mas_equalTo(self.view).with.offset(TopMargin);
        make.left.right.mas_equalTo(self.view);
        make.top.bottom.mas_equalTo(self.view);
    }];
    
    [tableView registerClass:[CloudCompanyAppointmentCell class] forCellReuseIdentifier:NSStringFromClass([CloudCompanyAppointmentCell class])];
    [tableView registerClass:[CloudCompanyAppointmentStaffCell class] forCellReuseIdentifier:NSStringFromClass([CloudCompanyAppointmentStaffCell class])];
    [tableView registerClass:[CompanyItemListCell class] forCellReuseIdentifier:NSStringFromClass([CompanyItemListCell class])];
}

-(void)initNavigation
{
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    self.title = @"我的合同";
    
    UIButton* editBtn = [UIButton buttonWithTitle:@"修改"
                                             font:[UIFont fontWithType:UIFontOpenSansRegular size:17]
                                        textColor:[UIColor colorWithRGBHex:HC_Blue_Text]
                                  backgroundColor:[UIColor clearColor]];
    [editBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

//#pragma mark - Setter & Getter
//-(void)setBrContract:(BRContract *)brContract
//{
//    _brContract = brContract;
//}


#pragma mark - Action
-(void)editBtnClicked:(UIButton*)sender
{
    
}

-(void)backToPre:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 2;
    }else{
        return 4;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return PXFIT_HEIGHT(20);
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = MO_RGBCOLOR(250, 250, 250);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 3){
        CloudCompanyAppointmentStaffCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CloudCompanyAppointmentStaffCell class])];
        // cell.staffCount = _customerArr.count; to do
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.section == 1)
    {
        CloudCompanyAppointmentCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CloudCompanyAppointmentCell class])];
        if (indexPath.row == 0){
            cell.textFieldType = CDA_CONTACTPERSON;
            cell.textField.text = gCompanyInfo.cLinkPeople;
            cell.textField.enabled = YES;
            cell.textField.tag = TEXTFIELD_CONTACT;
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.delegate = self;
            _contactPersonField = cell.textField;
        }else if (indexPath.row == 1){
            cell.textFieldType = CDA_CONTACTPHONE;
            cell.textField.text = gCompanyInfo.cLinkPhone;
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            cell.textField.enabled = YES;
            cell.textField.tag = TEXTFIELD_PHONE;
            //cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.delegate = self;
            _phoneNumField = cell.textField;
        }else if (indexPath.row == 2){
            cell.textFieldType = CDA_PERSON;
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            cell.textField.enabled = YES;
            cell.textField.tag = TEXTFIELD_CONTACTCOUNT;
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.delegate = self;
            _exminationCountField = cell.textField;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    CompanyItemListCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CompanyItemListCell class])];
    cell.editing = NO;
    if (indexPath.row == 0){
        if (_brContract.checkSiteID == nil || [_brContract.checkSiteID isEqualToString:@""]){
            //代表预约，可以修改
            cell.itemType = CDA_APPOINTMENTADDRESS;
        }else{
            //代表体检，不可修改
            cell.itemType = CDA_EXAMADDRESS;
        }
        [cell setTextViewText:_brContract.regPosAddr];
    }else{
        if (_brContract.checkSiteID == nil || [_brContract.checkSiteID isEqualToString:@""]){
            cell.itemType = CDA_APPOINTMENTTIME;
            
            //云预约服务点显示格式
            [cell setTextViewText:[NSString stringWithFormat:@"%@~%@", [NSDate converLongLongToChineseStringDate:_brContract.regBeginDate/1000],
                                   [NSDate converLongLongToChineseStringDate:_brContract.regEndDate/1000]]];
        }else{
            cell.itemType = CDA_EXAMTIME;
            
            //基于服务点(移动+固定)
            if ([_brContract.hosCode isEqualToString:_brContract.checkSiteID]){
                //固定服务点
                [cell setTextViewText:[NSString stringWithFormat:@"工作日(%@)", [NSDate getHour_MinuteByDate:_brContract.regTime/1000]]];
            }else{
                 NSString *year = [NSDate getYear_Month_DayByDate:_brContract.servicePoint.startTime/1000];
                 NSString *start = [NSDate getHour_MinuteByDate:_brContract.servicePoint.startTime/1000];
                 NSString *end = [NSDate getHour_MinuteByDate:_brContract.servicePoint.endTime/1000];
                [cell setTextViewText:[NSString stringWithFormat:@"%@(%@~%@)", year, start, end]];
            }
        }
        

        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

@end
