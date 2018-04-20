//
//  KMDVideoViewController.m
//  KMDance
//
//  Created by KM on 17/5/262017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDVideoViewController.h"

#import "KMDVIdeoPlayHeaderView.h"
#import "BATCourseCommentTableViewCell.h"
#import "BATSendCommentView.h"
#import "BATCourseDetailBottomView.h"
#import "KMDShareView.h"

#import "KMDVideoDetailModel.h"
#import "KMDEncodingModel.h"

#import "UINavigationController+FDFullscreenPopGesture.h"

#import "KMDDownloadTool.h"

static  NSString * const COMMENT_CELL = @"BATCourseCommentTableViewCell.h";

@interface KMDVideoViewController ()<UITableViewDelegate,UITableViewDataSource,YYTextViewDelegate,ZFPlayerDelegate>

@property (nonatomic,strong) UITableView *videoTableView;
@property (nonatomic,strong) KMDVIdeoPlayHeaderView *headerView;

//评论相关
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,strong) NSMutableArray *dataSource;
//输入框
@property (nonatomic,strong) BATSendCommentView *sendCommentView;
@property (nonatomic,strong) BATCourseDetailBottomView *courseDetailBottomView;

@property (nonatomic,assign) NSInteger resultCount;

@property (nonatomic,copy) NSString *parentId;
@property (nonatomic,copy) NSString *parentLevelId;

@property (nonatomic,strong) KMDShareView *shareView;

@property (nonatomic,strong) KMDVideoDetailModel *videoModel;

@end

@implementation KMDVideoViewController
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogDebug(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [TalkingData trackEvent:@"观看视频"];
    
    _dataSource = [NSMutableArray array];
    
    self.parentId = @"";
    self.parentLevelId = @"";
    
    [self layoutPages];

    [self videoDetailRequest];
    if (LOGIN_STATION) {
        [self isCollectionInfoRequest];
    }
    [self courseCommentListRequest];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillAppear:(BOOL)animated {
//    
//    [super viewWillAppear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    
//    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self.headerView.playerView pause];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATCourseCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:COMMENT_CELL forIndexPath:indexPath];

    cell.indexPath = indexPath;
    
    
    [cell configData:_dataSource[indexPath.row]];
    
    WEAK_SELF(self);
    WEAK_SELF(cell);
    
    [cell bk_whenTapped:^{
        STRONG_SELF(self);
        [self.view endEditing:YES];
    }];
    
    cell.likeAction = ^(NSIndexPath *cellIndexPath) {
        //点赞

        STRONG_SELF(cell);
        STRONG_SELF(self);
        if (!LOGIN_STATION) {
            PRESENT_LOGIN_VC;
            return;
        }
        BATCourseCommentData *data = self.dataSource[indexPath.row];

        if (cell.likeButton.selected == YES) {
            //取消
            [self commentCancelLikeRequest:data.ID];
            
            cell.likeCountLabel.text = [NSString stringWithFormat:@"%d",[cell.likeCountLabel.text intValue]-1];

        }
        else {
            //点赞
            [self commentLikeRequest:data.ID];
            cell.likeCountLabel.text = [NSString stringWithFormat:@"%d",[cell.likeCountLabel.text intValue]+1];
        }
        
        cell.likeButton.selected = !cell.likeButton.selected;
    };
    
    cell.commentAction = ^(NSIndexPath *cellIndexPath) {
        
        //点评论按钮
        STRONG_SELF(self);
        if (!LOGIN_STATION) {
            PRESENT_LOGIN_VC;
            return;
        }
        
        BATCourseCommentData *data = self.dataSource[indexPath.row];
        self.parentId = data.ID;
        self.parentLevelId = data.ID;
        
        self.sendCommentView.commentTextView.placeholderText = [NSString stringWithFormat:@"回复%@ ",data.UserName];
        [self.sendCommentView.commentTextView becomeFirstResponder];
        
    };
    
    cell.replyTableView.replyCommentAction = ^(NSIndexPath *commentIndexPath,BATCourseCommentData *comment,NSString *parentLevelId) {
        
        //回复评论
        STRONG_SELF(self);
        
        if (!LOGIN_STATION) {
            PRESENT_LOGIN_VC;
            return;
        }
        
        self.parentId = comment.ID;
        self.parentLevelId = parentLevelId;
        
        self.sendCommentView.commentTextView.placeholderText = [NSString stringWithFormat:@"回复%@ ",comment.UserName];
        [self.sendCommentView.commentTextView becomeFirstResponder];
    };
    

    return cell;

}

#pragma mark - YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView {
    
    if (textView.text.length > 0) {
        self.sendCommentView.sendCommentButton.enabled = YES;
        self.sendCommentView.sendCommentButton.backgroundColor = BASE_COLOR;
    }
    if (textView.text.length == 0) {
        self.sendCommentView.sendCommentButton.enabled = NO;
        self.sendCommentView.sendCommentButton.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)zf_playerBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - action
- (void)keyboardWillShow:(NSNotification *)notif {
    
    CGRect keyboardFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    double duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSInteger animation = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    WEAK_SELF(self);
    [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
        STRONG_SELF(self);
        self.sendCommentView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, -keyboardFrame.size.height-self.sendCommentView.bounds.size.height);
        
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    self.parentId = @"";
    self.parentLevelId = @"0";
    
    double duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSInteger animation = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    WEAK_SELF(self);

    [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
        STRONG_SELF(self);
        self.sendCommentView.transform = CGAffineTransformIdentity;
        
    } completion:nil];
}

