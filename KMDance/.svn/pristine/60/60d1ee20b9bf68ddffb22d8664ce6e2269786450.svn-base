//
//  KMDUploadedViewController.m
//  KMDance
//
//  Created by KM on 17/8/42017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDUploadedViewController.h"

#import "KMDDanceVideoTableViewCell.h"

#import "KMDDanceListModel.h"

#import "KMDVideoViewController.h"

#import "UIScrollView+EmptyDataSet.h"

static  NSString * const DANCE_VIDEO_CELL = @"KMDDanceVideoTableViewCell";

@interface KMDUploadedViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView *uploadedTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger currentPage;

@end

@implementation KMDUploadedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pagesLayout];
    [self.uploadedTableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KMDDanceListData *data = self.dataArray[indexPath.row];
    
    KMDDanceVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DANCE_VIDEO_CELL forIndexPath:indexPath];
    
    [cell.danceImageView sd_setImageWithURL:[NSURL URLWithString:data.Poster] placeholderImage:[UIImage imageNamed:@"默认图"]  completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (image) {
            cell.danceImageView.backgroundColor = [UIColor blackColor];
        }
    }];
    cell.danceTitleLabel.text = data.Name;
    cell.sourceLabel.text = data.AuthorName;
    
    switch (data.StatusFlag) {
        case KMDStatusFlagTypeWaiting:
        {
            cell.statusLabel.text = @"等待审核";
        }
            break;
        case KMDStatusFlagTypeSuccess:
        {
            cell.statusLabel.text = @"已上架";
        }
            break;
        case KMDStatusFlagTypeFailure:
        {
            cell.statusLabel.text = @"已拒绝";
        }
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KMDDanceListData *data = self.dataArray[indexPath.row];
    
    KMDVideoViewController *videoVC = [[KMDVideoViewController alloc] init];
    videoVC.videoID = data.ID;
    videoVC.ResourceKey = data.ResourceKey;
    videoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoVC animated:YES];
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *contentStr = @"您还没有上传任何内容哦，快去看看吧";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: STRING_MID_COLOR};
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contentStr attributes:attributes];
    
    return attrStr;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"no_collection"];
}

#pragma mark - NET
- (void)uploadedDanceRequest {
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/GetDanceOrMusicStatusFlag" parameters:@{@"pageIndex":@(self.currentPage),@"pageSize":@"10"} type:kXMHTTPMethodGET success:^(id responseObject) {
        
        [self.uploadedTableView.mj_header endRefreshing];
        [self.uploadedTableView.mj_footer endRefreshing];
        
        if (self.currentPage == 0) {
            [self.dataArray removeAllObjects];
        }
        
        KMDDanceListModel *model = [KMDDanceListModel mj_objectWithKeyValues:responseObject];
        [self.dataArray addObjectsFromArray:model.Data];
        [self.uploadedTableView reloadData];
        if (self.dataArray.count >= model.RecordsCount) {
            [self.uploadedTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError *error) {
        
        [self.uploadedTableView.mj_header endRefreshing];
        [self.uploadedTableView.mj_footer endRefreshing];
        
        self.currentPage --;
        if (self.currentPage < 0) {
            self.currentPage = 0;
        }
    }];
}

#pragma mark - layout
- (void)pagesLayout {
    
    [self.view addSubview:self.uploadedTableView];
    [self.uploadedTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

#pragma mark - getter
- (UITableView *)uploadedTableView {
    
    if (!_uploadedTableView) {
        
        _uploadedTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _uploadedTableView.showsVerticalScrollIndicator = NO;
        _uploadedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _uploadedTableView.backgroundColor = [UIColor whiteColor];
        _uploadedTableView.rowHeight = 90;
        
        [_uploadedTableView registerClass:[KMDDanceVideoTableViewCell class] forCellReuseIdentifier:DANCE_VIDEO_CELL];
        
        _uploadedTableView.delegate = self;
        _uploadedTableView.dataSource = self;
        
        _uploadedTableView.emptyDataSetDelegate = self;
        _uploadedTableView.emptyDataSetSource = self;
        
        WEAK_SELF(self);
        _uploadedTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            STRONG_SELF(self);
            self.currentPage = 0;
            if (!self.dataArray) {
                self.dataArray = [NSMutableArray array];
            }
            [self uploadedDanceRequest];
        }];
        
        _uploadedTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            STRONG_SELF(self);
            self.currentPage ++;
            [self uploadedDanceRequest];
        }];
    }
    return _uploadedTableView;
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
