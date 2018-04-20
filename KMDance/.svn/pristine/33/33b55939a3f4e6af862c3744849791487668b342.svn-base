//
//  KMDUploadViewController.m
//  KMDance
//
//  Created by KM on 17/8/72017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDUploadViewController.h"
#import "KMDUploadCenter.h"

#import "KMDUploadCollectionViewCell.h"

#import "KMDMyUploadViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import "TZImagePickerController.h"
#import "Reachability.h"

#import <ZLPhotoBrowser/ZLPhotoActionSheet.h>
#import <ZLPhotoBrowser/ZLPhotoConfiguration.h>
#import "KMDEditImageViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

static  NSString * const UPLOAD_CELL = @"KMDUploadCollectionViewCell.h";

@interface KMDUploadViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray *imageArray;

@property (nonatomic,strong) NSString *imageUrl;

@property (nonatomic,strong) UITextField *nameTF;
@property (nonatomic,strong) UILabel *desLabel;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UICollectionView *imagesCollectionView;
@property (nonatomic,strong) UIImageView *bigImageView;
@property (nonatomic,strong) UIButton *locationBtn;
@property (nonatomic,strong) UIButton *sendBtn;
@property (nonatomic,strong) NSIndexPath *selectedIndex;

@property (nonatomic,strong) ZLPhotoActionSheet *photoActionSheet;

@end

@implementation KMDUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageArray = [NSMutableArray array];
    
    //数据源
    AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:self.videoPathString]];
    CMTime   time = [asset duration];
    int seconds = ceil(time.value/time.timescale);
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:self.videoPathString]];
    moviePlayer.shouldAutoplay = NO;
    for (int i = 0; i < 10 ; i ++) {

        DDLogDebug(@"--------%f",seconds/10.0*i);
        UIImage *thumbnailImage = [moviePlayer thumbnailImageAtTime:seconds/10*i timeOption:MPMovieTimeOptionNearestKeyFrame];
        [self.imageArray addObject:thumbnailImage];
    }
    
    //上传第一张图
    UIImage *thumbnailImage = [moviePlayer thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    self.bigImageView.image = thumbnailImage;
    if (self.bigImageView.image) {
        [HTTPTool requestUploadImageToBATWithImages:@[self.bigImageView.image] success:^(NSArray *imageArray) {
            
            [self dismissProgress];
            
            NSDictionary *dic = [imageArray firstObject];
            //更改个人信息
            self.imageUrl = dic[@"url"];
        } failure:^(NSError *error) {
            
        } uploadProgress:^(NSProgress *progress) {
            
            [self showProgres:progress.fractionCompleted];
        }];
    }
   
    
    //布局
    [self layoutPages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    KMDUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UPLOAD_CELL forIndexPath:indexPath];
    cell.imageView.image = self.imageArray[indexPath.row];
    
    if (indexPath == self.selectedIndex) {
        cell.layer.borderColor = [UIColor redColor].CGColor;
    }
    else {
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(35, 45);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedIndex = indexPath;
    [collectionView reloadData];

    self.bigImageView.image = self.imageArray[indexPath.row];
    
    self.imageUrl = nil;
    //上传图片
    [HTTPTool requestUploadImageToBATWithImages:@[self.bigImageView.image] success:^(NSArray *imageArray) {
        [self dismissProgress];

        NSDictionary *dic = [imageArray firstObject];
        //更改个人信息
        self.imageUrl = dic[@"url"];
    } failure:^(NSError *error) {
        
    } uploadProgress:^(NSProgress *progress) {
        
        [self showProgres:progress.fractionCompleted];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ((textField.text.length + string.length) > 20) {
        
        [self showErrorWithText:@"视频名称限制在20字以内"];
        
        textField.text = [[NSString stringWithFormat:@"%@%@",textField.text,string] substringToIndex:20];
        
        return NO;
    }
    return YES;
}

#pragma mark - private
//mov转mp4

- (void)movFileTransformToMP4WithSourcePath:(NSString *)sourcePath completion:(void(^)(NSString *Mp4FilePath))comepleteBlock {
    
    NSString *path = [[NSHomeDirectory() stringByAppendingString:@"/tmp/"] stringByAppendingString:[NSString stringWithFormat:@"%ld_compressedVideo.mp4",time(NULL)]];

    //压缩
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:sourcePath] options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset640x480];
        //输出URL
        exportSession.outputURL = [NSURL fileURLWithPath:path];
        //优化网络
        exportSession.shouldOptimizeForNetworkUse = true;
        //转换后的格式
        exportSession.outputFileType = AVFileTypeMPEG4;
        //异步导出
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            // 如果导出的状态为完成
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                
                if (comepleteBlock) {
                    comepleteBlock(path);
                }
                
                DDLogDebug(@"压缩完毕");
                //删除mov格式
                [[NSFileManager defaultManager] removeItemAtPath:sourcePath error:nil];

            }
            else {
                
                DDLogDebug(@"当前压缩进度:%f",exportSession.progress);
            }
            
            DDLogDebug(@"%@",exportSession.error);
        }];
    }
}

