//
//  AppDelegate+KMDUploadCategory.m
//  KMDance
//
//  Created by KM on 17/8/72017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "AppDelegate+KMDUploadCategory.h"
#import "KMDUploadCenter.h"

@implementation AppDelegate (KMDUploadCategory)

- (void)pauseAllUploadTask {
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveUploadSource) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveUploadSource) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUploadSource) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    NSMutableArray *uploadFiles = [[KMDUploadCenter sharedKMDUploadCenter] getUploadSource];
    
    for (KMDUploadFile *file in uploadFiles) {
        
        file.isPause = YES;
    }
    
    [[KMDUploadCenter sharedKMDUploadCenter] saveUploadSource:uploadFiles];
}

- (void)saveUploadSource {
    
    [[KMDUploadCenter sharedKMDUploadCenter] saveUploadSource:[KMDUploadCenter sharedKMDUploadCenter].dataArray];
}

- (void)getUploadSource {
    
    [[KMDUploadCenter sharedKMDUploadCenter] getUploadSource];
}

@end
