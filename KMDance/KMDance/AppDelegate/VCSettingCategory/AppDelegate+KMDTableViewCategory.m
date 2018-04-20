//
//  AppDelegate+KMDTableViewCategory.m
//  KMDance
//
//  Created by Skybrim on 2017/9/20.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "AppDelegate+KMDTableViewCategory.h"
#import "Aspects.h"

@implementation AppDelegate (KMDTableViewCategory)

- (void)cancelTableViewAdjust {
    
    [UITableView aspect_hookSelector:@selector(initWithFrame:style:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        
        UITableView * tableView = aspectInfo.instance;
        
        if (tableView == nil) {
            return ;
        }
        
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
            if (tableView.estimatedRowHeight == UITableViewAutomaticDimension) {
                tableView.estimatedRowHeight = 0;
                tableView.estimatedSectionHeaderHeight = 0;
                tableView.estimatedSectionFooterHeight = 0;
            }
        }
    } error:nil];
 }
@end
