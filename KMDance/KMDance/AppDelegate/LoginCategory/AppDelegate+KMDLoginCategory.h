//
//  AppDelegate+KMDLoginCategory.h
//  KMDance
//
//  Created by KM on 17/5/222017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "AppDelegate.h"
#import "BATLoginModel.h"

@interface AppDelegate (KMDLoginCategory)


/**
 登录

 @param userName 用户名
 @param password 密码
 @param success 成功
 @param failure 失败
 */
- (void)kmd_LoginWithUserName:(NSString *)userName password:(NSString *)password Success:(void(^)(void))success failure:(void(^)(NSError * error))failure;


/**
 登出
 */
- (void)kmd_logout;


/**
 自动登录

 @param success 成功
 @param failure 失败
 */
- (void)kmd_autoLoginSuccess:(void(^)(void))success failure:(void(^)(void))failure;

/**
 登录成功处理

 @param login 登录模型
 @param userName 用户名
 @param password 密码
 */
- (void)successActionWithLogin:(BATLoginModel *)login userName:(NSString *)userName password:(NSString *)password;
@end
