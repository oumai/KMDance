//
//  KMDDownloadTool.m
//  KMDance
//
//  Created by KM on 17/6/232017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDDownloadTool.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AppDelegate+KMDDownloadCategory.h"

@interface KMDDownloadSource ()

@property (strong, nonatomic) NSFileHandle *fileHandle;

@end

@implementation KMDDownloadSource
- (NSFileHandle *)fileHandle
{
    if (_fileHandle == nil) {
        NSURL *url = [NSURL fileURLWithPath:self.location];
        _fileHandle = url ? [NSFileHandle fileHandleForWritingToURL:url error:nil] : nil;
    }
    
    return _fileHandle;
}
- (void)setStyle:(KMDDownloadSourceStyle)style
{
    if ([self.delegate respondsToSelector:@selector(downloadSource:changedStyle:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate downloadSource:self changedStyle:style];
        });
    }
    
    _style = style;
}
- (void)setNetPath:(NSString *)netPath
{
    _netPath = netPath;
}
- (void)setLocation:(NSString *)location
{
    _location = location;
}
- (void)setTask:(NSURLSessionDataTask *)task
{
    _task = task;
}
- (void)setFileName:(NSString *)fileName
{
    _fileName = fileName;
}
- (void)setTotalBytesWritten:(int64_t)totalBytesWritten
{
    _totalBytesWritten = totalBytesWritten;
}
- (void)setTotalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    _totalBytesExpectedToWrite = totalBytesExpectedToWrite;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.netPath = [aDecoder decodeObjectForKey:@"netPath"];
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.style = [aDecoder decodeIntegerForKey:@"style"];
        self.task = nil;
        self.fileName = [aDecoder decodeObjectForKey:@"fileName"];
        self.totalBytesWritten = [aDecoder decodeInt64ForKey:@"totalBytesWritten"];
        self.totalBytesExpectedToWrite = [aDecoder decodeInt64ForKey:@"totalBytesExpectedToWrite"];
        self.offLine = [aDecoder decodeBoolForKey:@"offLine"];
    }
    
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.netPath forKey:@"netPath"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeInteger:self.style forKey:@"style"];
    [aCoder encodeObject:nil forKey:@"task"];
    [aCoder encodeObject:self.fileName forKey:@"fileName"];
    [aCoder encodeInt64:self.totalBytesWritten forKey:@"totalBytesWritten"];
    [aCoder encodeInt64:self.totalBytesExpectedToWrite forKey:@"totalBytesExpectedToWrite"];
    [aCoder encodeBool:self.offLine forKey:@"offLine"];
}

@end


@interface KMDDownloadTool ()<NSURLSessionDataDelegate>

@property (strong, nonatomic) NSMutableArray *downloadSources;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSMutableArray *delegateArr;

@end

@implementation KMDDownloadTool

static KMDDownloadTool *_shareInstance;

