//
//  KMDShareCollectionViewCell.m
//  KMDance
//
//  Created by KM on 17/5/312017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDShareCollectionViewCell.h"

@implementation KMDShareCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.shareImageView];
        [self.shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.centerY.equalTo(@-20);
        }];
        
        [self.shareImageView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.top.equalTo(self.shareImageView.mas_bottom).offset(10);
        }];
    }
    return self;
}

- (UIImageView *)shareImageView {
    
    if (!_shareImageView) {
        _shareImageView = [[UIImageView alloc] init];
        [_shareImageView sizeToFit];
        
    }
    return _shareImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentCenter];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

@end
