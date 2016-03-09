//
//  DHTableManager.m
//  DHRequestServer
//
//  Created by xy2 on 16/2/26.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHTableManager.h"
#import "NSObject+Properties.h"
@implementation DHTableManager
#pragma mark - Singleton
+ (DHTableManager *)shareInstance{
    static DHTableManager* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
+ (BOOL) asyncCheckTableExistOrNotWithTableName:(NSString *)tableName withDB:(FMDatabase *)db{
    BOOL isOK = NO;
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next]){
        NSInteger count = [rs intForColumn:@"count"];
        if (0 == count){
            isOK =  NO;
        }else{
            isOK = YES;
        }
    }
    [rs close];
    return isOK;
}
//创建用户存储表 key：字段名，value：字段类型
+(void)asyncCreateUserTableWithTableName:(NSString *)tableName field:(NSDictionary *)field result:(void(^)(BOOL flag, NSString *sql))result{
    NSDictionary *dict = [self asyncFormatWithObject:field];
    [DHDBHelper asyncGetDatabaseQueueWithDataBaseName:@"chat" queue:^(FMDatabaseQueue *databaseQueue, NSString *dbPath) {
        [databaseQueue inDatabase:^(FMDatabase *db) {
            if (![DHTableManager asyncCheckTableExistOrNotWithTableName:tableName withDB:db]) {
                NSMutableString *sql = [NSMutableString string];
                [sql appendFormat:@"%@",[DHTableManager asyncConfigDataBaseSqlWithType:DB_SQL_QUERY_TYPE_CREATE_TABLE]];
                [sql appendFormat:@" %@",tableName];
                [sql appendFormat:@"("];
                for (int i = 0; i < [[dict allKeys] count]; i ++) {
                    NSString *key = [[dict allKeys] objectAtIndex:i];
                    if (i == [[dict allKeys] count] - 1) {
                        if (![[dict allKeys] containsObject:@"userId"]) {
                            [sql appendFormat:@"%@ %@,userId text",key,[dict objectForKey:key]];
                        }else{
                            [sql appendFormat:@"%@ %@",key,[dict objectForKey:key]];
                        }
                        
                    }else{
                        [sql appendFormat:@"%@ %@,",key,[dict objectForKey:key]];
                    }
                }
                [sql appendFormat:@")"];
                BOOL flag = [db executeUpdate:sql];
                result(flag,sql);
            }
        }];
    }];
    
}
// 插入数据 key：字段名，value：具体数值
+ (void)asyncInsertDataToDataBaseWithUserId:(NSString *)userId tableName:(NSString *)tableName field:(NSDictionary *)field result:(void(^)(BOOL flag, NSString *sql))result{
    [[DHTableManager shareInstance] asyncInsertDataToDataBaseWithUserId:userId tableName:tableName field:field result:result];
}
- (void)asyncInsertDataToDataBaseWithUserId:(NSString *)userId tableName:(NSString *)tableName field:(NSDictionary *)field result:(void(^)(BOOL flag, NSString *sql))result{
    
    __block NSMutableString *sql = [NSMutableString string];
    NSMutableString *tempStr = [NSMutableString string];
    [sql appendString:[DHTableManager asyncConfigDataBaseSqlWithType:DB_SQL_QUERY_TYPE_INSERT]];
    [sql appendFormat:@" %@",tableName];
    [sql appendFormat:@"("];
    for (int i = 0; i < [[field allKeys] count]; i ++) {
        NSString *key = [[field allKeys] objectAtIndex:i];
        if (i == [[field allKeys] count] - 1) {
            [sql appendFormat:@"%@,userId",key];
            [tempStr appendFormat:@"'%@','%@'",[field objectForKey:key],userId];
        }else{
            [sql appendFormat:@"%@,",key];
            [tempStr appendFormat:@"'%@',",[field objectForKey:key]];
        }
    }
    [sql appendFormat:@")"];
    [sql appendFormat:@"VALUES"];
    [sql appendFormat:@"("];
    [sql appendFormat:@"%@",tempStr];
    [sql appendFormat:@")"];
    [DHDBHelper asyncGetDatabaseQueueWithDataBaseName:@"chat" queue:^(FMDatabaseQueue *queue, NSString *dbPath) {
        [queue inDatabase:^(FMDatabase *db) {
            BOOL flag = [db executeUpdate:sql];
            result(flag,sql);
        }];
    }];
    
}
// 删除数据 key：字段名，value：具体数值
+ (void)asyncDeleteDataFromDataBaseWithUserId:(NSString *)userId tableName:(NSString *)tableName filter:(NSDictionary *)filter result:(void(^)(BOOL flag, NSString *sql))result{
    [[DHTableManager shareInstance] asyncDeleteDataFromDataBaseWithUserId:userId tableName:tableName filter:filter result:result];
}
- (void)asyncDeleteDataFromDataBaseWithUserId:(NSString *)userId tableName:(NSString *)tableName filter:(NSDictionary *)filter result:(void(^)(BOOL flag, NSString *sql))result{
    __block NSMutableString *sql = [NSMutableString string];
    [sql appendString:[DHTableManager asyncConfigDataBaseSqlWithType:DB_SQL_QUERY_TYPE_DELETE]];
    [sql appendFormat:@" %@",tableName];
    //    [sql appendFormat:@" WHERE "];
    if (filter != nil) {
        [sql appendFormat:@" WHERE "];
    }else{
        [sql appendFormat:@" WHERE userId='%@'",userId];
    }
    for (int i = 0; i < [[filter allKeys] count]; i ++) {
        NSString *key = [[filter allKeys] objectAtIndex:i];
        if (i == [[filter allKeys] count] - 1) {
            [sql appendFormat:@"%@='%@' AND userId='%@'",key,[filter objectForKey:key],userId];
        }else{
            [sql appendFormat:@"%@='%@' AND",key,[filter objectForKey:key]];
        }
    }
    [DHDBHelper asyncGetDatabaseQueueWithDataBaseName:@"chat" queue:^(FMDatabaseQueue *queue, NSString *dbPath) {
        [queue inDatabase:^(FMDatabase *db) {
            BOOL flag = [db executeUpdate:sql];
            result(flag,sql);
        }];
    }];
    
}
// 修改数据 key：字段名，value：具体数值
+ (void)asyncUpdateDataSetDataBaseWithUserId:(NSString *)userId tableName:(NSString *)tableName updateInfo:(NSDictionary *)updateInfo filter:(NSDictionary *)filter result:(void(^)(BOOL flag, NSString *sql))result{
    [[DHTableManager shareInstance] asyncUpdateDataSetDataBaseWithUserId:userId tableName:tableName updateInfo:updateInfo filter:filter result:result];
}
- (void)asyncUpdateDataSetDataBaseWithUserId:(NSString *)userId tableName:(NSString *)tableName updateInfo:(NSDictionary *)updateInfo filter:(NSDictionary *)filter result:(void(^)(BOOL flag, NSString *sql))result{
    if (updateInfo == nil) {
        result(NO,@"更新内容为空，加入更新内容");
        return;
    }
    __block NSMutableString *sql = [NSMutableString string];
    [sql appendString:[DHTableManager asyncConfigDataBaseSqlWithType:DB_SQL_QUERY_TYPE_UPDATE]];
    [sql appendFormat:@" %@ ",tableName];
    [sql appendFormat:@"SET "];
    for (int i = 0; i < [[updateInfo allKeys] count]; i ++) {
        NSString *key = [[updateInfo allKeys] objectAtIndex:i];
        if (i == [[updateInfo allKeys] count] - 1) {
            [sql appendFormat:@"%@='%@'",key,[updateInfo objectForKey:key]];
        }else{
            [sql appendFormat:@"%@='%@',",key,[updateInfo objectForKey:key]];
        }
    }
    if (filter != nil) {
        [sql appendFormat:@" WHERE "];
    }else{
        [sql appendFormat:@" WHERE userId='%@'",userId];
    }
    for (int i = 0; i < [[filter allKeys] count]; i ++) {
        NSString *key = [[filter allKeys] objectAtIndex:i];
        if (i == [[filter allKeys] count] - 1) {
            [sql appendFormat:@"%@='%@' AND userId='%@'",key,[filter objectForKey:key],userId];
        }else{
            [sql appendFormat:@"%@='%@' AND",key,[filter objectForKey:key]];
        }
    }
    [DHDBHelper asyncGetDatabaseQueueWithDataBaseName:@"chat" queue:^(FMDatabaseQueue *queue, NSString *dbPath) {
        [queue inDatabase:^(FMDatabase *db) {
            BOOL flag = [db executeUpdate:sql];
            result(flag,sql);
        }];
    }];
    
}
// 查询数据 key：字段名，value：具体数值
+ (void)asyncQueryDataFromDataBaseWithUserId:(NSString *)userId tableName:(NSString *)tableName filter:(NSDictionary *)filter groupFilter:(NSDictionary *)groupFilter completed:(void(^)(NSMutableArray *array, NSString *sql))completed{
    [[DHTableManager shareInstance] asyncQueryDataFromDataBaseWithUserId:userId tableName:tableName filter:filter groupFilter:groupFilter completed:completed];
}
- (void)asyncQueryDataFromDataBaseWithUserId:(NSString *)userId tableName:(NSString *)tableName filter:(NSDictionary *)filter groupFilter:(NSDictionary *)groupFilter completed:(void(^)(NSMutableArray *array, NSString *sql))completed{
    __block NSMutableString *sql = [NSMutableString string];
    [sql appendString:[DHTableManager asyncConfigDataBaseSqlWithType:DB_SQL_QUERY_TYPE_SELECT]];
    [sql appendFormat:@" %@ ",tableName];
    if (filter != nil) {
        [sql appendFormat:@" WHERE "];
    }else{
        [sql appendFormat:@" WHERE userId ='%@'",userId];
    }
    for (int i = 0; i < [[filter allKeys] count]; i ++) {
        NSString *key = [[filter allKeys] objectAtIndex:i];
        if (i == [[filter allKeys] count] - 1) {
            if (groupFilter != nil) {
                [sql appendFormat:@"%@ ='%@' AND userId='%@' ",key,[filter objectForKey:key],userId];
                [sql appendFormat:@"GROUP BY "];
                [sql appendFormat:@"%@",[[groupFilter allKeys] objectAtIndex:0]];
                [sql appendFormat:@" ORDER BY %@ DESC",[groupFilter objectForKey:[[groupFilter allKeys] objectAtIndex:0]]];
            }else{
                [sql appendFormat:@"%@ ='%@' AND userId='%@'",key,[filter objectForKey:key],userId];
            }
        }else{
            [sql appendFormat:@"%@ ='%@' AND ",key,[filter objectForKey:key]];
        }
    }
//    group by targetId order by timeStamp desc
    [DHDBHelper asyncGetDatabaseQueueWithDataBaseName:@"chat" queue:^(FMDatabaseQueue *queue, NSString *dbPath) {
        NSMutableArray *array = [NSMutableArray array];
        [queue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:sql];
            NSDictionary *temp = [rs columnNameToIndexMap];
            while ([rs next]) {
                NSMutableDictionary *d = [NSMutableDictionary dictionary];
                for (NSString *key in [temp allKeys]) {
                    NSString *str = [rs stringForColumn:key];
                    [d setObject:str forKey:key];
                }
                [array addObject:d];
            }
            [rs close];
        }];
         completed(array,sql);
    }];
    
}
// 查询数据 key：字段名，value：具体数值
+ (void)asyncQueryCountDataFromDataBaseWithUserId:(NSString *)userId tableName:(NSString *)tableName filter:(NSDictionary *)filter completed:(void(^)(NSInteger count, NSString *sql))completed{
    [[DHTableManager shareInstance] asyncQueryCountDataFromDataBaseWithUserId:userId tableName:tableName filter:filter completed:completed];
}
- (void)asyncQueryCountDataFromDataBaseWithUserId:(NSString *)userId tableName:(NSString *)tableName filter:(NSDictionary *)filter completed:(void(^)(NSInteger count, NSString *sql))completed{
    __block NSMutableString *sql = [NSMutableString string];
    [sql appendString:[DHTableManager asyncConfigDataBaseSqlWithType:DB_SQL_QUERY_TYPE_SELECT_COUNT]];
    [sql appendFormat:@" %@ ",tableName];
    if (filter != nil) {
        [sql appendFormat:@" WHERE "];
    }else{
        [sql appendFormat:@" WHERE userId='%@'",userId];
    }
    
    for (int i = 0; i < [[filter allKeys] count]; i ++) {
        NSString *key = [[filter allKeys] objectAtIndex:i];
        if (i == [[filter allKeys] count] - 1) {
            [sql appendFormat:@"%@='%@' AND userId='%@'",key,[filter objectForKey:key],userId];
        }else{
            [sql appendFormat:@"%@='%@' AND",key,[filter objectForKey:key]];
        }
    }
    [DHDBHelper asyncGetDatabaseQueueWithDataBaseName:@"chat" queue:^(FMDatabaseQueue *queue, NSString *dbPath) {
        [queue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:sql];
            while (rs.next) {
                completed([rs intForColumn:@"COUNT"],sql);
            }
            [rs close];
        }];
    }];
    
}



