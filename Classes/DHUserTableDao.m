//
//  DHUserTableDao.m
//  DHRequestServer
//
//  Created by xy2 on 16/3/1.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHUserTableDao.h"

static  NSString * const USERINFO_TABLE_NAME = @"USERINFOTABLE";
@implementation DHUserTableDao


+ (void)asyncExecuteSaveUsereInfoToDataBaseWithItem:(id )item currentUserId:(NSString *)currentUserId compeleted:(void(^)(BOOL flag,NSString *sql))compeleted{
    NSDictionary *fieldDict = [self asyncFormatPropertyNamesWithClass:item ];
    [DHUserTableDao asyncInsertDataToDataBaseWithUserId:currentUserId tableName:USERINFO_TABLE_NAME field:fieldDict result:^(BOOL flag, NSString *sql) {
        compeleted(flag,sql);
    }];
}
+ (void)asyncExecuteQueryUserInfoWithCurrentUserId:(NSString *)userId filter:(NSDictionary *)filter compeleted:(void(^)(NSArray *array,NSString *sql))compeleted{
    [DHUserTableDao asyncQueryDataFromDataBaseWithUserId:userId tableName:USERINFO_TABLE_NAME filter:filter groupFilter:nil completed:^(NSMutableArray *array, NSString *sql) {
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
//        [rs close];
        compeleted(array,sql);
    }];
}

+ (void)asyncExecuteQueryUserInfoCountWithCurrentUserId:(NSString *)userId filter:(NSDictionary *)filter compeleted:(void(^)(NSInteger count,NSString *sql))compeleted{
    
    [DHUserTableDao asyncQueryCountDataFromDataBaseWithUserId:userId tableName:USERINFO_TABLE_NAME filter:filter completed:^(NSInteger count, NSString *sql) {
        compeleted(count,sql);
    }];
    
}
+ (void)asyncExecuteUpdateUserInfoWithCurrentUserId:(NSString *)userId userinfo:(id)item filter:(NSDictionary *)filter compeleted:(void(^)(BOOL flag,NSString *sql))compeleted{
    NSDictionary *userinfoDict = [self asyncFormatPropertyNamesWithClass:[item class]];
    [DHUserTableDao asyncUpdateDataSetDataBaseWithUserId:userId tableName:USERINFO_TABLE_NAME updateInfo:userinfoDict filter:filter result:^(BOOL flag, NSString *sql) {
        compeleted(flag,sql);
    }];
}

+ (void)asyncExecuteDeleteUserInfoWithCurrentUserId:(NSString *)userId filter:(NSDictionary *)filter compeleted:(void(^)(BOOL flag,NSString *sql))compeleted{
    [DHUserTableDao asyncDeleteDataFromDataBaseWithUserId:userId tableName:USERINFO_TABLE_NAME filter:filter result:^(BOOL flag, NSString *sql) {
        compeleted(flag,sql);
    }];
}

@end
