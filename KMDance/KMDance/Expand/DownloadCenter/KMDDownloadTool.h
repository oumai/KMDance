//
//  KMDDownloadTool.h
//  KMDance
//
//  Created by KM on 17/6/232017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMDDownloadInfoModel.h"

typedef NS_ENUM(NSInteger, KMDDownloadSourceStyle) {
    KMDDownloadSourceStyleDown = 0,//下载
    KMDDownloadSourceStyleSuspend = 1,//暂停
    KMDDownloadSourceStyleStop = 2,//停止
    KMDDownloadSourceStyleFinished = 3,//完成
    KMDDownloadSourceStyleFail = 4//失败
};

@class KMDDownloadSource;
@protocol KMDDownloadSourceDelegate <NSObject>
@optional
- (void)downloadSource:(KMDDownloadSource *)source changedStyle:(KMDDownloadSourceStyle)style;
- (void)downloadSource:(KMDDownloadSource *)source didWriteData:(NSData *)data totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;
@end

@interface KMDDownloadSource : NSObject <NSCoding>
//地址路径
@property (copy, nonatomic, readonly) NSString *netPath;
//本地路径
@property (copy, nonatomic, readonly) NSString *location;
//下载状态
@property (assign, nonatomic, readonly) KMDDownloadSourceStyle style;
//下载任务
@property (strong, nonatomic, readonly) NSURLSessionDataTask *task;
//文件名称
@property (strong, nonatomic, readonly) NSString *fileName;
//已下载的字节数
@property (assign, nonatomic, readonly) int64_t totalBytesWritten;
//文件字节数
@property (assign, nonatomic, readonly) int64_t totalBytesExpectedToWrite;
//是否离线下载
@property (assign, nonatomic, getter=isOffLine) BOOL offLine;
//代理
@property (weak, nonatomic) id<KMDDownloadSourceDelegate> delegate;

@end


@class KMDDownloadTool;
@protocol KMDDownloadToolDelegate <NSObject>

- (void)downloadToolDidFinish:(KMDDownloadTool *)tool downloadSource:(KMDDownloadSource *)source;

@end

typedef NS_ENUM(NSInteger, KMDDownloadToolOffLineStyle) {
    KMDDownloadToolOffLineStyleDefaut = 0,//默认离线后暂停
    KMDDownloadToolOffLineStyleAuto = 1,//根据保存的状态自动处理
    KMDDownloadToolOffLineStyleFromSource = 2//根据保存的状态自动处理
};
@interface KMDDownloadTool : NSObject

#define KMDDownloadTool_Document_Path                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define KMDDownloadTool_DownloadDataDocument_Path_Video       [KMDDownloadTool_Document_Path stringByAppendingPathComponent:@"KMDDownloadTool_DownloadDataDocument_Path_Video"]
#define KMDDownloadTool_DownloadDataDocument_Path_Music       [KMDDownloadTool_Document_Path stringByAppendingPathComponent:@"KMDDownloadTool_DownloadDataDocument_Path_Music"]
#define KMDDownloadTool_DownloadSources_Path            [KMDDownloadTool_Document_Path stringByAppendingPathComponent:@"KMDDownloadTool_downloadSources.data"]
#define KMDDownloadTool_OffLineStyle_Key                @"KMDDownloadTool_OffLineStyle_Key"
#define KMDDownloadTool_OffLine_Key                     @"KMDDownloadTool_OffLine_Key"

#define KMDDownloadTool_Limit                           1024.0

/**
 下载的所有任务资源
 */
@property (strong, nonatomic, readonly) NSArray *downloadSources;
//离线后的下载方式
@property (assign, nonatomic) KMDDownloadToolOffLineStyle offLineStyle;

+ (instancetype)shareInstance;

/**
 按字节计算文件大小
 
 @param tytes 字节数
 @return 文件大小字符串
 */
+ (NSString *)calculationDataWithBytes:(int64_t)tytes;


/**
 下载的文件的信息

 @param dic 参数
 @param mediaType 类型
 */
- (void)saveDownloadInfoWithDic:(NSDictionary *)dic mediaType:(KMDDownloadType)mediaType;


/**
 删除下载的信息

 @param mediaType 类型
 */
- (void)deleteDownloadInfoWithFileName:(NSString *)fileName mediaType:(KMDDownloadType)mediaType;

/**
 添加下载任务
 
 @param netPath 下载地址
 @return 下载任务数据模型
 */
- (KMDDownloadSource *)addDownloadTast:(NSString *)netPath andOffLine:(BOOL)offLine mediaType:(KMDDownloadType)mediaType;

/**
 添加代理
 
 @param delegate 代理对象
 */
- (void)addDownloadToolDelegate:(id<KMDDownloadToolDelegate>)delegate;
/**
 移除代理
 
 @param delegate 代理对象
 */
- (void)removeDownloadToolDelegate:(id<KMDDownloadToolDelegate>)delegate;

/**
 暂停下载任务
 
 @param source 下载任务数据模型
 */
- (void)suspendDownload:(KMDDownloadSource *)source;
/**
 暂停所有下载任务
 */
- (void)suspendAllTask;

/**
 继续下载任务
 
 @param source 下载任务数据模型
 */
- (void)continueDownload:(KMDDownloadSource *)source;
/**
 开启所有下载任务
 */
- (void)startAllTask;
/**
 停止下载任务
 
 @param source 下载任务数据模型
 */
- (void)stopDownload:(KMDDownloadSource *)source;
/**
 停止所有下载任务
 */
- (void)stopAllTask;

@end


@interface KMDDownloadToolDelegateObject : NSObject

@property (weak, nonatomic) id<KMDDownloadToolDelegate> delegate;

@end
