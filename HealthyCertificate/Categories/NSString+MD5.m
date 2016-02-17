//
//  NSString+MD5.m
//  whrttv
//
//  Created by CDCKT on 11-12-5.
//  Copyright (c) 2011 CDCKT. All rights reserved.
//

#import "NSString+MD5.h"

@implementation NSString (MD5)

#pragma mark MD5
-(NSString *)md5HexDigest
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str),result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16 ; i ++ ) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return [hash lowercaseString];
}
@end