#pragma mark - 属性方法
- (NSMutableArray *)downloadSources
{
    if (_downloadSources == nil) {
        _downloadSources = [NSMutableArray arrayWithCapacity:1];
        NSArray *arr = [NSArray arrayWithContentsOfFile:KMDDownloadTool_DownloadSources_Path];
        
        for (NSData *data in arr) {
            KMDDownloadSource *source = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[source.netPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
            [source setTask:[self.session dataTaskWithRequest:request]];
            [_downloadSources addObject:source];
            
            if (source.isOffLine) {
                if (self.offLineStyle == KMDDownloadToolOffLineStyleDefaut) {
                    if (source.style == KMDDownloadSourceStyleDown || source.style == KMDDownloadSourceStyleSuspend) {
                        source.style = KMDDownloadSourceStyleDown;
                        [self suspendDownload:source];
                    }
                }
                else if (self.offLineStyle == KMDDownloadToolOffLineStyleAuto)
                {
                    if (source.style == KMDDownloadSourceStyleDown || source.style == KMDDownloadSourceStyleSuspend || source.style == KMDDownloadSourceStyleFail) {
                        source.style = KMDDownloadSourceStyleSuspend;
                        [self continueDownload:source];
                    }
                }
                else if (self.offLineStyle == KMDDownloadToolOffLineStyleFromSource)
                {
                    if (source.style == KMDDownloadSourceStyleDown) {
                        source.style = KMDDownloadSourceStyleSuspend;
                        [self continueDownload:source];
                    }
                }
            }
        }
    }
    
    return _downloadSources;
}
- (KMDDownloadToolOffLineStyle)offLineStyle
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:KMDDownloadTool_OffLineStyle_Key];
}
- (void)setOffLineStyle:(KMDDownloadToolOffLineStyle)offLineStyle
{
    [[NSUserDefaults standardUserDefaults] setInteger:self.offLineStyle forKey:KMDDownloadTool_OffLineStyle_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSURLSession *)session
{
    if (_session == nil) {
        //可以上传下载HTTP和HTTPS的后台任务(程序在后台运行)。 在后台时，将网络传输交给系统的单独的一个进程,即使app挂起、推出甚至崩溃照样在后台执行。
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"KMDDownload"];
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    }
    
    return _session;
}
- (NSMutableArray *)delegateArr
{
    if (_delegateArr == nil) {
        _delegateArr = [NSMutableArray arrayWithCapacity:1];
    }
    
    return _delegateArr;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [super allocWithZone:zone];
        //        [[NSNotificationCenter defaultCenter] addObserver:_shareInstance selector:@selector(terminateAction:) name:UIApplicationWillTerminateNotification object:nil];
        if (![[NSFileManager defaultManager] fileExistsAtPath:KMDDownloadTool_DownloadDataDocument_Path_Video]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:KMDDownloadTool_DownloadDataDocument_Path_Video withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:KMDDownloadTool_DownloadDataDocument_Path_Music]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:KMDDownloadTool_DownloadDataDocument_Path_Music withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    
    return _shareInstance;
}
- (void)terminateAction:(NSNotification *)sender
{
    NSLog(@"我退出啦！");
}
- (void)saveDownloadSource
{
    NSMutableArray *mArr = [[NSMutableArray alloc] initWithCapacity:1];
    for (KMDDownloadSource *souce in self.downloadSources) {
        if (souce.isOffLine) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:souce];
            [mArr addObject:data];
        }
    }
    
    [mArr writeToFile:KMDDownloadTool_DownloadSources_Path atomically:YES];
}
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[self alloc] init];
    });
    
    return _shareInstance;
}

/**
 按字节计算文件大小
 
 @param tytes 字节数
 @return 文件大小字符串
 */
+ (NSString *)calculationDataWithBytes:(int64_t)tytes
{
    NSString *result;
    double length;
    if (tytes > KMDDownloadTool_Limit) {
        length = tytes/KMDDownloadTool_Limit;
        if (length > KMDDownloadTool_Limit) {
            length /= KMDDownloadTool_Limit;
            if (length > KMDDownloadTool_Limit) {
                length /= KMDDownloadTool_Limit;
                if (length > KMDDownloadTool_Limit) {
                    length /= KMDDownloadTool_Limit;
                    result = [NSString stringWithFormat:@"%.2fTB", length];
                }
                else
                {
                    result = [NSString stringWithFormat:@"%.2fGB", length];
                }
            }
            else
            {
                result = [NSString stringWithFormat:@"%.2fMB", length];
            }
        }
        else
        {
            result = [NSString stringWithFormat:@"%.2fKB", length];
        }
    }
    else
    {
        result = [NSString stringWithFormat:@"%lliB", tytes];
    }
    
    return result;
}

- (void)saveDownloadInfoWithDic:(NSDictionary *)dic mediaType:(KMDDownloadType)mediaType {
    
    KMDDownloadInfoModel *downloadInfo = DOWNLOAD_INFO;
    
    if (!downloadInfo) {
        downloadInfo = [KMDDownloadInfoModel mj_objectWithKeyValues:@{@"videos":@[],@"songs":@[]}];
    }
    DownLoadData *data = [DownLoadData mj_objectWithKeyValues:dic];
    
    switch (mediaType) {
        case KMDDownloadTypeSong:
        {
            [downloadInfo.songs insertObject:data atIndex:0];
        }
            break;
        case KMDDownloadTypeDance:
        {
            [downloadInfo.videos insertObject:data atIndex:0];
        }
            break;
    }
    
    //保存信息
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DownloadInfo.data"];
    [NSKeyedArchiver archiveRootObject:downloadInfo toFile:file];
    
}