#pragma mark - private
- (void)downloadVideo {
    
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    
    if (!self.videoModel.Data.Url) {
        
        [self showErrorWithText:@"无法下载"];
        return;
    }
    
    NSString *fileName = [[self.videoModel.Data.Url componentsSeparatedByString:@"/"] lastObject];

    NSString *filePath = [KMDDownloadTool_DownloadDataDocument_Path_Video stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO) {
        
        [[KMDDownloadTool shareInstance] addDownloadTast:self.videoModel.Data.Url andOffLine:YES mediaType:KMDDownloadTypeDance];
        
        [[KMDDownloadTool shareInstance] saveDownloadInfoWithDic:@{@"fileName":fileName,@"Name":self.videoModel.Data.Name,@"Poster":self.videoModel.Data.Poster,@"Singer":self.videoModel.Data.Singer,@"AuthorName":self.videoModel.Data.AuthorName,@"Url":self.videoModel.Data.Url,@"ID":self.videoModel.Data.ID} mediaType:KMDDownloadTypeDance];
        
        [self showSuccessWithText:@"已添加，请到“我的下载”查看"];

    }
    else {
        
        [self showSuccessWithText:@"已添加，请到“我的下载”查看"];
    }
}

#pragma mark - NET
- (void)getVideoInfoWithModel:(ZFPlayerModel *)model {
    
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        
        request.url = @"http://media-manage.jkbat.com/Video/Info";
        request.httpMethod = kXMHTTPMethodGET;
        request.parameters = @{@"key":self.ResourceKey,};
    } onSuccess:^(id  _Nullable responseObject) {
        
        KMDEncodingModel *encodingModel = [KMDEncodingModel mj_objectWithKeyValues:responseObject];
        
        DDLogDebug(@"%@+++",encodingModel.Encoding);
        
        if (encodingModel.Encoding.length > 0) {
            
            model.videoURL = [NSURL URLWithString:[encodingModel.Url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            self.videoModel.Data.Url = encodingModel.Url;
            
            [self updatePlayCountRequest];
            [self insertPlayHistoryRequest];
            
            [self.headerView.playerView playerControlView:nil playerModel:model];
            [self.headerView.playerView autoPlayTheVideo];
        }
        else {
            
            model.videoURL = nil;
            self.videoModel.Data.Url = nil;
            [self.headerView.playerView playerControlView:nil playerModel:model];
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"视频转码中，请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
                [self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }

    } onFailure:^(NSError * _Nullable error) {
        
    }];
}

- (void)videoDetailRequest {
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/GetDanceDetail" parameters:@{@"ID":self.videoID} type:kXMHTTPMethodGET success:^(id responseObject) {
        
        KMDVideoDetailModel *videoModel = [KMDVideoDetailModel mj_objectWithKeyValues:responseObject];
        
        self.title = videoModel.Data.Name;
        
        self.headerView.titleLabel.text = videoModel.Data.Name;
        self.headerView.readCountLabel.text = [NSString stringWithFormat:@"%ld 播放",(long)videoModel.Data.PlayCount];
        [self.headerView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.Data.userPhoto] placeholderImage:[UIImage imageNamed:@"默认图"]];
        self.headerView.nameLabel.text = videoModel.Data.AuthorName;
        
        
        ZFPlayerModel *model = [[ZFPlayerModel alloc] init];
        model.fatherView = self.headerView.backView;
        model.title = videoModel.Data.Name;
        model.videoURL =  [NSURL URLWithString:[videoModel.Data.Url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        model.placeholderImageURLString = videoModel.Data.Poster;
        
        self.videoModel = videoModel;
        
        if (self.ResourceKey.length > 0) {
            
            //resourceKey有值，需要转码的视频，判断是否转码完成
            [self getVideoInfoWithModel:model];
            
            return ;
        }
        
        [self updatePlayCountRequest];
        [self insertPlayHistoryRequest];
        
        [self.headerView.playerView playerControlView:nil playerModel:model];
        [self.headerView.playerView autoPlayTheVideo];
        
        

        
    } failure:^(NSError *error) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"网络异常，请检查网络" message:@"" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:deleteAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

-(void)updatePlayCountRequest {
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/UpdatePlayCount" parameters:@{@"ID":self.videoID} type:kXMHTTPMethodPOST success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)insertPlayHistoryRequest {
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/InsertHistoryRecord" parameters:@{@"VideoID":self.videoID,@"PlayRecording":@"00:00"} type:kXMHTTPMethodPOST success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)isCollectionInfoRequest {
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/IsCollect" parameters:@{@"RelationType":@(kKMDCollectDance),@"RelationId":self.videoID} type:kXMHTTPMethodGET success:^(id responseObject) {
        
        NSString *isCollectionString = [NSString stringWithFormat:@"%@",responseObject[@"Data"][@"IsCollect"]];
        if ([isCollectionString isEqualToString:@"0"]) {
            
            DDLogDebug(@"没有收藏");
            
            self.headerView.collectionBtn.selected = NO;
        }else {
            DDLogDebug(@"已经收藏");
            
            self.headerView.collectionBtn.selected = YES;
        }
    } failure:^(NSError *error) {
        
    }];
}

