//
//  NSString+Send.h
//  1919sendImmediately
//
//  Created by kaka on 16/1/29.
//  Copyright © 2016年 kaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Send)

+ (NSString *)getStringByObject:(id)obj;

- (NSString *)trim;

- (NSString *)MD5Hash;

- (NSString *)pinyinString;//拼音字符串
- (NSString *)pinyinStringWithReadingVoice;//拼音字符串(含声调)
- (NSString *)captainPinyinString;//拼音首字母字符串(不含空格)

+ (NSData*)AES256Encrypt:(NSString*)strSource withKey:(NSString*)key;//加密

+ (NSString*)AES256Decrypt:(NSData*)dataSource withKey:(NSString*)key;//解密


@end
