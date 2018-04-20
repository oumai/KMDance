//
//  HTTPTool+BATUploadImage.h
//  HealthBAT_Pro
//
//  Created by KM on 16/9/132016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool.h"
#import "BATUploadImageModel.h"

@interface HTTPTool (BATUploadImage)


/**
 上传图片

 @param images 图片数组
 @param success 成功
 @param failure 失败
 @param uploadProgress 上传进度
 */
+ (void)requestUploadImageToBATWithImages:(NSArray *)images
                                  success:(void(^)(NSArray *imageArray))success
                                  failure:(void(^)(NSError *error))failure
                           uploadProgress:(void(^)(NSProgress *progress))uploadProgress;



/**
 上传文件

 @param filePaths 文件路径
 @param success 成功
 @param failure 失败
 @param uploadProgress 上传进度
 */
+ (void)requestUploadImageToBATWithFilePaths:(NSArray *)filePaths
                                     success:(void(^)(NSArray *fileArray))success
                                     failure:(void(^)(NSError *error))failure
                              uploadProgress:(void(^)(NSProgress *progress))uploadProgress;
@end
