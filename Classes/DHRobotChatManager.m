//
//  DHRobotChatManager.m
//  DHRequestServer
//
//  Created by xy2 on 16/2/29.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHRobotChatManager.h"
#import "DHRobotTableDao.h"
#import "DHUserTableDao.h"
#import "DHRandomMessageModel.h"
#import "DHMessageTableDao.h"
#import "DHMessageModel.h"
#import "DHChatMessageDao.h"
@implementation DHRobotChatManager

+ (void)asyncConfigRobotManagerWithCurrentUserId:(NSString *)userId{
    static DHRobotChatManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DHRobotChatManager alloc]init];
        __weak DHRobotChatManager *weakManager = manager;
        [manager asyncGetCurrentUserInfoWithUserId:userId completed:^(DHUserInfoModel *userInfo, NSString *sql) {
            [weakManager pushfirstNotificationWithUserInfo:userInfo currentUserId:userId];
        }];
    });
}
/**
 *  发送第一条消息
 */
- (void)pushfirstNotificationWithUserInfo:(DHUserInfoModel *)item currentUserId:(NSString *)userId{
    self.userinfo = item;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replyMessageToRobot:) name:REPLY_MESSAGE_TO_ROBOT_NOTIFICATION object:nil];
    NSString *date = [[DHDateFormatManager asyncStringFromDate:[NSDate date]] substringToIndex:10];
    BOOL istodaysended = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@-%@",date,userId]];
    if (!istodaysended) {
        if ([item.b144 integerValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *robotMessageType = @"1";
                [self pushfirstNotificationWhenAfterLogin:item lastRobotMessageType:[robotMessageType integerValue] targetRobotId:nil compeleted:^(NSString *robotId) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:item,@"currentUserinfo",robotId,@"robotId",robotMessageType,@"robotMessageType", nil];
                    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(pushRobotMessage:) userInfo:dict repeats:YES];
                    [timer fire];
                    
                }];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10*2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *robotMessageType = @"1";
                [self pushfirstNotificationWhenAfterLogin:item lastRobotMessageType:[robotMessageType integerValue] targetRobotId:nil compeleted:^(NSString *robotId) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:item,@"currentUserinfo",robotId,@"robotId",robotMessageType,@"robotMessageType", nil];
                    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(pushRobotMessage:) userInfo:dict repeats:YES];
                    [timer fire];
                }];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10*5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *robotMessageType = @"1";
                [self pushfirstNotificationWhenAfterLogin:item lastRobotMessageType:[robotMessageType integerValue] targetRobotId:nil compeleted:^(NSString *robotId) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:item,@"currentUserinfo",robotId,@"robotId",robotMessageType,@"robotMessageType", nil];
                    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(pushRobotMessage:) userInfo:dict repeats:YES];
                    [timer fire];
                    // 记录当天已经发送了三个人
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@-%@",date,userId]];
                }];
            });
        }
    }
    
}
/**
 *  机器人给用户发消息
 *
 *  @param timer
 */
- (void)pushRobotMessage:(NSTimer *)timer{
    NSDictionary *dict = timer.userInfo;
    DHUserInfoModel *item = [dict objectForKey:@"currentUserinfo"];
    NSString *robotId = [dict objectForKey:@"robotId"];
    NSInteger robotMessageType = [[NSUserDefaults standardUserDefaults] integerForKey:robotId];
    if (robotMessageType == 0) {
        robotMessageType = 1;
    }
    NSString *targetRobotId = [[NSUserDefaults standardUserDefaults] objectForKey:@"targetRobotId"];
    if (!targetRobotId) {
        // 如果已经发送过，则发送下一个类型的消息
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:robotId,@"targetId",[NSString stringWithFormat:@"%ld",robotMessageType],@"robotMessageType", nil];
        [DHMessageTableDao asyncExecuteQueryMessageInfoWithCurrentUserId:item.b80 filter:dict groupFilter:nil compeleted:^(NSArray *array, NSString *sql) {
            if (array.count > 0) {
                NSInteger type = 0;
                if (robotMessageType == 1) {
                    type = robotMessageType  + 2;
                }else{
                    type = robotMessageType  + 1;
                }
                [self pushfirstNotificationWhenAfterLogin:item lastRobotMessageType:type targetRobotId:robotId compeleted:^(NSString *robotId) {
                    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:robotId];
                    // 发了第4种类型消息，停止发送
                    if (type == 4) {
                        [timer invalidate];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:robotId];
                    }
                }];
            }else{
                NSInteger type = robotMessageType;
                [self pushfirstNotificationWhenAfterLogin:item lastRobotMessageType:type targetRobotId:robotId compeleted:^(NSString *robotId) {
                    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:robotId];
                }];
                
            }
        }];
    }
}
/**
 *  用户回复机器人情况
 *
 *  @param notifi 通知回调
 */
