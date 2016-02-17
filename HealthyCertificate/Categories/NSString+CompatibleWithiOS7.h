//
//  NSString+CompatibleWithiOS7.h
//  SioEyeAPP
//
//  Created by P22289D2 on 15/11/5.
//  Copyright © 2015年 CDCKT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CompatibleWithiOS7)


- (BOOL)hi_containsString:(NSString *)string;
- (BOOL)hi_localizedCaseInsensitiveContainsString:(NSString *)string;
@end
