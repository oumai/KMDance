//
//  AppDelegate+KMDTalkingDataCategory.m
//  KMDance
//
//  Created by Skybrim on 2017/9/21.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "AppDelegate+KMDTalkingDataCategory.h"

@implementation AppDelegate (KMDTalkingDataCategory)

- (void)talkingDataInit {

    // App ID: 在 App Analytics 创建应用后，进入数据报表页中，在“系统设置”-“编辑应用”页面里查看App ID。
    // 渠道 ID: 是渠道标识符，可通过不同渠道单独追踪数据。
#ifdef ENTERPRISERELEASE
    [TalkingData sessionStarted:@"A780CD919C314ED9B5A6EB1A2B14DB44" withChannelId:@"iOS-PGY"];
#elif RELEASE
    [TalkingData sessionStarted:@"A780CD919C314ED9B5A6EB1A2B14DB44" withChannelId:@"iOS-AppStore"];
#else
    [TalkingData sessionStarted:@"A780CD919C314ED9B5A6EB1A2B14DB44" withChannelId:@"iOS-TEST"];
#endif
    
    [TalkingData setExceptionReportEnabled:YES];

}
@end
