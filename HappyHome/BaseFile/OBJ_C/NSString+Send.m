//
//  NSString+Send.m
//  1919sendImmediately
//
//  Created by kaka on 16/1/29.
//  Copyright © 2016年 kaka. All rights reserved.
//

#import "NSString+Send.h"
#import "NSData+Send.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Send)

+ (NSString *)getStringByObject:(id)obj {
    if (!obj) {
        return nil;
    }
    NSString *objStr = [NSString stringWithFormat:@"%@",obj];
    if ([objStr isEqualToString:@"<null>"] || [objStr isEqualToString:@"(null)"]) {
        return nil;
    }
    return objStr;
}

- (NSString *)trim {
    if (self != nil) {
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else {
        return @"";
    }
}

- (NSString *)MD5Hash {
    if(self.length == 0) { return nil; }
    
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}

- (NSString *)pinyinString {
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:[self pinyinStringWithReadingVoice]];
    BOOL canTransform = CFStringTransform((__bridge CFMutableStringRef)mutableString, 0, kCFStringTransformStripDiacritics, NO);
    return canTransform ? [mutableString copy]: nil;
}

- (NSString *)pinyinStringWithReadingVoice {
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:self];
    BOOL canTransform = CFStringTransform((__bridge CFMutableStringRef)mutableString, 0, kCFStringTransformMandarinLatin, NO);
    return canTransform ? [mutableString copy] : nil;
}

- (NSString *)captainPinyinString {
    NSString *pinyin = [self pinyinString];
    if (pinyin.length <= 0) {
        return nil;
    }
    NSArray *charPinyinArray = [pinyin componentsSeparatedByString:@" "];
    NSMutableString *captaiPinyin = [NSMutableString string];
    for (NSString *subPinyin in charPinyinArray) {
        NSString *thisCaptain = [subPinyin substringWithRange:NSMakeRange(0, 1)];
        [captaiPinyin appendString:thisCaptain];
    }
    return [captaiPinyin uppercaseString];
}

+ (NSData*)AES256Encrypt:(NSString*)strSource withKey:(NSString*)key {
    NSData *dataSource = [strSource dataUsingEncoding:NSUTF8StringEncoding];
    return [dataSource AES256EncryptWithKey:[key MD5Hash]];
}

+ (NSString*)AES256Decrypt:(NSData*)dataSource withKey:(NSString*)key {
    NSData *decryptData = [dataSource AES256DecryptWithKey:[key MD5Hash]];
    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}

@end
