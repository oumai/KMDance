//
//  KMDVideoDownloadTableViewCell.h
//  KMDance
//
//  Created by KM on 17/6/262017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMDDownloadTool.h"

@interface KMDVideoDownloadTableViewCell : UITableViewCell<KMDDownloadSourceDelegate>

@property (nonatomic,strong) UIImageView *danceImageView;
@property (nonatomic,strong) UILabel     *danceTitleLabel;
@property (nonatomic,strong) UILabel     *sourceLabel;

@property (nonatomic,strong) KMDDownloadSource *source;
@property (strong, nonatomic) UIProgressView *progressView;//进度条
@property (strong, nonatomic) UIButton *pauseButton;
@property (strong, nonatomic) UIButton *deletebutton;
@property (strong, nonatomic) UILabel *rateLabel;
@property (strong, nonatomic) NSDate *lastDate;
@property (assign, nonatomic) int64_t bytes;

@property (nonatomic,copy) void(^deleteBlock)(void);
@property (nonatomic,copy) void(^pauseBlock)(void);

@end
