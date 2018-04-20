//
//  KMDSearchViewController.m
//  KMDance
//
//  Created by KM on 17/5/252017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDSearchViewController.h"

#import "KMDDanceVideoTableViewCell.h"
#import "KMDSongTableViewCell.h"
#import "KMDSearchHotKeyTableViewCell.h"
#import "KMDSearchHistoryTableViewCell.h"
#import "KMDSearchHeaderView.h"

#import "KMDDanceListModel.h"
#import "KMDSearchHotKeyModel.h"

#import "KMDVideoViewController.h"
#import "KMDSongPlayViewController.h"

#import "UIScrollView+EmptyDataSet.h"

#import "KMDTextField.h"

static  NSString * const VIDEO_CELL = @"KMDDanceVideoTableViewCell.h";
static  NSString * const SONG_CELL = @"KMDSongTableViewCell.h";
static  NSString * const HOT_KEY_CELL = @"KMDSearchHotKeyTableViewCell.h";
static  NSString * const HISTORY_CELL = @"KMDSearchHistoryTableViewCell.h";

static  NSString * const SEARCH_HISTORY = @"SEARCH_HISTORY";

@interface KMDSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView *searchTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong) KMDSearchHotKeyModel *hotKeyModel;

@property (nonatomic,copy) NSString *currentKey;

@property (nonatomic,strong) KMDTextField *searchTF;

/**
 歌曲列表用，是否已经取完
 */
@property (nonatomic,assign) BOOL isFinish;

@end

@implementation KMDSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isFinish = NO;
    self.dataArray = [NSMutableArray array];
    
    [self layoutPasges];
    
    [self hotKeyRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.currentKey.length > 0) {
        return 1;
    }
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //有搜索结果
    if (self.currentKey.length > 0) {
        return self.dataArray.count;
    }
    
    //无结果
    if (section == 0) {
        //热词
        return 1;
    }
    else {
        //历史记录
        NSArray * historyArray = [[NSUserDefaults standardUserDefaults] valueForKey:SEARCH_HISTORY];
        if (!historyArray) {
            
            historyArray = [NSArray array];
        }
        return historyArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.currentKey.length > 0) {
        //有搜索结果
        
        switch (self.searchCategory) {
            case kKMDSearchAll:
            {
                return nil;
            }
                break;
            case kKMDSearchSong:
            {
                KMDDanceListData *data = self.dataArray[indexPath.row];
                
                KMDSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SONG_CELL forIndexPath:indexPath];
                
                cell.songTitleLabel.text = data.Name;
                cell.contentLabel.text = data.Singer;
                
                return cell;
            }
                break;
            case kKMDSearchDance:
            {
                KMDDanceListData *data = self.dataArray[indexPath.row];
                
                KMDDanceVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VIDEO_CELL forIndexPath:indexPath];
                
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
        }
        

    }
    
    //没有开始搜搜
    
    if (indexPath.section == 0) {
        //热门词
        
        KMDSearchHotKeyTableViewCell *hotKeyCell = [tableView dequeueReusableCellWithIdentifier:HOT_KEY_CELL forIndexPath:indexPath];
        
        hotKeyCell.dataArray = self.hotKeyModel.Data;
//        [hotKeyCell.hotKeyCollectionView reloadData];
        WEAK_SELF(self);
        [hotKeyCell setHotKeyClick:^(NSString *keyword){
            STRONG_SELF(self);
            [self searchResultRequest:keyword];
            self.searchTF.text = keyword;
        }];
        return hotKeyCell;
        
    }
    else {
        //历史词
        NSArray * historyArray = [[NSUserDefaults standardUserDefaults] valueForKey:SEARCH_HISTORY];

        KMDSearchHistoryTableViewCell *historyCell = [tableView dequeueReusableCellWithIdentifier:HISTORY_CELL forIndexPath:indexPath];
        
        historyCell.nameLabel.text = historyArray[indexPath.row];
        
        return historyCell;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.currentKey.length > 0) {
        
        return nil;
    }
    
    KMDSearchHeaderView *headerView = [[KMDSearchHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    switch (section) {
        case 0:
            headerView.nameLabel.text = @"附近的人都在搜索";
            headerView.leftImageView.image = [UIImage imageNamed:@"search_nearby_icon"];
            break;
        case 1:
            headerView.nameLabel.text = @"历史记录";
            headerView.leftImageView.image = [UIImage imageNamed:@"search_history_icon"];
            break;
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.currentKey.length > 0) {
        
        return 0;
    }
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 1) {
        return 45;
    }
    
    return 90;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.currentKey.length > 0 && self.dataArray.count > 0) {
        
        switch (self.searchCategory) {
            case kKMDSearchAll:
            {
                
            }
                break;
            case kKMDSearchDance:
            {
                KMDDanceListData *data = self.dataArray[indexPath.row];
                
                KMDVideoViewController *videoVC = [[KMDVideoViewController alloc] init];
                videoVC.videoID = data.ID;
                videoVC.ResourceKey = data.ResourceKey;
                videoVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:videoVC animated:YES];
            }
                break;
            case kKMDSearchSong:
            {
                KMDSongPlayViewController *songPlayVC = [[KMDSongPlayViewController alloc] init];
                songPlayVC.songArray = self.dataArray;
                songPlayVC.index = indexPath.row;
                songPlayVC.currentPage = self.currentPage;
                songPlayVC.isSearch = YES;
                songPlayVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:songPlayVC animated:YES];
            }
                break;
        }
    }
    
    
    
    if (indexPath.section == 1) {
        
        NSArray * historyArray = [[NSUserDefaults standardUserDefaults] valueForKey:SEARCH_HISTORY];
        
        [self searchResultRequest:historyArray[indexPath.row]];
        
        self.searchTF.text = historyArray[indexPath.row];
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text.length == 0) {
        return NO;
    }
    
    [self searchResultRequest:textField.text];
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    self.currentKey = @"";
    [self.dataArray removeAllObjects];
    [textField resignFirstResponder];

    [self.searchTableView reloadData];
    
    [self.searchTableView.mj_footer endRefreshingWithNoMoreData];
    
    return YES;
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *contentStr = [NSString stringWithFormat:@"没有搜到“%@”相关内容\n建议您尝试其他相关词",self.currentKey];
    
    NSRange range = [contentStr rangeOfString:self.currentKey];
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: STRING_MID_COLOR};
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contentStr attributes:attributes];
    
    
    [attrStr setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName: [UIFont systemFontOfSize:16.0f]} range:range];
    

    return attrStr;
}