//收藏舞蹈
-(void)addCollection {
    
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/AddCollectDance" parameters:@{@"OBJ_ID":self.videoID,@"OBJ_TYPE":@(kKMDCollectDance)} type:kXMHTTPMethodPOST success:^(id responseObject) {
        [self showSuccessWithText:@"收藏成功"];
        self.headerView.collectionBtn.selected = YES;

    } failure:^(NSError *error) {
        [self showErrorWithText:@"收藏失败"];
        self.headerView.collectionBtn.selected = NO;

    }];
}
//取消收藏舞蹈
-(void)cancleCollection {
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/CanelCollectDance" parameters:@{@"OBJ_ID":self.videoID,@"OBJ_TYPE":@(kKMDCollectDance)} type:kXMHTTPMethodPOST success:^(id responseObject) {
        [self showSuccessWithText:@"取消收藏成功"];
    
        self.headerView.collectionBtn.selected = NO;
        
    } failure:^(NSError *error) {
        [self showErrorWithText:@"取消收藏失败"];
        self.headerView.collectionBtn.selected = YES;
    }];
}

//点赞
-(void)commentLikeRequest:(NSString *)commentID {
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/AddCollectDance" parameters:@{@"OBJ_ID":commentID,@"OBJ_TYPE":@(kKMDCollectLike)} type:kXMHTTPMethodPOST success:^(id responseObject) {

        
    } failure:^(NSError *error) {

    }];
}
//取消点赞
-(void)commentCancelLikeRequest:(NSString *)commentID {
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/CanelCollectDance" parameters:@{@"OBJ_ID":commentID,@"OBJ_TYPE":@(kKMDCollectLike)} type:kXMHTTPMethodPOST success:^(id responseObject) {
        
    } failure:^(NSError *error) {

    }];
}

