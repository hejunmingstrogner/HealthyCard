//
//  PersonInfoOfPhonePacket.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/17.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "PersonInfoOfPhonePacket.h"
#import "Constants.h"

#import "HMDataOperate.h"

@implementation PersonInfoOfPhonePacket


-(instancetype)init{
    if (self = [super init])
    {
        self.protocalNum = PROXY_PDA_CUSTOMER_INFO;
    }
    return self;
}

#pragma mark - Public Methods
-(void)writeData:(NSData*)data Index:(NSInteger*)index;
{
    self.mCustCode = [DataOperate read256String:data Index:index];
    self.mCustName = [DataOperate read256String:data Index:index];
    self.bGender = [DataOperate readByte:data Index:index];
    self.cNation = [DataOperate read256String:data Index:index];
    self.cAddress = [DataOperate read256String:data Index:index];
    self.dBornDate = [DataOperate readDate:data Index:index];
    self.bMarryFlag = [DataOperate readByte:data Index:index];
    self.CustId = [DataOperate read256String:data Index:index];
    self.StrTel = [DataOperate read256String:data Index:index];
    self.cEmail = [DataOperate read256String:data Index:index];
    self.cCustPhoto = [DataOperate read256String:data Index:index];
    self.cUnitCode = [DataOperate read256String:data Index:index];
    self.cUnitName = [DataOperate read256String:data Index:index];
    self.cIndustry = [DataOperate read256String:data Index:index];
}

@end
