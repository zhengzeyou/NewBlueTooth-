//
//  NSUserDefaults+Klanguage.m
//  BlueTooth
//
//  Created by  on 16/1/14.
//  Copyright © 2016年 starlinktech. All rights reserved.
//

#import "NSUserDefaults+Klanguage.h"

@implementation NSUserDefaults (Klanguage)

+(NSInteger)systemLanguage
{
    NSUserDefaults *defa= [NSUserDefaults standardUserDefaults];
    
    NSInteger languagetype=[defa integerForKey:@"language"];
    
    
    return languagetype;
}

@end
