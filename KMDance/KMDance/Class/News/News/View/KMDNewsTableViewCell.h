//
//  KMDNewsTableViewCell.h
//  KMDance
//
//  Created by KM on 17/5/182017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMDNewsTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *newsImageView;
@property (nonatomic,strong) UILabel     *newsTitleLabel;
@property (nonatomic,strong) UILabel     *contentLabel;
@property (nonatomic,strong) UILabel     *sourceLabel;
@property (nonatomic,strong) UILabel     *readTimeLabel;

@end
