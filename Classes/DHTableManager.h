//
//  DHTableManager.h
//  DHRequestServer
//
//  Created by xy2 on 16/2/26.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHDBHelper.h"
@interface DHTableManager : DHDBHelper
/**
 *  获取当前运行时model的所有属性
 *
 *  @param class 类名
 *
 *  @return
 */
+ (NSDictionary *) asyncFormatPropertyNamesWithClass:(id)class;

/**
 *  检测本数据库中，表是否已经存在
 *
 *  @param tableName 表明
 *  @param db        数据库名
 *
 *  @return
 */
+ (BOOL) asyncCheckTableExistOrNotWithTableName:(NSString *)tableName withDB:(FMDatabase *)db;
/**
 *  建表
 *
 *  @param tableName 表名
 *  @param field     字段：key：字段名，value：字段类型
 *  @param result    
 */
+(void)asyncCreateUserTableWithTableName:(NSString *)tableName field:(NSDictionary *)field result:(void(^)(BOOL flag, NSString *sql))result;
/**
 *  插入数据
 *
 *  @param userId    当前用户id（为了区分不同用户登录本app）
 *  @param tableName 表名
 *  @param field    字段：key：字段名，value：字段数值
 *  @param result    
 */
+ (void)asyncInsertDataToDataBaseWithUserId:(NSString *)userId tableName:(NSString *)tableName field:(NSDictionary *)field result:(void(^)(BOOL flag, NSString *sql))result;
/**
 *  删除数据
 *
 *  @param userId    当前用户id
 *  @param tableName 表名
 *  @param filter    过滤条件：where ...字段：key：字段名，value：字段数值
 *  @param result    
 */
+ (void)asyncDeleteDataFromDataBaseWithUserId:(NSString *)userId tableName:(NSString *)tableName filter:(NSDictionary *)filter result:(void(^)(BOOL flag, NSString *sql))result;
/**
 *  修改数据
 *
 *  @param userId     当前用户id
 *  @param tableName  表名
 *  @param updateInfo 更新数据 字段：key：字段名，value：字段数值
 *  @param filter     过滤条件：where ...字段：key：字段名，value：字段数值
 *  @param result     
 */
+ (void)asyncUpdateDataSetDataBaseWithUserId:(NSString *)userId tableName:(NSString *)tableName updateInfo:(NSDictionary *)updateInfo filter:(NSDictionary *)filter result:(void(^)(BOOL flag, NSString *sql))result;
/**
 *  查询数据
 *
 *  @param userId    当前用户id
 *  @param tableName 表名
 *  @param filter    过滤条件：where ...字段：key：字段名，value：字段数值
 *  @param groupFilter group by和order by过滤条件，key：groupby的字段，value：orderby的字段
 *  @param result    
 */
+ (void)asyncQueryDataFromDataBaseWithUserId:(NSString *)userId tableName:(NSString *)tableName filter:(NSDictionary *)filter groupFilter:(NSDictionary *)groupFilter completed:(void(^)(NSMutableArray *array, NSString *sql))completed;
/**
 *  查询统计
 *
 *  @param userId    当前用户id
 *  @param tableName 表名
 *  @param filter    过滤条件
 *  @param completed 
 */
+ (void)asyncQueryCountDataFromDataBaseWithUserId:(NSString *)userId tableName:(NSString *)tableName filter:(NSDictionary *)filter completed:(void(^)(NSInteger count, NSString *sql))completed;
@end
