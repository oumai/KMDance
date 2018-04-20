//
//  KMDNewsViewController.m
//  KMDance
//
//  Created by KM on 17/5/172017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDNewsViewController.h"

#import "KMDNewsTableViewCell.h"

#import "KMDNewsModel.h"

#import "BATNewsDetailViewController.h"

static  NSString * const NEWS_CELL = @"KMDNewsTableViewCell";

@interface KMDNewsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *newsTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger currentPage;

@end

@implementation KMDNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pagesLayout];
    [self.newsTableView.mj_header beginRefreshing];
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
    
    KMDNewsData *data = self.dataArray[indexPath.row];
    
    KMDNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NEWS_CELL forIndexPath:indexPath];
    
    [cell.newsImageView sd_setImageWithURL:[NSURL URLWithString:data.MainImage] placeholderImage:[UIImage imageNamed:@"默认图"]];
    cell.newsTitleLabel.text = data.Title;
    cell.readTimeLabel.text = [NSString stringWithFormat:@"阅读量：%ld",(long)data.ReadingQuantity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KMDNewsData *data = self.dataArray[indexPath.row];
    BATNewsDetailViewController *detailVC = [[BATNewsDetailViewController alloc] init];
    detailVC.newsID = data.ID;
    detailVC.title = data.Title;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [self addReadingQuantityRequestWithNewID:data.ID];
    data.ReadingQuantity ++;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - NET
- (void)newsDataRequest {
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/GetSquareNewList" parameters:@{@"keyword":@"",@"pageIndex":@(self.currentPage),@"pageSize":@"10"} type:kXMHTTPMethodGET success:^(id responseObject) {
        
        [self.newsTableView.mj_header endRefreshing];
        [self.newsTableView.mj_footer endRefreshing];
        
        if (self.currentPage == 0) {
            [self.dataArray removeAllObjects];
        }
        
        KMDNewsModel *model = [KMDNewsModel mj_objectWithKeyValues:responseObject];
        [self.dataArray addObjectsFromArray:model.Data];
        [self.newsTableView reloadData];
        if (self.dataArray.count >= model.RecordsCount) {
            [self.newsTableView.mj_footer endRefreshingWithNoMoreData];
        }

    } failure:^(NSError *error) {
        [self.newsTableView.mj_header endRefreshing];
        [self.newsTableView.mj_footer endRefreshing];
        
        self.currentPage --;
        if (self.currentPage < 0) {
            self.currentPage = 0;
        }
    }];
}

//阅读量
- (void)addReadingQuantityRequestWithNewID:(NSString *)newID {

    [HTTPTool requestWithLoginURLString:[NSString stringWithFormat:@"/api/News/UpdateReadingQuantity?id=%@",newID] parameters:nil type:kXMHTTPMethodGET success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - layout
- (void)pagesLayout {
    
    self.navigationItem.title = @"资讯";
    
    [self.view addSubview:self.newsTableView];
    [self.newsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
        if (@available(iOS 11.0,*)) {
            if (iPhoneX) {
                make.bottom.equalTo(@(-83+49));
            }
            else {
                make.bottom.equalTo(@-20);
            }
        }
    }];
}

#pragma mark - getter
- (UITableView *)newsTableView {
    
    if (!_newsTableView) {
        
        _newsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _newsTableView.showsVerticalScrollIndicator = NO;
        _newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _newsTableView.backgroundColor = BASE_BACKGROUND_COLOR;
        _newsTableView.rowHeight = 90;

        [_newsTableView registerClass:[KMDNewsTableViewCell class] forCellReuseIdentifier:NEWS_CELL];
        
        _newsTableView.delegate = self;
        _newsTableView.dataSource = self;
        
        WEAK_SELF(self);
        _newsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            STRONG_SELF(self);
            self.currentPage = 0;
            if (!self.dataArray) {
                self.dataArray = [NSMutableArray array];
            }
            [self newsDataRequest];
        }];
        
        _newsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            STRONG_SELF(self);
            self.currentPage ++;
            [self newsDataRequest];
        }];
    }
    return _newsTableView;
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
