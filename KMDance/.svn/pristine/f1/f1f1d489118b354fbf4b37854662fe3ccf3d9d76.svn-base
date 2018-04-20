//
//  KMDDanceViewController.m
//  KMDance
//
//  Created by KM on 17/5/172017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDDanceViewController.h"

#import "KMDDanceHeaderView.h"
#import "KMDDanceVideoTableViewCell.h"
#import "KMDDanceCircleTableHeaderView.h"
#import "KMDUploadView.h"

#import "KMDDanceListModel.h"

#import "KMDVideoViewController.h"
#import "KMDSearchViewController.h"
#import "KMDDanceThemeViewController.h"
#import "KMDUploadViewController.h"

#import "KMDTextField.h"

static  NSString * const DANCE_VIDEO_CELL = @"KMDDanceVideoTableViewCell";

@interface KMDDanceViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) KMDTextField *searchTF;
@property (nonatomic,strong) UITableView *danceTableView;
@property (nonatomic,strong) KMDDanceCircleTableHeaderView *tableHeaderView;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger currentPage;

//上传
@property (strong, nonatomic) UIImagePickerController *imgPickerController;
@property (strong, nonatomic) NSString *videoPathString;
@property (nonatomic,strong) KMDUploadView *uploadView;

@end

@implementation KMDDanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.modalPresentationStyle = UIModalPresentationNone;
    
    [self pagesLayout];
    [self.danceTableView.mj_header beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    KMDDanceListData *data = self.dataArray[indexPath.row];

    KMDDanceVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DANCE_VIDEO_CELL forIndexPath:indexPath];

//    [cell.danceImageView sd_setImageWithURL:[NSURL URLWithString:data.Poster] placeholderImage:[UIImage imageNamed:@"默认图"]];
    
    [cell.danceImageView sd_setImageWithURL:[NSURL URLWithString:data.Poster] placeholderImage:[UIImage imageNamed:@"默认图"]  completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (image) {
            cell.danceImageView.backgroundColor = [UIColor blackColor];
        }
    }];
    
    cell.danceTitleLabel.text = data.Name;
    cell.sourceLabel.text = data.AuthorName;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    KMDDanceHeaderView *header = [[KMDDanceHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    header.nameLabel.text = @"舞蹈视频";
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KMDDanceListData *data = self.dataArray[indexPath.row];

    KMDVideoViewController *videoVC = [[KMDVideoViewController alloc] init];
    videoVC.videoID = data.ID;
    videoVC.ResourceKey = data.ResourceKey;
    videoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoVC animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    //搜索
    KMDSearchViewController *searchVC = [[KMDSearchViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    searchVC.searchCategory = kKMDSearchDance;
    [self.navigationController pushViewController:searchVC animated:YES];
    return NO;
}

#pragma mark - UIImagePickerControllerDelegate,UINavigationControllerDelegate

/**
 *  视频保存后的回调
 第一个参数 : 录到并保存在本地的视频路径
 */
- (void)video:(NSString *)videoPathString didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    [self handleLocalVideo];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

// 代理方法(1) : 用户作出完成动作时会触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [UIApplication sharedApplication].statusBarHidden = NO;

    if (self.imgPickerController.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {// 相册选取视频
        
        // 获取到这个视频的路径
        self.videoPathString = (NSString *)([info[@"UIImagePickerControllerMediaURL"] path]);
        [self handleLocalVideo];
    }
    else if (self.imgPickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {// 录像
        
        // 录像会自动放到沙盒的某个路径, 获取到这个路径
        self.videoPathString = (NSString *)([info[@"UIImagePickerControllerMediaURL"] path]);
        // 是否保存录像到相册(不写的话就是不保存), 保存后有一个回调方法
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoPathString)) {
            
            UISaveVideoAtPathToSavedPhotosAlbum(self.videoPathString, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    
    // 模态走imgPicker
    [self bk_performBlock:^(id obj) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } afterDelay:0.35];

}
// 代理方法(2) : 用户作出取消动作时会触发的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    // 模态走imgPicker
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([viewController isKindOfClass:NSClassFromString(@"PUUIImageViewController")]) {
        [navigationController setNavigationBarHidden:YES animated:YES];
        [UIApplication sharedApplication].statusBarHidden = YES;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUUIMomentsGridViewController")]) {
        [navigationController setNavigationBarHidden:NO animated:YES];
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUUIMomentsGridViewController")]) {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PLUICameraViewController")]) {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
}

//处理本地沙盒中的视频
- (void)handleLocalVideo {
    
    KMDUploadViewController *uploadVC = [[KMDUploadViewController alloc] init];
    uploadVC.videoPathString = self.videoPathString;
    uploadVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:uploadVC animated:YES];
    

}

#pragma mark - NET
- (void)danceDataRequest {
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/GetDanceOrMusicList"
                        parameters:@{
                                      @"category":@(kKMDSearchDance),
                                       @"keyword":@"",
                                     @"pageIndex":@(self.currentPage),
                                      @"pageSize":@"10"
                                     }
                              type:kXMHTTPMethodGET
                           success:^(id responseObject) {
                               
                               [self.danceTableView.mj_header endRefreshing];
                               [self.danceTableView.mj_footer endRefreshing];

                               if (self.currentPage == 0) {
                                   [self.dataArray removeAllObjects];
                               }
                               
                               KMDDanceListModel *model = [KMDDanceListModel mj_objectWithKeyValues:responseObject];
                               [self.dataArray addObjectsFromArray:model.Data];
                               [self.danceTableView reloadData];
                               if (self.dataArray.count >= model.RecordsCount) {
                                   [self.danceTableView.mj_footer endRefreshingWithNoMoreData];
                               }
    }
                           failure:^(NSError *error) {
                               [self.danceTableView.mj_header endRefreshing];
                               [self.danceTableView.mj_footer endRefreshing];
                               
                               self.currentPage --;
                               if (self.currentPage < 0) {
                                   self.currentPage = 0;
                               }
    }];
}

