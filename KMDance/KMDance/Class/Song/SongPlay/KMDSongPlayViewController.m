//
//  KMDSongPlayViewController.m
//  KMDance
//
//  Created by KM on 17/5/272017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDSongPlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "KMDDanceListModel.h"

#import "KMDShareView.h"

#import "UINavigationController+FDFullscreenPopGesture.h"

#import "STKAudioPlayer.h"
#import "KMDDownloadTool.h"

@interface KMDSongPlayViewController ()<STKAudioPlayerDelegate>

//播放器
@property (nonatomic,strong) STKAudioPlayer* audioPlayer;
//表示进度的slider
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
//计时器
@property (nonatomic, strong) NSTimer *timer;
//播放模式
@property (nonatomic,assign) KMDRepeatType type;
//开始按钮
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UILabel *CurrentProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *AllProgressLabel;

@property (weak, nonatomic) IBOutlet UIButton *repeatBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;

@property (weak, nonatomic) IBOutlet UIImageView *songImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic,strong) KMDShareView *shareView;

@property (nonatomic,strong) KMDDanceListData *currentData;

@end

@implementation KMDSongPlayViewController
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    DDLogDebug(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutPages];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transAnimationAgain) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.startButton.selected = YES;
    [self loadMusic];
    
    self.type = KMDRepeatTypeCircle;
    if (self.isList) {
        
        [self songDataRequest];
    }
    else if (self.isSearch) {
        
        self.type = KMDRepeatTypeSingle;
        self.repeatBtn.tag = KMDRepeatTypeSingle;
        [self.repeatBtn setImage:[UIImage imageNamed:@"single_icon"] forState:UIControlStateNormal];
    }
    else if (self.isCollection) {
        
    }
    else if (self.isLocal) {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 40);
    WEAK_SELF(self);
    [btn bk_whenTapped:^{
        STRONG_SELF(self);
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [btn setImage:[UIImage imageNamed:@"backwhite_icon"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.hidesBottomBarWhenPushed = YES;

    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                    NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                    NSFontAttributeName:stringFont(20)
                                                                    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.backImageView.image = nil;
    [self.timer invalidate];
    self.timer = nil;
    
    if (self.startButton.selected == YES) {
        [self startClick:self.startButton];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 40);
    WEAK_SELF(self);
    [btn bk_whenTapped:^{
        STRONG_SELF(self);
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [btn setImage:[UIImage imageNamed:@"backgrey_icon"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.hidesBottomBarWhenPushed = YES;

    
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                    NSForegroundColorAttributeName:STRING_MID_COLOR,
                                                                    NSFontAttributeName:stringFont(20)
                                                                    }];
    [self.navigationController.navigationBar setBackgroundImage:[Tools imageFromColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:BASE_LINECOLOR];
    [self.navigationController.navigationBar setTintColor:UIColorFromHEX(0x02a9a9, 1)];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];

    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
}


#pragma mark - STKAudioPlayerDelegate
/// 当播放器 状态发生改变的时候调用，  暂停-开始播放都会调用
- (void)audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState
{
    
}
/// 引发的意外和可能发生的不可恢复的错误，极少概率会调用。  就是此歌曲不能加载，或者url是不可用的
- (void)audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode
{
    
}
///当一个项目开始播放调用
- (void)audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(sliderDisplay) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
// 一般是歌曲快结束提前5秒调用
- (void)audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId
{
    
}
///当一个项目完成后，就调用
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{

}


#pragma mark - private
- (void)loadMusic {
    
    if (self.isLocal) {
        DownLoadData *data = self.songArray[self.index];
        
        self.title = data.Name;
        if (LOGIN_STATION) {
            [self isCollectionInfoRequest];
        }
        
        [self.songImageView sd_setImageWithURL:[NSURL URLWithString:data.Poster] placeholderImage:[UIImage imageNamed:@"gcw_round"]];
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:data.Poster] placeholderImage:[UIImage imageNamed:@"bg_for_music_def"]];
        self.songImageView.layer.cornerRadius = 1.1/2.0*SCREEN_WIDTH/2.0;
        
        [self.timer invalidate];
        
        NSURL *url = [NSURL fileURLWithPath: [KMDDownloadTool_DownloadDataDocument_Path_Music stringByAppendingPathComponent:data.fileName]];
        [self.audioPlayer playURL:url];
        
        self.currentData = nil;
        
    }
    else {
        KMDDanceListData *data = self.songArray[self.index];
        
        self.title = data.Name;
        if (LOGIN_STATION) {
            [self isCollectionInfoRequest];
        }
        
        [self.songImageView sd_setImageWithURL:[NSURL URLWithString:data.Poster] placeholderImage:[UIImage imageNamed:@"gcw_round"]];
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:data.Poster] placeholderImage:[UIImage imageNamed:@"bg_for_music_def"]];
        self.songImageView.layer.cornerRadius = 1.1/2.0*SCREEN_WIDTH/2.0;
        
        [self.timer invalidate];
        
        [self.audioPlayer play:data.Url];
        
        self.currentData = data;
    }

    [self transAnimationAgain];
}

/** 将秒数转换为分秒格式的时间字符串 */
- (NSString *)timeFormatted:(int)totalSeconds
{
    //将秒数转换为时间
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:totalSeconds];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    //设置时间格式
    NSDateFormatter *dateformmatter = [[NSDateFormatter alloc] init];
    dateformmatter.dateFormat = @"mm:ss";
    NSString *time = [dateformmatter stringFromDate:localeDate];
    
    return time;
}

