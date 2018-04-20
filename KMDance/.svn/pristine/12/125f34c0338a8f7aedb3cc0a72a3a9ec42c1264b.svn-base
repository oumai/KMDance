//
//  KMDUploadCenter.h
//  KMDance
//
//  Created by KM on 17/7/272017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KMDUploadFile;

@interface KMDUploadFile : NSObject

@property (nonatomic,copy) NSString *fileName;//文件名
@property (nonatomic,copy) NSString *filePath;//文件在app中路径
@property (nonatomic,copy) NSString *token;//在服务器上的token
@property (nonatomic,copy) NSString *fileSize;//文件大小
@property (nonatomic,copy) NSString *blockSize;//分块大小
@property (nonatomic,copy) NSString *trunks;//总片数
@property (nonatomic,strong) NSMutableArray *fileArr;//标记每片的上传状态
@property (nonatomic,assign) BOOL isPause;//是否暂停
@property (nonatomic,copy) NSString *ResourceKey;//转码视频的key

@property (nonatomic,copy) NSString *videoName;
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,copy) NSString *videoUrl;

@end

@protocol KMDUploadProgressDelegate <NSObject>

- (void)uploadProgress:(double)progress uploadFile:(KMDUploadFile *)file;
- (void)uploadPauseWithUploadFile:(KMDUploadFile *)file;
- (void)uploadFinishWithUploadFile:(KMDUploadFile *)file;

@end

@interface KMDUploadCenter : NSObject

singletonInterface(KMDUploadCenter)

@property (nonatomic,assign) BOOL isUploading;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) KMDUploadFile *currentUploadFile;
@property (weak, nonatomic) id<KMDUploadProgressDelegate> delegate;

#define KMDUploadCenter_Document_Path                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define KMDUploadCenter_UploadSources_Path              [KMDUploadCenter_Document_Path stringByAppendingPathComponent:@"KMDUploadCenter_UploadSources.data"]



- (void)startUpload;

/**
 读取本地文件分片数据，并上传

 @param chunk 索引
 @param file 文件
 */
-(void)readDataWithChunk:(NSInteger)chunk file:(KMDUploadFile *)file;

/**
 上传

 @param data 数据
 @param chunk 索引
 @param file 文件
 */
-(void)uploadData:(NSData*) data WithChunk:(NSInteger) chunk file:(KMDUploadFile *)file;

/**
 上传成功的处理

 @param chunk 索引
 @param file 文件
 */
- (void)uploadSuccessWithChunk:(NSInteger)chunk file:(KMDUploadFile *)file;


/**
 保存上传源信息
 
 @param uploadSources 上传源信息
 */
- (void)saveUploadSource:(NSMutableArray *)uploadSources;


/**
 获取上传源信息

 @return 上传源信息
 */
- (NSMutableArray *)getUploadSource;
@end
