//
//  KMDDanceThemeCollectionViewCell.m
//  KMDance
//
//  Created by KM on 17/6/222017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDDanceThemeCollectionViewCell.h"

@implementation KMDDanceThemeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        WEAK_SELF(self);

        [self.contentView addSubview:self.videoImageView];
        [self.videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@5);
            make.right.equalTo(@-5);
            make.height.mas_equalTo((frame.size.width-10)/16.0*9);
        }];
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.videoImageView.mas_bottom).offset(10);
            make.right.equalTo(@-5);
            make.left.equalTo(@5);
            make.bottom.equalTo(@-5);
        }];
        
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.videoImageView.mas_right);
            make.bottom.equalTo(self.videoImageView.mas_bottom);
        }];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)videoImageView {

    if (!_videoImageView) {
        
        _videoImageView = [[UIImageView alloc] init];
        [_videoImageView sizeToFit];
    }
    return _videoImageView;
}

- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentRight];
        _timeLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _timeLabel;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}


@end
