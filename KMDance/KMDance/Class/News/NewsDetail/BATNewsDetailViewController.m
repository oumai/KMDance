//
//  BATNewsDetailViewController.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/9/2.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATNewsDetailViewController.h"

#import "BATBottomBar.h"
#import "BATNewsCommentTableViewCell.h"
#import "BATSendCommentView.h"
#import "KMDShareView.h"

#import "BATNewsCommentModel.h"

#import "BATShareCommentCollectionViewCell.h"
#import "BATHeaderViewCollectionViewCell.h"

#import "WZLBadgeImport.h"

#import <WebKit/WebKit.h>

static  NSString * const WEB_CELL = @"WebCell";
static  NSString * const COMMENT_CELL = @"CommentCell";

@interface BATNewsDetailViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,YYTextViewDelegate,WKNavigationDelegate,WKUIDelegate>

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) UIProgressView *progressView;

@property (nonatomic,strong) UITableView *reviewTableView;
@property (nonatomic,assign) float webViewHeight;
@property (nonatomic,strong) BATBottomBar *bottomBar;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) BATSendCommentView *sendCommentView;
@property (nonatomic,assign) float keyboardHeight;

@property (nonatomic,assign) BOOL isCollection;

@property (nonatomic,strong) KMDShareView *shareView;

@end

@implementation BATNewsDetailViewController

- (void)dealloc {

    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.webView removeObserver:self forKeyPath:@"title"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (LOGIN_STATION) {
        [self isCollectionInfoRequest];
    }
    
//    self.title = @"健康资讯";
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];



    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/App/NewsDetail/%@",APP_WEB_URL,self.newsID]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];


    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];


    [self layoutPages];
    self.dataArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if ([keyPath isEqualToString:@"contentSize"]) {
        self.webViewHeight = self.webView.scrollView.contentSize.height;
        [self.reviewTableView reloadData];
    }

    else if ([keyPath isEqualToString:@"estimatedProgress"]) {

        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;

            }];
        }
    }
}


#pragma mark - WKNavigationDelegate

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {

    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    self.webViewHeight = webView.scrollView.contentSize.height;

    self.reviewTableView.mj_footer.hidden = NO;
    [self.reviewTableView reloadData];
    
    self.reviewTableView.mj_footer.hidden = NO;
    self.reviewTableView.mj_header.hidden = NO;
    //加载完网页后，请求评论列表
    [self newsCommentListRequest];

    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {

    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (iPhoneSystemVersion >= 10) {
        NSArray *visibleCell = [self.reviewTableView visibleCells];
        for (UITableViewCell *cell in visibleCell) {
            NSIndexPath *indexPath = [self.reviewTableView indexPathForCell:cell];
            if (indexPath.section == 0 && indexPath.row == 0) {
                [self.webView setNeedsLayout];
            }
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        //新闻网页
        UITableViewCell *webCell = [tableView dequeueReusableCellWithIdentifier:WEB_CELL];
        if (!webCell) {
            webCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WEB_CELL];
            webCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [webCell.contentView addSubview:self.webView];
            [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(@0);
            }];
        }
        return webCell;
    }

    //评论
    BATNewsCommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:COMMENT_CELL forIndexPath:indexPath];
    commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    CommentData *comment = self.dataArray[indexPath.row];
    commentCell.contentLabel.text = comment.Comment;
    [commentCell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",comment.PhotoPath]] placeholderImage:[UIImage imageNamed:@"personalCenter_defaultAvator"]];
    commentCell.nameLabel.text = comment.UserName;
    commentCell.timeLabel.text = comment.CreatedTime;
    return commentCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {

        return self.webViewHeight;
    }
    else {

        //评论高度
        CommentData *comment = self.dataArray[indexPath.row];

        return 30 + [Tools calculateHeightWithText:comment.Comment width:SCREEN_WIDTH-40 font:[UIFont systemFontOfSize:14] lineHeight:14] + 30;
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
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

- (void)keyboardWillShow:(NSNotification *)notif {
    
    CGRect keyboardFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    double duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSInteger animation = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
        
        self.sendCommentView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, -keyboardFrame.size.height-self.sendCommentView.bounds.size.height);
        
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    
    double duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSInteger animation = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
        self.sendCommentView.transform = CGAffineTransformIdentity;
        
    } completion:nil];
}



#pragma mark - private
- (void)editReview {
    //编辑评论
    [self.sendCommentView.commentTextView becomeFirstResponder];
}

