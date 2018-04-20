//
//  AppDelegate+KMDLogSettingCategory.m
//  KMDance
//
//  Created by KM on 17/5/182017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "AppDelegate+KMDLogSettingCategory.h"

@implementation AppDelegate (KMDLogSettingCategory)

- (void)logSetting {
    
    //配置DDLog
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
    
    
    NSLog(@"NSLog");
    DDLogVerbose(@"Verbose");
    DDLogDebug(@"Debug");
    DDLogWarn(@"Warn");
    DDLogError(@"Error");
    
    DDLogError(@"%@",NSHomeDirectory());
}

@end