- (void)courseCommentListRequest {
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/GetSquareDanceReplyList"
                        parameters:@{
                                     @"videoId":self.videoID,
                                     @"pageIndex":@(self.pageIndex),
                                     @"pageSize":@(10)
                                     }
                              type:kXMHTTPMethodGET
                           success:^(id responseObject) {

                               [self.videoTableView.mj_header endRefreshing];
                               [self.videoTableView.mj_footer endRefreshing];

                               BATCourseCommentModel *comment = [BATCourseCommentModel mj_objectWithKeyValues:responseObject];
                               self.resultCount = comment.RecordsCount;
                               if (_pageIndex == 0) {
                                   [_dataSource removeAllObjects];
                                   
                               }
                               [_dataSource addObjectsFromArray:comment.Data];
                               if (_dataSource.count >= comment.RecordsCount) {
                                   [self.videoTableView.mj_footer endRefreshingWithNoMoreData];
                               }
                               [self.videoTableView reloadData];
                           }
                           failure:^(NSError *error) {

                               [self.videoTableView.mj_header endRefreshing];
                               [self.videoTableView.mj_footer endRefreshing];
                               
                               self.pageIndex --;
                               if (self.pageIndex < 0) {
                                   self.pageIndex = 0;
                               }
                           }];
}

- (void)sendCommentRequest:(NSString *)parentId parentLevelId:(NSString *)parentLevelId {
    
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    
    if (self.sendCommentView.commentTextView.text.length > 1000) {
        [self showErrorWithText:@"最多输入1000字"];
        return;
    }
    
    if ([[self.sendCommentView.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        [self showErrorWithText:@"请输入评论内容"];
        return;
    }
    
    if (parentLevelId.length == 0) {
        parentLevelId = @"0";
    }
    
    if (parentId.length == 0) {
        parentId = @"0";
    }
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/SubmitSquareDanceReply"
                        parameters:@{
                                     @"VideoID":self.videoID,
                                     @"ReplyContent":self.sendCommentView.commentTextView.text,
                                     @"ParentId":parentId,
                                     @"ParentLevelId":parentLevelId
                                     }
                              type:kXMHTTPMethodPOST
                           success:^(id responseObject) {
    
                               [self showSuccessWithText:@"评论成功"];
                               self.sendCommentView.commentTextView.text = nil;
                               [self.sendCommentView.commentTextView resignFirstResponder];
                               self.sendCommentView.commentTextView.placeholderText = nil;
                               
                               //重新获取评论
                               _pageIndex = 0;
                               [self courseCommentListRequest];
                           }
                           failure:^(NSError *error) {
                               
                               [self showErrorWithText:error.localizedDescription];
                           }];
}


#pragma mark - layout
- (void)layoutPages {
    WEAK_SELF(self);
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.videoTableView];
    [self.videoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        if (iPhoneX) {
            make.top.equalTo(self.mas_topLayoutGuideBottom);
        }
        else {
            make.top.equalTo(@0);
        }
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@-50);
    }];
    
    [self.view addSubview:self.sendCommentView];
    [self.sendCommentView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.right.equalTo(@0);
        make.bottom.equalTo(@120);
        make.height.mas_equalTo(120);
    }];
    
    [self.view addSubview:self.courseDetailBottomView];
    [self.courseDetailBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@0);
        if (iPhoneX) {
            make.height.mas_offset(50+34);
        }
        else {
            make.height.mas_offset(50);
        }
    }];
    
    [self.view addSubview:self.shareView];
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.mas_equalTo(140);
        make.bottom.equalTo(@140);
    }];
}

#pragma mark - getter
- (UITableView *)videoTableView {
    
    if (!_videoTableView) {
        
        _videoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _videoTableView.showsVerticalScrollIndicator = NO;
        _videoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _videoTableView.backgroundColor = BASE_BACKGROUND_COLOR;
        _videoTableView.rowHeight = UITableViewAutomaticDimension;
        _videoTableView.estimatedRowHeight = 250;
        
        _videoTableView.tableHeaderView = self.headerView;
        _videoTableView.tableFooterView = [[UIView alloc] init];
        [_videoTableView registerClass:[BATCourseCommentTableViewCell class] forCellReuseIdentifier:COMMENT_CELL];
        
        _videoTableView.delegate = self;
        _videoTableView.dataSource = self;
        
        WEAK_SELF(self);
        _videoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 0;
            [self courseCommentListRequest];
        }];
        
        _videoTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex ++;
            [self courseCommentListRequest];
        }];
    
    }
    return _videoTableView;
}