+ (NSDictionary *) asyncFormatWithObject:(NSDictionary *)object{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *key in [object allKeys]) {
        [dict setObject:@"text" forKey:key];
    }
    return dict;
}
/**
 *  获取当前运行时model的所有属性
 *
 *  @param class 类名
 *
 *  @return
 */
+ (NSDictionary *) asyncFormatPropertyNamesWithClass:(id )obj{
//    NSDictionary *dict = class.dataDictionary;
    //存储所有的属性名称
    NSMutableDictionary *propertyDict = [[NSMutableDictionary alloc] init];
    //存储属性的个数
    unsigned int propertyCount = 0;
    
    //通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList([obj class], &propertyCount);
    NSMutableArray *arr = [NSMutableArray array];
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        //取出第一个属性
        objc_property_t property = propertys[i];
        const char * propertyName = property_getName(property);
        NSString *itemName = [NSString stringWithUTF8String:propertyName];
        id value = [obj valueForKey:itemName];
        if (value == nil || [value isEqual:[NSNull null]]) {
            value = @"";
        }
        [propertyDict setObject:value forKey:itemName];
        [arr addObject:itemName];
    }
//    [self displayCurrentModleProperty:arr class:obj];
    //释放
    free(propertys);
    return propertyDict;
}

+ (SEL) creatGetterWithPropertyName: (NSString *) propertyName{
    //1.返回get方法: oc中的get方法就是属性的本身
    return NSSelectorFromString(propertyName);
}
+ (void) displayCurrentModleProperty:(NSArray *)array class:(Class)obj{
    //获取实体类的属性名
//    NSArray *array = [self allPropertyNames];
    //拼接参数
    NSMutableString *resultString = [[NSMutableString alloc] init];
    for (int i = 0; i < array.count; i ++) {
        //获取get方法
        SEL getSel = [self creatGetterWithPropertyName:array[i]];
        if ([obj respondsToSelector:getSel]) {
            //获得类和方法的签名
            NSMethodSignature *signature = [self methodSignatureForSelector:getSel];
            //从签名获得调用对象
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            //设置target
            [invocation setTarget:self];
            //设置selector
            [invocation setSelector:getSel];
            //接收返回的值
            NSObject *__unsafe_unretained returnValue = nil;
            //调用
            [invocation invoke];
            //接收返回值
            [invocation getReturnValue:&returnValue];
            [resultString appendFormat:@"%@\n", returnValue];
        }
    }
    NSLog(@"%@", resultString);
}
@end
