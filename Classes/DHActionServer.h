//
//  DHActionServer.h
//  DHRequestServer
//
//  Created by xy2 on 16/1/19.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "AFNetworking.h"
//#import "ASIHTTPRequest.h"
//#import "ASIFormDataRequest.h"
//#import "GTMBase64.h"
//#import "SecurityUtil.h"

/**
 *  加密key可修改
 */
static NSString * const SECURITY_ENCODE_KEY   = @"2015$!@aiyoutech";

typedef NS_ENUM(NSInteger , DHRequestServerType){
    DHRequestServerTypeAuthor = 0,
    DHRequestServerTypeBus,
    DHRequestServerTypeFile,
};
typedef NS_ENUM(NSInteger , DHRequestMethodType) {
    DHRequestMethodTypeGet = 0,
    DHRequestMethodTypePost,
};
/**
 *  内网ip
 */
static const NSString *INLINE_SEVER_URL = @"http://api5.lingte.cc/web/getmv";
/**
 *  图片上传url
 */
static const NSString *INLINE_FILE_SERVER_URL = @"http://115.236.55.163:9096/";
/**
 *  192.168.0.194
 */
static const NSString *LOCAL_194_SERVERURL = @"http://192.168.0.194:9093/";
/**
 *  192.168.0.195
 */
static const NSString *LOCAL_195_SERVERURL = @"http://192.168.0.195:9093/";
/**
 *  msgweb.imchumo.com
 */
static const NSString *ONLINE_SERVER_URL = @"http://msgweb.imchumo.com/";



@interface DHActionServer : NSObject

/**
 *  请求对象单利
 *
 *  @return
 */
+ (DHActionServer *)shareActionServer;

/**
 *  获取请iuqduixiang
 *
 *  @return
 */
+ (id) getRequestManager;
/**
 *  请求数据
 *
 *  @param request      请求服务器对象
 *  @param methodType   GET/POST
 *  @param serverType   请求服务器类型
 *  @param service      api
 *  @param parameters   请求参数
 *  @param resultBlock
 *  @param failureBlock 
 */
+ (void)actionWithRequest:(AFHTTPRequestOperationManager *)request methodType:(DHRequestMethodType )methodType server:(DHRequestServerType )serverType service:(NSString *)service parameters:(NSDictionary *)parameters result:(void(^)(id result ,NSInteger resultCode))resultBlock failure:(void(^)(AFHTTPRequestOperation *operation, NSDictionary *userInfo))failureBlock;
/**
 *  上传图片
 *
 *  @param imageData    图片二进制文件
 *  @param methodType   post
 *  @param serverType   file
 *  @param service      api
 *  @param parameters   参数
 *  @param resultBlock
 *  @param failureBlock
 */
+ (void)actionFromImageTypeForUploadImageData:(NSData *)imageData methodType:(DHRequestMethodType )methodType server:(DHRequestServerType )serverType service:(NSString *)service parameters:(NSDictionary *)parameters result:(void(^)(id result ,NSInteger resultCode))resultBlock failure:(void(^)(NSDictionary *userInfo))failureBlock;
@end
