//
//  HTTPTool+KMDLoginRequest.h
//  KMDance
//
//  Created by KM on 17/6/262017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "HTTPTool.h"

@interface HTTPTool (KMDLoginRequest)

/**
 *  .net接口 封装
 *
 *  @param URLString  URL
 *  @param parameters 参数
 *  @param type       请求类型
 *  @param success    请求成功
 *  @param failure    请求失败
 */
+ (void)requestWithLoginURLString:(NSString *)URLString
                       parameters:(id)parameters
                             type:(XMHTTPMethodType)type
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError * error))failure;

@end
