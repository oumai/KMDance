//
//  KMDDownloadDetailViewController.m
//  KMDance
//
//  Created by KM on 17/6/232017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDDownloadDetailViewController.h"

#import "KMDVideoDownloadTableViewCell.h"
#import "KMDMusicDownloadTableViewCell.h"

#import "KMDDanceListModel.h"

#import "KMDVideoViewController.h"
#import "KMDSongPlayViewController.h"

#import "KMDDownloadTool.h"

#import "UIScrollView+EmptyDataSet.h"
#import "ZFPlayer.h"

#import "UIView+CustomControlView.h"

static  NSString * const DANCE_CELL = @"KMDVideoDownloadTableViewCell.h";
static  NSString * const SONG_CELL = @"KMDMusicDownloadTableViewCell.h";

@interface KMDDownloadDetailViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,ZFPlayerDelegate,ZFPlayerControlViewDelagate>

@property (nonatomic,strong) UITableView *downloadTableView;

@property (nonatomic,strong) KMDDownloadInfoModel *downloadInfo;

@property (nonatomic,strong) ZFPlayerView *playerView;
@property (nonatomic,strong) ZFPlayerControlView *controlView;

@end
    
@implementation KMDDownloadDetailViewController

- (void)dealloc {
    
    DDLogDebug(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.downloadInfo = DOWNLOAD_INFO;
    
    [self pagesLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    switch (self.type) {
        case KMDDownloadTypeDance:
        {
            return self.downloadInfo.videos.count;
        }
            break;
        case KMDDownloadTypeSong:
        {
            return self.downloadInfo.songs.count;

        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF(self);

    switch (self.type) {
        case KMDDownloadTypeDance:
        {
            DownLoadData *data = self.downloadInfo.videos[indexPath.row];
            WEAK_SELF(data);
            
            KMDVideoDownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DANCE_CELL forIndexPath:indexPath];
            WEAK_SELF(cell);
            
            [cell.danceImageView sd_setImageWithURL:[NSURL URLWithString:data.Poster] placeholderImage:[UIImage imageNamed:@"默认图"]];
            cell.danceTitleLabel.text = data.Name;
            cell.sourceLabel.text = data.AuthorName;
            
            if ([KMDDownloadTool shareInstance].downloadSources.count > 0) {
                
                for (KMDDownloadSource *downSource in [KMDDownloadTool shareInstance].downloadSources) {
                    
                    if ([downSource.fileName isEqualToString:data.fileName]) {
                        
                        //正在下载的文件
                        cell.source = downSource;
                        //暂停
                        cell.pauseBlock = nil;
                        [cell setPauseBlock:^{
                            STRONG_SELF(cell);
                            
                            if (cell.pauseButton.selected == YES) {
                                
                                [[KMDDownloadTool shareInstance] continueDownload:downSource];
                            }
                            else {
                                [[KMDDownloadTool shareInstance] suspendDownload:downSource];
                                
                            }
                        }];
                        
                        break;
                    }
                    
                    if ([[KMDDownloadTool shareInstance].downloadSources lastObject] == downSource) {
                        
                        cell.source = nil;
                    }
                }
            }
            else {
                
                cell.source = nil;
            }
            
            //删除
            cell.deleteBlock = nil;
            [cell setDeleteBlock:^{
                STRONG_SELF(self);
                
                [self showDeleteAlertWithDelete:^{
                    STRONG_SELF(cell);
                    STRONG_SELF(data);
                    
                    DDLogDebug(@"%@",data.fileName);
                    
                    if (cell.source) {
                        [[KMDDownloadTool shareInstance] stopDownload:cell.source];
                    }
                    
                    [[NSFileManager defaultManager] removeItemAtPath:[KMDDownloadTool_DownloadDataDocument_Path_Video stringByAppendingPathComponent:data.fileName] error:nil];
                    [[KMDDownloadTool shareInstance] deleteDownloadInfoWithFileName:data.fileName mediaType:KMDDownloadTypeDance];
                    self.downloadInfo = nil;
                    self.downloadInfo = DOWNLOAD_INFO;
                    [self.downloadTableView reloadData];
                }];
            }];
            
            return cell;
        }
            break;
        case KMDDownloadTypeSong:
        {
            DownLoadData *data = self.downloadInfo.songs[indexPath.row];
            WEAK_SELF(data);

            KMDMusicDownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SONG_CELL forIndexPath:indexPath];
            WEAK_SELF(cell);
            
            cell.songTitleLabel.text = data.Name;
            cell.contentLabel.text = data.Singer;
            
            if ([KMDDownloadTool shareInstance].downloadSources.count > 0) {
                
                for (KMDDownloadSource *downSource in [KMDDownloadTool shareInstance].downloadSources) {
                    
                    if ([downSource.fileName isEqualToString:data.fileName]) {
                        
                        //正在下载的文件
                        cell.source = downSource;
                        //暂停
                        cell.pauseBlock = nil;
                        [cell setPauseBlock:^{
                            STRONG_SELF(cell);
                            
                            if (cell.pauseButton.selected == YES) {
                                
                                [[KMDDownloadTool shareInstance] continueDownload:downSource];
                            }
                            else {
                                [[KMDDownloadTool shareInstance] suspendDownload:downSource];
                                
                            }
                        }];
                        
                        break;
                    }
                    
                    if ([[KMDDownloadTool shareInstance].downloadSources lastObject] == downSource) {
                        
                        cell.source = nil;
                    }
                }
            }
            else {
                
                cell.source = nil;
            }
            
            //删除
            cell.deleteBlock = nil;
            [cell setDeleteBlock:^{
                STRONG_SELF(self);
                
                [self showDeleteAlertWithDelete:^{
                    STRONG_SELF(cell);
                    STRONG_SELF(data);
                    
                    DDLogDebug(@"%@",data.fileName);
                    
                    if (cell.source) {
                        [[KMDDownloadTool shareInstance] stopDownload:cell.source];
                    }
                    
                    [[NSFileManager defaultManager] removeItemAtPath:[KMDDownloadTool_DownloadDataDocument_Path_Music stringByAppendingPathComponent:data.fileName] error:nil];
                    [[KMDDownloadTool shareInstance] deleteDownloadInfoWithFileName:data.fileName mediaType:KMDDownloadTypeSong];
                    self.downloadInfo = nil;
                    self.downloadInfo = DOWNLOAD_INFO;
                    [self.downloadTableView reloadData];
                }];
            }];

            
            return cell;
        }
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    switch (self.type) {
        case KMDDownloadTypeDance:
        {
            DownLoadData *data = self.downloadInfo.videos[indexPath.row];
            
            if ([KMDDownloadTool shareInstance].downloadSources.count > 0) {
                
                for (KMDDownloadSource *downSource in [KMDDownloadTool shareInstance].downloadSources) {
                    
                    if ([downSource.fileName isEqualToString:data.fileName]) {
                        
                        return;
                    }
                }
            }
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    
            ZFPlayerModel *model = [[ZFPlayerModel alloc] init];
            model.fatherView = cell.contentView;
            model.title = data.Name;
            model.videoURL =  [NSURL fileURLWithPath:[KMDDownloadTool_DownloadDataDocument_Path_Video stringByAppendingPathComponent:data.fileName]];
            model.placeholderImageURLString = data.Poster;

            [self.playerView playerControlView:self.controlView playerModel:model];
            
            [self.playerView autoPlayTheVideo];
            
            [self.controlView fullScreenBtnClick:self.controlView.fullScreenBtn];


        }
            break;
        case KMDDownloadTypeSong:
        {
            DownLoadData *data = self.downloadInfo.songs[indexPath.row];
            
            NSMutableArray *songs = [NSMutableArray arrayWithArray:self.downloadInfo.songs];
            
            if ([KMDDownloadTool shareInstance].downloadSources.count > 0) {
                
                for (KMDDownloadSource *downSource in [KMDDownloadTool shareInstance].downloadSources) {
                    
                    if ([downSource.fileName isEqualToString:data.fileName]) {
                       
                        return;
                    }
                }
            }
            
            for (KMDDownloadSource *downSource in [KMDDownloadTool shareInstance].downloadSources) {
                
                if ([downSource.fileName isEqualToString:data.fileName]) {
                    
                    if (downSource.style != KMDDownloadSourceStyleFinished) {
                        [songs removeObjectAtIndex:0];
                    }
                }
            }
            
            KMDSongPlayViewController *songPlayVC = [[KMDSongPlayViewController alloc] init];
            songPlayVC.songArray = songs;
            songPlayVC.index = [songs indexOfObject:data];
            songPlayVC.currentPage = 0;
            songPlayVC.isLocal = YES;
            songPlayVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:songPlayVC animated:YES];
            
        }
            break;
    }
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *contentStr = @"您还没有下载任何内容哦，快去看看吧";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: STRING_MID_COLOR};
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contentStr attributes:attributes];
    
    return attrStr;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"no_collection"];
    
}

