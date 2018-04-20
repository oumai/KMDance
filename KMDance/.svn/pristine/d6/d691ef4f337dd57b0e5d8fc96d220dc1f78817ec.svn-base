//
//  KMDMeViewController.m
//  KMDance
//
//  Created by KM on 17/5/172017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDMeViewController.h"

#import "KMDMeHeaderView.h"
#import "KMDMeTableViewCell.h"
#import "KMDShareView.h"

#import "BATPerson.h"

#import "KMDMyCollectionViewController.h"
#import "KMDHistoryViewController.h"
#import "KMDSettingViewController.h"
#import "KMDPersonInfoViewController.h"
#import "KMDMyDownloadViewController.h"
#import "KMDMyUploadViewController.h"


static  NSString * const ME_CELL = @"KMDMeTableViewCell";

@interface KMDMeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *meTableView;
@property (nonatomic,strong) KMDMeHeaderView *headerView;

@property (nonatomic,strong) KMDShareView *shareView;

@end

@implementation KMDMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pagesLayout];
    [self.meTableView.mj_header beginRefreshing];
    
    if (LOGIN_STATION) {
        
        [self personInfoListRequest];
    }
    else {
        
        //未登录
        self.headerView.avatarImageView.image = [UIImage imageNamed:@"avatar_01"];
        self.headerView.loginLabel.text = @"登录/注册";
        
        PRESENT_LOGIN_VC;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (LOGIN_STATION) {
        
        [self personInfoListRequest];
    }
    else {
        
        //未登录
        self.headerView.avatarImageView.image = [UIImage imageNamed:@"avatar_01"];
        self.headerView.loginLabel.text = @"登录/注册";
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@140);
    }];
    
    [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        [self.tabBarController.tabBar setHidden:NO];
    } completion:nil];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KMDMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ME_CELL forIndexPath:indexPath];

    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                cell.nameLabel.text = @"我的收藏";
                cell.leftImageView.image = [UIImage imageNamed:@"collecton2_icon"];
            }
                break;
            case 1:
            {
                cell.nameLabel.text = @"观看历史";
                cell.leftImageView.image = [UIImage imageNamed:@"history_icon"];

            }
                break;
            case 2:
            {
                cell.nameLabel.text = @"我的下载";
                cell.leftImageView.image = [UIImage imageNamed:@"我的-下载"];
            }
                break;
            case 3:
            {
                cell.nameLabel.text = @"我的上传";
                cell.leftImageView.image = [UIImage imageNamed:@"uploading_icon"];
                
            }
                break;
        }
    }
    else {
        switch (indexPath.row) {
            case 0:
            {
                cell.nameLabel.text = @"设置";
                cell.leftImageView.image = [UIImage imageNamed:@"set_icon"];
            }
                break;
            case 1:
            {
                cell.nameLabel.text = @"分享到";
                cell.leftImageView.image = [UIImage imageNamed:@"share_icon"];
            }
                break;
        }
    }

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 16;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    if (!LOGIN_STATION) {
                        PRESENT_LOGIN_VC;
                        return;
                    }
                    //我的收藏
                    KMDMyCollectionViewController *collectionVC = [[KMDMyCollectionViewController alloc] init];
                    collectionVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:collectionVC animated:YES];
                }
                    break;
                case 1:
                {
                    if (!LOGIN_STATION) {
                        PRESENT_LOGIN_VC;
                        return;
                    }
                    //观看历史
                    KMDHistoryViewController *historyVC = [[KMDHistoryViewController alloc] init];
                    historyVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:historyVC animated:YES];
                }
                    break;
                case 2:
                {
                    //我的下载
                    KMDMyDownloadViewController *downloadVC = [[KMDMyDownloadViewController alloc] init];
                    downloadVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:downloadVC animated:YES];
                }
                    break;
                case 3:
                {
                    if (!LOGIN_STATION) {
                        PRESENT_LOGIN_VC;
                        return;
                    }
                    //我的上传
                    KMDMyUploadViewController *uploadVC = [[KMDMyUploadViewController alloc] init];
                    uploadVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:uploadVC animated:YES];
                    
                }
                    break;
            }

        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    if (!LOGIN_STATION) {
                        PRESENT_LOGIN_VC;
                        return;
                    }
                    //设置
                    KMDSettingViewController *settingVC = [[KMDSettingViewController alloc] init];
                    settingVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:settingVC animated:YES];
                }
                    break;
                case 1:
                {
                    //分享到
                    [self.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
                        if (iPhoneX) {
                            make.bottom.equalTo(@-34);
                        }
                        else {
                            make.bottom.equalTo(@0);
                        }
                    }];
    
                    [self.tabBarController.tabBar setHidden:YES];

                    [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        [self.view setNeedsLayout];
                        [self.view layoutIfNeeded];
                    } completion:nil];
                    
                }
                    break;
            }
        }
            break;
    }
    
}

