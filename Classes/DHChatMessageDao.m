//
//  DHChatMessageDao.m
//  http
//
//  Created by xy2 on 16/3/3.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHChatMessageDao.h"
static NSString * const CHATMESSAGEINFO_TABLE_NAME = @"CHATMESSAGEINFO_TABLE";
@implementation DHChatMessageDao
+ (void)asyncExecuteSaveMessageInfoToDataBaseWithItem:(id )item currentUserId:(NSString *)currentUserId compeleted:(void(^)(BOOL flag,NSString *sql))compeleted{
    NSDictionary *fieldDict = [self asyncFormatPropertyNamesWithClass:item];
    [self asyncInsertDataToDataBaseWithUserId:currentUserId tableName:CHATMESSAGEINFO_TABLE_NAME field:fieldDict result:^(BOOL flag, NSString *sql) {
        compeleted(flag,sql);
    }];
}
+ (void)asyncExecuteQueryMessageInfoWithCurrentUserId:(NSString *)userId filter:(NSDictionary *)filter groupFilter:(NSDictionary *)groupFilter compeleted:(void(^)(NSArray *array,NSString *sql))compeleted{
    [self asyncQueryDataFromDataBaseWithUserId:userId tableName:CHATMESSAGEINFO_TABLE_NAME filter:filter groupFilter:groupFilter completed:^(NSMutableArray *array, NSString *sql) {
        compeleted(array,sql);
    }];
}

+ (void)asyncExecuteQueryMessageInfoCountWithCurrentUserId:(NSString *)userId filter:(NSDictionary *)filter compeleted:(void(^)(NSInteger count,NSString *sql))compeleted{
    
    [self asyncQueryCountDataFromDataBaseWithUserId:userId tableName:CHATMESSAGEINFO_TABLE_NAME filter:filter completed:^(NSInteger count, NSString *sql) {
        compeleted(count,sql);
    }];
    
}
+ (void)asyncExecuteUpdateMessageInfoWithCurrentUserId:(NSString *)userId userinfo:(id)item filter:(NSDictionary *)filter compeleted:(void(^)(BOOL flag,NSString *sql))compeleted{
    NSDictionary *userinfoDict = [self asyncFormatPropertyNamesWithClass:[item class]];
    [self asyncUpdateDataSetDataBaseWithUserId:userId tableName:CHATMESSAGEINFO_TABLE_NAME updateInfo:userinfoDict filter:filter result:^(BOOL flag, NSString *sql) {
        compeleted(flag,sql);
    }];
}

+ (void)asyncExecuteDeleteMessageInfoWithCurrentUserId:(NSString *)userId filter:(NSDictionary *)filter compeleted:(void(^)(BOOL flag,NSString *sql))compeleted{
    [self asyncDeleteDataFromDataBaseWithUserId:userId tableName:CHATMESSAGEINFO_TABLE_NAME filter:filter result:^(BOOL flag, NSString *sql) {
        compeleted(flag,sql);
    }];
}
@end
