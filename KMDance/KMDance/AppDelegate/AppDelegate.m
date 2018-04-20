//
//  AppDelegate.m
//  KMDance
//
//  Created by KM on 17/5/122017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+KMDVCSettingCategory.h"//设置VC
#import "AppDelegate+KMDLogSettingCategory.h"
#import "AppDelegate+KMDLoginCategory.h"//登录
#import "AppDelegate+KMDShareCategory.h"
#import "AppDelegate+KMDUploadCategory.h"
#import "AppDelegate+KMDTableViewCategory.h"
#import "AppDelegate+KMDTalkingDataCategory.h"

#import "KMDRootTabBarViewController.h"

#import "HTTPTool+BATDomainAPI.h"
#import "Tools+DeviceCategory.h"
#import "KMDUploadCenter.h"

#import <AVFoundation/AVFoundation.h>
#import "Reachability.h"

@interface AppDelegate ()

@property (nonatomic,strong) Reachability *internetReachability;

@end

@implementation AppDelegate

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    //设置接口信息
    [HTTPTool getDomain];
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"ImageResolutionHeight"]) {
        [Tools saveDeviceInfo];
    }
    
    //设置talkingdata
    [self talkingDataInit];

    //创建window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[KMDRootTabBarViewController alloc] init];

    //设置VC
    [self kmd_settingVC];
    [self kmd_VCDissmiss];
    //设置iOS11tableView
    [self cancelTableViewAdjust];
    
    //设置log
    [self logSetting];
    //设置上传
    [self pauseAllUploadTask];
    
    //自动登录
    if (LOGIN_STATION) {
        [self kmd_autoLoginSuccess:^{
            
        } failure:^{
            
        }];
    }
    
    //音频
    NSError* error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    //状态栏字体
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    //分享设置
    [self shareInit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    //初始化
    _internetReachability=[Reachability reachabilityForInternetConnection];
    //通知添加到Run Loop
    [_internetReachability startNotifier];
    [self updateInterfaceWithReachability:_internetReachability];
    
    
#ifdef RELEASE
    //AppStore更新
    [Tools updateVersion];
#endif
    
    return YES;
}

//实现通知方法
- (void)reachabilityChanged:(NSNotification *)note {
    
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}
//监测网络状态方法
- (void)updateInterfaceWithReachability:(Reachability *)reachability {
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable:
            NSLog(@"====当前网络状态不可用=======");
            break;
        case ReachableViaWiFi:
            NSLog(@"====当前网络状态为Wifi=======");
            break;
        case ReachableViaWWAN:
        {
            NSLog(@"====当前网络状态为流量=======keso");
            
            if ([KMDUploadCenter sharedKMDUploadCenter].isUploading == YES) {
                WEAK_SELF(self);
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您正在使用移动数据网络" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消上传" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    STRONG_SELF(self);
                    [self saveUploadSource];
                    [self pauseAllUploadTask];
                }];
                UIAlertAction *uploadAction = [UIAlertAction actionWithTitle:@"继续上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:uploadAction];
                [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
            }
        }
            break;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid) {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([OpenShare handleOpenURL:url]) {
        return YES;
    }
    
    return NO;
}

@end
