//
//  KMDVIdeoPlayHeaderView.h
//  KMDance
//
//  Created by KM on 17/5/262017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFPlayer.h"

@interface KMDVIdeoPlayHeaderView : UIView

@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) ZFPlayerView *playerView;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *readCountLabel;
@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic,strong) UIButton *collectionBtn;
@property (nonatomic,strong) UIButton *downloadBtn;

@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,copy) void(^shareBlock)(void);
@property (nonatomic,copy) void(^collectionBlock)(UIButton *collectionBtn);
@property (nonatomic,copy) void(^downloadBlock)(void);

@end
