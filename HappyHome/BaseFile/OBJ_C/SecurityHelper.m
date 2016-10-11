//
//  SecurityHelper.m
//  1919sendImmediately
//
//  Created by kaka on 16/1/29.
//  Copyright © 2016年 kaka. All rights reserved.
//

#import "SecurityHelper.h"
#import "SecurityService.h"
#import "NSString+Send.h"

static NSString * const KEY_IN_KEYCHAIN = @"com.1919.send";
static NSString * const KEY_PASSWORD = @"com.1919.send.password";

@implementation SecurityHelper


//根据密码和时间戳获取安全传输字符串
+ (NSString *)getSecurityStringFromPassword:(NSString *)password TimeStamp:(NSString *)timeString {
    NSString *timeMD5 = [timeString MD5Hash];
    NSString *passwordMD5 = [password MD5Hash];
    
    NSMutableArray *locationArr = [NSMutableArray array];
    for (int i = 0; i < timeMD5.length; i++) {
        NSString *sub = [timeMD5 substringWithRange:NSMakeRange(i, 1)];
        int loc = [SecurityHelper getLocationBySubString:sub];
        int location = loc + (i%4)*16;
        int realLocation = [SecurityHelper getRealLocationByArray:locationArr location:location];
        [locationArr addObject:[NSNumber numberWithInt:realLocation]];
    }
    
    NSString *result = @"----------------------------------------------------------------";
    
    for (int i = 0; i < locationArr.count; i++) {
        int location = [[locationArr objectAtIndex:i] intValue];
        result = [result stringByReplacingCharactersInRange:NSMakeRange(location, 1) withString:[timeMD5 substringWithRange:NSMakeRange(i, 1)]];
    }
    
    for (int i = 0; i < passwordMD5.length; i++) {
        NSString *sub = [passwordMD5 substringWithRange:NSMakeRange(i, 1)];
        for (int j = 0 ; j < result.length; j++) {
            NSString *subs = [result substringWithRange:NSMakeRange(j, 1)];
            if ([subs isEqualToString:@"-"]) {
                result = [result stringByReplacingCharactersInRange:NSMakeRange(j, 1) withString:sub];
                break;
            }
        }
    }
    return result;
}

+ (int)getRealLocationByArray:(NSArray *)arr location:(int)loc {
    if (loc == 64) {
        loc = 0;
    }
    
    BOOL addFlag = NO;
    for (int i = 0 ; i < arr.count; i++) {
        int loca = [[arr objectAtIndex:i] intValue];
        if (loca == loc) {
            addFlag = YES;
            break;
        }
    }
    
    if (addFlag) {
        loc++;
        return [SecurityHelper getRealLocationByArray:arr location:loc];
    } else {
        return loc;
    }
    return 0;
}

+ (int)getLocationBySubString:(NSString *)subString {
    if (subString.length == 1) {
        if ([subString intValue] != 0) {
            return [subString intValue];
        } else {
            if ([subString.uppercaseString isEqualToString:@"A"]) {
                return 10;
            } else if ([subString.uppercaseString isEqualToString:@"B"]) {
                return 11;
            } else if ([subString.uppercaseString isEqualToString:@"C"]) {
                return 12;
            } else if ([subString.uppercaseString isEqualToString:@"D"]) {
                return 13;
            } else if ([subString.uppercaseString isEqualToString:@"E"]) {
                return 14;
            } else if ([subString.uppercaseString isEqualToString:@"F"]) {
                return 15;
            } else {
                return 0;
            }
        }
    }
    return 0;
}

+ (NSString *)getTimeStampString {
    long int timestamp = (long int)[[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] integerValue];
    return [NSString stringWithFormat:@"%li",timestamp];
}

+ (void)savePassword:(NSString *)password {
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    [usernamepasswordKVPairs setObject:password forKey:KEY_PASSWORD];
    if (![SecurityService save:KEY_IN_KEYCHAIN data:usernamepasswordKVPairs]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[NSString AES256Encrypt:password withKey:KEY_IN_KEYCHAIN] forKey:KEY_PASSWORD];
        [userDefaults synchronize];
    }
}

+ (id)readPassword {
    NSMutableDictionary *usernamepasswordKVPair = (NSMutableDictionary *)[SecurityService load:KEY_IN_KEYCHAIN];
    if (usernamepasswordKVPair == nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *passData = [userDefaults objectForKey:KEY_PASSWORD];
        return [NSString AES256Decrypt:passData withKey:KEY_IN_KEYCHAIN];
    }
    return [usernamepasswordKVPair objectForKey:KEY_PASSWORD];
}

+ (void)deletePassword {
    [SecurityService delete:KEY_IN_KEYCHAIN];
}
@end