- (void)transAnimationAgain {
    
    if (self.audioPlayer.state != STKAudioPlayerStatePlaying) {
        return;
    }
    
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat:M_PI *2];
    animation.duration  = 10;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    [self.songImageView.layer addAnimation:animation forKey:nil];
}

- (void)transAnimationStop {
    
    [self.songImageView.layer removeAllAnimations];
}

#pragma mark - action
//开始播放按钮
- (IBAction)startClick:(UIButton *)sender {
 
    if (!sender.selected) {
        
        sender.selected = YES;

        [self.audioPlayer resume];
        
        [self transAnimationAgain];
    } else {
        
        sender.selected = NO;
        
        [self.audioPlayer pause];
        
        [self transAnimationStop];
    }
    
}
- (IBAction)downloadSong:(id)sender {
    
    if (!LOGIN_STATION) {
        
        PRESENT_LOGIN_VC;
        return;
    }
    
    if (!self.currentData) {
        
        [self showSuccessWithText:@"已添加，请到“我的下载”查看"];
        return;
    }
    
    NSString *fileName = [[self.currentData.Url componentsSeparatedByString:@"/"] lastObject];
    NSString *filePath = [KMDDownloadTool_DownloadDataDocument_Path_Music stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO) {
        
        [[KMDDownloadTool shareInstance] addDownloadTast:self.currentData.Url andOffLine:YES mediaType:KMDDownloadTypeSong];
        
        [[KMDDownloadTool shareInstance] saveDownloadInfoWithDic:@{@"fileName":fileName,@"Name":self.currentData.Name,@"Poster":self.currentData.Poster,@"Singer":self.currentData.Singer,@"AuthorName":self.currentData.AuthorName,@"Url":self.currentData.Url,@"ID":self.currentData.ID} mediaType:KMDDownloadTypeSong];
        
        [self showSuccessWithText:@"已添加，请到“我的下载”查看"];
    }
    else {
        
        [self showSuccessWithText:@"已添加，请到“我的下载”查看"];
    }
}

/** 计时器调用的显示slider的方法 */
- (void)sliderDisplay {
    //赋值
    self.progressSlider.value = self.audioPlayer.progress/self.audioPlayer.duration;
    //转换时间格式
    NSString *curren = [self timeFormatted:self.audioPlayer.progress];
    NSString *all = [self timeFormatted:self.audioPlayer.duration];
    //把时间拼接赋值给显示时间的label
    self.CurrentProgressLabel.text = [NSString stringWithFormat:@"%@",curren];
    self.AllProgressLabel.text = [NSString stringWithFormat:@"%@",all];
    
    if (self.progressSlider.value >= 0.999) {
        
        if (self.type == KMDRepeatTypeSingle) {
            
            [self.audioPlayer seekToTime:0];
            return;
        }
        [self nextMusicClick:nil];
    }
}

/** 拖动进度条 */
- (IBAction)slideProgress:(UISlider *)sender {
    //将当前的播放时间设置为slider的value
    [self.audioPlayer seekToTime:self.audioPlayer.duration*sender.value];
}


