//
//  StepDataDB.m
//  NewBlueTooth
//
//  Created by  on 16/1/18.
//  Copyright © 2016年 starlinktech. All rights reserved.
//

#import "StepDataDB.h"
#import <sqlite3.h>
#import "EGODatabase.h"
#import "StepData.h"

@implementation StepDataDB

#define fileDB [NSHomeDirectory() stringByAppendingString:@"/Documents/db.sqlite"]

static NSOperationQueue *queue = nil;

//EGODatabase 框架不支持 DDL语句的操作
//1.创建表
+ (BOOL)createDataTable {
    
    sqlite3 *sqlite;
    
    if (sqlite3_open([fileDB UTF8String], &sqlite) != SQLITE_OK) {
        NSLog(@"打开数据库失败");
        sqlite3_close(sqlite);
        return NO;
    }
    
    NSString *sql = @"CREATE TABLE t_stepData (starTime TEXT,endTime TEXT,steps INTEGER)";
    
    char *error;
    BOOL result = sqlite3_exec(sqlite, [sql UTF8String], NULL, NULL, &error);
    if (result != SQLITE_OK) {
        NSLog(@"创建表失败");
        sqlite3_close(sqlite);
        return NO;
    }
    
    sqlite3_close(sqlite);
    
    return YES;
}

//删除数据
+ (BOOL)deleteData {
    sqlite3 *sqlite = nil;
    //1.打开数据库
    int result = sqlite3_open([fileDB UTF8String], &sqlite);
    if (result != SQLITE_OK) {
        NSLog(@"数据打开失败");
        return NO;
    }
    
    //2.定义SQL语句
    NSString *sql = @"delete from t_stepData";
    
    int result2 = sqlite3_exec(sqlite, sql.UTF8String, NULL, NULL, NULL);
    if (result2 != SQLITE_OK) {
        NSLog(@"删除失败");
        return NO;
    }
    NSLog(@"删除数据成功");
    return YES;
}

//添加数据
+ (void)addData:(StepData *)data {
    
    if (!data) {
        return;
    }
    
    EGODatabase *database = [[EGODatabase alloc] initWithPath:fileDB];
    
    [database open];
    
    NSString *sql = @"insert into t_stepData(starTime,endTime,steps) values(?,?,?)";
    
    NSArray *params = @[data.starTime,data.endTime,@(data.steps)];
    
    [database executeQuery:sql parameters:params];
    
    [database close];
}

//查询
+ (void)findData:(void(^)(NSArray *result))complectionHandle {
    
    //1.打开数据库
    EGODatabase *database = [[EGODatabase alloc] initWithPath:fileDB];
    
    //2.定义SQL语句
    NSString *sql = @"select starTime,endTime,steps from t_stepData";
    
    //3.取数据
    //同步查询
    //    EGODatabaseResult *result = [database executeQuery:sql];
    
    //异步查询
    //创建查询请求对象：EGODatabaseRequest
    EGODatabaseRequest *request = [database requestWithQuery:sql];
    
    [request setSuccessBlock:^(EGODatabaseResult *result){
        //查询操作完成之后回调的block
        
        NSMutableArray *dataArray = @[].mutableCopy;
        
        for (int i=0; i<result.count; i++) {
            
            StepData *data = [[StepData alloc] init];
            
            EGODatabaseRow *row = result.rows[i];

            data.starTime = [row stringForColumn:@"starTime"];
            data.endTime = [row stringForColumnIndex:1];
            data.steps = [row intForColumnIndex:2] ;
            
            [dataArray addObject:data];
        }
        
        
        complectionHandle(dataArray);
        
        //3.关闭数据库
        [database close];
    }];
    
    if (queue == nil) {
        queue = [[NSOperationQueue alloc] init];
    }
    
    [queue addOperation:request];
}

//更新数据库
+ (void)updateData:(StepData *)data {
    EGODatabase *database = [[EGODatabase alloc] initWithPath:fileDB];
    
    //打开数据库
    [database open];
    
    //定义SQL语句
    NSString *sql = @"update t_stepData set steps=1800 where date=2016/1/10";
    
    //执行语句
    NSArray *params = @[data.starTime,data.endTime,@(data.steps)];
    [database executeUpdate:sql parameters:params];
    
    //4.关闭数据库
    [database close];

}





@end
