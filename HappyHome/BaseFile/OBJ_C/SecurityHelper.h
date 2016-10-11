//
//  SecurityHelper.h
//  1919sendImmediately
//
//  Created by kaka on 16/1/29.
//  Copyright © 2016年 kaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityHelper : NSObject

+ (NSString *)getSecurityStringFromPassword:(NSString *)password TimeStamp:(NSString *)timeString;
+ (NSString *)getTimeStampString;

+(void)savePassword:(NSString *)password;

+(id)readPassword;

+(void)deletePassword;

@end
