//
//  PeripheralModel.m
//  NewBlueTooth
//
//  Created by  on 16/2/15.
//  Copyright © 2016年 starlinktech. All rights reserved.
//

#import "PeripheralModel.h"


@implementation PeripheralModel

+(id)PeripheralModel:(NSDictionary *)dic
{
    return [[PeripheralModel alloc]initWithDictionary:dic];;
}

-(id)initWithDictionary:(NSDictionary *)dic
{
    if (self =[super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end
