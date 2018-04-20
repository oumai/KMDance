//
//  HTTPTool+BATDomainAPI.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/8/15.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool+BATDomainAPI.h"
#import "BATDomainModel.h"

@implementation HTTPTool (BATDomainAPI)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
+ (void)getDomain {

#ifdef DEBUG
    //开发｀


    //BAT-WEB
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.29:9999" forKey:@"AppDomainUrl"];//李秋萍
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc001tn-web.chinacloudsites.cn/" forKey:@"AppWebUrl"];//测试

    //BAT-H5
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc001tn-h5.chinacloudsites.cn" forKey:@"AppH5Url"];//测试

    //BAT-用户信息接口
    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.32.24:81" forKey:@"AppApiLoginUrl"];//张玮
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc001tn-app.chinacloudsites.cn" forKey:@"AppApiLoginUrl"];

    //广场舞API
    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.32.24:81" forKey:@"AppApiUrl"];//张玮
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.198:9998" forKey:@"AppApiUrl"];//金迪
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.83:9998" forKey:@"AppApiUrl"];//催扬
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://121.15.153.63:8124" forKey:@"AppApiUrl"];//李何苗
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.205:80" forKey:@"AppApiUrl"];//王立军
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.29:9998" forKey:@"AppApiUrl"];//李秋萍
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc012tn-web.chinacloudsites.cn" forKey:@"AppApiUrl"];//测试


    //java
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.181:8081" forKey:@"searchdominUrl"];//郭关荣
//    [[NSUserDefaults standardUserDefaults]setValue:@"http://10.2.21.82:8083" forKey:@"searchdominUrl"];//连自杰
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.59:8081" forKey:@"searchdominUrl"];//陈珊
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.test.jkbat.com" forKey:@"searchdominUrl"];

    //商城
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"malldomainUrl"];

#elif TESTING
    //开发&内测
    [[NSUserDefaults standardUserDefaults] setValue:@"http://test.jkbat.com" forKey:@"AppWebUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://weixin.test.jkbat.com/" forKey:@"AppH5Url"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.test.jkbat.com" forKey:@"AppApiLoginUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.sd.test.jkbat.cn" forKey:@"AppApiUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.test.jkbat.com" forKey:@"searchdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"malldomainUrl"];

#elif PUBLICRELEASE
    //测试
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc001tn-web.chinacloudsites.cn/" forKey:@"AppWebUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc001tn-h5.chinacloudsites.cn" forKey:@"AppH5Url"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc001tn-app.chinacloudsites.cn" forKey:@"AppApiLoginUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc012tn-web.chinacloudsites.cn" forKey:@"AppApiUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.test.jkbat.com" forKey:@"searchdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"malldomainUrl"];
#elif PRERELEASE
    //预发布
    /*
    //预发布环境
    [[NSUserDefaults standardUserDefaults] setValue:@"http://apreview.jkbat.com" forKey:@"AppWebUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://weixin.apreview.jkbat.com" forKey:@"AppH5Url"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.apreview.jkbat.com" forKey:@"AppApiLoginUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.sd.apreview.jkbat.cn" forKey:@"AppApiUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc001pe-search.chinacloudsites.cn/" forKey:@"searchdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"malldomainUrl"];
    */
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://www.jkbat.com" forKey:@"AppWebUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://weixin.jkbat.com/" forKey:@"AppH5Url"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.jkbat.com" forKey:@"AppApiLoginUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.sd.jkbat.cn" forKey:@"AppApiUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"searchdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"malldomainUrl"];
    
#elif ENTERPRISERELEASE
    //企业无线发布（蒲公英）

    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc001tn-web.chinacloudsites.cn/" forKey:@"AppWebUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc001tn-h5.chinacloudsites.cn" forKey:@"AppH5Url"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc001tn-app.chinacloudsites.cn" forKey:@"AppApiLoginUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc012tn-web.chinacloudsites.cn" forKey:@"AppApiUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"searchdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"malldomainUrl"];

#elif RELEASE
    //正式（APPSTORE）
    [[NSUserDefaults standardUserDefaults] setValue:@"http://www.jkbat.com" forKey:@"AppWebUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://weixin.jkbat.com/" forKey:@"AppH5Url"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.jkbat.com" forKey:@"AppApiLoginUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.sd.jkbat.cn" forKey:@"AppApiUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"searchdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"malldomainUrl"];
    
#endif

    [[NSUserDefaults standardUserDefaults] setValue:@"http://www.jkbat.com:8080" forKey:@"storedominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://www.jkbat.com:8080" forKey:@"hotquestionUrl"];

    [[NSUserDefaults standardUserDefaults] synchronize];


    [XMCenter setupConfig:^(XMConfig *config) {
//        config.generalServer = @"general server address";
//        config.generalHeaders = @{@"general-header": @"general header value"};
//        config.generalParameters = @{@"general-parameter": @"general parameter value"};
//        config.generalUserInfo = nil;
        config.callbackQueue = dispatch_get_main_queue();
        config.engine = [XMEngine sharedEngine];
#ifdef DEBUG
        config.consoleLog = YES;
#elif TESTING
        config.consoleLog = YES;
#elif PUBLICRELEASE
        config.consoleLog = NO;
#elif PRERELEASE
        config.consoleLog = YES;
#elif ENTERPRISERELEASE
        config.consoleLog = NO;
#elif RELEASE
        config.consoleLog = NO;
#endif
    }];
}



@end