#pragma mark - layout
- (void)pagesLayout {
    
    self.navigationItem.titleView = self.searchTF;
    
    [self.view addSubview:self.danceTableView];
    [self.danceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        if (@available(iOS 11.0,*)) {
            if (iPhoneX) {
                make.bottom.equalTo(@(-83+49));
            }
            else {
                make.bottom.equalTo(@-20);
            }
        }
        else {
            make.bottom.equalTo(@0);
        }
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"上传视频" style:UIBarButtonItemStylePlain handler:^(id sender) {
       
        [[UIApplication sharedApplication].windows[0] addSubview:self.uploadView];
        [self.uploadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(@0);
            make.top.equalTo(@-64);
        }];
        
    }];
    
}

#pragma mark - getter
- (KMDTextField *)searchTF {
    
    if (!_searchTF) {
        
        _searchTF = [[KMDTextField alloc] init];
        _searchTF.font = [UIFont systemFontOfSize:15];
        _searchTF.textColor = UIColorFromHEX(0x02a9a9, 1);
        _searchTF.borderStyle = UITextBorderStyleNone;
        _searchTF.clearButtonMode = UITextFieldViewModeNever;
        _searchTF.backgroundColor = UIColorFromHEX(0x099090, 0.2);
        _searchTF.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
        if (@available(iOS 11.0, *)) {
            
            _searchTF.intrinsicContentSize = CGSizeMake(SCREEN_WIDTH, 30);
        }
        _searchTF.text = @"舞蹈";
        
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon"]];
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        [leftIcon addSubview:searchIcon];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftIcon);
        }];
        
        _searchTF.leftView = leftIcon;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.delegate = self;

        _searchTF.layer.cornerRadius = 3.0f;
        _searchTF.clipsToBounds = YES;
    }
    return _searchTF;
}

- (UITableView *)danceTableView {
    
    if (!_danceTableView) {
        
        _danceTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _danceTableView.showsVerticalScrollIndicator = NO;
        _danceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _danceTableView.backgroundColor = BASE_BACKGROUND_COLOR;
        _danceTableView.rowHeight = 90;
//        _danceTableView.estimatedRowHeight = 90;
        
        _danceTableView.tableHeaderView = self.tableHeaderView;
        _danceTableView.tableFooterView = [[UIView alloc] init];
        [_danceTableView registerClass:[KMDDanceVideoTableViewCell class] forCellReuseIdentifier:DANCE_VIDEO_CELL];
       
        _danceTableView.delegate = self;
        _danceTableView.dataSource = self;
        
        WEAK_SELF(self);
        _danceTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            STRONG_SELF(self);
            self.currentPage = 0;
            if (!self.dataArray) {
                self.dataArray = [NSMutableArray array];
            }
            [self danceDataRequest];
        }];
        
        _danceTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            STRONG_SELF(self);
            self.currentPage ++;
            [self danceDataRequest];
        }];
    }
    return _danceTableView;
}

