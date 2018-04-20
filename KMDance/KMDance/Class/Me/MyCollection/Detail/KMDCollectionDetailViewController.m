//
//  KMDCollectionDetailViewController.m
//  KMDance
//
//  Created by KM on 17/5/232017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDCollectionDetailViewController.h"

#import "KMDDanceVideoTableViewCell.h"
#import "KMDSongTableViewCell.h"
#import "KMDNewsTableViewCell.h"

#import "KMDDanceListModel.h"
#import "KMDNewsModel.h"

#import "KMDVideoViewController.h"
#import "KMDSongPlayViewController.h"
#import "BATNewsDetailViewController.h"

#import "UIScrollView+EmptyDataSet.h"

static  NSString * const DANCE_CELL = @"KMDDanceVideoTableViewCell";
static  NSString * const SONG_CELL = @"KMDSongTableViewCell";
static  NSString * const NEWS_CELL = @"KMDNewsTableViewCell";

@interface KMDCollectionDetailViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView *collectionListTableView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) BOOL isFinish;

@end

@implementation KMDCollectionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pagesLayout];
    [self.collectionListTableView.mj_header beginRefreshing];
    self.isFinish = NO;
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
    
    
    switch (self.type) {
        case kKMDCollectDance:
        {
            KMDDanceListData *data = self.dataArray[indexPath.row];

            KMDDanceVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DANCE_CELL forIndexPath:indexPath];
            
            [cell.danceImageView sd_setImageWithURL:[NSURL URLWithString:data.Poster] placeholderImage:[UIImage imageNamed:@"默认图"]  completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
                if (image) {
                    cell.danceImageView.backgroundColor = [UIColor blackColor];
                }
            }];
            cell.danceTitleLabel.text = data.Name;
            cell.sourceLabel.text = data.AuthorName;
            
            return cell;
        }
            break;
        case kKMDCollectSong:
        {
            KMDDanceListData *data = self.dataArray[indexPath.row];

            KMDSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SONG_CELL forIndexPath:indexPath];
            
            cell.songTitleLabel.text = data.Name;
            cell.contentLabel.text = data.Singer;
            
            return cell;
        }
            break;
        case kKMDCollectNews:
        {
            KMDNewsData *data = self.dataArray[indexPath.row];
            
            KMDNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NEWS_CELL forIndexPath:indexPath];
            
            [cell.newsImageView sd_setImageWithURL:[NSURL URLWithString:data.MainImage] placeholderImage:[UIImage imageNamed:@"默认图"]];
            cell.newsTitleLabel.text = data.Title;
            cell.readTimeLabel.text = [NSString stringWithFormat:@"阅读量：%ld",(long)data.ReadingQuantity];
            
            return cell;
        }
            break;
        case kKMDCollectFollow:
        {
            //关注
            return nil;
        }
            break;
        case kKMDCollectLike:
        {
            //点赞
            return nil;
        }
            break;

    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.type) {
        case kKMDCollectDance:
        {
            KMDDanceListData *data = self.dataArray[indexPath.row];

            KMDVideoViewController *videVC = [[KMDVideoViewController alloc] init];
            videVC.videoID = data.ID;
            videVC.ResourceKey = data.ResourceKey;
            [self.navigationController pushViewController:videVC animated:YES];
        }
            break;
        case kKMDCollectSong:
        {
            KMDSongPlayViewController *songPlayVC = [[KMDSongPlayViewController alloc] init];
            songPlayVC.songArray = self.dataArray;
            songPlayVC.index = indexPath.row;
            songPlayVC.currentPage = self.currentPage;
            songPlayVC.isCollection = YES;
            [self.navigationController pushViewController:songPlayVC animated:YES];
        }
            break;
        case kKMDCollectNews:
        {
            KMDNewsData *data = self.dataArray[indexPath.row];
            BATNewsDetailViewController *newsVC = [[BATNewsDetailViewController alloc] init];
            newsVC.newsID = data.ID;
            newsVC.title = data.Title;
            [self.navigationController pushViewController:newsVC animated:YES];
        }
            break;
        case kKMDCollectFollow:
        {
            
        }
            break;
        case kKMDCollectLike:
        {
            //点赞
        }
            break;
    }

}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {

    NSString *contentStr = @"您还没有收藏任何内容哦，快去看看吧";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: STRING_MID_COLOR};
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contentStr attributes:attributes];
    
    return attrStr;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {

    return [UIImage imageNamed:@"no_collection"];
    
}

