//
//  KMDDanceVideoTableViewCell.h
//  KMDance
//
//  Created by KM on 17/5/182017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMDDanceVideoTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *danceImageView;
@property (nonatomic,strong) UILabel     *danceTitleLabel;
@property (nonatomic,strong) UILabel     *contentLabel;
@property (nonatomic,strong) UILabel     *sourceLabel;
@property (nonatomic,strong) UILabel     *readTimeLabel;

@property (nonatomic,strong) UILabel     *statusLabel;

@end
