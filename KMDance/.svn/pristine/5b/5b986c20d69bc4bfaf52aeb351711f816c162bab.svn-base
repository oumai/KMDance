//
//  KMDDanceThemeViewController.m
//  KMDance
//
//  Created by KM on 17/6/222017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDDanceThemeViewController.h"

#import "KMDDanceThemeTableViewCell.h"

#import "KMDDanceThemeModel.h"

#import "KMDVideoViewController.h"

#import "UIScrollView+EmptyDataSet.h"

static  NSString * const DANCE_THEME_CELL = @"KMDDanceThemeTableViewCell.h";

@interface KMDDanceThemeViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView *danceThemeTableView;
@property (nonatomic,strong) UIImageView *topImageView;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,assign) BOOL isRequestFinish;

@end

@implementation KMDDanceThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pagesLayout];
    
    self.isRequestFinish = NO;
    self.currentPage = 0;
    self.dataArray = [NSMutableArray array];
    
    [self.danceThemeTableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KMDDanceThemeData *data = self.dataArray[indexPath.section];
    
    KMDDanceThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DANCE_THEME_CELL forIndexPath:indexPath];
    
    cell.titleLabel.text = data.Name;
    cell.desLabel.text =  data.Remark;
    cell.dataArray = data.ZoneMusicList;
    
    if (!data.multiple || data.multiple==0) {
        cell.multiple = 1;
        data.multiple = 1;
    }
    else {
        cell.multiple = data.multiple;
    }

    [cell.videoCollectionView reloadData];

    WEAK_SELF(self);
    [cell setVideoClicked:^(NSString *videoID){
        
        if (!LOGIN_STATION) {
            PRESENT_LOGIN_VC;
            return ;
        }
        
        STRONG_SELF(self);
        KMDVideoViewController *videoVC = [[KMDVideoViewController alloc] init];
        videoVC.videoID = videoID;
        [self.navigationController pushViewController:videoVC animated:YES];
    }];

    WEAK_SELF(cell);
    WEAK_SELF(data);
    [cell setExpandClicked:^{
        STRONG_SELF(self);
        STRONG_SELF(cell);
        STRONG_SELF(data);
        data.multiple ++;
        cell.multiple = data.multiple;
//        [cell.videoCollectionView reloadData];
        [self.danceThemeTableView reloadData];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    header.backgroundColor = BASE_BACKGROUND_COLOR;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *contentStr = @"敬请期待";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:29.0f],
                                 NSForegroundColorAttributeName: STRING_LIGHT_COLOR};
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contentStr attributes:attributes];
    
    if (self.isRequestFinish == NO) {
        
        return [[NSAttributedString alloc] initWithString:@""];
    }
    
    return attrStr;
}


#pragma mark - net
- (void)danceThemeDataRequest {
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/GetSquareZoneList" parameters:@{@"zoneType":@(self.type),@"pageIndex":@(self.currentPage),@"pageSize":@"10"} type:kXMHTTPMethodGET success:^(id responseObject) {
        self.isRequestFinish = YES;

        [self.danceThemeTableView.mj_header endRefreshing];
        [self.danceThemeTableView.mj_footer endRefreshing];
        
        if (self.currentPage == 0) {
            [self.dataArray removeAllObjects];
        }
        
        KMDDanceThemeModel *model = [KMDDanceThemeModel mj_objectWithKeyValues:responseObject];
        [self.dataArray addObjectsFromArray:model.Data];
        
        if (self.dataArray.count >= model.RecordsCount) {
            [self.danceThemeTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.danceThemeTableView reloadData];
        

    } failure:^(NSError *error) {
        self.isRequestFinish = YES;

        [self.danceThemeTableView.mj_header endRefreshing];
        [self.danceThemeTableView.mj_footer endRefreshing];
        
        self.currentPage --;
        if (self.currentPage < 0) {
            self.currentPage = 0;
        }

    }];
}

#pragma mark - layout
- (void)pagesLayout {
    
    [self.view addSubview:self.danceThemeTableView];
    [self.danceThemeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

#pragma mark - getter
- (UITableView *)danceThemeTableView {
    
    if (!_danceThemeTableView) {
        
        _danceThemeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        
        _danceThemeTableView.showsVerticalScrollIndicator = NO;
        _danceThemeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _danceThemeTableView.backgroundColor = BASE_BACKGROUND_COLOR;
        
        _danceThemeTableView.rowHeight = UITableViewAutomaticDimension;
        _danceThemeTableView.estimatedRowHeight = 300;
        
        _danceThemeTableView.tableHeaderView = self.topImageView;
        _danceThemeTableView.tableFooterView = [[UIView alloc] init];
        [_danceThemeTableView registerClass:[KMDDanceThemeTableViewCell class] forCellReuseIdentifier:DANCE_THEME_CELL];
        
        _danceThemeTableView.delegate = self;
        _danceThemeTableView.dataSource = self;
        
        _danceThemeTableView.emptyDataSetDelegate = self;
        _danceThemeTableView.emptyDataSetSource = self;
        
        WEAK_SELF(self);
        _danceThemeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            STRONG_SELF(self);
            self.currentPage = 0;
            [self danceThemeDataRequest];
        }];
        
        _danceThemeTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            STRONG_SELF(self);
            self.currentPage ++;
            [self danceThemeDataRequest];
        }];
    }
    return _danceThemeTableView;
}

- (UIImageView *)topImageView {
    
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*380/750.0)];
        switch (self.type) {
            case kKMDLast:
            {
                _topImageView.image = [UIImage imageNamed:@"广场舞-往期"];
            }
                break;
            case kKMDNow:
            {
                _topImageView.image = [UIImage imageNamed:@"广场舞-本期"];
            }
                break;
        }
    }
    return _topImageView;
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
