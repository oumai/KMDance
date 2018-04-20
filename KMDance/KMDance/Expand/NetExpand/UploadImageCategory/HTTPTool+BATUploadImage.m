//
//  HTTPTool+BATUploadImage.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/132016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool+BATUploadImage.h"
#import "SVProgressHUD.h"

@implementation HTTPTool (BATUploadImage)

+ (void)requestUploadImageToBATWithImages:(NSArray *)images
                                  success:(void(^)(NSArray *imageArray))success
                                  failure:(void(^)(NSError *error))failure
                           uploadProgress:(void(^)(NSProgress *progress))uploadProgress
{

    [XMCenter sendRequest:^(XMRequest *request) {

        request.url = @"http://upload.jkbat.com";
        request.requestType = kXMRequestUpload;
        for (UIImage *image in images) {
            NSData *fileData = UIImageJPEGRepresentation(image, 1.0);
            [request addFormDataWithName:@"image[]" fileName:@"temp.jpg" mimeType:@"image/jpeg" fileData:fileData];
        }

    } onProgress:^(NSProgress *progress) {

        if (uploadProgress) {
            uploadProgress(progress);
        }
    } onSuccess:^(id responseObject) {

        NSArray *imageArray = (NSArray *)responseObject;
        if (success) {
            success(imageArray);
        }
    } onFailure:^(NSError *error) {

        if (failure) {
            
            failure(error);
        }
    } onFinished:^(id responseObject, NSError *error) {

    
    }];
}

+ (void)requestUploadImageToBATWithFilePaths:(NSArray *)filePaths
                                  success:(void(^)(NSArray *fileArray))success
                                  failure:(void(^)(NSError *error))failure
                           uploadProgress:(void(^)(NSProgress *progress))uploadProgress
{
    [XMCenter sendRequest:^(XMRequest *request) {
        request.url = @"http://upload.jkbat.com";
        request.requestType = kXMRequestUpload;
        for (NSString *filePath in filePaths) {
            NSURL *fileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
            [request addFormDataWithName:@"file" fileURL:fileURL];
        }
        
    } onProgress:^(NSProgress *progress) {
        
        if (uploadProgress) {
            uploadProgress(progress);
        }
    } onSuccess:^(id responseObject) {
        
        NSArray *fileArray = (NSArray *)responseObject;
        if (success) {
            success(fileArray);
        }
    } onFailure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
        }
    } onFinished:^(id responseObject, NSError *error) {
        
        
    }];
}

@end