#pragma mark - NET
//获取个人信息
- (void)personInfoListRequest {
    
    [HTTPTool requestWithLoginURLString:@"/api/Patient/Info" parameters:nil type:kXMHTTPMethodGET success:^(id responseObject) {
        
        BATPerson * person = [BATPerson mj_objectWithKeyValues:responseObject];
        if (person.ResultCode == 0) {
            
            [self.headerView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:person.Data.PhotoPath] placeholderImage:[UIImage imageNamed:@"avatar_01"]];
            self.headerView.loginLabel.text = person.Data.UserName;
            
            //保存登录信息
            NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"];
            [NSKeyedArchiver archiveRootObject:person toFile:file];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - layout
- (void)pagesLayout {

    [self.view addSubview:self.meTableView];
    [self.meTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(@available(iOS 11.0, *)) {
            make.top.equalTo(@0);
        }
        else {
            make.top.equalTo(@-20);
        }
        make.left.right.bottom.equalTo(@0);
    }];
    
    [self.view addSubview:self.shareView];
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.mas_equalTo(140);
        make.bottom.equalTo(@140);
    }];
}

#pragma mark - getter
- (UITableView *)meTableView {
    
    if (!_meTableView) {
        
        _meTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _meTableView.showsVerticalScrollIndicator = NO;
        _meTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _meTableView.backgroundColor = UIColorFromHEX(0xf8f7fb, 1);
        _meTableView.rowHeight = 45;
        _meTableView.bounces = NO;
        
        [_meTableView registerClass:[KMDMeTableViewCell class] forCellReuseIdentifier:ME_CELL];

        _meTableView.tableHeaderView = self.headerView;
        _meTableView.tableFooterView = [[UIView alloc] init];
        
        _meTableView.delegate = self;
        _meTableView.dataSource = self;
        
        _meTableView.estimatedRowHeight = 0;
        _meTableView.estimatedSectionHeaderHeight = 0;
        _meTableView.estimatedSectionFooterHeight = 0;
        
    }
    return _meTableView;
}

- (KMDMeHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[KMDMeHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 394.0/750.0*SCREEN_WIDTH)];

        WEAK_SELF(self);
        [_headerView bk_whenTapped:^{
            STRONG_SELF(self);
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC;
                return;
            }
        }];
        
        [_headerView.avatarImageView bk_whenTapped:^{
            STRONG_SELF(self);
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC;
                return;
            }
            
            if (LOGIN_STATION) {
                KMDPersonInfoViewController *personInfoVC = [[KMDPersonInfoViewController alloc] init];
                personInfoVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:personInfoVC animated:YES];
            }
        }];
        
        [_headerView.loginLabel bk_whenTapped:^{
            
            STRONG_SELF(self);
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC;
                return;
            }
            
            if (LOGIN_STATION) {
                KMDPersonInfoViewController *personInfoVC = [[KMDPersonInfoViewController alloc] init];
                personInfoVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:personInfoVC animated:YES];
            }
        }];
    }
    return _headerView;
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
            
            [self.tabBarController.tabBar setHidden:NO];

            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            } completion:nil];
        }];
        
        [_shareView setWeiChatBlock:^{
           
            OSMessage *msg=[[OSMessage alloc]init];
            msg.title = @"康美广场舞";
            msg.desc = @"康美广场舞";
            msg.image = [UIImage imageNamed:@"login_icon"];
            msg.link = [NSString stringWithFormat:@"%@/App/Dancing/appDownload",APP_H5_URL];
            msg.multimediaType = OSMultimediaTypeNews;
            [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
                
            } Fail:^(OSMessage *message, NSError *error) {
                
            }];
    
        }];
        
        [_shareView setQQBlock:^{
            
            OSMessage *msg=[[OSMessage alloc]init];
            msg.title = @"康美广场舞";
            msg.desc = @"康美广场舞";
            msg.image = [UIImage imageNamed:@"login_icon"];
            msg.link = [NSString stringWithFormat:@"%@/App/Dancing/appDownload",APP_H5_URL];
            msg.multimediaType = OSMultimediaTypeNews;
            [OpenShare shareToQQFriends:msg Success:^(OSMessage *message) {
                
            } Fail:^(OSMessage *message, NSError *error) {
                
            }];
        }];
        
        [_shareView setWeiChatMomentsBlock:^{
            
            OSMessage *msg=[[OSMessage alloc]init];
            msg.title = @"康美广场舞";
            msg.desc = @"康美广场舞";
            msg.image = [UIImage imageNamed:@"login_icon"];
            msg.link = [NSString stringWithFormat:@"%@/App/Dancing/appDownload",APP_H5_URL];
            msg.multimediaType = OSMultimediaTypeNews;
            [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
                
            } Fail:^(OSMessage *message, NSError *error) {
                
            }];
        }];
        
        [_shareView setWeiboBlock:^{
            
            OSMessage *msg=[[OSMessage alloc]init];
            msg.title = @"康美广场舞";
            msg.desc = @"康美广场舞";
            msg.image = [UIImage imageNamed:@"login_icon"];
            msg.link = [NSString stringWithFormat:@"%@/App/Dancing/appDownload",APP_H5_URL];
            msg.multimediaType = OSMultimediaTypeNews;
            [OpenShare shareToWeibo:msg Success:^(OSMessage *message) {
                
            } Fail:^(OSMessage *message, NSError *error) {
                
            }];
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
