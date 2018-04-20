//
//  AppDelegate+KMDDownloadCategory.m
//  KMDance
//
//  Created by KM on 17/6/232017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "AppDelegate+KMDDownloadCategory.h"
#import <objc/message.h>

#define CompletionHandlerName       "completionHandler"

@implementation AppDelegate (KMDDownloadCategory)

- (void (^)(void))completionHandler
{
    return objc_getAssociatedObject(self, CompletionHandlerName);
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"%s", __FUNCTION__);
    objc_setAssociatedObject(self, CompletionHandlerName, completionHandler, OBJC_ASSOCIATION_COPY);
}

@end
