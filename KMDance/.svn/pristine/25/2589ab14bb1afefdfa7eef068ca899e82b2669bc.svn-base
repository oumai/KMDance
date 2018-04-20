//
//  KMDUploadingTableViewCell.m
//  KMDance
//
//  Created by KM on 17/8/42017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDUploadingTableViewCell.h"

@implementation KMDUploadingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WEAK_SELF(self);
        
        [self.contentView addSubview:self.danceImageView];
        [self.danceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@10);
            make.bottom.equalTo(@-10);
            make.size.mas_equalTo(CGSizeMake(70/9.0*16, 70));
        }];
        
        [self.contentView addSubview:self.danceTitleLabel];
        [self.danceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(@10);
            make.left.equalTo(self.danceImageView.mas_right).offset(10);
            make.right.lessThanOrEqualTo(@-10);
        }];
        
        [self.contentView addSubview:self.deletebutton];
        [self.deletebutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-5);
            make.centerY.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [self.contentView addSubview:self.pauseButton];
        [self.pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.deletebutton.mas_left).offset(-5);
            make.centerY.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [self.contentView addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.bottom.equalTo(@-10);
            make.left.equalTo(self.danceImageView.mas_right).offset(5);
            make.right.equalTo(self.pauseButton.mas_left).offset(-5);
            make.height.mas_equalTo(3);
        }];
        
        [self.contentView addSubview:self.rateLabel];
        [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.progressView.mas_right).offset(0);
            make.bottom.equalTo(self.progressView.mas_top).offset(-5);
        }];
        
        [self.contentView addSubview:self.pauseStatusButton];
        [self.pauseStatusButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.progressView.mas_left).offset(0);
            make.bottom.equalTo(self.progressView.mas_top).offset(-5);
        }];
        
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        
    }
    return self;
}

#pragma mark - setter && getter
- (UIImageView *)danceImageView {
    
    if (!_danceImageView) {
        
        _danceImageView = [[UIImageView alloc] init];
        [_danceImageView sizeToFit];
    }
    return _danceImageView;
}

- (UILabel *)danceTitleLabel {
    
    if (!_danceTitleLabel) {
        
        _danceTitleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentLeft];
    }
    return _danceTitleLabel;
}

- (UIProgressView *)progressView {
    
    if (!_progressView) {
        
        _progressView = [[UIProgressView alloc] init];
        _progressView.progress = 0;
        _progressView.tintColor = BASE_COLOR;
    }
    return _progressView;
}

- (UIButton *)pauseStatusButton {
    
    if (!_pauseStatusButton) {
        _pauseStatusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseStatusButton setTitle:@"上传中" forState:UIControlStateNormal];
        [_pauseStatusButton setTitle:@"暂停中" forState:UIControlStateSelected];
        [_pauseStatusButton setTitleColor:STRING_MID_COLOR forState:UIControlStateNormal];
        [_pauseStatusButton setTitleColor:STRING_MID_COLOR forState:UIControlStateSelected];
        _pauseStatusButton.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _pauseStatusButton;
}

- (UIButton *)pauseButton {
    
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setTitle:@"暂停" forState:UIControlStateNormal];
        [_pauseButton setTitle:@"继续" forState:UIControlStateSelected];
        [_pauseButton setTitleColor:STRING_MID_COLOR forState:UIControlStateNormal];
        [_pauseButton setTitleColor:STRING_MID_COLOR forState:UIControlStateSelected];
        _pauseButton.titleLabel.font = [UIFont systemFontOfSize:13];
        
        WEAK_SELF(self);
        [_pauseButton bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.pauseBlock) {
                self.pauseBlock();
            }
        }];
    }
    return _pauseButton;
}

- (UIButton *)deletebutton {
    
    if (!_deletebutton) {
        _deletebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deletebutton setImage:[UIImage imageNamed:@"我的下载-删除"] forState:UIControlStateNormal];
        WEAK_SELF(self);
        [_deletebutton bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.deleteBlock) {
                self.deleteBlock();
            }
        }];
    }
    return _deletebutton;
}

- (UILabel *)rateLabel {
    
    if (!_rateLabel) {
        _rateLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:11] textColor:STRING_LIGHT_COLOR textAlignment:NSTextAlignmentRight];
    }
    return _rateLabel;
}

#pragma mark -


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
