//
//  CompanyInfoOfPhonePacket.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/17.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CompanyInfoOfPhonePacket.h"
#import "Constants.h"
#import "HMDataOperate.h"

@implementation CompanyInfoOfPhonePacket


-(instancetype)init{
    if (self = [super init])
    {
        self.protocalNum = PROXY_PDA_CUSTOMER_INFO;
    }
    return self;
}


#pragma mark - Override Methods
-(void)writeData:(NSData*)data Index:(NSInteger*)index;
{
    self.cUnitCode = [DataOperate read256String:data Index:index];
    self.cUnitName = [DataOperate read256String:data Index:index];
    self.cUnitShotName = [DataOperate read256String:data Index:index];
    self.cUnitAddr = [DataOperate read256String:data Index:index];
    self.cLinkPeople = [DataOperate read256String:data Index:index];
    self.cLinkTel = [DataOperate read256String:data Index:index];
    self.cLinkPhone = [DataOperate read256String:data Index:index];
    self.cEmail = [DataOperate read256String:data Index:index];
    self.cLinkFax = [DataOperate read256String:data Index:index];
    self.cUnitType = [DataOperate read256String:data Index:index];
    self.cUnitURL = [DataOperate read256String:data Index:index];
    self.cAccountNo = [DataOperate read256String:data Index:index];
    self.cAccountBank = [DataOperate read256String:data Index:index];
    self.cUnitPhto = [DataOperate read256String:data Index:index];
}

@end