- (void)deleteDownloadInfoWithFileName:(NSString *)fileName mediaType:(KMDDownloadType)mediaType {
    
    KMDDownloadInfoModel *downloadInfo = DOWNLOAD_INFO;
    
    if (!downloadInfo) {
        downloadInfo = [KMDDownloadInfoModel mj_objectWithKeyValues:@{@"videos":@[],@"songs":@[]}];
    }
    
    
    switch (mediaType) {
        case KMDDownloadTypeSong:
        {
            for (DownLoadData *data in downloadInfo.songs) {
                
                if ([data.fileName isEqualToString:fileName]) {
                    [downloadInfo.songs removeObject:data];
                    break;
                }
            }
        }
            break;
        case KMDDownloadTypeDance:
        {
            for (DownLoadData *data in downloadInfo.videos) {
                
                if ([data.fileName isEqualToString:fileName]) {
                    [downloadInfo.videos removeObject:data];
                    break;
                }
            }
        }
            break;
    }
    
    //保存信息
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DownloadInfo.data"];
    [NSKeyedArchiver archiveRootObject:downloadInfo toFile:file];
}

/**
 添加下载任务
 
 @param netPath 下载地址
 @return 下载任务数据模型
 */
- (KMDDownloadSource *)addDownloadTast:(NSString *)netPath andOffLine:(BOOL)offLine mediaType:(KMDDownloadType)mediaType
{
    KMDDownloadSource *source = [[KMDDownloadSource alloc] init];
    [source setNetPath:netPath];
    [source setTask:[self.session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[netPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]]]];
    //[self.session downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[netPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]]]
    NSString *path ;
    switch (mediaType) {
        case KMDDownloadTypeSong:
        {
            path = KMDDownloadTool_DownloadDataDocument_Path_Music;
        }
            break;
        case KMDDownloadTypeDance:
        {
            path = KMDDownloadTool_DownloadDataDocument_Path_Video;
        }
            break;
    
    }
    [source setFileName:[self getFileName:[[netPath componentsSeparatedByString:@"/"] lastObject] mediaType:mediaType]];
    [source setLocation:[path stringByAppendingPathComponent:source.fileName]];
    source.style = KMDDownloadSourceStyleDown;
    source.offLine = offLine;
    //开始下载任务
    [source.task resume];
    [(NSMutableArray *)self.downloadSources addObject:source];
    [self saveDownloadSource];
    return source;
}
- (NSString *)getFileName:(NSString *)sourceName mediaType:(KMDDownloadType)mediaType
{
    NSArray *arr = [sourceName componentsSeparatedByString:@"."];
    NSString *type = arr.count > 1 ? [arr lastObject] : nil;
    NSString *name = type ? [sourceName substringToIndex:sourceName.length - type.length - 1] : sourceName;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *result = sourceName;
    
    NSString *path ;
    switch (mediaType) {
        case KMDDownloadTypeSong:
        {
            path = KMDDownloadTool_DownloadDataDocument_Path_Music;
        }
            break;
        case KMDDownloadTypeDance:
        {
            path = KMDDownloadTool_DownloadDataDocument_Path_Video;
        }
                break;
            default:
                break;
    }
    int count = 0;
    do {
        if ([manager fileExistsAtPath:[path stringByAppendingPathComponent:result]]) {
            count++;
            result = type ? [NSString stringWithFormat:@"%@ (%i).%@", name, count, type] : [NSString stringWithFormat:@"%@ (%i)", name, count];
        }
        else
        {
            [manager createFileAtPath:[path stringByAppendingPathComponent:result] contents:nil attributes:nil];
            return result;
        }
    } while (1);
}
- (void)addDownloadToolDelegate:(id<KMDDownloadToolDelegate>)delegate
{
    for (KMDDownloadToolDelegateObject *obj in self.delegateArr) {
        if (obj.delegate == delegate) {
            return;
        }
    }
    
    KMDDownloadToolDelegateObject *delegateObj = [[KMDDownloadToolDelegateObject alloc] init];
    delegateObj.delegate = delegate;
    [self.delegateArr addObject:delegateObj];
}
- (void)removeDownloadToolDelegate:(id<KMDDownloadToolDelegate>)delegate
{
    for (KMDDownloadToolDelegateObject *obj in self.delegateArr) {
        if (obj.delegate == delegate) {
            [self.delegateArr removeObject:delegate];
            return;
        }
    }
}

