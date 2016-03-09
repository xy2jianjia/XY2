//
//  DHActionServer.m
//  DHRequestServer
//
//  Created by xy2 on 16/1/19.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHActionServer.h"
@implementation DHActionServer

+ (DHActionServer *)shareActionServer{
    static DHActionServer *action = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        action = [[DHActionServer alloc]init];
    });
    return action;
}
// 获取请求对象
+ (id) getRequestManager{
    return [[DHActionServer shareActionServer] getRequestManager];
}
- (id) getRequestManager{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    return manager;
}
// 请求服务器
+ (void)actionWithRequest:(AFHTTPRequestOperationManager *)request methodType:(DHRequestMethodType )methodType server:(DHRequestServerType )serverType service:(NSString *)service parameters:(NSDictionary *)parameters result:(void(^)(id result ,NSInteger resultCode))resultBlock failure:(void(^)(AFHTTPRequestOperation *operation, NSDictionary *userInfo))failureBlock{
    [[[DHActionServer alloc]init] actionWithRequest:request methodType:methodType server:serverType service:service parameters:parameters result:resultBlock failure:failureBlock];
    
}
- (void)actionWithRequest:(AFHTTPRequestOperationManager *)request methodType:(DHRequestMethodType )methodType server:(DHRequestServerType )serverType service:(NSString *)service parameters:(NSDictionary *)parameters result:(void(^)(id result ,NSInteger resultCode))resultBlock failure:(void(^)(AFHTTPRequestOperation *operation, NSDictionary *userInfo))failureBlock{
    NSString *server = nil;
    if (serverType == DHRequestServerTypeAuthor) {
        server = @"lp-author-msc/";
    }else if (serverType == DHRequestServerTypeBus){
        server = @"lp-bus-msc/";
    }
    NSString *url = [NSString stringWithFormat:@"%@",INLINE_SEVER_URL];
    AFHTTPRequestOperationManager *manger = request;
    __block NSError *error = nil;
    if (methodType == DHRequestMethodTypeGet) {
        [manger GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            id responseJSON = [self asyncparseJSONDataToNSDictionary:responseObject];
           
            id responseJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingAllowFragments) error:&error];
//            NSInteger codeNum = [responseJSON[@"code"] integerValue];
            resultBlock(responseJSON,200);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failureBlock(operation,error.userInfo);
        }];
    }else if (methodType == DHRequestMethodTypePost){
        [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            id responseJSON = [self asyncparseJSONDataToNSDictionary:responseObject];
            id responseJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingAllowFragments) error:&error];
