//
//  StepDataDB.h
//  NewBlueTooth
//
//  Created by  on 16/1/18.
//  Copyright © 2016年 starlinktech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StepData;

@interface StepDataDB : NSObject

//1.创建表
+ (BOOL)createDataTable;

//2.添加数据
+ (void)addData:(StepData *)data;

//3.查询数据
+ (void)findData:(void(^)(NSArray *result))complectionHandle;

//4.修改数据
//+ (void)updateData:(StepData *)data;

//5.删除表
+ (BOOL)deleteData;

@end