/**
 暂停下载任务
 
 @param source 下载任务数据模型
 */
- (void)suspendDownload:(KMDDownloadSource *)source
{
    if (source.style == KMDDownloadSourceStyleDown || source.style == KMDDownloadSourceStyleFail) {
        [source.task cancel];
        source.style = KMDDownloadSourceStyleSuspend;
    }
    else
    {
        NSLog(@"不能暂停未开始的下载任务！");
    }
}
- (void)suspendAllTask
{
    for (KMDDownloadSource *source in self.downloadSources) {
        [self suspendDownload:source];
    }
}
/**
 继续下载任务
 
 @param source 下载任务数据模型
 */
- (void)continueDownload:(KMDDownloadSource *)source
{
    if (source.style == KMDDownloadSourceStyleSuspend || source.style == KMDDownloadSourceStyleFail) {
        source.style = KMDDownloadSourceStyleDown;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[source.netPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        [request setValue:[NSString stringWithFormat:@"bytes=%zd-", source.totalBytesWritten] forHTTPHeaderField:@"Range"];
        source.task = [self.session dataTaskWithRequest:request];
        [source.task resume];
    }
    else
    {
        NSLog(@"不能继续未暂停的下载任务！");
    }
}
- (void)startAllTask
{
    for (KMDDownloadSource *source in self.downloadSources) {
        [self continueDownload:source];
    }
}
/**
 停止下载任务
 
 @param source 下载任务数据模型
 */
- (void)stopDownload:(KMDDownloadSource *)source
{
    if (source.style == KMDDownloadSourceStyleDown) {
        [source.task cancel];
    }
    
    source.style = KMDDownloadSourceStyleStop;
    [source.fileHandle closeFile];
    source.fileHandle = nil;
    [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:source.location] error:nil];
    [(NSMutableArray *)self.downloadSources removeObject:source];
    [self saveDownloadSource];
}
- (void)stopAllTask
{
    for (KMDDownloadSource *source in self.downloadSources) {
        [self stopDownload:source];
    }
}
#pragma mark - NSURLSessionDataDelegate代理方法
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSLog(@"%s", __FUNCTION__);
    dispatch_async(dispatch_get_main_queue(), ^{
        for (KMDDownloadSource *source in self.downloadSources) {
            if (source.task == dataTask) {
                source.totalBytesExpectedToWrite = source.totalBytesWritten + response.expectedContentLength;
            }
        }
    });
    
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized (self) {
            for (KMDDownloadSource *source in self.downloadSources) {
                if (source.task == dataTask) {
                    [source.fileHandle seekToEndOfFile];
                    [source.fileHandle writeData:data];
                    source.totalBytesWritten += data.length;
                    if ([source.delegate respondsToSelector:@selector(downloadSource:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:)]) {
                        [source.delegate downloadSource:source didWriteData:data totalBytesWritten:source.totalBytesWritten totalBytesExpectedToWrite:source.totalBytesExpectedToWrite];
                    }
                }
            }
        }
    });
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {
        NSLog(@"%@", error);
        NSLog(@"%@", error.userInfo);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        KMDDownloadSource *currentSource = nil;
        for (KMDDownloadSource *source in self.downloadSources) {
            if (source.fileHandle) {
                [source.fileHandle closeFile];
                source.fileHandle = nil;
            }
            
            if (error) {
                if (source.task == task && source.style == KMDDownloadSourceStyleDown) {
                    source.style = KMDDownloadSourceStyleFail;
                    if (error.code == -997) {
                        [self continueDownload:source];
                    }
                }
            }
            else
            {
                if (source.task == task) {
                    currentSource = source;
                    break;
                }
            }
        }
        
        if (currentSource) {
            currentSource.style = KMDDownloadSourceStyleFinished;
            [(NSMutableArray *)self.downloadSources removeObject:currentSource];
            [self saveDownloadSource];
            for (KMDDownloadToolDelegateObject *delegateObj in self.delegateArr) {
                if ([delegateObj.delegate respondsToSelector:@selector(downloadToolDidFinish:downloadSource:)]) {
                    [delegateObj.delegate downloadToolDidFinish:self downloadSource:currentSource];
                }
            }
        }
    });
}

@end


@implementation KMDDownloadToolDelegateObject

@end