//拼装uploadFile
- (void)saveUploadFileWithPath:(NSString *)videoPath {
    
    NSDictionary *fileAttrDic = [[NSFileManager defaultManager] attributesOfItemAtPath:videoPath error:nil];
    DDLogDebug(@"%@",fileAttrDic);
    
    NSString *fileName = [[videoPath componentsSeparatedByString:@"/"] lastObject];
    

    KMDUploadFile *uploadFile = [[KMDUploadFile alloc] init];
    //文件名字
    uploadFile.fileName = fileName;
    //文件路径
    uploadFile.filePath = [[videoPath componentsSeparatedByString:@"/tmp/"] lastObject];
    //文件大小
    uploadFile.fileSize = fileAttrDic[NSFileSize];
    if ([uploadFile.fileSize longLongValue] > 500*1024*1024) {
        [self showErrorWithText:@"你所上传的文件太大，请重新选取"];
        return;
    }
        
    if ([self.nameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [self showErrorWithText:@"请输入视频名称"];
        return;
    }
    if ([self.nameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 20) {
        [self showErrorWithText:@"视频名称限制在20字以内"];
        return;
    }
    uploadFile.videoName = [self.nameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!self.imageUrl) {
        
        return;
    }
    uploadFile.imageUrl = self.imageUrl;
    
    
    //判断当前的网络状态
    
    //4g情况
    if ([self getCurrentReachStatus] == ReachableViaWWAN) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您正在使用移动数据网络" preferredStyle:UIAlertControllerStyleAlert];
        WEAK_SELF(self);
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消上传" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *uploadAction = [UIAlertAction actionWithTitle:@"继续上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            STRONG_SELF(self);
            [self addUploadFile:uploadFile];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:uploadAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    //wifi情况下
    [self addUploadFile:uploadFile];
}

//添加uploadFile到上传类
- (void)addUploadFile:(KMDUploadFile *)file {
        
    [[KMDUploadCenter sharedKMDUploadCenter].dataArray addObject:file];
    
    if ([KMDUploadCenter sharedKMDUploadCenter].isUploading == NO) {
        [[KMDUploadCenter sharedKMDUploadCenter] startUpload];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //我的上传
        KMDMyUploadViewController *uploadVC = [[KMDMyUploadViewController alloc] init];
        uploadVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:uploadVC animated:YES];
        //移除编辑界面
        [self bk_performBlock:^(id obj) {
            
            NSArray *vcArray = self.navigationController.viewControllers;
            NSMutableArray *vcMArray = [NSMutableArray arrayWithArray:vcArray];
            [vcMArray removeObject:self];
            self.navigationController.viewControllers = [NSArray arrayWithArray:vcMArray];
            
        } afterDelay:1.5];
    });
    

}

- (NetworkStatus)getCurrentReachStatus {
    
    Reachability*reach=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    return [reach currentReachabilityStatus];
}
    