#pragma mark - private
- (void)showDeleteAlertWithDelete:(void(^)(void))delete {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否删除" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (delete) {
            delete();
        }

    }];
    
    
    [alertController addAction:cameraAction];
    [alertController addAction:deleteAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - layout
- (void)pagesLayout {
    
    [self.view addSubview:self.downloadTableView];
    [self.downloadTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

#pragma mark - getter
- (UITableView *)downloadTableView {
    
    if (!_downloadTableView) {
        
        _downloadTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _downloadTableView.showsVerticalScrollIndicator = NO;
        _downloadTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _downloadTableView.backgroundColor = [UIColor whiteColor];
        _downloadTableView.rowHeight = 90;

        
        [_downloadTableView registerClass:[KMDVideoDownloadTableViewCell class] forCellReuseIdentifier:DANCE_CELL];
        [_downloadTableView registerClass:[KMDMusicDownloadTableViewCell class] forCellReuseIdentifier:SONG_CELL];
        
        _downloadTableView.delegate = self;
        _downloadTableView.dataSource = self;
        
        _downloadTableView.emptyDataSetDelegate = self;
        _downloadTableView.emptyDataSetSource = self;
        
    }
    return _downloadTableView;
}

- (ZFPlayerView *)playerView {
    
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        _playerView.isDownloadVideo = YES;
//        _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspectFill;
        _playerView.delegate = self;
        
        WEAK_SELF(self);
        [_playerView setBackBlock:^{
            STRONG_SELF(self);
            [self.playerView interfaceOrientation:UIInterfaceOrientationPortrait];
            [self.playerView resetPlayer];
            [self.playerView removeFromSuperview];
            [self.controlView removeFromSuperview];
            self.playerView = nil;
            self.controlView = nil;
        }];
        
        [_playerView setFullScreenBlock:^{
            STRONG_SELF(self);
            [self.playerView interfaceOrientation:UIInterfaceOrientationPortrait];
            [self.playerView resetPlayer];
            [self.playerView removeFromSuperview];
            [self.controlView removeFromSuperview];
            self.playerView = nil;
            self.controlView = nil;
        }];
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView {
    
    if (!_controlView) {
        
        _controlView = [[ZFPlayerControlView alloc] init];
    }
    return _controlView;
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
