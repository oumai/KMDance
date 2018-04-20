//
//  AppDelegate+KMDLoginCategory.m
//  KMDance
//
//  Created by KM on 17/5/222017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "AppDelegate+KMDLoginCategory.h"

#import "KMDRootTabBarViewController.h"

#import "BATPerson.h"

#import "SFHFKeychainUtils.h"
#import "SVProgressHUD.h"

@implementation AppDelegate (KMDLoginCategory)

- (void)kmd_LoginWithUserName:(NSString *)userName password:(NSString *)password Success:(void(^)(void))success failure:(void(^)(NSError * error))failure {
    
    [HTTPTool requestWithLoginURLString:@"/api/NetworkMedical/Login"
                        parameters:@{
                                     @"AccountName":userName,
                                     @"PhoneNumber":@"",
                                     @"PassWord":password,
                                     @"LoginType":@"1"
                                     }
                              type:kXMHTTPMethodPOST
                           success:^(id responseObject) {
                               
                               BATLoginModel * login = [BATLoginModel mj_objectWithKeyValues:responseObject];
                               
                               if (login.ResultCode == 0) {
                                   
                                   [self successActionWithLogin:login userName:userName password:password];
                                   
                                   if (success) {
                                       success();
                                   }
                               }
                           }
                           failure:^(NSError *error) {
                               
                               if (failure) {
                                   failure(error);
                               }
                           }];
}

- (void)kmd_logout {
    
    DDLogDebug(@"退出登录");
    SET_LOGIN_STATION(NO);
    
    //清除本地数据
    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserLogin.data"] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"] error:nil];
    
    //清楚token
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //清楚推送
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //界面跳转
    KMDRootTabBarViewController *rootTabBar = (KMDRootTabBarViewController *)self.window.rootViewController;
    for (UINavigationController * nav in rootTabBar.viewControllers) {
        
        [nav popToRootViewControllerAnimated:YES];
    }
    [self bk_performBlock:^(id obj) {
        
        SET_LOGIN_STATION(NO);
        [SVProgressHUD showSuccessWithStatus:@"退出登录"];
    } afterDelay:0.5];
}

- (void)kmd_autoLoginSuccess:(void(^)(void))success failure:(void(^)(void))failure {
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"LOGIN_NAME"];
    NSError *error;
    NSString * password = [SFHFKeychainUtils getPasswordForUsername:userName andServiceName:ServiceName error:&error];
    if(error){
        DDLogError(@"从Keychain里获取密码出错：%@",error);
        return;
    }
    
    if (!password || !userName) {
        //密码或者用户名未获取到，退出登录
        [self kmd_logout];
        return;
    }
    
    [self kmd_LoginWithUserName:userName password:password Success:^{
        
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        
        [self kmd_logout];
        if (failure) {
            failure();
        }
    }];
}

- (void)successActionWithLogin:(BATLoginModel *)login userName:(NSString *)userName password:(NSString *)password {
    
    //talkingData登陆统计
    [TalkingData onLogin:login.Data.Mobile type:TDAccountTypeRegistered name:login.Data.UserName];

    //登录成功
    if (login.Data.AccountType == 2) {
        //医生账号，暂时不能登陆
        [SVProgressHUD showErrorWithStatus:@"账号异常"];
        return ;
    }
    
    //保存密码
    NSError  *error;
    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"LOGIN_NAME"];
    BOOL saved = [SFHFKeychainUtils storeUsername:userName andPassword:password forServiceName:ServiceName updateExisting:YES error:&error];
    if(!saved){
        DDLogError(@"保存密码时出错：%@",error.localizedDescription);
    }
    
    //改变登录状态
    SET_LOGIN_STATION(YES);
    
    //保存登录信息
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserLogin.data"];
    [NSKeyedArchiver archiveRootObject:login toFile:file];
    
    //保存token
    [[NSUserDefaults standardUserDefaults] setValue:login.Data.Token forKey:@"Token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //获取个人信息
    [self personInfoListRequest];
}



//获取个人信息
- (void)personInfoListRequest {
    
    [HTTPTool requestWithLoginURLString:@"/api/Patient/Info" parameters:nil type:kXMHTTPMethodGET success:^(id responseObject) {
        
        BATPerson * person = [BATPerson mj_objectWithKeyValues:responseObject];
        if (person.ResultCode == 0) {
            
            //保存登录信息
            NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"];
            [NSKeyedArchiver archiveRootObject:person toFile:file];
        }
    } failure:^(NSError *error) {
        
    }];
}


@end
