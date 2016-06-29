//
//  NSString+Data.m
//  NewBlueTooth
//
//  Created by  on 16/1/21.
//  Copyright © 2016年 starlinktech. All rights reserved.
//

#import "NSString+Data.h"

@implementation NSString (Data)


/**
 *  十六进制转换成十进制
 *
 *  @param num 十六进制的值
 *
 *  @return 十进制的值
 */
+(NSString *)to10:(NSString *)num
{
    NSString *result = [NSString stringWithFormat:@"%ld", strtoul([num UTF8String],0,16)];
    return result;
}


/**
 *  data转化成string
 *
 *  @param data data
 *
 *  @return string
 */

+ (NSString*)hexadecimalString:(NSData *)data{
    NSString* result;
    const unsigned char* dataBuffer = (const unsigned char*)[data bytes];
    if(!dataBuffer){
        return nil;
    }
    NSUInteger dataLength = [data length];
    NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for(int i = 0; i < dataLength; i++){
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }
    result = [NSString stringWithString:hexString];
    return result;
}


+(NSString *)to16:(int)num
{
    NSString *result = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",num]];
    if ([result length] < 2) {
        result = [NSString stringWithFormat:@"0%@", result];
    }
    return result;
    
}



@end