- (void)getPhotosFromLocal {
    
    [self.photoActionSheet showPhotoLibrary];
    
    /*
    TZImagePickerController *tzImagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    tzImagePickerVC.allowPickingVideo = NO;
    tzImagePickerVC.barItemTextColor = STRING_DARK_COLOR;

    tzImagePickerVC.showSelectBtn = NO;
    tzImagePickerVC.allowCrop = YES;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 3;
    NSInteger widthHeight = SCREEN_WIDTH - 2 * left;
    NSInteger top = (SCREEN_HEIGHT- widthHeight) / 2;
    tzImagePickerVC.cropRect = CGRectMake(left, top, widthHeight, widthHeight/16.0*9.0);

    
    [tzImagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        UIImage *avatar = [photos firstObject];
        
        if (isSelectOriginalPhoto == NO) {
            avatar = [Tools compressImageWithImage:avatar ScalePercent:0.5];
        }
        
        self.bigImageView.image = avatar;
        
        self.imageUrl = nil;
        
        
        [HTTPTool requestUploadImageToBATWithImages:@[avatar] success:^(NSArray *imageArray) {
            
            [self dismissProgress];
            
            NSDictionary *dic = [imageArray firstObject];
            //更改个人信息
            
            self.imageUrl = dic[@"url"];
            
        } failure:^(NSError *error) {
            
        } uploadProgress:^(NSProgress *progress) {
            
            [self showProgres:progress.fractionCompleted];
        }];
        
    }];
    
    [self presentViewController:tzImagePickerVC animated:YES completion:nil];
    */
}


#pragma mark - layout
- (void)layoutPages {
    
    self.title = @"上传视频";
    
    WEAK_SELF(self);
    [self.navigationItem.leftBarButtonItem.customView bk_whenTapped:^{
        STRONG_SELF(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.view addSubview:self.sendBtn];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.bottom.equalTo(@-10);
        make.width.mas_equalTo(SCREEN_WIDTH-60);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.locationBtn];
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);

        make.centerX.equalTo(@0);
        make.bottom.equalTo(self.sendBtn.mas_top).offset(-10);
        make.width.mas_equalTo(SCREEN_WIDTH-60);
        make.height.mas_equalTo(44);
    }];
    
    
    [self.view addSubview:self.nameTF];
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@10);
        make.width.mas_equalTo(SCREEN_WIDTH-40);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.nameTF.mas_left).offset(0);
        make.top.equalTo(self.nameTF.mas_bottom).offset(5);
        make.height.mas_equalTo(25);
    }];
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);

        make.left.equalTo(@20);
        make.top.equalTo(self.desLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(25);
    }];
    
    [self.view addSubview:self.imagesCollectionView];
    [self.imagesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH-40);
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.bigImageView];
    [self.bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);

        make.centerX.equalTo(@0);
        make.top.equalTo(self.imagesCollectionView.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH-40);
        make.bottom.lessThanOrEqualTo(self.locationBtn.mas_top).offset(-10);
    }];
}

#pragma mark - getter
- (UITextField *)nameTF {
    
    if (!_nameTF) {
        
        _nameTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:15] textColor:STRING_DARK_COLOR placeholder:@"请输入视频名称" BorderStyle:UITextBorderStyleRoundedRect];
        _nameTF.clearButtonMode = UITextFieldViewModeNever;
        _nameTF.returnKeyType = UIReturnKeyDone;
        _nameTF.delegate = self;
    }
    return _nameTF;
}

- (UILabel *)desLabel {
    
    if (!_desLabel) {
        
        _desLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:11] textColor:STRING_LIGHT_COLOR textAlignment:NSTextAlignmentLeft];
        _desLabel.text = @"视频名称限制在20字以内";
    }
    return _desLabel;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentLeft];
        _titleLabel.text = @"请选择一张封面";
    }
    return _titleLabel;
}

