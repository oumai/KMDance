//
//  KMDUploadCenter.m
//  KMDance
//
//  Created by KM on 17/7/272017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDUploadCenter.h"
#import "BATLoginModel.h"
#import "KMDUploadBlockModel.h"
#import "SVProgressHUD.h"

@implementation KMDUploadFile

- (void)setFileName:(NSString *)fileName {
    
    _fileName = fileName;
}
- (void)setFilePath:(NSString *)filePath {
    
    _filePath = filePath;
}
- (void)setToken:(NSString *)token {
    
    _token = token;
}
- (void)setFileSize:(NSString *)fileSize {
    
    _fileSize = fileSize;
}
- (void)setBlockSize:(NSString *)blockSize {
    
    _blockSize = blockSize;
}
- (void)setTrunks:(NSString *)trunks {
    
    _trunks = trunks;
}
- (void)setFileArr:(NSMutableArray *)fileArr {
    
    _fileArr = fileArr;
}
- (void)setIsPause:(BOOL)isPause {
    
    _isPause = isPause;
}
- (void)setResourceKey:(NSString *)ResourceKey {
    
    _ResourceKey = ResourceKey;
}
- (void)setVideoName:(NSString *)videoName {
    
    _videoName = videoName;
}
- (void)setImageUrl:(NSString *)imageUrl {
    
    _imageUrl = imageUrl;
}
- (void)setVideoUrl:(NSString *)videoUrl {
    
    _videoUrl = videoUrl;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        self.fileName = [aDecoder decodeObjectForKey:@"fileName"];
        self.filePath = [aDecoder decodeObjectForKey:@"filePath"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.fileSize = [aDecoder decodeObjectForKey:@"fileSize"];
        self.blockSize = [aDecoder decodeObjectForKey:@"blockSize"];
        self.trunks = [aDecoder decodeObjectForKey:@"trunks"];
        self.fileArr = [aDecoder decodeObjectForKey:@"fileArr"];
        self.isPause = [aDecoder decodeBoolForKey:@"isPause"];
        self.ResourceKey = [aDecoder decodeObjectForKey:@"ResourceKey"];

        self.videoName = [aDecoder decodeObjectForKey:@"videoName"];
        self.imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
        self.videoUrl = [aDecoder decodeObjectForKey:@"videoUrl"];
    }
    
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.fileName forKey:@"fileName"];
    [aCoder encodeObject:self.filePath forKey:@"filePath"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.fileSize forKey:@"fileSize"];
    [aCoder encodeObject:self.blockSize forKey:@"blockSize"];
    [aCoder encodeObject:self.trunks forKey:@"trunks"];
    [aCoder encodeObject:self.fileArr forKey:@"fileArr"];
    [aCoder encodeBool:self.isPause forKey:@"isPause"];
    [aCoder encodeObject:self.ResourceKey forKey:@"ResourceKey"];

    [aCoder encodeObject:self.videoName forKey:@"videoName"];
    [aCoder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [aCoder encodeObject:self.videoUrl forKey:@"videoUrl"];
}

@end

@implementation KMDUploadCenter

singletonImplemention(KMDUploadCenter)

