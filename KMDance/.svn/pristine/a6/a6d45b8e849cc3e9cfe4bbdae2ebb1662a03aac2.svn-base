//
//  AppDelegate+KMDVCSettingCategory.m
//  KMDance
//
//  Created by KM on 17/5/172017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "AppDelegate+KMDVCSettingCategory.h"
#import "Aspects.h"
#import "SVProgressHUD.h"

@implementation AppDelegate (KMDVCSettingCategory)

- (void)kmd_settingVC {
    [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo) {
        UIViewController * vc = aspectInfo.instance;
        
        if (vc == nil) {
            return ;
        }
        
        if ([aspectInfo.instance isKindOfClass:NSClassFromString(@"UIInputWindowController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIWindow")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UINavigationController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UITabBarController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UINavigationController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UICompatibilityInputViewController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"_UIRemoteInputViewController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIApplicationRotationFollowingControllerNoTouches")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIApplicationRotationFollowingController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIAlertController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"PLPhotoTileViewController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"PUUIImageViewController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"PUUIMomentsGridViewController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"ZLImageNavigationController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"ZLThumbnailViewController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"ZLShowBigImgViewController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"ZLEditViewController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIImagePickerController")]) {
            //屏蔽一些系统界面
            
            return ;
        }
        
        //背景色
        vc.view.backgroundColor = BASE_BACKGROUND_COLOR;
        
        //返回按钮
        //KMDSearchViewController.h 搜索界面不要返回按钮

        if (vc.navigationController.viewControllers.count> 1 &&
            ![vc isKindOfClass:NSClassFromString(@"KMDSearchViewController")] ) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 20, 40);
            WEAK_SELF(vc);
            [btn bk_whenTapped:^{
                STRONG_SELF(vc);
                [vc.navigationController popViewControllerAnimated:YES];
                [vc dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [btn setImage:[UIImage imageNamed:@"backgrey_icon"] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
            vc.navigationItem.leftBarButtonItem = backItem;
            
            vc.hidesBottomBarWhenPushed = YES;
        }
        
        //导航条标题
        [vc.navigationController.navigationBar setTitleTextAttributes:@{
                                                                        NSForegroundColorAttributeName:STRING_MID_COLOR,
                                                                        NSFontAttributeName:stringFont(20)
                                                                        }];
        
        //导航条背景色
        [vc.navigationController.navigationBar setBackgroundImage:[Tools imageFromColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        vc.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:BASE_LINECOLOR];
        [vc.navigationController.navigationBar setTintColor:UIColorFromHEX(0x02a9a9, 1)];
        
        vc.automaticallyAdjustsScrollViewInsets = NO;

    } error:NULL];
}

- (void)kmd_VCDissmiss {
    
    [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo) {
        
        UIViewController * vc = aspectInfo.instance;
        if (vc == nil) {
            return ;
        }
        
        if ([aspectInfo.instance isKindOfClass:NSClassFromString(@"UIInputWindowController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIWindow")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UINavigationController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UITabBarController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UINavigationController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UICompatibilityInputViewController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIApplicationRotationFollowingControllerNoTouches")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIApplicationRotationFollowingController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIAlertController")]) {
            //屏蔽一些系统界面
            
            return ;
        }
        
        [SVProgressHUD dismiss];
        [vc.view endEditing:YES];
        
        
    } error:NULL];
}


@end
