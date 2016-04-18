//
//  CompanySearchViewController.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/4/18.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CompanySearchViewControllerDelegate <NSObject>

- (void)theCompanySearchResult:(NSString *)companyName address:(NSString *)address;

@end

/**
 *  单位注册时，搜索模糊补全公司名称地址
 */
@interface CompanySearchViewController : UIViewController

@property (nonatomic, strong) id<CompanySearchViewControllerDelegate> delegate;

@end
