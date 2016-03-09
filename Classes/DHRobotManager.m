//
//  DHRobotManager.m
//  DHRequestServer
//
//  Created by xy2 on 16/2/25.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHRobotManager.h"

@implementation DHRobotManager


+ (DHRobotManager *)asyncGetInstance{
    static DHRobotManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DHRobotManager alloc]init];
    });
    return manager;
}





@end