//上一曲
- (IBAction)lastMusicClick:(id)sender {
    
    self.startButton.selected = YES;
    
    switch (self.type) {
        case KMDRepeatTypeCircle:
        {
            if (self.index <= 0) {
                self.index = self.songArray.count - 1;
            } else {
                self.index--;
            }
        }
            break;
        case KMDRepeatTypeSingle:
        {
            if (self.index <= 0) {
                self.index = self.songArray.count - 1;
            } else {
                self.index--;
            }
        }
            break;
        case KMDRepeatTypeRandom:
        {
            NSInteger index = arc4random() % self.songArray.count;
            self.index = index;
        }
            break;
    }
    
    [self loadMusic];
}
//下一曲
- (IBAction)nextMusicClick:(id)sender {
    
    self.startButton.selected = YES;
    
    switch (self.type) {
        case KMDRepeatTypeCircle:
        {
            if (self.index >= self.songArray.count - 1) {
                self.index = 0;
            } else {
                self.index++;
            }
        }
            break;
        case KMDRepeatTypeSingle:
        {
            if (self.index >= self.songArray.count - 1) {
                self.index = 0;
            } else {
                self.index++;
            }
        }
            break;
        case KMDRepeatTypeRandom:
        {
            NSInteger index = arc4random() % self.songArray.count;
            self.index = index;
        }
            break;
    }
    
    
    [self loadMusic];
}

- (IBAction)collectionSong:(UIButton *)sender {
    
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    
    if (sender.selected == YES) {
        //取消
        [self cancleCollection];
    }
    else {
        //收藏
        [self addCollection];
    }
    
    sender.selected = !sender.selected;
}

- (IBAction)repeatModel:(UIButton *)sender {
    
    if (self.isSearch) {
        return;
    }
    
    if (sender.tag == KMDRepeatTypeCircle) {
        
        self.type = KMDRepeatTypeRandom;
        sender.tag = KMDRepeatTypeRandom;
        [sender setImage:[UIImage imageNamed:@"random_icon"] forState:UIControlStateNormal];
    }
    else if (sender.tag == KMDRepeatTypeRandom) {
        
        self.type = KMDRepeatTypeSingle;
        sender.tag = KMDRepeatTypeSingle;
        [sender setImage:[UIImage imageNamed:@"single_icon"] forState:UIControlStateNormal];
    }
    else if (sender.tag == KMDRepeatTypeSingle) {
        
        self.type = KMDRepeatTypeCircle;
        sender.tag = KMDRepeatTypeCircle;
        [sender setImage:[UIImage imageNamed:@"circulation_icon"] forState:UIControlStateNormal];
    }
}

#pragma mark - NET
- (void)songDataRequest {
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/GetDanceOrMusicList"
                        parameters:@{
                                     @"category":@(kKMDSearchSong),
                                     @"keyword":@"",
                                     @"pageIndex":@(0),
                                     @"pageSize":@"1000"
                                     }
                              type:kXMHTTPMethodGET
                           success:^(id responseObject) {
                               
                               KMDDanceListModel *model = [KMDDanceListModel mj_objectWithKeyValues:responseObject];

                               self.songArray = [NSMutableArray arrayWithArray:model.Data];
                           }
                           failure:^(NSError *error) {
    
                           }];
}

//收藏舞蹈
-(void)addCollection {
    
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    
    KMDDanceListData *data = self.songArray[self.index];

    [HTTPTool requestWithURLString:@"/api/SquareDance/AddCollectDance" parameters:@{@"OBJ_ID":data.ID,@"OBJ_TYPE":@(kKMDCollectSong)} type:kXMHTTPMethodPOST success:^(id responseObject) {
        [self showSuccessWithText:@"收藏成功"];
        
    } failure:^(NSError *error) {
        [self showErrorWithText:@"收藏失败"];
    }];
}
//取消收藏舞蹈
-(void)cancleCollection {
    
    KMDDanceListData *data = self.songArray[self.index];

    [HTTPTool requestWithURLString:@"/api/SquareDance/CanelCollectDance" parameters:@{@"OBJ_ID":data.ID,@"OBJ_TYPE":@(kKMDCollectSong)} type:kXMHTTPMethodPOST success:^(id responseObject) {
        [self showSuccessWithText:@"取消收藏成功"];
        
        
    } failure:^(NSError *error) {
        [self showErrorWithText:@"取消收藏失败"];
    }];
}

