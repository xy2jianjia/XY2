//
//  DHMessageTableDao.m
//  DHRequestServer
//
//  Created by xy2 on 16/3/1.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHMessageTableDao.h"

static  NSString * const MESSAGEINFO_TABLE_NAME = @"MESSAGETABLE";
@implementation DHMessageTableDao
+ (void)asyncExecuteSaveMessageInfoToDataBaseWithItem:(id )item currentUserId:(NSString *)currentUserId compeleted:(void(^)(BOOL flag,NSString *sql))compeleted{
    NSDictionary *fieldDict = [self asyncFormatPropertyNamesWithClass:item];
    [DHMessageTableDao asyncInsertDataToDataBaseWithUserId:currentUserId tableName:MESSAGEINFO_TABLE_NAME field:fieldDict result:^(BOOL flag, NSString *sql) {
        compeleted(flag,sql);
    }];
}
+ (void)asyncExecuteQueryMessageInfoWithCurrentUserId:(NSString *)userId filter:(NSDictionary *)filter groupFilter:(NSDictionary *)groupFilter compeleted:(void(^)(NSArray *array,NSString *sql))compeleted{
    [DHMessageTableDao asyncQueryDataFromDataBaseWithUserId:userId tableName:MESSAGEINFO_TABLE_NAME filter:filter groupFilter:groupFilter completed:^(NSMutableArray *array, NSString *sql) {
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

+ (void)asyncExecuteQueryMessageInfoCountWithCurrentUserId:(NSString *)userId filter:(NSDictionary *)filter compeleted:(void(^)(NSInteger count,NSString *sql))compeleted{
    
    [DHMessageTableDao asyncQueryCountDataFromDataBaseWithUserId:userId tableName:MESSAGEINFO_TABLE_NAME filter:filter completed:^(NSInteger count, NSString *sql) {
        compeleted(count,sql);
    }];
    
}
+ (void)asyncExecuteUpdateMessageInfoWithCurrentUserId:(NSString *)userId userinfo:(id)item filter:(NSDictionary *)filter compeleted:(void(^)(BOOL flag,NSString *sql))compeleted{
    NSDictionary *userinfoDict = [self asyncFormatPropertyNamesWithClass:[item class]];
    [DHMessageTableDao asyncUpdateDataSetDataBaseWithUserId:userId tableName:MESSAGEINFO_TABLE_NAME updateInfo:userinfoDict filter:filter result:^(BOOL flag, NSString *sql) {
        compeleted(flag,sql);
    }];
}

+ (void)asyncExecuteDeleteMessageInfoWithCurrentUserId:(NSString *)userId filter:(NSDictionary *)filter compeleted:(void(^)(BOOL flag,NSString *sql))compeleted{
    [DHMessageTableDao asyncDeleteDataFromDataBaseWithUserId:userId tableName:MESSAGEINFO_TABLE_NAME filter:filter result:^(BOOL flag, NSString *sql) {
        compeleted(flag,sql);
    }];
}
@end
