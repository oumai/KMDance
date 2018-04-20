//
//  AppDelegate+KMDVCSettingCategory.h
//  KMDance
//
//  Created by KM on 17/5/172017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (KMDVCSettingCategory)

/**
 *  设置VC颜色等
 */
- (void)kmd_settingVC;
/**
 *  VC消失时执行方法
 */
- (void)kmd_VCDissmiss;

@end
