//
//  NSString+MD5.h
//  BaiduBaike
//
//  Created by CDCKT on 11-12-5.
//  Copyright (c) 2011 CDCKT. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)
-(NSString *)md5HexDigest;
@end