- (void)startUpload {
    
    self.currentUploadFile = nil;
    
    //上传的源数组为空，没有上传对象
    if ([KMDUploadCenter sharedKMDUploadCenter].dataArray.count == 0) {
        
        self.isUploading = NO;
        return;
    }
    
    KMDUploadFile *file;
    for (KMDUploadFile *tmpFile in [KMDUploadCenter sharedKMDUploadCenter].dataArray) {
        
        //有需要上传的文件
        if (tmpFile.isPause == NO) {
            
            file = tmpFile;
            self.currentUploadFile = tmpFile;
            self.isUploading = YES;
            break;
        }
        
        //没有需要上传的文件
        if (tmpFile == [KMDUploadCenter sharedKMDUploadCenter].dataArray.lastObject) {
            
            self.isUploading = NO;
            return;
        }
    }
    
    //已经完成上传并拿到视频的上传地址，在转码or发布时接口出现问题，重新走转码和发布接口
    if (file.videoUrl.length > 0) {
        
        [self encodeVideoWithFile:file];
        return;
    }
    
    //上传
    //token存在
    if (file.token) {
        //验证
        [self getBlockInfoRequestWithFile:file success:^(id  _Nullable responseObject) {
            
            KMDUploadBlockModel *blockModel = [KMDUploadBlockModel mj_objectWithKeyValues:responseObject];
            
            file.blockSize = [NSString stringWithFormat:@"%ld",(long)blockModel.BlockSize];
            file.trunks = [NSString stringWithFormat:@"%ld",(long)blockModel.TotalBlocks];
            
            if (blockModel.incomplete.blockIndex == 0) {
                for (int i=0; i<[file.trunks intValue]; i++) {
                    [file.fileArr addObject:@"wait"];
                }
            }
            else {
                
                for (long i=0; i<blockModel.incomplete.blockIndex; i++) {
                    [file.fileArr addObject:@"finish"];
                }
                for (long i=blockModel.incomplete.blockIndex; i<[file.trunks intValue]; i++) {
                    [file.fileArr addObject:@"wait"];
                }
            }
            
            //上传
            [self readDataWithChunk:[file.fileArr indexOfObject:@"wait"] file:file];

        } failure:^(NSError * _Nullable error) {
            
            file.token = nil;
            
            self.currentUploadFile.isPause = YES;
            file.isPause = YES;
            if (self.delegate) {
                [self.delegate uploadPauseWithUploadFile:file];
            }
            [self startUpload];
            [SVProgressHUD showErrorWithStatus:@"数据错误，请重新上传"];
        }];
    }
    else {
        //获取token
        [self getTokenWithFile:file success:^(id  _Nullable responseObject) {

            file.token = responseObject[@"token"];
            [self getBlockInfoRequestWithFile:file success:^(id  _Nullable responseObject) {

                KMDUploadBlockModel *blockModel = [KMDUploadBlockModel mj_objectWithKeyValues:responseObject];
                
                file.blockSize = [NSString stringWithFormat:@"%ld",(long)blockModel.BlockSize];
                file.trunks = [NSString stringWithFormat:@"%ld",(long)blockModel.TotalBlocks];
                
                file.fileArr = [NSMutableArray array];
                if (blockModel.incomplete.blockIndex == 0) {
                    for (int i=0; i<[file.trunks intValue]; i++) {
                        [file.fileArr addObject:@"wait"];
                    }
                }
                else {
                    
                    for (long i=0; i<blockModel.incomplete.blockIndex; i++) {
                        [file.fileArr addObject:@"finish"];
                    }
                    for (long i=blockModel.incomplete.blockIndex; i<[file.trunks intValue]; i++) {
                        [file.fileArr addObject:@"wait"];
                    }
                }
                
                //上传
                [self readDataWithChunk:[file.fileArr indexOfObject:@"wait"] file:file];

            } failure:^(NSError * _Nullable error) {
                
                file.token = nil;
                
                self.currentUploadFile.isPause = YES;
                file.isPause = YES;
                if (self.delegate) {
                    [self.delegate uploadPauseWithUploadFile:file];
                }
                [self startUpload];
                [SVProgressHUD showErrorWithStatus:@"数据错误，请重新上传"];

            }];
        } failure:^(NSError * _Nullable error) {
            self.currentUploadFile.isPause = YES;
            file.isPause = YES;
            if (self.delegate) {
                [self.delegate uploadPauseWithUploadFile:file];
            }
            [self startUpload];
            [SVProgressHUD showErrorWithStatus:@"数据错误，请重新上传"];
        }];
    }
}

//读取本地文件分片数据，并上传
-(void)readDataWithChunk:(NSInteger)chunk file:(KMDUploadFile *)file {
    
    //（每一片的大小是64kb）
    int offset = [file.blockSize intValue];
    
    //将文件分片，读取每一片的数据：
    NSData* data;
    NSString *currentFilePath = [[NSHomeDirectory() stringByAppendingString:@"/tmp/"] stringByAppendingString:file.filePath];
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:currentFilePath];
    [readHandle seekToFileOffset:offset * chunk];
    data = [readHandle readDataOfLength:offset];
    
    if (!data) {
        
        self.currentUploadFile.isPause = YES;
        file.isPause = YES;
        if (self.delegate) {
            [self.delegate uploadPauseWithUploadFile:file];
        }
        [self startUpload];
        [SVProgressHUD showErrorWithStatus:@"本地文件损坏，请重新上传"];
        return;
    }
    
    //上传
    [self uploadData:data WithChunk:chunk file:file];
}

