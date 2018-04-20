//
//  BATMacro.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/8/15.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#ifndef BATMacro_h
#define BATMacro_h

//健康BAT的App Store的ID
#define KMDDance_APPSTORE_ID @"1243304044"

//微信appid
#define WeChatAppId @"wxe604d9160748549a"

//网络

#define APP_WEB_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"AppWebUrl"]//域名
#define APP_H5_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"AppH5Url"]//域名

#define APP_LOGIN_API_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"AppApiLoginUrl"]//登录API
#define APP_API_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"AppApiUrl"]//API

#define SEARCH_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"searchdominUrl"]//搜索域名
#define MALL_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"malldomainUrl"]//搜索域名

#define STORE_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"storedominUrl"]//商城域名
#define HOT_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"hotquestionUrl"]//热门话题域名

#define LOCAL_TOKEN [[NSUserDefaults standardUserDefaults] valueForKey:@"Token"]//存入本地的token

//登录
#define LOGIN_STATION [[NSUserDefaults standardUserDefaults] boolForKey:@"LoginStation"]//登录状态

//网络状态
#define NET_STATION [[NSUserDefaults standardUserDefaults] boolForKey:@"netStatus"]//有无网络

//请求状态
#define RESQUEST_STATION [[NSUserDefaults standardUserDefaults] boolForKey:@"resquestStatus"]//请求成功还是失败

//地理位置
#define LOCATION_STATION [[NSUserDefaults standardUserDefaults] boolForKey:@"LOCATION_STATION"]//地理位置定位状态

#define SET_LOGIN_STATION(bool) [[NSUserDefaults standardUserDefaults] setBool:bool forKey:@"LoginStation"];[[NSUserDefaults standardUserDefaults] synchronize];//改变登录状态
#define PRESENT_LOGIN_VC [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[KMDLoginViewController new]] animated:YES completion:nil];//弹出登录界面


#define ServiceName @"com.KmHealthBAT.app"//保存密码的标示


//蓝色
#define BASE_COLOR UIColorFromHEX(0x099090, 1)
//背景灰色
#define BASE_BACKGROUND_COLOR UIColorFromHEX(0xf5f3f9, 1)
//文字灰色
#define STRING_DARK_COLOR UIColorFromHEX(0x333333, 1)
#define STRING_MID_COLOR UIColorFromHEX(0x666666, 1)
#define STRING_LIGHT_COLOR UIColorFromHEX(0x999999, 1)
//渐变色
#define START_COLOR UIColorFromHEX(0x099090, 1)
#define END_COLOR UIColorFromHEX(0x099090, 1)
//分割线颜色
#define BASE_LINECOLOR UIColorFromHEX(0xe0e0e0, 1)
//辅助色
#define SUB_RED_COLOR UIColorFromHEX(0xff4343, 1)
#define SUB_ORIGIN_COLOR UIColorFromHEX(0xfc9f26, 1)

//160地理数据地址
#define location160Data @"Documents/areaList.data"//每次清空
//科室本地数据
#define locationDepartmentData @"Documents/departmentList.data"//每次清空



//全局开关
#define CANCONSULT [[[NSUserDefaults standardUserDefaults] objectForKey:@"CanConsult"] boolValue]
#define CANREGISTER [[[NSUserDefaults standardUserDefaults] objectForKey:@"CanRegister"] boolValue]
#define CANVISITSHOP [[[NSUserDefaults standardUserDefaults] objectForKey:@"CanVisitShop"] boolValue]

//个人定位坐标系
#define LONGITUDE   [[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] doubleValue]
#define LATITUDE [[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] doubleValue]
//登录信息
#define LOGIN_INFO [NSKeyedUnarchiver unarchiveObjectWithFile: [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserLogin.data"]]
//个人信息
#define PERSON_INFO [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"]]

#define DOWNLOAD_INFO [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DownloadInfo.data"]]


//云通信信息
#define LOGIN_TIM_INFO [NSKeyedUnarchiver unarchiveObjectWithFile: [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TIMData.data"]]


//生成随机数
#define RANDNUMBERS         [[NSUserDefaults standardUserDefaults] setObject:[Tools randomArray] forKey:@"RANDNUMBERS"];  [[NSUserDefaults standardUserDefaults] synchronize];

//全局宏

#define BAT_NO_DATA @"暂时没有数据"
#define BAT_NO_NETWORK @"呜呜呜，断网啦"


#define BAT_KANGDOCTOR_FIRSTMESSAGE @"你好，我是康博士\n有什么需要我帮助的嘛？关于快速查病、预约挂号、咨询医生都可以找我了解\n除此之外，我还很会聊天的哟！"

#endif /* BATMacro_h */
