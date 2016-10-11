//
//  SecurityService.h
//  1919sendImmediately
//
//  Created by kaka on 16/1/29.
//  Copyright © 2016年 kaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityService : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;
+ (BOOL)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