- (UICollectionView *)imagesCollectionView {
    
    if (!_imagesCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _imagesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _imagesCollectionView.backgroundColor = [UIColor whiteColor];
        _imagesCollectionView.showsHorizontalScrollIndicator = NO;
        _imagesCollectionView.delegate = self;
        _imagesCollectionView.dataSource = self;
        
        [_imagesCollectionView registerClass:[KMDUploadCollectionViewCell class] forCellWithReuseIdentifier:UPLOAD_CELL];
    }
    return _imagesCollectionView;
}

- (UIImageView *)bigImageView {
    
    if (!_bigImageView) {
        
        _bigImageView = [[UIImageView alloc] init];
        _bigImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _bigImageView.userInteractionEnabled = YES;
        WEAK_SELF(self);
        [_bigImageView bk_whenTapped:^{
           
            STRONG_SELF(self);

            KMDEditImageViewController *editImageVC = [[KMDEditImageViewController alloc] init];
            editImageVC.oriImage = self.bigImageView.image;
            editImageVC.photoConfiguration = self.photoActionSheet.configuration;
            [editImageVC setEditImageBlock:^(UIImage *editImage) {
               
                
                self.bigImageView.image = editImage;
                
                self.imageUrl = nil;
                //上传图片
                [HTTPTool requestUploadImageToBATWithImages:@[self.bigImageView.image] success:^(NSArray *imageArray) {
                    [self dismissProgress];
                    
                    NSDictionary *dic = [imageArray firstObject];
                    //更改个人信息
                    self.imageUrl = dic[@"url"];
                } failure:^(NSError *error) {
                    
                } uploadProgress:^(NSProgress *progress) {
                    
                    [self showProgres:progress.fractionCompleted];
                }];
                
            }];
            [self.navigationController pushViewController:editImageVC animated:YES];
        }];
    }
    return _bigImageView;
}

- (UIButton *)locationBtn {
    
    if (!_locationBtn) {
        
        _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locationBtn setTitle:@"从本地相册选择" forState:UIControlStateNormal];
        _locationBtn.titleLabel.textColor  = [UIColor whiteColor];
        [_locationBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg"] forState:UIControlStateNormal];
        
        _locationBtn.layer.cornerRadius = 3.0f;
        _locationBtn.clipsToBounds = YES;
        
        WEAK_SELF(self);
        [_locationBtn bk_whenTapped:^{
            STRONG_SELF(self);
    
            [self getPhotosFromLocal];
        }];
    }
    return _locationBtn;
}

- (UIButton *)sendBtn {
    
    if (!_sendBtn) {
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发布作品" forState:UIControlStateNormal];
        _sendBtn.titleLabel.textColor  = [UIColor whiteColor];
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg"] forState:UIControlStateNormal];
        
        _sendBtn.layer.cornerRadius = 3.0f;
        _sendBtn.clipsToBounds = YES;
        
        WEAK_SELF(self);
        [_sendBtn bk_whenTapped:^{
            STRONG_SELF(self);
            
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC;
                return ;
            }
            
            [self showProgressWithText:@"压缩中"];
            
            [self movFileTransformToMP4WithSourcePath:self.videoPathString completion:^(NSString *Mp4FilePath) {
                
                [self dismissProgress];
                [self saveUploadFileWithPath:Mp4FilePath];
            }];

        }];
    }
    return _sendBtn;
}

