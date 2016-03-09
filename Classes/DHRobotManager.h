//
//  DHRobotManager.h
//  DHRequestServer
//
//  Created by xy2 on 16/2/25.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHHttpBusServer.h"
#import "DHDateFormatManager.h"


static  NSString *const DID_RECEIVE_MESSAGE_NOTIFICATION = @"DID_RECEIVE_MESSAGE_NOTIFICATION";

@interface DHRobotManager : NSObject
/**
 *  获取机器人组件实体
 *
 *  @return
 */
+ (DHRobotManager *)asyncGetInstance;

@end