//上传
-(void)uploadData:(NSData*) data WithChunk:(NSInteger) chunk file:(KMDUploadFile *)file {

    [XMCenter sendRequest:^(XMRequest *request) {
        request.server = @"http://upload.jkbat.com";
        request.api = [NSString stringWithFormat:@"/bigfile/%@/%ld",file.token,(long)chunk];
        request.requestType = kXMRequestUpload;
        [request addFormDataWithName:[NSString stringWithFormat:@"%@_%ld",file.fileName,(long)chunk] fileData:data];
    } onProgress:^(NSProgress *progress) {
    
    } onSuccess:^(id responseObject) {

        [self uploadSuccessWithChunk:chunk file:file];
    } onFailure:^(NSError *error) {

        self.currentUploadFile.isPause = YES;
        file.isPause = YES;
        if (self.delegate) {
            [self.delegate uploadPauseWithUploadFile:file];
        }
        [self startUpload];
        [SVProgressHUD showErrorWithStatus:@"数据错误，请重新上传"];
    } onFinished:^(id responseObject, NSError *error) {
        
    }];
}

- (void)getTokenWithFile:(KMDUploadFile *)file success:(void(^)(id  _Nullable responseObject))success failure:(void(^)(NSError * _Nullable error))failure {
    
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.server = @"http://upload.jkbat.com";
        request.api = @"/bigfile";
        request.httpMethod = kXMHTTPMethodGET;
        request.parameters = @{@"fileSize":file.fileSize};

    } onSuccess:^(id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } onFailure:^(NSError * _Nullable error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getBlockInfoRequestWithFile:(KMDUploadFile *)file success:(void(^)(id  _Nullable responseObject))success failure:(void(^)(NSError * _Nullable error))failure {
    
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        
        request.server = @"http://upload.jkbat.com";
        request.api = [NSString stringWithFormat:@"/bigfile/%@",file.token];
        request.httpMethod = kXMHTTPMethodGET;
    } onSuccess:^(id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
        
    } onFailure:^(NSError * _Nullable error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getUrlRequestWithFile:(KMDUploadFile *)file {
    
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        
        request.server = @"http://upload.jkbat.com";
        request.api = [NSString stringWithFormat:@"/bigfile/%@",file.token];
        request.httpMethod = kXMHTTPMethodGET;
        request.parameters = @{@"filename":file.fileName};
    } onSuccess:^(id  _Nullable responseObject) {
        
        file.videoUrl = responseObject[@"url"];

        //转码视频
        [self encodeVideoWithFile:file];

    } onFailure:^(NSError * _Nullable error) {
        
        self.currentUploadFile.isPause = YES;
        file.isPause = YES;
        if (self.delegate) {
            [self.delegate uploadPauseWithUploadFile:file];
        }
        [self startUpload];
        [SVProgressHUD showErrorWithStatus:@"数据错误，请重新上传"];
    }];
}

- (void)encodeVideoWithFile:(KMDUploadFile *)file {
    
    BATLoginModel *login = LOGIN_INFO;
    file.ResourceKey = [NSString stringWithFormat:@"GCW_%.0f_%ld",[[NSDate date] timeIntervalSince1970]*1000,(long)login.Data.ID];

    
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        
        request.server = @"http://media-manage.jkbat.com";
        request.api = @"/Video/Upload/";
        request.httpMethod = kXMHTTPMethodGET;
        request.parameters = @{@"url":file.videoUrl,
                               @"category":@"Dancing",
                               @"key":file.ResourceKey,
                               @"name":file.videoName,
                               @"encoding":@"dancing",
                               };
    } onSuccess:^(id  _Nullable responseObject) {
    
        //发布视频
        [self sendVideoWithFile:file];
        
        //删除已经上传的文件
        [[NSFileManager defaultManager] removeItemAtPath:[[NSHomeDirectory() stringByAppendingString:@"/tmp/"] stringByAppendingString:file.filePath] error:nil];
        
    } onFailure:^(NSError * _Nullable error) {
        
        self.currentUploadFile.isPause = YES;
        file.isPause = YES;
        if (self.delegate) {
            [self.delegate uploadPauseWithUploadFile:file];
        }
        [self startUpload];
        
        [SVProgressHUD showErrorWithStatus:@"数据错误，请重新上传"];
    }];
}