- (KMDDanceCircleTableHeaderView *)tableHeaderView {
    
    if (!_tableHeaderView) {
        
        _tableHeaderView = [[KMDDanceCircleTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*380/750.0)];
        _tableHeaderView.circlePictureView.placeholderImage = [UIImage imageNamed:@"默认图"];
        _tableHeaderView.circlePictureView.localizationImageNamesGroup = @[[UIImage imageNamed:@"广场舞-本期"], [UIImage imageNamed:@"广场舞-往期"],];
        
        WEAK_SELF(self);
        [_tableHeaderView setTopPicClick:^(NSInteger index) {
            STRONG_SELF(self);
            
            KMDDanceThemeViewController *danceThemeVC = [[KMDDanceThemeViewController alloc] init];
            danceThemeVC.hidesBottomBarWhenPushed = YES;
            switch (index) {
                case 0:
                {
                    //本期
                    danceThemeVC.title = @"本期精彩";
                    danceThemeVC.type = kKMDNow;
                }
                    break;
                case 1:
                {
                    //往期
                    danceThemeVC.title = @"往期回顾";
                    danceThemeVC.type = kKMDLast;
                }
                    break;
            }
            
            [self.navigationController pushViewController:danceThemeVC animated:YES];
        }];
    }
    return _tableHeaderView;
}

- (UIImagePickerController *)imgPickerController {
    
    if (!_imgPickerController) {
        
        _imgPickerController = [[UIImagePickerController alloc] init];
        _imgPickerController.delegate = self;
        // 产生的媒体文件是否可进行编辑
        _imgPickerController.allowsEditing = YES;
        // 媒体类型
        _imgPickerController.mediaTypes = @[@"public.movie"];
        
        /**
         *  录像质量 :
         
         这三种录像质量会录出一个根据当前设备自适应分辨率的视频文件, MOV格式, 视频采用 H264 编码, 三种质量视频的清晰度还是有明显差别, 所以我一般选取高质量的录像, 然后才去中质量的视频压缩, 最终得到的视频清晰度和高质量没啥区别, 而大小又和中质量直接录的视频没啥区别
         UIImagePickerControllerQualityTypeLow
         UIImagePickerControllerQualityTypeMedium
         UIImagePickerControllerQualityTypeHigh
         
         这三种录像质量会录出一个指定分辨率的视频文件, MOV格式, 视频采用 H264 编码, 但是我们一般选取中质量
         UIImagePickerControllerQualityType640x480
         UIImagePickerControllerQualityTypeIFrame960x540
         UIImagePickerControllerQualityTypeIFrame1280x720
         */
        
    }
    return _imgPickerController;
}

- (KMDUploadView *)uploadView {
    
    if (!_uploadView) {
        
        _uploadView = [[KMDUploadView alloc] initWithFrame:CGRectZero];
        WEAK_SELF(self);
        [_uploadView bk_whenTapped:^{
            STRONG_SELF(self);
            [self.uploadView removeFromSuperview];
        }];
        
        [_uploadView setCameraClickBlock:^{
            STRONG_SELF(self);
            [self.uploadView removeFromSuperview];
            
            
            // 调用 imgPickerController 的时候, 判断一下是否支持相册或者摄像头功能
            if (![UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeSavedPhotosAlbum)] || ![UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的设备不支持此功能!" preferredStyle:(UIAlertControllerStyleAlert)];
                
                UIAlertAction *defaltAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:nil];
                
                [alertController addAction:defaltAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
                return ;
            }
            
            // 媒体源, 这里设置为摄像头
            self.imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            // 摄像头, 这里设置默认使用后置摄像头
            self.imgPickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            // 摄像头模式, 这里设置为录像模式
            self.imgPickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            // 录像质量
            self.imgPickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
            // 模态出 imgPicker
            [self presentViewController:self.imgPickerController animated:YES completion:nil];
        }];
        
        [_uploadView setVideoClickBlock:^{
            STRONG_SELF(self);
            [self.uploadView removeFromSuperview];

            // 调用 imgPickerController 的时候, 判断一下是否支持相册或者摄像头功能
            if (![UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeSavedPhotosAlbum)] || ![UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的设备不支持此功能!" preferredStyle:(UIAlertControllerStyleAlert)];
                
                UIAlertAction *defaltAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:nil];
                
                [alertController addAction:defaltAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
                return ;
            }
            
            // 媒体源, 这里设置为相册
            self.imgPickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            // 模态出 imgPicker
            [self presentViewController:self.imgPickerController animated:YES completion:nil];

        }];
    }
    return _uploadView;
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