- (void)replyMessageToRobot:(NSNotification *)notifi{
    NSDictionary *dict = notifi.object;
    NSInteger lastRobotMessageType = [[dict objectForKey:@"lastRobotMessageType"] integerValue];
    if (lastRobotMessageType == 0) {
        lastRobotMessageType = 1;
    }
    NSString *targetRobotId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"targetRobotId"]];
    //    DHUserForChatModel *userinfo = [dict objectForKey:@"robotUserinfo"];
    // 保存到本地，用于判断是否回复
    [[NSUserDefaults standardUserDefaults] setObject:targetRobotId forKey:@"targetRobotId"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        switch (lastRobotMessageType) {
            case 1:{
                // 回复类型1，发类型2或者4
                NSInteger temp = arc4random() % 2;
                NSInteger type = temp == 0 ? 2 : 4;
                [self pushfirstNotificationWhenAfterLogin:self.userinfo lastRobotMessageType:type targetRobotId:targetRobotId compeleted:^(NSString *robotId) {
                    
                }];
            }
                break;
            case 2:{
                // 回复类型2，发类型4
                NSInteger type = 4;
                [self pushfirstNotificationWhenAfterLogin:self.userinfo lastRobotMessageType:type targetRobotId:targetRobotId compeleted:^(NSString *robotId) {
                    
                }];
            }
                break;
            case 4:{
                // 回复类型4，停止发送
                return ;
                
            }
                break;
            default:
                break;
        }
    });
}

- (void )pushfirstNotificationWhenAfterLogin:(DHUserInfoModel *)item lastRobotMessageType:(NSInteger )lastRobotMessageType targetRobotId:(NSString *)targetRobotId compeleted:(void(^)(NSString *robotId))compeleted{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([item.b144 integerValue] == 1) {
            DHUserInfoModel *userinfo = item;
            [self asyncConfigRandomMessageWithUserId:item.b80 lastRobotMessageType:lastRobotMessageType compeleted:^(DHRandomMessageModel *message, NSString *sql) {
                __block DHRandomMessageModel *messageItem = message;
                [self asyncGetRobotInfoWithUserId:userinfo.b80 robotId:targetRobotId gender:userinfo.b69 result:^(DHRobotModel *userInfo, NSString *sql) {
                    DHRobotModel *robotUser = userInfo;
                    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                    NSTimeInterval a = [dat timeIntervalSince1970]*1000;
                    long long b = a;
                    NSString *timeString = [NSString stringWithFormat:@"%lld", b];//转为字符型
                    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
                    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *fmtDate = [fmt stringFromDate:dat];
                    DHMessageModel *msg = [[DHMessageModel alloc] init];
                    msg.toUserAccount = userinfo.b80;
                    msg.roomName = robotUser.b52;
                    msg.message = messageItem.b14;
                    msg.fromUserDevice = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2]];// 1:安卓 2:苹果 3:windowPhone
                    msg.timeStamp = fmtDate;
                    NSString *userId = item.b80;
                    msg.fromUserAccount = robotUser.b80;
                    msg.messageType = @"1";
                    msg.messageId = timeString;// 消息ID
                    msg.roomCode = robotUser.b80;
                    msg.targetId = robotUser.b80;
                    msg.robotMessageType = messageItem.b78;
//                    msg.userId = userId;
                    msg.isRead = @"1";
                    [self localNotification:msg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:DID_RECEIVE_MESSAGE_NOTIFICATION object:msg];
                    NSDictionary *filter = [NSDictionary dictionaryWithObjectsAndKeys:msg.messageId,@"messageId",msg.targetId,@"targetId", nil];
                    NSDictionary *filed = [msg dataDictionary];
                    [DHChatMessageDao asyncCreateUserTableWithTableName:@"CHATMESSAGEINFO_TABLE" field:filed result:^(BOOL flag, NSString *sql) {
                        
                    }];
                    [DHChatMessageDao asyncExecuteQueryMessageInfoWithCurrentUserId:userId filter:filter groupFilter:nil compeleted:^(NSArray *array, NSString *sql) {
                        if (array.count == 0) {
                            [DHChatMessageDao asyncExecuteSaveMessageInfoToDataBaseWithItem:msg currentUserId:userId compeleted:^(BOOL flag, NSString *sql) {
                                
                            }];
                        }
                    }];
                    compeleted(robotUser.b80);
                }];
            }];
            
        }else{
            compeleted(nil);
        }
    });
    
}
/**
 *  添加本地通知
 *
 *  @param message 消息
 */
