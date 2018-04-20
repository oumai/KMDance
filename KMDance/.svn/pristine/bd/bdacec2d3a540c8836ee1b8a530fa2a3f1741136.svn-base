//
//  KMDVIdeoPlayHeaderView.m
//  KMDance
//
//  Created by KM on 17/5/262017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDVIdeoPlayHeaderView.h"

@implementation KMDVIdeoPlayHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backgroundColor = [UIColor whiteColor];
        
        WEAK_SELF(self);
        [self addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/16.0*9));
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.backView.mas_bottom).offset(15);
            make.left.equalTo(@10);
        }];
        
        [self addSubview:self.readCountLabel];
        [self.readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.left.equalTo(@10);
        }];
        
        [self addSubview:self.shareBtn];
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(@-10);
            make.top.equalTo(self.titleLabel.mas_bottom);
        }];
        
        [self addSubview:self.collectionBtn];
        [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.shareBtn.mas_left).offset(-20);
            make.top.equalTo(self.titleLabel.mas_bottom);
        }];
        
        [self addSubview:self.downloadBtn];
        [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.collectionBtn.mas_left).offset(-20);
            make.top.equalTo(self.titleLabel.mas_bottom);
        }];
        
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(@0);
            make.top.equalTo(self.readCountLabel.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
        }];
        
        [self addSubview:self.avatarImageView];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@-12.5);
            make.left.equalTo(@10);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.avatarImageView.mas_centerY);
            make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        }];
        
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        
    
    }
    return self;
}



#pragma mark - getter
- (UIView *)backView {
    
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/16.0*9);
    }
    return _backView;
}

- (ZFPlayerView *)playerView {
    
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
//        _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspectFill;
    }
    return _playerView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UILabel *)readCountLabel {
    
    if (!_readCountLabel) {
        _readCountLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:STRING_LIGHT_COLOR textAlignment:NSTextAlignmentLeft];

    }
    return _readCountLabel;
}

- (UIButton *)shareBtn {
    
    if (!_shareBtn) {
        
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"sharegray_icon"] forState:UIControlStateNormal];
        
        WEAK_SELF(self);
        [_shareBtn bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.shareBlock) {
                self.shareBlock();
            }
        }];
    }
    return _shareBtn;
}

- (UIButton *)collectionBtn {
    
    if (!_collectionBtn) {
        _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionBtn setImage:[UIImage imageNamed:@"collect_icon"] forState:UIControlStateNormal];
        [_collectionBtn setImage:[UIImage imageNamed:@"icon-sc-d"] forState:UIControlStateSelected];

        WEAK_SELF(self);
        [_collectionBtn bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.collectionBlock) {
                self.collectionBlock(self.collectionBtn);
            }
        }];
    }
    return _collectionBtn;
}

- (UIButton *)downloadBtn {
    
    if (!_downloadBtn) {
        _downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downloadBtn setImage:[UIImage imageNamed:@"视频播放-下载"] forState:UIControlStateNormal];
        
        WEAK_SELF(self);
        [_downloadBtn bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.downloadBlock) {
                self.downloadBlock();
            }
        }];
    }
    return _downloadBtn;
}

- (UIView *)lineView {
    
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BASE_LINECOLOR;
        
    }
    return _lineView;
}

- (UIImageView *)avatarImageView {
    
    if (!_avatarImageView) {
        
        _avatarImageView = [[UIImageView alloc] init];
        [_avatarImageView sizeToFit];
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentLeft];

    }
    return _nameLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
