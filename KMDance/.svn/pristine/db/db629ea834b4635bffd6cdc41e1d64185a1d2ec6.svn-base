//
//  KMDMyDownloadViewController.m
//  KMDance
//
//  Created by KM on 17/6/232017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDMyDownloadViewController.h"

#import "KMDDownloadDetailViewController.h"

#import "DLTabedSlideView.h"

@interface KMDMyDownloadViewController ()<DLTabedSlideViewDelegate>

@property (nonatomic,strong) DLTabedSlideView *topSlideView;

@end

@implementation KMDMyDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutPages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DLTabedSlideViewDelegate
- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    
    return 2;
}
- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case 0:
        {
            KMDDownloadDetailViewController *collectionVC = [[KMDDownloadDetailViewController alloc] init];
            collectionVC.type = KMDDownloadTypeDance;
            return collectionVC;
        }
        case 1:
        {
            KMDDownloadDetailViewController *collectionVC = [[KMDDownloadDetailViewController alloc] init];
            collectionVC.type = KMDDownloadTypeSong;
            return collectionVC;
        }
    }
    
    return nil;
}

- (void)DLTabedSlideView:(DLTabedSlideView *)sender didSelectedAt:(NSInteger)index {
    
}

#pragma mark - layout
- (void)layoutPages {
    
    self.title = @"我的下载";
    [self.view addSubview:self.topSlideView];
    [self.topSlideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

#pragma mark - getter
- (DLTabedSlideView *)topSlideView {
    if (!_topSlideView) {
        _topSlideView = [[DLTabedSlideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 40 - 64)];
        _topSlideView.delegate = self;
        _topSlideView.baseViewController = self;
        _topSlideView.tabItemNormalColor = STRING_MID_COLOR;
        _topSlideView.tabItemSelectedColor = BASE_COLOR;
        _topSlideView.backgroundColor = BASE_BACKGROUND_COLOR;
        _topSlideView.tabbarTrackColor = BASE_COLOR;
        _topSlideView.tabbarBottomSpacing = 0.0;
        DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"舞蹈" image:nil selectedImage:nil];
        DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"舞曲" image:nil selectedImage:nil];
            _topSlideView.tabbarItems = @[item1, item2];
        [_topSlideView buildTabbar];
        _topSlideView.selectedIndex = 0;
    }
    return _topSlideView;
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
