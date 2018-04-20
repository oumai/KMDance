//
//  KMDSongViewController.m
//  KMDance
//
//  Created by KM on 17/5/172017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDSongViewController.h"

#import "KMDSongTableViewCell.h"

#import "KMDDanceListModel.h"

#import "KMDSearchViewController.h"
#import "KMDSongPlayViewController.h"

#import "KMDTextField.h"

static  NSString * const SONG_CELL = @"KMDSongTableViewCell";

@interface KMDSongViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) KMDTextField *searchTF;
@property (nonatomic,strong) UITableView *songTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,assign) BOOL isFinish;

@end

@implementation KMDSongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pagesLayout];
    [self.songTableView.mj_header beginRefreshing];
    
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
    
    KMDDanceListData *data = self.dataArray[indexPath.row];
    
    KMDSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SONG_CELL forIndexPath:indexPath];
    
    cell.songTitleLabel.text = data.Name;
    cell.contentLabel.text = data.Singer;
    
    WEAK_SELF(self);
    [cell setPlayBlock:^{
        STRONG_SELF(self);
        KMDSongPlayViewController *songPlayVC = [[KMDSongPlayViewController alloc] init];
        songPlayVC.songArray = self.dataArray;
        songPlayVC.index = indexPath.row;
        songPlayVC.currentPage = self.currentPage;
        songPlayVC.isList = YES;
        songPlayVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:songPlayVC animated:YES];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KMDSongPlayViewController *songPlayVC = [[KMDSongPlayViewController alloc] init];
    songPlayVC.songArray = self.dataArray;
    songPlayVC.index = indexPath.row;
    songPlayVC.currentPage = self.currentPage;
    songPlayVC.isList = YES;
    songPlayVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:songPlayVC animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    //搜索
    KMDSearchViewController *searchVC = [[KMDSearchViewController alloc] init];
    searchVC.searchCategory = kKMDSearchSong;
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    return NO;
}

#pragma mark - NET
- (void)songDataRequest {
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/GetDanceOrMusicList"
                        parameters:@{
                                     @"category":@(kKMDSearchSong),
                                     @"keyword":@"",
                                     @"pageIndex":@(self.currentPage),
                                     @"pageSize":@"10"
                                     }
                              type:kXMHTTPMethodGET
                           success:^(id responseObject) {
                               
                               [self.songTableView.mj_header endRefreshing];
                               [self.songTableView.mj_footer endRefreshing];
                               
                               if (self.currentPage == 0) {
                                   [self.dataArray removeAllObjects];
                               }
                               
                               KMDDanceListModel *model = [KMDDanceListModel mj_objectWithKeyValues:responseObject];
                               [self.dataArray addObjectsFromArray:model.Data];
                               [self.songTableView reloadData];
                               if (self.dataArray.count >= model.RecordsCount) {
                                   [self.songTableView.mj_footer endRefreshingWithNoMoreData];
                                   self.isFinish = YES;
                               }
                           }
                           failure:^(NSError *error) {
                               [self.songTableView.mj_header endRefreshing];
                               [self.songTableView.mj_footer endRefreshing];
                               
                               self.currentPage --;
                               if (self.currentPage < 0) {
                                   self.currentPage = 0;
                               }
                           }];
}

#pragma mark - layout
- (void)pagesLayout {
    
    self.navigationItem.titleView = self.searchTF;
    
    [self.view addSubview:self.songTableView];
    [self.songTableView mas_makeConstraints:^(MASConstraintMaker *make) {
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
- (KMDTextField *)searchTF {
    
    if (!_searchTF) {
        
        _searchTF = [[KMDTextField alloc] init];
        _searchTF.font = [UIFont systemFontOfSize:13];
        _searchTF.textColor = UIColorFromHEX(0x02a9a9, 1);
        _searchTF.borderStyle = UITextBorderStyleNone;
        _searchTF.clearButtonMode = UITextFieldViewModeNever;
        _searchTF.backgroundColor = UIColorFromHEX(0x099090, 0.2);
        _searchTF.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
        if (@available(iOS 11.0, *)) {
            
            _searchTF.intrinsicContentSize = CGSizeMake(SCREEN_WIDTH, 30);
        }

        _searchTF.text = @"舞曲";
        
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

- (UITableView *)songTableView {
    
    if (!_songTableView) {
        
        _songTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _songTableView.showsVerticalScrollIndicator = NO;
        _songTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _songTableView.backgroundColor = BASE_BACKGROUND_COLOR;
        _songTableView.rowHeight = UITableViewAutomaticDimension;
        _songTableView.estimatedRowHeight = 70;
        
        _songTableView.tableFooterView = [[UIView alloc] init];
        [_songTableView registerClass:[KMDSongTableViewCell class] forCellReuseIdentifier:SONG_CELL];
        
        _songTableView.delegate = self;
        _songTableView.dataSource = self;
        
        WEAK_SELF(self);
        _songTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            STRONG_SELF(self);
            self.currentPage = 0;
            if (!self.dataArray) {
                self.dataArray = [NSMutableArray array];
            }
            [self songDataRequest];
        }];
        
        _songTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            STRONG_SELF(self);
            self.currentPage ++;
            [self songDataRequest];
        }];
    }
    return _songTableView;
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
