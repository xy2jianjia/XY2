//
//  DHRobotTableDao.m
//  DHRequestServer
//
//  Created by xy2 on 16/3/2.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHRobotTableDao.h"
static  NSString * const ROBOTINFO_TABLE_NAME = @"ROBOTINFOTABLE";
@implementation DHRobotTableDao
+ (void)asyncExecuteSaveRobotInfoToDataBaseWithItem:(id )item currentUserId:(NSString *)currentUserId compeleted:(void(^)(BOOL flag,NSString *sql))compeleted{
    NSDictionary *fieldDict = [self asyncFormatPropertyNamesWithClass:[item class]];
    [DHRobotTableDao asyncInsertDataToDataBaseWithUserId:currentUserId tableName:ROBOTINFO_TABLE_NAME field:fieldDict result:^(BOOL flag, NSString *sql) {
        compeleted(flag,sql);
    }];
}
+ (void)asyncExecuteQueryRobotInfoWithCurrentUserId:(NSString *)userId filter:(NSDictionary *)filter compeleted:(void(^)(NSArray *array,NSString *sql))compeleted{
    [DHRobotTableDao asyncQueryDataFromDataBaseWithUserId:userId tableName:ROBOTINFO_TABLE_NAME filter:filter groupFilter:nil completed:^(NSMutableArray *array, NSString *sql) {
//        NSMutableArray *array = [NSMutableArray array];
//        NSDictionary *temp = [rs columnNameToIndexMap];
//        while ([rs next]) {
//            NSMutableDictionary *d = [NSMutableDictionary dictionary];
//            for (NSString *key in [temp allKeys]) {
//                NSString *str = [rs stringForColumn:key];
//                [d setObject:str forKey:key];
//            }
//            [array addObject:d];
//        }
        compeleted(array,sql);
    }];
}

+ (void)asyncExecuteQueryRobotInfoCountWithCurrentUserId:(NSString *)userId filter:(NSDictionary *)filter compeleted:(void(^)(NSInteger count,NSString *sql))compeleted{
    
    [DHRobotTableDao asyncQueryCountDataFromDataBaseWithUserId:userId tableName:ROBOTINFO_TABLE_NAME filter:filter completed:^(NSInteger count, NSString *sql) {
        compeleted(count,sql);
    }];
    
}
+ (void)asyncExecuteUpdateRobotInfoWithCurrentUserId:(NSString *)userId userinfo:(id)item filter:(NSDictionary *)filter compeleted:(void(^)(BOOL flag,NSString *sql))compeleted{
    NSDictionary *userinfoDict = [self asyncFormatPropertyNamesWithClass:[item class]];
    [DHRobotTableDao asyncUpdateDataSetDataBaseWithUserId:userId tableName:ROBOTINFO_TABLE_NAME updateInfo:userinfoDict filter:filter result:^(BOOL flag, NSString *sql) {
        compeleted(flag,sql);
    }];
}

+ (void)asyncExecuteDeleteRobotInfoWithCurrentUserId:(NSString *)userId filter:(NSDictionary *)filter compeleted:(void(^)(BOOL flag,NSString *sql))compeleted{
    [DHRobotTableDao asyncDeleteDataFromDataBaseWithUserId:userId tableName:ROBOTINFO_TABLE_NAME filter:filter result:^(BOOL flag, NSString *sql) {
        compeleted(flag,sql);
    }];
}
@end