- (ZLPhotoActionSheet *)photoActionSheet
{
    if (!_photoActionSheet) {
        
        _photoActionSheet = [[ZLPhotoActionSheet alloc] init];
        
#pragma mark - 参数配置 optional，可直接使用 defaultPhotoConfiguration
        ZLPhotoConfiguration *configuration = [ZLPhotoConfiguration defaultPhotoConfiguration];
        configuration.maxSelectCount = 1;
        configuration.allowTakePhotoInLibrary = NO;

        /*
         //以下参数为自定义参数，均可不设置，有默认值
         configuration.sortAscending = self.sortSegment.selectedSegmentIndex==0;
         configuration.allowSelectImage = self.selImageSwitch.isOn;
         configuration.allowSelectGif = self.selGifSwitch.isOn;
         configuration.allowSelectVideo = self.selVideoSwitch.isOn;
         configuration.allowSelectLivePhoto = self.selLivePhotoSwitch.isOn;
         configuration.allowForceTouch = self.allowForceTouchSwitch.isOn;
         configuration.allowEditImage = self.allowEditSwitch.isOn;
         configuration.allowEditVideo = self.allowEditVideoSwitch.isOn;
         configuration.allowSlideSelect = self.allowSlideSelectSwitch.isOn;
         configuration.allowMixSelect = self.mixSelectSwitch.isOn;
         configuration.allowDragSelect = self.allowDragSelectSwitch.isOn;
         //设置相册内部显示拍照按钮
         configuration.allowTakePhotoInLibrary = self.takePhotoInLibrarySwitch.isOn;
         //设置在内部拍照按钮上实时显示相机俘获画面
         configuration.showCaptureImageOnTakePhotoBtn = self.showCaptureImageSwitch.isOn;
         //设置照片最大预览数
         configuration.maxPreviewCount = self.previewTextField.text.integerValue;
         //设置照片最大选择数
         configuration.maxSelectCount = self.maxSelCountTextField.text.integerValue;
         //设置允许选择的视频最大时长
         configuration.maxVideoDuration = self.maxVideoDurationTextField.text.integerValue;
         //设置照片cell弧度
         configuration.cellCornerRadio = self.cornerRadioTextField.text.floatValue;
         //单选模式是否显示选择按钮
         //    configuration.showSelectBtn = YES;
         //是否在选择图片后直接进入编辑界面
         configuration.editAfterSelectThumbnailImage = self.editAfterSelectImageSwitch.isOn;
         //设置编辑比例
         //    configuration.clipRatios = @[GetClipRatio(1, 1)];
         //是否在已选择照片上显示遮罩层
         configuration.showSelectedMask = self.maskSwitch.isOn;
         //颜色，状态栏样式
         //    configuration.selectedMaskColor = [UIColor purpleColor];
         //    configuration.navBarColor = [UIColor orangeColor];
         //    configuration.navTitleColor = [UIColor blackColor];
         //    configuration.bottomBtnsNormalTitleColor = kRGB(80, 160, 100);
         //    configuration.bottomBtnsDisableBgColor = kRGB(190, 30, 90);
         //    configuration.bottomViewBgColor = [UIColor blackColor];
         //    configuration.statusBarStyle = UIStatusBarStyleDefault;
         //是否允许框架解析图片
         configuration.shouldAnialysisAsset = self.allowAnialysisAssetSwitch.isOn;
         //框架语言
         configuration.languageType = self.languageSegment.selectedSegmentIndex;
         //是否使用系统相机
         //    configuration.useSystemCamera = YES;
         //    configuration.sessionPreset = ZLCaptureSessionPreset1920x1080;
         */
#pragma mark - required
        _photoActionSheet.configuration = configuration;
        //如果调用的方法没有传sender，则该属性必须提前赋值
        _photoActionSheet.sender = self;
        //记录上次选择的图片
        _photoActionSheet.arrSelectedAssets = nil;
        
        WEAK_SELF(self);
        [_photoActionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
            
            STRONG_SELF(self);
            
            UIImage *avatar = [images firstObject];
            
            if (isOriginal == NO) {
                avatar = [Tools compressImageWithImage:avatar ScalePercent:0.5];
            }
            
           
            self.bigImageView.image = avatar;
            
            self.imageUrl = nil;
            
            
            [HTTPTool requestUploadImageToBATWithImages:@[avatar] success:^(NSArray *imageArray) {
                
                [self dismissProgress];
                
                NSDictionary *dic = [imageArray firstObject];
                //更改个人信息
                
                self.imageUrl = dic[@"url"];
                
            } failure:^(NSError *error) {
                
            } uploadProgress:^(NSProgress *progress) {
                
                [self showProgres:progress.fractionCompleted];
            }];
            
        }];
    }
    
    return _photoActionSheet;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