//            NSInteger codeNum = [responseJSON[@"code"] integerValue];
            resultBlock(responseJSON,200);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failureBlock(operation,error.userInfo);
        }];
    }
}
//+ (void)actionFromImageTypeForUploadImageData:(NSData *)imageData methodType:(DHRequestMethodType )methodType server:(DHRequestServerType )serverType service:(NSString *)service parameters:(NSDictionary *)parameters result:(void(^)(id result ,NSInteger resultCode))resultBlock failure:(void(^)(NSDictionary *userInfo))failureBlock{
//    [[[DHActionServer alloc]init] actionFromImageTypeForUploadImageData:imageData methodType:methodType server:serverType service:service parameters:parameters result:resultBlock failure:failureBlock];
//}
//- (void)actionFromImageTypeForUploadImageData:(NSData *)imageData methodType:(DHRequestMethodType )methodType server:(DHRequestServerType )serverType service:(NSString *)service parameters:(NSDictionary *)parameters result:(void(^)(id result ,NSInteger resultCode))resultBlock failure:(void(^)(NSDictionary *userInfo))failureBlock{
//    NSMutableString *urlStr = [NSMutableString string];
//    for (NSString *akey in [parameters allKeys]) {
//        [urlStr appendFormat:@"%@=%@&",akey,[parameters objectForKey:akey]];
//    }
//    NSString *urlString = nil;
//    if ([urlStr length] > 0) {
//        urlString = [NSString stringWithFormat:@"%@",[urlStr substringToIndex:[urlStr length]-1]];
//    }
//    NSString *server = nil;
//    if (serverType == DHRequestServerTypeFile) {
//        server = @"lp-file-msc/";
//    }
//    NSString *url = [NSString stringWithFormat:@"%@%@%@.service?%@",INLINE_FILE_SERVER_URL,server,service,urlString];
//    NSData *data = imageData;
//    NSMutableData *myRequestData=[NSMutableData data];
//    //分界线 --AaB03x
//    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
//    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
//    //结束符 AaB03x--
//    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
//    //        //http body的字符串
//    NSMutableString *body=[[NSMutableString alloc]init];
//    ////添加分界线，换行
//    [body appendFormat:@"%@\r\n",MPboundary];
//    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSMutableString *imgbody = [[NSMutableString alloc] init];
//    ////添加分界线，换行
//    [imgbody appendFormat:@"%@\r\n",MPboundary];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyyMMddHHmmsssss";
//    NSString *str = [formatter stringFromDate:[NSDate date]];
//    NSString *fileName = [NSString stringWithFormat:@"%@", str];
//    //声明pic字段，文件名为数字.png，方便后面使用
//    [imgbody appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n",@"a102",fileName];
//    //声明上传文件的格式
//    //            [imgbody appendFormat:@"Content-Type: image/png\r\n\r\n"];
//    [imgbody appendFormat:@"Content-Type: application/octet-stream; charset=utf-8\r\n\r\n"];
//    //声明myRequestData，用来放入http body
//    
//    //将body字符串转化为UTF8格式的二进制
//    [myRequestData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
//    //将image的data加入
//    [myRequestData appendData:data];
//    [myRequestData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    //声明结束符：--AaB03x--
//    NSString *end=[[NSString alloc]initWithFormat:@"%@\r\n",endMPboundary];
//    //加入结束符--AaB03x--
//    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
//    //设置HTTPHeader中Content-Type的值
//    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
//    [request addRequestHeader:@"Content-Type" value:content];
//    //设置http body
//    [request setPostBody:myRequestData];
//    if (methodType == DHRequestMethodTypePost) {
//        [request setRequestMethod:@"POST"];
//    }else{
//        [request setRequestMethod:@"GET"];
//    }
//    [request setTimeOutSeconds:1200];
//    [request setDelegate:self];
//    [request startSynchronous];
//    NSInteger responseCode = [request responseStatusCode];
//    NSData *responseObject = request.responseData;
//    id responseJSON = [self asyncparseJSONDataToNSDictionary:responseObject];
//    NSInteger codeNum = [responseJSON[@"code"] integerValue];
//    if (responseCode == 200 && codeNum == 200) {
//        resultBlock(responseJSON,codeNum);
//    }else{
//        failureBlock(responseJSON);
//    }
//}
///**
// *  将返回数据转换成字典或者数组
// *
// *  @param jsonData nsdata
// *
// *  @return
// */
//- (id)asyncparseJSONDataToNSDictionary:(NSData *)jsonData{
//    NSData *datas = jsonData;
//    NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
//    NSString *decStr = nil;
//    if ([result isEqualToString:@""] || result == nil){
//        // 数据加载异常
//        decStr = nil;
//    }else{
//        NSData *EncryptData = [GTMBase64 decodeString:result]; //解密前进行GTMBase64编码
//        NSString * string = [SecurityUtil decryptAESData:EncryptData app_key:SECURITY_ENCODE_KEY];
//        if ([string isEqualToString:@""] || string == nil) {
//            // 数据加载异常
//            decStr = nil;
//        }else{
//            decStr = [string copy];
//        }
//        
//    }
//    NSData *JSONData = [decStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *responseJSON = nil;
//    if (JSONData) {
//        responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
//        
//    }
//    return responseJSON;
//}



@end