- (void)localNotification:(DHMessageModel *)message{
    UILocalNotification *localNotifi = [[UILocalNotification alloc]init];
    // 设置推送时间
    localNotifi.fireDate = [NSDate date];
    // 设置时区
    localNotifi.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复间隔
    localNotifi.repeatInterval = 0;
    //    kCFCalendarUnitDay;
    // 推送声音
    localNotifi.soundName = UILocalNotificationDefaultSoundName;
    // 推送内容
    localNotifi.alertBody = message.message;
    //显示在icon上的红色圈中的数子
    //    localNotifi.applicationIconBadgeNumber = 1;
    //设置userinfo 方便在之后需要撤销的时候使用
    NSDictionary *info = [NSDictionary dictionaryWithObject:@"name"forKey:@"key"];
    localNotifi.userInfo = info;
    //添加推送到UIApplication
    UIApplication *app = [UIApplication sharedApplication];
    [app scheduleLocalNotification:localNotifi];
}
/**
 *  获取当前用户信息
 *
 *  @param userId
 *  @param completed
 */
- (void )asyncGetCurrentUserInfoWithUserId:(NSString *)userId completed:(void(^)(DHUserInfoModel *userInfo,NSString *sql))completed{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"b80", nil];
    [DHUserTableDao asyncExecuteQueryUserInfoWithCurrentUserId:userId filter:dict compeleted:^(NSArray *array, NSString *sql) {
        if (array.count > 0) {
            NSDictionary *temp = [array lastObject];
            DHUserInfoModel *item = [[DHUserInfoModel alloc]init];
            [item setValuesForKeysWithDictionary:temp];
            completed(item,sql);
        }else{
            completed(nil,sql);
        }
    }];
}
/**
 *  获取机器人用户信息
 *
 *  @param userId    当前用户id
 *  @param robotId   机器人id---可为空，若为空，则随机获取一个机器人，若不为空，则获取该id的机器人
 *  @param gender    性别，取反
 *  @param completed
 */
- (void )asyncGetRobotInfoWithUserId:(NSString *)userId robotId:(NSString *)robotId gender:(NSString *)gender result:(void(^)(DHRobotModel *userInfo,NSString *sql))result{
    NSString *gender1 = nil;
    if ([gender integerValue] == 1) {
        gender1 = @"2";
    }else{
        gender1 = @"1";
    }
    NSDictionary *dict = nil;
    if ([robotId length] == 0) {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:gender1,@"b69",@"2",@"b143", nil];
    }else{
        dict = [NSDictionary dictionaryWithObjectsAndKeys:robotId,@"b80",gender1,@"b69",@"2",@"b143", nil];
    }
    
    [DHRobotTableDao asyncExecuteQueryRobotInfoWithCurrentUserId:userId filter:dict compeleted:^(NSArray *array, NSString *sql) {
        if (array.count > 0) {
            NSInteger randomIndex = arc4random()%array.count-1;
            if (randomIndex<0) {
                randomIndex = 0;
            }else if(randomIndex > array.count - 1){
                randomIndex = array.count - 1;
            }
            DHRobotModel *userInfo = [[DHRobotModel alloc]init];
            NSDictionary *temp = [array lastObject];
            [userInfo setValuesForKeysWithDictionary:temp];
            result(userInfo,sql);
        }else{
            result(nil,sql);
        }
    }];
    
//    [DHUserTableDao asyncExecuteQueryUserInfoWithCurrentUserId:userId filter:dict compeleted:^(NSArray *array, NSString *sql) {
//        if (array.count > 0) {
//            NSInteger randomIndex = arc4random()%array.count-1;
//            if (randomIndex<0) {
//                randomIndex = 0;
//            }else if(randomIndex > array.count - 1){
//                randomIndex = array.count - 1;
//            }
//            DHRobotModel *userInfo = [[DHRobotModel alloc]init];
//            NSDictionary *temp = [array lastObject];
//            [userInfo setValuesForKeysWithDictionary:temp];
//            result(userInfo,sql);
//        }else{
//            result(nil,sql);
//        }
//    }];
}
/**
 *  获取随机消息
 *
 *  @param userId     当前用户id
 *  @param compeleted
 */
- (void)asyncConfigRandomMessageWithUserId:(NSString *)userId lastRobotMessageType:(NSInteger )lastRobotMessageType  compeleted:(void(^)(DHRandomMessageModel *message,NSString *sql))compeleted{
//    NSDictionary *groupFilter = [NSDictionary dictionaryWithObjectsAndKeys:@"timeStamp",@"targetId", nil];
    NSDictionary *filter = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",lastRobotMessageType],@"b78", nil];
    [DHMessageTableDao asyncExecuteQueryMessageInfoWithCurrentUserId:userId filter:filter groupFilter:nil compeleted:^(NSArray *array, NSString *sql) {
        if (array.count > 0) {
            NSInteger randomIndex = arc4random()%array.count-1;
            if (randomIndex<0) {
                randomIndex = 0;
            }else if(randomIndex > array.count - 1){
                randomIndex = array.count - 1;
            }
            DHRandomMessageModel *item = [[DHRandomMessageModel alloc]init];
            NSDictionary *temp = [array objectAtIndex:randomIndex];
            [item setValuesForKeysWithDictionary:temp];
            compeleted(item,sql);
        }else{
            compeleted(nil,sql);
        }
    }];
}
@end
