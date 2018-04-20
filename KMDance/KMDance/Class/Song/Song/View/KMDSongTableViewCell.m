//
//  KMDSongTableViewCell.m
//  KMDance
//
//  Created by KM on 17/5/182017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDSongTableViewCell.h"

@implementation KMDSongTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WEAK_SELF(self);
        
        [self.contentView addSubview:self.songTitleLabel];
        [self.songTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.left.equalTo(@10);
        }];
        
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.songTitleLabel.mas_bottom).offset(10);
            make.left.equalTo(@10);
            make.bottom.equalTo(@-10);
        }];
        
        [self.contentView addSubview:self.playBtn];
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.centerY.equalTo(@0);
        }];
        
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        
    }
    return self;
}

#pragma mark - setter && getter
- (UILabel *)songTitleLabel {
    
    if (!_songTitleLabel) {
        
        _songTitleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentLeft];
    }
    return _songTitleLabel;
}

- (UILabel *)contentLabel {
    
    if (!_contentLabel) {
        
        _contentLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentCenter];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIButton *)playBtn {
    
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom Title:@"播放" titleColor:BASE_COLOR backgroundColor:nil backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
        
        WEAK_SELF(self);
        [_playBtn bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.playBlock) {
                self.playBlock();
            }
        }];
    }
    return _playBtn;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