- (void)showReview {

    //查看评论
    // 先判断评论列表是否有数据，如果没有执行tableview的滚动方法，会奔溃，因为并不存在数据，如果没有数据，就直接用下面的方法滚到最后一行
    NSLog(@"contentsize:%f",self.reviewTableView.contentSize.height);
    NSLog(@"bouns:%f",self.reviewTableView.bounds.size.height);
    
    CGFloat contentsizeHeight = self.reviewTableView.contentSize.height;
    CGFloat bounsHeight = self.reviewTableView.bounds.size.height;
    
    CGFloat realHeight = 0.0;
    if (contentsizeHeight>bounsHeight) {
        realHeight = contentsizeHeight - bounsHeight;
    }else {
        realHeight = 0.0;
    }
    
    if (self.dataArray.count == 0) {
        [UIView animateWithDuration:1 animations:^{
            [self.reviewTableView setContentOffset:CGPointMake(0, realHeight) animated:YES];
        }];
    }else {
        [UIView animateWithDuration:1 animations:^{
            [self.reviewTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }];
    }
    
//    if (self.dataArray.count != 0) {
//        [UIView animateWithDuration:1 animations:^{
//            [self.reviewTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        }];
//    }
}

//收藏按钮点击事件
- (void)collectionNews {
    DDLogDebug(@"收藏被点击了");
    
    if (self.isCollection) {
        [self cancleCollection];
    }else{
        [self addCollection];
    }
}

//分享按钮点击事件
- (void)shareNews {
    DDLogDebug(@"分享被点击了");

    [self.sendCommentView.commentTextView resignFirstResponder];
    
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
}

//隐藏分享界面
- (void)hideShareAllView{

}

#pragma mark - NET
- (void)newsCommentListRequest {

    [HTTPTool requestWithLoginURLString:@"/api/News/GetNewsCommentList"
                        parameters:@{
                                     @"NewsID":self.newsID,
                                     @"pageIndex":@(self.currentPage),
                                     @"pageSize":@"10"
                                     }
                              type:kXMHTTPMethodGET
                           success:^(id responseObject) {
                               [self dismissProgress];
                               [self.reviewTableView.mj_header endRefreshing];
                               [self.reviewTableView.mj_footer endRefreshing];

                               BATNewsCommentModel *comment = [BATNewsCommentModel mj_objectWithKeyValues:responseObject];
                               if (self.currentPage == 0) {
                                   [self.dataArray removeAllObjects];

                               }
                               [self.dataArray addObjectsFromArray:comment.Data];
                               if (self.dataArray.count >= comment.RecordsCount) {
                                   [self.reviewTableView.mj_footer endRefreshingWithNoMoreData];
                               }
                               [self.reviewTableView reloadData];

                               self.bottomBar.reviewButton.imageView.badgeMaximumBadgeNumber = 9999;
                               [self.bottomBar.reviewButton.imageView showBadgeWithStyle:WBadgeStyleNumber value:comment.RecordsCount animationType:WBadgeAnimTypeNone];
    }
                           failure:^(NSError *error) {
                               [self.reviewTableView.mj_header endRefreshing];
                               [self.reviewTableView.mj_footer endRefreshing];
    }];
}

- (void)sendCommentRequest {

    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }

    if (self.sendCommentView.commentTextView.text.length > 600) {
        [self showErrorWithText:@"最多输入600字"];
        return;
    }

    if ([[self.sendCommentView.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        [self showErrorWithText:@"请输入评论内容"];
        return;
    }

    [HTTPTool requestWithLoginURLString:@"/api/News/CommentNews"
                        parameters:@{
                                     @"RelatedID":self.newsID,
                                     @"Comment":self.sendCommentView.commentTextView.text
                                     }
                              type:kXMHTTPMethodPOST
                           success:^(id responseObject) {

                               [self showSuccessWithText:@"评论成功"];
                               self.sendCommentView.commentTextView.text = nil;
                               [self.sendCommentView.commentTextView resignFirstResponder];

                               
                               CGFloat contentsizeHeight = self.reviewTableView.contentSize.height;
                               CGFloat bounsHeight = self.reviewTableView.bounds.size.height;
                               
                               CGFloat realHeight = 0.0;
                               if (contentsizeHeight>bounsHeight) {
                                   realHeight = contentsizeHeight - bounsHeight;
                               }else {
                                   realHeight = 0.0;
                               }
                               
                               if (self.dataArray.count == 0) {
                                   [UIView animateWithDuration:1 animations:^{
                                       [self.reviewTableView setContentOffset:CGPointMake(0, realHeight) animated:YES];
                                   }];
                               }else {
                                   [UIView animateWithDuration:1 animations:^{
                                       [self.reviewTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                   }];
                               }

                               //重新获取评论
                               self.currentPage = 0;
                               [self newsCommentListRequest];
    }
                           failure:^(NSError *error) {

    }];
}

//收藏资讯
-(void)addCollection {
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/AddCollectDance" parameters:@{@"OBJ_ID":self.newsID,@"OBJ_TYPE":@(kKMDCollectNews)} type:kXMHTTPMethodPOST success:^(id responseObject) {
        [self showSuccessWithText:@"收藏成功"];
        self.isCollection = YES;
        self.bottomBar.collectionButton.selected = YES;
    } failure:^(NSError *error) {
        [self showErrorWithText:@"收藏失败"];
    }];
}
//取消收藏资讯
-(void)cancleCollection {
    
    [HTTPTool requestWithURLString:@"/api/SquareDance/CanelCollectDance" parameters:@{@"OBJ_ID":self.newsID,@"OBJ_TYPE":@(kKMDCollectNews)} type:kXMHTTPMethodPOST success:^(id responseObject) {
        [self showSuccessWithText:@"取消收藏成功"];
        self.isCollection = NO;
        self.bottomBar.collectionButton.selected = NO;
        
    } failure:^(NSError *error) {
        [self showErrorWithText:@"取消收藏失败"];
    }];
}

-(void)isCollectionInfoRequest {
    
    [HTTPTool requestWithURLString:@"api/SquareDance/IsCollect" parameters:@{@"RelationType":@(kKMDCollectNews),@"RelationId":self.newsID} type:kXMHTTPMethodGET success:^(id responseObject) {
        NSString *isCollectionString = [NSString stringWithFormat:@"%@",responseObject[@"Data"][@"IsCollect"]];
        if ([isCollectionString isEqualToString:@"0"]) {
            self.isCollection = NO;
            self.bottomBar.collectionButton.selected = NO;

        }else {
            self.isCollection = YES;
            self.bottomBar.collectionButton.selected = YES;

        }
   } failure:^(NSError *error) {
       
   }];
}

#pragma mark - layout
- (void)layoutPages {

    WEAK_SELF(self);

    [self.view addSubview:self.bottomBar];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.bottom.right.equalTo(self.view);
        if (iPhoneX) {
            make.height.mas_equalTo(50+34);
        }
        else {
            make.height.mas_equalTo(50);
        }
    }];

    [self.view addSubview:self.reviewTableView];
    [self.reviewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomBar.mas_top);
    }];

    [self.view addSubview:self.sendCommentView];
    [self.sendCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(1200);
        make.height.mas_equalTo(1200);
    }];



    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        make.height.mas_equalTo(2);
    }];

    
    [self.view addSubview:self.shareView];
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.mas_equalTo(140);
        make.bottom.equalTo(@140);
    }];
}

