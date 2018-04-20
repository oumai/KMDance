//
//  KMDRootTabBarViewController.m
//  KMDance
//
//  Created by KM on 17/5/172017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDRootTabBarViewController.h"

#import "KMDDanceViewController.h"
#import "KMDSongViewController.h"
#import "KMDNewsViewController.h"
#import "KMDMeViewController.h"

@interface KMDRootTabBarViewController ()

@end

@implementation KMDRootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupViewControllers {
    KMDDanceViewController *firstViewController = [[KMDDanceViewController alloc] init];
    UINavigationController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    KMDSongViewController *secondViewController = [[KMDSongViewController alloc] init];
    UINavigationController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    KMDNewsViewController *thirdViewController = [[KMDNewsViewController alloc] init];
    UINavigationController *thirdNavigationController = [[UINavigationController alloc]
                                                          initWithRootViewController:thirdViewController];
    KMDMeViewController *fouthViewController = [[KMDMeViewController alloc] init];
    UINavigationController *fouthNavigationController = [[UINavigationController alloc]
                                                          initWithRootViewController:fouthViewController];
    
    
    [self customizeTabBarForController:self];
    
    [self setViewControllers:@[
                               firstNavigationController,
                               secondNavigationController,
                               thirdNavigationController,
                               fouthNavigationController,
                               ]];
}

- (void)customizeTabBarForController:(CYLTabBarController *)tabBarController {
    
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"舞蹈",
                            CYLTabBarItemImage : @"dancing_gray",
                            CYLTabBarItemSelectedImage : @"dancing_on",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : @"舞曲",
                            CYLTabBarItemImage : @"music_gray",
                            CYLTabBarItemSelectedImage : @"music_on",
                            };
    NSDictionary *dict3 = @{
                            CYLTabBarItemTitle : @"资讯",
                            CYLTabBarItemImage : @"news_gray",
                            CYLTabBarItemSelectedImage : @"news_on",
                            };
    NSDictionary *dict4 = @{
                            CYLTabBarItemTitle : @"我的",
                            CYLTabBarItemImage : @"user_gray",
                            CYLTabBarItemSelectedImage : @"user_on",
                            };
    
    NSArray *tabBarItemsAttributes = @[ dict1, dict2, dict3, dict4];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:@{
                                   NSFontAttributeName: [UIFont systemFontOfSize:14],
                                   NSForegroundColorAttributeName:UIColorFromHEX(0xffffff, 0.7),
                                   }
                        forState:UIControlStateNormal];
    
    [tabBar setTitleTextAttributes:@{
                                   NSFontAttributeName: [UIFont systemFontOfSize:14],
                                   NSForegroundColorAttributeName:UIColorFromHEX(0xffffff, 1),
                                   }
                        forState:UIControlStateSelected];
    
    self.tabBarHeight = 30+16+10;
    if (iPhoneX) {
        self.tabBarHeight = 83;
    }
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_bg"]];
    img.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.tabBarHeight);
    img.contentMode = UIViewContentModeScaleToFill;
    [[self tabBar] insertSubview:img atIndex:0];
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