- (KMDVIdeoPlayHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[KMDVIdeoPlayHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/16.0*9.0 + 68 + 60)];
        
        _headerView.playerView.delegate = self;

        WEAK_SELF(self);
        [_headerView bk_whenTapped:^{
            STRONG_SELF(self);
            [self.view endEditing:YES];
        }];
        
        [_headerView setShareBlock:^{
            STRONG_SELF(self);
            
            if (!self.videoModel.Data.Url) {
                
                [self showErrorWithText:@"数据错误，暂时无法分享"];
                return;
            }
            
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
        
        [_headerView setCollectionBlock:^(UIButton *collectionBtn){
            STRONG_SELF(self);
            if (collectionBtn.selected == NO) {
                [self addCollection];
            }
            else {
                [self cancleCollection];
            }
            
        }];
        
        [_headerView setDownloadBlock:^{
           
            STRONG_SELF(self);
            [self downloadVideo];
        }];
    }
    return _headerView;
}

- (BATSendCommentView *)sendCommentView {
    
    if (!_sendCommentView) {
        _sendCommentView = [[BATSendCommentView alloc] init];
        _sendCommentView.commentTextView.delegate = self;
        WEAK_SELF(self);
        [_sendCommentView setSendBlock:^{
            STRONG_SELF(self);
            NSString *text = [self.sendCommentView.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (text.length == 0) {
                [self showErrorWithText:@"请输入评论"];
            }
            
            [self sendCommentRequest:self.parentId parentLevelId:self.parentLevelId];
        }];
    }
    
    return _sendCommentView;
}

- (BATCourseDetailBottomView *)courseDetailBottomView
{
    if (_courseDetailBottomView == nil) {
        _courseDetailBottomView = [[BATCourseDetailBottomView alloc] init];
        _courseDetailBottomView.backgroundColor = [UIColor whiteColor];
        WEAK_SELF(self);
        _courseDetailBottomView.inputBlock = ^(){
            STRONG_SELF(self);
            
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC;
                return;
            }
            
            self.sendCommentView.commentTextView.placeholderText = @"请输入...";
            [self.sendCommentView.commentTextView becomeFirstResponder];
        };
    }
    return _courseDetailBottomView;
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
            OSMessage *msg=[[OSMessage alloc]init];
            msg.title = self.title;
            msg.desc = @"康美广场舞";
            msg.image = [UIImage imageNamed:@"login_icon"];
            msg.link = [NSString stringWithFormat:@"%@/App/Dancing/ShareVedio?ID=%@",APP_H5_URL,self.videoID];
            msg.multimediaType = OSMultimediaTypeNews;
            [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
                
            } Fail:^(OSMessage *message, NSError *error) {
                
            }];
            
            self.shareView.cancelBlock();
        }];
        
        [_shareView setQQBlock:^{
            STRONG_SELF(self);

            OSMessage *msg=[[OSMessage alloc]init];
            msg.title = self.title;
            msg.desc = @"康美广场舞";
            msg.image = [UIImage imageNamed:@"login_icon"];
            msg.link = [NSString stringWithFormat:@"%@/App/Dancing/ShareVedio?ID=%@",APP_H5_URL,self.videoID];
            msg.multimediaType = OSMultimediaTypeNews;
            [OpenShare shareToQQFriends:msg Success:^(OSMessage *message) {
                
            } Fail:^(OSMessage *message, NSError *error) {
                
            }];
            self.shareView.cancelBlock();

        }];
        
        [_shareView setWeiChatMomentsBlock:^{
            STRONG_SELF(self);

            OSMessage *msg=[[OSMessage alloc]init];
            msg.title = self.title;
            msg.desc = @"康美广场舞";
            msg.image = [UIImage imageNamed:@"login_icon"];
            msg.link = [NSString stringWithFormat:@"%@/App/Dancing/ShareVedio?ID=%@",APP_H5_URL,self.videoID];
            msg.multimediaType = OSMultimediaTypeNews;
            [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
                
            } Fail:^(OSMessage *message, NSError *error) {
                
            }];
            self.shareView.cancelBlock();

        }];
        
        [_shareView setWeiboBlock:^{
            STRONG_SELF(self);

            OSMessage *msg=[[OSMessage alloc]init];
            msg.title = self.title;
            msg.desc = @"康美广场舞";
            msg.image = [UIImage imageNamed:@"login_icon"];
            msg.link = [NSString stringWithFormat:@"%@/App/Dancing/ShareVedio?ID=%@",APP_H5_URL,self.videoID];
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
