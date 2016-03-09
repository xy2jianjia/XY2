//
//  DHUserTableDao.h
//  DHRequestServer
//
//  Created by xy2 on 16/3/1.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHTableManager.h"

@interface DHUserTableDao : DHTableManager
/**
 *  保存用户数据
 *
 *  @param item          model
 *  @param currentUserId 当前登录的用户id
 *  @param compeleted    
 */
+ (void)asyncExecuteSaveUsereInfoToDataBaseWithItem:(id )item currentUserId:(NSString *)currentUserId compeleted:(void(^)(BOOL flag,NSString *sql))compeleted;
/**
 *  查询用户数据
 *
 *  @param userId     当前登录的用户id
 *  @param filter     过滤条件：key：字段名，value：字段的值
 *  @param compeleted 
 */
+ (void)asyncExecuteQueryUserInfoWithCurrentUserId:(NSString *)userId filter:(NSDictionary *)filter compeleted:(void(^)(NSArray *array,NSString *sql))compeleted;
/**
 *  查询用户个数
 *
 *  @param userId     当前登录的用户id
 *  @param filter     过滤条件：key：字段名，value：字段的值
 *  @param compeleted 
 */
+ (void)asyncExecuteQueryUserInfoCountWithCurrentUserId:(NSString *)userId filter:(NSDictionary *)filter compeleted:(void(^)(NSInteger count,NSString *sql))compeleted;
/**
 *  <#Description#>
 *
 *  @param userId     当前登录的用户id
 *  @param item       model
 *  @param filter     过滤条件：key：字段名，value：字段的值
 *  @param compeleted 
 */
+ (void)asyncExecuteUpdateUserInfoWithCurrentUserId:(NSString *)userId userinfo:(id)item filter:(NSDictionary *)filter compeleted:(void(^)(BOOL flag,NSString *sql))compeleted;
/**
 *  删除用户数据
 *
 *  @param userId     当前登录的用户id
 *  @param filter     过滤条件：key：字段名，value：字段的值
 *  @param compeleted 
 */
+ (void)asyncExecuteDeleteUserInfoWithCurrentUserId:(NSString *)userId filter:(NSDictionary *)filter compeleted:(void(^)(BOOL flag,NSString *sql))compeleted;
@end
