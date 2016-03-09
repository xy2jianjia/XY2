//
//  DHRobotTableDao.h
//  DHRequestServer
//
//  Created by xy2 on 16/3/2.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHTableManager.h"

@interface DHRobotTableDao : DHTableManager
/**
 *  保存用户数据
 *
 *  @param item          model
 *  @param currentUserId 当前登录的用户id
 *  @param compeleted
 */
+ (void)asyncExecuteSaveRobotInfoToDataBaseWithItem:(id )item currentUserId:(NSString *)currentUserId compeleted:(void(^)(BOOL flag,NSString *sql))compeleted;
/**
 *  查询用户数据
 *
 *  @param userId     当前登录的用户id
 *  @param filter     过滤条件：key：字段名，value：字段的值
 *  @param compeleted
 */
+ (void)asyncExecuteQueryRobotInfoWithCurrentUserId:(NSString *)userId filter:(NSDictionary *)filter compeleted:(void(^)(NSArray *array,NSString *sql))compeleted;
/**
 *  查询用户个数
 *
 *  @param userId     当前登录的用户id
 *  @param filter     过滤条件：key：字段名，value：字段的值
 *  @param compeleted
 */
+ (void)asyncExecuteQueryRobotInfoCountWithCurrentUserId:(NSString *)userId filter:(NSDictionary *)filter compeleted:(void(^)(NSInteger count,NSString *sql))compeleted;
/**
 *  <#Description#>
 *
 *  @param userId     当前登录的用户id
 *  @param item       model
 *  @param filter     过滤条件：key：字段名，value：字段的值
 *  @param compeleted
 */
+ (void)asyncExecuteUpdateRobotInfoWithCurrentUserId:(NSString *)userId userinfo:(id)item filter:(NSDictionary *)filter compeleted:(void(^)(BOOL flag,NSString *sql))compeleted;
/**
 *  删除用户数据
 *
 *  @param userId     当前登录的用户id
 *  @param filter     过滤条件：key：字段名，value：字段的值
 *  @param compeleted
 */
+ (void)asyncExecuteDeleteRobotInfoWithCurrentUserId:(NSString *)userId filter:(NSDictionary *)filter compeleted:(void(^)(BOOL flag,NSString *sql))compeleted;
@end