#pragma mark - setter && getter
- (WKWebView *)webView {
    if (!_webView) {
    
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.navigationDelegate = self;
        _webView.scrollView.scrollEnabled = NO;
    }
    return _webView;
}

- (UIProgressView *)progressView {

    if (!_progressView) {

        _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
        _progressView.backgroundColor = BASE_COLOR;
        //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    }
    return _progressView;
}

- (UITableView *)reviewTableView {

    if (!_reviewTableView) {
        _reviewTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _reviewTableView.delegate = self;
        _reviewTableView.dataSource = self;
        _reviewTableView.backgroundColor = [UIColor clearColor];
        [_reviewTableView registerClass:[BATNewsCommentTableViewCell class] forCellReuseIdentifier:COMMENT_CELL];
        _reviewTableView.tableFooterView = [[UIView alloc] init];
        WEAK_SELF(self);
        _reviewTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage = 0;
            [self newsCommentListRequest];
        }];

        _reviewTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage ++;
            [self newsCommentListRequest];
        }];

        _reviewTableView.mj_footer.hidden = YES;
        _reviewTableView.mj_header.hidden = YES;

    }
    return _reviewTableView;
}

- (BATBottomBar *)bottomBar {

    if (!_bottomBar) {
        _bottomBar = [[BATBottomBar alloc] initWithFrame:CGRectZero];

        WEAK_SELF(self);
        [_bottomBar setEditBlock:^{
            //开始编辑评论

            STRONG_SELF(self);
            [self editReview];
        }];

        [_bottomBar setReviewBlock:^{
            //查看评论
            STRONG_SELF(self);
            [self showReview];
        }];

        [_bottomBar setCollectionBlock:^{
            //收藏
            STRONG_SELF(self);
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC;
                return ;
            }
            [self collectionNews];
        }];

        [_bottomBar setShareBlock:^{
            //分享
            STRONG_SELF(self);
            [self shareNews];
        }];
    }
    return _bottomBar;
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

            [self sendCommentRequest];
        }];
        
        [_sendCommentView setClaerBlock:^{
            STRONG_SELF(self);
            [self.view endEditing:YES];
        }];
    }

    return _sendCommentView;
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
            msg.link = [NSString stringWithFormat:@"%@/App/Dancing/shareNews?id=%@",APP_H5_URL,self.newsID];
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
            msg.link = [NSString stringWithFormat:@"%@/App/Dancing/shareNews?id=%@",APP_H5_URL,self.newsID];
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
            msg.link = [NSString stringWithFormat:@"%@/App/Dancing/shareNews?id=%@",APP_H5_URL,self.newsID];
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
            msg.link = [NSString stringWithFormat:@"%@/App/Dancing/shareNews?id=%@",APP_H5_URL,self.newsID];
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
