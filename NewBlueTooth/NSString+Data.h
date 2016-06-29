//
//  NSString+Data.h
//  NewBlueTooth
//
//  Created by  on 16/1/21.
//  Copyright © 2016年 starlinktech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Data)

/**
 *  十六进制转换成十进制
 *
 *  @param num 十六进制的值
 *
 *  @return 十进制的值
 */
+ (NSString *)to10:(NSString *)num;

/**
 *  data转化成string
 *
 *  @param data data
 *
 *  @return string
 */

+ (NSString*)hexadecimalString:(NSData *)data;

/**
 *  转成16进制
 *

 */
+(NSString *)to16:(int)num;



@end
