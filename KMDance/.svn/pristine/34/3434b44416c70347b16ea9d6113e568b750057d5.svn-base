//
//  KMDHistoryViewController.m
//  KMDance
//
//  Created by KM on 17/5/232017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDHistoryViewController.h"

#import "KMDDanceVideoTableViewCell.h"

#import "KMDHistoryModel.h"

#import "KMDVideoViewController.h"

static  NSString * const DANCE_CELL = @"KMDDanceVideoTableViewCell";

@interface KMDHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *danceTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger currentPage;

@end

@implementation KMDHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    KMDHistoryData *data = self.dataArray[indexPath.row];
    
    KMDDanceVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DANCE_CELL forIndexPath:indexPath];
    
    [cell.danceImageView sd_setImageWithURL:[NSURL URLWithString:data.Poster] placeholderImage:[UIImage imageNamed:@"默认图"]  completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (image) {
            cell.danceImageView.backgroundColor = [UIColor blackColor];
        }
    }];
    cell.danceTitleLabel.text = data.MusicName;
    cell.sourceLabel.text = data.AuthorName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KMDHistoryData *data = self.dataArray[indexPath.row];

    KMDVideoViewController *videoVC = [[KMDVideoViewController alloc] init];
    videoVC.videoID = data.VideoID;
    videoVC.ResourceKey = data.ResourceKey;
    videoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoVC animated:YES];
}

#pragma mark - NET
- (void)danceDataRequest {
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/GetHistoryRecordList"
                        parameters:nil
                              type:kXMHTTPMethodGET
                           success:^(id responseObject) {
                               
                               [self.danceTableView.mj_header endRefreshing];
                               [self.danceTableView.mj_footer endRefreshing];
                               
                               if (self.currentPage == 0) {
                                   [self.dataArray removeAllObjects];
                               }
                               
                               KMDHistoryModel *model = [KMDHistoryModel mj_objectWithKeyValues:responseObject];
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
    
    self.title = @"观看历史";
    
    [self.view addSubview:self.danceTableView];
    [self.danceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}


#pragma mark - getter
- (UITableView *)danceTableView {
    
    if (!_danceTableView) {
        
        _danceTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _danceTableView.showsVerticalScrollIndicator = NO;
        _danceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _danceTableView.backgroundColor = BASE_BACKGROUND_COLOR;
        _danceTableView.rowHeight = 90;
        
        _danceTableView.tableFooterView = [[UIView alloc] init];
        [_danceTableView registerClass:[KMDDanceVideoTableViewCell class] forCellReuseIdentifier:DANCE_CELL];
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
