//
//  NSData+Send.h
//  1919sendImmediately
//
//  Created by kaka on 16/1/29.
//  Copyright © 2016年 kaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Send)

//加密函数
- (NSData*)AES256EncryptWithKey:(NSString*)key;

//解密函数
- (NSData*)AES256DecryptWithKey:(NSString*)key;


@end