#pragma mark - private
- (void)saveHistoryWithKey:(NSString *)key {
    
    NSArray * historyArray = [[NSUserDefaults standardUserDefaults] valueForKey:SEARCH_HISTORY];
    if (!historyArray) {
        
        historyArray = [NSArray array];
    }
    NSMutableArray * array = [NSMutableArray arrayWithArray:historyArray];
    if (array.count > 5) {
        
        [array removeLastObject];
    }
    if ([array containsObject:key]) {
        [array removeObject:key];
    }
    [array insertObject:key atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:SEARCH_HISTORY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - NET
- (void)hotKeyRequest {
    
    NSDictionary *dic = @{};
    switch (self.searchCategory) {
        case kKMDSearchAll:
        {
            
        }
            break;
        case kKMDSearchSong:
        {
            dic = @{@"Category":@"3"};
        }
            break;
        case kKMDSearchDance:
        {
            dic = @{@"Category":@"2"};
        }
            break;
    }
    [HTTPTool requestWithLoginURLString:@"api/Search/GetHotKeywords" parameters:dic type:kXMHTTPMethodGET success:^(id responseObject) {
        
        self.hotKeyModel = [KMDSearchHotKeyModel mj_objectWithKeyValues:responseObject];
        
        [self.searchTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)searchResultRequest:(NSString *)key {
    
    self.currentKey = key;
    
    [self saveHistoryWithKey:key];
    [self.searchTF resignFirstResponder];
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/GetDanceOrMusicList"
                        parameters:@{
                                     @"category":@(self.searchCategory),
                                     @"keyword":key,
                                     @"pageIndex":@(self.currentPage),
                                     @"pageSize":@"10"
                                     }
                              type:kXMHTTPMethodGET
                           success:^(id responseObject) {
                               
                               [self.searchTableView.mj_header endRefreshing];
                               [self.searchTableView.mj_footer endRefreshing];
                               
                               KMDDanceListModel *model = [KMDDanceListModel mj_objectWithKeyValues:responseObject];
                               
                               if (self.currentPage == 0) {
                                   [self.dataArray removeAllObjects];
                               }
                               
                               [self.dataArray addObjectsFromArray:model.Data];
                               [self.searchTableView reloadData];
                    
                               if (self.dataArray.count >= model.RecordsCount) {
                                   [self.searchTableView.mj_footer endRefreshingWithNoMoreData];
                                   self.isFinish = YES;
                               }
                           }
                           failure:^(NSError *error) {
                               
                               [self.searchTableView reloadData];
                           }];
}

#pragma mark - layout
- (void)layoutPasges {
    
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.titleView = self.searchTF;
    
    
    WEAK_SELF(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStylePlain handler:^(id sender) {
        STRONG_SELF(self);
        if (self.searchTF.text.length > 0) {
            self.currentKey = @"";
            self.searchTF.text = @"";
            [self.dataArray removeAllObjects];
            [self.searchTF resignFirstResponder];
            
            [self.searchTableView reloadData];
            return ;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.view addSubview:self.searchTableView];
    [self.searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [self.searchTableView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - getter
- (UITableView *)searchTableView {
    
    if (!_searchTableView) {
        
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _searchTableView.showsVerticalScrollIndicator = NO;
        _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchTableView.backgroundColor = BASE_BACKGROUND_COLOR;
        
        _searchTableView.tableFooterView = [[UIView alloc] init];
        
        [_searchTableView registerClass:[KMDDanceVideoTableViewCell class] forCellReuseIdentifier:VIDEO_CELL];
        [_searchTableView registerClass:[KMDSongTableViewCell class] forCellReuseIdentifier:SONG_CELL];
        [_searchTableView registerClass:[KMDSearchHotKeyTableViewCell class] forCellReuseIdentifier:HOT_KEY_CELL];
        [_searchTableView registerClass:[KMDSearchHistoryTableViewCell class] forCellReuseIdentifier:HISTORY_CELL];

        
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        
        _searchTableView.emptyDataSetDelegate = self;
        _searchTableView.emptyDataSetSource = self;
        
        WEAK_SELF(self);
        _searchTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            STRONG_SELF(self);
            self.currentPage = 0;
            if (!self.dataArray) {
                self.dataArray = [NSMutableArray array];
            }
            if (self.currentKey.length > 0) {
                [self searchResultRequest:self.currentKey];
            }else{
                [self.searchTableView.mj_header endRefreshing];
            }
        }];
        
        _searchTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            STRONG_SELF(self);
            self.currentPage ++;
            if (self.currentKey.length > 0) {
                [self searchResultRequest:self.currentKey];
            }
        }];
        
    }
    return _searchTableView;
}

- (KMDTextField *)searchTF {
    
    if (!_searchTF) {
        
        _searchTF = [[KMDTextField alloc] init];
        _searchTF.font = [UIFont systemFontOfSize:13];
        _searchTF.textColor = UIColorFromHEX(0x02a9a9, 1);
        _searchTF.borderStyle = UITextBorderStyleNone;
        _searchTF.clearButtonMode = UITextFieldViewModeNever;
        _searchTF.backgroundColor = UIColorFromHEX(0x099090, 0.2);
        [_searchTF setTintColor:UIColorFromHEX(0x02a9a9, 1)];
        _searchTF.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
        if (@available(iOS 11.0, *)) {
            
            _searchTF.intrinsicContentSize = CGSizeMake(SCREEN_WIDTH, 30);
        }

        _searchTF.clearButtonMode = UITextFieldViewModeAlways;
        _searchTF.returnKeyType = UIReturnKeySearch;
        UIColor *color = UIColorFromHEX(0x02a9a9, 1);
   
        switch (self.searchCategory) {
            case kKMDSearchAll:
            {
                
            }
                break;
            case kKMDSearchSong:
            {
                _searchTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"舞曲" attributes:@{NSForegroundColorAttributeName: color}];
            }
                break;
            case kKMDSearchDance:
            {
                _searchTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"舞蹈" attributes:@{NSForegroundColorAttributeName: color}];
            }
                break;
        }
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
        
        WEAK_SELF(self);
        [_searchTF bk_addEventHandler:^(UITextField *tf) {
            STRONG_SELF(self);
            
            if (tf.text == nil || tf.text.length == 0) {
                self.currentKey = @"";
                [self.dataArray removeAllObjects];
                [self.searchTableView reloadData];
                [self.searchTableView.mj_footer endRefreshingWithNoMoreData];
            }
        } forControlEvents:UIControlEventEditingChanged];
    }
    return _searchTF;
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