#pragma mark - NET
- (void)dataRequest {
    
    switch (self.type) {
        case kKMDCollectDance:
        {
            [HTTPTool requestWithURLString:@"/api/SquareDance/GetCollectDanceList" parameters:nil type:kXMHTTPMethodGET success:^(id responseObject) {
                
                [self.collectionListTableView.mj_header endRefreshing];
                [self.collectionListTableView.mj_footer endRefreshing];
                
                if (self.currentPage == 0) {
                    [self.dataArray removeAllObjects];
                }
                
                KMDDanceListModel *model = [KMDDanceListModel mj_objectWithKeyValues:responseObject];
                [self.dataArray addObjectsFromArray:model.Data];
                [self.collectionListTableView reloadData];
                if (self.dataArray.count >= model.RecordsCount) {
                    [self.collectionListTableView.mj_footer endRefreshingWithNoMoreData];
                }
                
            } failure:^(NSError *error) {
                [self.collectionListTableView.mj_header endRefreshing];
                [self.collectionListTableView.mj_footer endRefreshing];
                
                self.currentPage --;
                if (self.currentPage < 0) {
                    self.currentPage = 0;
                }
            }];
        }
            break;
        case kKMDCollectSong:
        {
            [HTTPTool requestWithURLString:@"/api/SquareDance/GetCollectMusicList" parameters:nil type:kXMHTTPMethodGET success:^(id responseObject) {
                
                [self.collectionListTableView.mj_header endRefreshing];
                [self.collectionListTableView.mj_footer endRefreshing];
                
                if (self.currentPage == 0) {
                    [self.dataArray removeAllObjects];
                }
                
                KMDDanceListModel *model = [KMDDanceListModel mj_objectWithKeyValues:responseObject];
                [self.dataArray addObjectsFromArray:model.Data];
                [self.collectionListTableView reloadData];
                if (self.dataArray.count >= model.RecordsCount) {
                    [self.collectionListTableView.mj_footer endRefreshingWithNoMoreData];
                    self.isFinish = YES;
                }
                
            } failure:^(NSError *error) {
                
            }];
        }
            break;
        case kKMDCollectNews:
        {
            [HTTPTool requestWithURLString:@"/api/SquareDance/GetCollectNewList" parameters:nil type:kXMHTTPMethodGET success:^(id responseObject) {
                
                [self.collectionListTableView.mj_header endRefreshing];
                [self.collectionListTableView.mj_footer endRefreshing];
                
                if (self.currentPage == 0) {
                    [self.dataArray removeAllObjects];
                }
                
                KMDNewsModel *model = [KMDNewsModel mj_objectWithKeyValues:responseObject];
                [self.dataArray addObjectsFromArray:model.Data];
                [self.collectionListTableView reloadData];
                if (self.dataArray.count >= model.RecordsCount) {
                    [self.collectionListTableView.mj_footer endRefreshingWithNoMoreData];
                }
                
            } failure:^(NSError *error) {
                
            }];
        }
            break;
        case kKMDCollectFollow:
        {
            
        }
            break;
        case kKMDCollectLike:
        {
            //点赞
        }
            break;
    }

}

#pragma mark - layout
- (void)pagesLayout {
    
    
    [self.view addSubview:self.collectionListTableView];
    [self.collectionListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

#pragma mark - getter
- (UITableView *)collectionListTableView {
    
    if (!_collectionListTableView) {
        
        _collectionListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _collectionListTableView.showsVerticalScrollIndicator = NO;
        _collectionListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _collectionListTableView.backgroundColor = [UIColor whiteColor];
        if (self.type == kKMDCollectSong) {
            _collectionListTableView.rowHeight = UITableViewAutomaticDimension;
            _collectionListTableView.estimatedRowHeight = 70;
        }
        else{
            _collectionListTableView.rowHeight = 90;
        }
        
        [_collectionListTableView registerClass:[KMDNewsTableViewCell class] forCellReuseIdentifier:NEWS_CELL];
        [_collectionListTableView registerClass:[KMDDanceVideoTableViewCell class] forCellReuseIdentifier:DANCE_CELL];
        [_collectionListTableView registerClass:[KMDSongTableViewCell class] forCellReuseIdentifier:SONG_CELL];

        _collectionListTableView.delegate = self;
        _collectionListTableView.dataSource = self;
        
        _collectionListTableView.emptyDataSetDelegate = self;
        _collectionListTableView.emptyDataSetSource = self;
        
        WEAK_SELF(self);
        _collectionListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            STRONG_SELF(self);
            self.currentPage = 0;
            if (!self.dataArray) {
                self.dataArray = [NSMutableArray array];
            }
            [self dataRequest];
        }];
        
        _collectionListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            STRONG_SELF(self);
            self.currentPage ++;
            [self dataRequest];
        }];
    }
    return _collectionListTableView;
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