- (void)sendVideoWithFile:(KMDUploadFile *)file {
    
    BATLoginModel *login = LOGIN_INFO;
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/EditSquareDanceEntity"
                        parameters:@{
                                     @"CategoryID":@"1",
                                     @"Name":file.videoName,
                                     @"AccountID":@(login.Data.ID),
                                     @"Url":file.videoUrl,
                                     @"Poster":file.imageUrl,
                                     @"ResourceKey":file.ResourceKey,
                                     }
                              type:kXMHTTPMethodPOST
      success:^(id responseObject) {
        
          NSMutableArray *array = [NSMutableArray arrayWithArray:[KMDUploadCenter sharedKMDUploadCenter].dataArray];
          for (KMDUploadFile *tmpfile in [KMDUploadCenter sharedKMDUploadCenter].dataArray) {
              
              if ([file.filePath isEqualToString:tmpfile.filePath]) {
                  [array removeObject:tmpfile];
              }
          }
          
          [KMDUploadCenter sharedKMDUploadCenter].dataArray = array;
          
          if (self.delegate) {
              [self.delegate uploadFinishWithUploadFile:file];
          }
          
          [self startUpload];
          
          [SVProgressHUD showSuccessWithStatus:@"上传完成"];
                               
    } failure:^(NSError *error) {
        
        self.currentUploadFile.isPause = YES;
        file.isPause = YES;
        if (self.delegate) {
            [self.delegate uploadPauseWithUploadFile:file];
        }
        [self startUpload];
        
        [SVProgressHUD showErrorWithStatus:@"数据错误，请重新上传"];
    }];
}

//上传成功一个分片后的处理
- (void)uploadSuccessWithChunk:(NSInteger)chunk file:(KMDUploadFile *)file {
    
    //1）先将已经成功上传的本片的flag置finish
    [file.fileArr replaceObjectAtIndex:chunk withObject:@"finish"];
    
    if (self.delegate) {
        
        [self.delegate uploadProgress:(chunk/[file.trunks floatValue]) uploadFile:file];
    }
    
     //2）查看是否所有片的flag都已经置finish，如果都已经finishi，说明该文件上传完成，那么删除该文件
    for (NSInteger j =0; j<[file.trunks intValue]; j++) {
        
        if (j == [file.trunks intValue] || ((j == [file.trunks intValue] -1)&&([file.fileArr[j]isEqualToString:@"finish"]))) {
            
            //获取上传完成的视频的地址
            [self getUrlRequestWithFile:file];
            return;
        }
    }
    
    //暂停
    if (self.currentUploadFile.isPause == YES) {

        //保存uploadFile

        NSMutableArray *array = [NSMutableArray arrayWithArray:[KMDUploadCenter sharedKMDUploadCenter].dataArray];
        
        for (KMDUploadFile *tmpFile in [KMDUploadCenter sharedKMDUploadCenter].dataArray) {
            
            if ([tmpFile.filePath isEqualToString:file.filePath]) {
                
                [array replaceObjectAtIndex:[array indexOfObject:tmpFile] withObject:file];
            }
        }
        
        [KMDUploadCenter sharedKMDUploadCenter].dataArray = array;
        
        [self startUpload];
        
        return ;
    }
    
     //3）如果没有都finish，那么看本地下一chunk对用的flag是否是wait
     for(NSInteger i = chunk+1; i < [file.trunks intValue]; i++) {
         
         NSString *flag = [file.fileArr objectAtIndex:i];
         NSLog(@"查看第%ld片的状态--%@",(long)chunk,flag);

         if ([flag isEqualToString:@"wait"]) {

             //上传下一片数据
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 [self readDataWithChunk:i file:file];
             });
             break;
         }
     }
}

- (void)saveUploadSource:(NSMutableArray *)uploadSources {
    
    self.dataArray = uploadSources;

    NSMutableArray *mArr = [[NSMutableArray alloc] initWithCapacity:1];
    for (KMDUploadFile *file in uploadSources) {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:file];
        [mArr addObject:data];
    }
    
    [mArr writeToFile:KMDUploadCenter_UploadSources_Path atomically:YES];
}

- (NSMutableArray *)getUploadSource {
    
    NSArray *arr = [NSArray arrayWithContentsOfFile:KMDUploadCenter_UploadSources_Path];
    NSMutableArray *uploadFileArr = [NSMutableArray array];
    for (NSData *data in arr) {
        KMDUploadFile *file = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [uploadFileArr addObject:file];
    }
    
    self.dataArray = uploadFileArr;
    
    return uploadFileArr;
}

@end