-(void)isCollectionInfoRequest {
    
    KMDDanceListData *data = self.songArray[self.index];

    [HTTPTool requestWithURLString:@"/api/SquareDance/IsCollect" parameters:@{@"RelationType":@(kKMDCollectSong),@"RelationId":data.ID} type:kXMHTTPMethodGET success:^(id responseObject) {
        
        NSString *isCollectionString = [NSString stringWithFormat:@"%@",responseObject[@"Data"][@"IsCollect"]];
        if ([isCollectionString isEqualToString:@"0"]) {
            
            DDLogDebug(@"没有收藏");
            self.collectionBtn.selected = NO;
            
        }else {
            DDLogDebug(@"已经收藏");
            
            self.collectionBtn.selected = YES;
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - layout
- (void)layoutPages {
    
    self.songImageView.clipsToBounds = YES;

    [self transAnimationAgain];
    
    
    WEAK_SELF(self);
    [self.view addSubview:self.shareView];
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.mas_equalTo(140);
        make.bottom.equalTo(@140);
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"icon-fenxiang"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        STRONG_SELF(self);
        [self.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (iPhoneX) {
                make.bottom.equalTo(@-34);
            }
            else {
                make.bottom.equalTo(@0);
            }
        }];
        
        [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        } completion:nil];
    }];
}

#pragma mark - getter
- (STKAudioPlayer *)audioPlayer {
    
    if (!_audioPlayer) {
        
        _audioPlayer = [[STKAudioPlayer alloc] init];
        _audioPlayer.delegate = self;
    }
    return _audioPlayer;
}

- (KMDShareView *)shareView {
    
    if (!_shareView) {
        _shareView = [[KMDShareView alloc] initWithFrame:CGRectZero];
        WEAK_SELF(self);
        [_shareView setCancelBlock:^{
            STRONG_SELF(self);
            [self.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@140);
            }];
            
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            } completion:nil];
        }];
        
        [_shareView setWeiChatBlock:^{
            STRONG_SELF(self);
            
            KMDDanceListData *data = self.songArray[self.index];
        
            OSMessage *msg=[[OSMessage alloc]init];
            msg.title = self.title;
            msg.desc = @"康美广场舞";
            
            msg.link = [NSString stringWithFormat:@"%@/App/Dancing/ShareMusic?ID=%@",APP_H5_URL,data.ID];
            msg.image = [UIImage imageNamed:@"login_icon"];
            msg.multimediaType = OSMultimediaTypeNews;
//            msg.mediaDataUrl = data.Url;

            [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
                
            } Fail:^(OSMessage *message, NSError *error) {
                
            }];
            self.shareView.cancelBlock();

        }];
        
        [_shareView setQQBlock:^{
            STRONG_SELF(self);
            KMDDanceListData *data = self.songArray[self.index];

            OSMessage *msg=[[OSMessage alloc]init];
            msg.title = self.title;
            msg.desc = @"康美广场舞";
            msg.image = [UIImage imageNamed:@"login_icon"];
            msg.link = [NSString stringWithFormat:@"%@/App/Dancing/ShareMusic?ID=%@",APP_H5_URL,data.ID];
            msg.multimediaType = OSMultimediaTypeNews;
            
            [OpenShare shareToQQFriends:msg Success:^(OSMessage *message) {
                
            } Fail:^(OSMessage *message, NSError *error) {
                
            }];
            self.shareView.cancelBlock();

        }];
        
        [_shareView setWeiChatMomentsBlock:^{
            STRONG_SELF(self);
            KMDDanceListData *data = self.songArray[self.index];

            OSMessage *msg=[[OSMessage alloc]init];
            msg.title = self.title;
            msg.desc = @"康美广场舞";
            msg.link = [NSString stringWithFormat:@"%@/App/Dancing/ShareMusic?ID=%@",APP_H5_URL,data.ID];
            msg.image = [UIImage imageNamed:@"login_icon"];
            msg.multimediaType = OSMultimediaTypeAudio;
            msg.mediaDataUrl = data.Url;
            
            [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
                
            } Fail:^(OSMessage *message, NSError *error) {
                
            }];
            self.shareView.cancelBlock();

        }];
        
        [_shareView setWeiboBlock:^{
            STRONG_SELF(self);
            KMDDanceListData *data = self.songArray[self.index];

            OSMessage *msg=[[OSMessage alloc]init];
            msg.title = self.title;
            msg.desc = @"康美广场舞";
            msg.image = [UIImage imageNamed:@"login_icon"];
            msg.link = [NSString stringWithFormat:@"%@/App/Dancing/ShareMusic?ID=%@",APP_H5_URL,data.ID];
            msg.multimediaType = OSMultimediaTypeNews;
            [OpenShare shareToWeibo:msg Success:^(OSMessage *message) {
                
            } Fail:^(OSMessage *message, NSError *error) {
                
            }];
            self.shareView.cancelBlock();

        }];
        
    }
    return _shareView;
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
