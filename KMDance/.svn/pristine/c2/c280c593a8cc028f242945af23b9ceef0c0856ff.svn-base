//
//  KMDDanceVideoTableViewCell.m
//  KMDance
//
//  Created by KM on 17/5/182017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDDanceVideoTableViewCell.h"

@implementation KMDDanceVideoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WEAK_SELF(self);
        
        [self.contentView addSubview:self.danceImageView];
        [self.danceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.centerY.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(70/9.0*16, 70));
//            make.width.mas_equalTo(70/9.0*16);
//            make.height.mas_equalTo(70);
//            make.top.equalTo(@10);
//            make.bottom.equalTo(@-10);
        }];
        
        [self.contentView addSubview:self.danceTitleLabel];
        [self.danceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.danceImageView.mas_top);
            make.left.equalTo(self.danceImageView.mas_right).offset(10);
            make.right.lessThanOrEqualTo(@-10);
        }];
        
//        [self.contentView addSubview:self.contentLabel];
//        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.top.equalTo(self.newsTitleLabel.mas_bottom).offset(10);
//            make.left.equalTo(self.newsImageView.mas_right).offset(10);
//            make.right.equalTo(@-10);
//        }];

        [self.contentView addSubview:self.sourceLabel];
        [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.danceImageView.mas_right).offset(10);
//            make.top.equalTo(self.danceTitleLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.danceImageView.mas_bottom);
        }];
        
//        [self.contentView addSubview:self.readTimeLabel];
//        [self.readTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            STRONG_SELF(self);
//            make.left.equalTo(self.danceImageView.mas_right).offset(10);
//            make.bottom.equalTo(@-10);
//        }];
        
        [self.contentView addSubview:self.statusLabel];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-5);
            make.centerY.equalTo(@0);
        }];
        
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        
    }
    return self;
}

#pragma mark - setter && getter
- (UIImageView *)danceImageView {
    
    if (!_danceImageView) {
        
        _danceImageView = [[UIImageView alloc] init];
        _danceImageView.contentMode = UIViewContentModeScaleAspectFit;
//        [_danceImageView sizeToFit];
    }
    return _danceImageView;
}

- (UILabel *)danceTitleLabel {
    
    if (!_danceTitleLabel) {
        
        _danceTitleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentLeft];
    }
    return _danceTitleLabel;
}

- (UILabel *)contentLabel {
    
    if (!_contentLabel) {
        
        _contentLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentCenter];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UILabel *)sourceLabel {
    
    if (!_sourceLabel) {
        
        _sourceLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:11] textColor:STRING_LIGHT_COLOR textAlignment:NSTextAlignmentCenter];
    }
    return _sourceLabel;
}

- (UILabel *)readTimeLabel {
    
    if (!_readTimeLabel) {
        
        _readTimeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:11] textColor:STRING_LIGHT_COLOR textAlignment:NSTextAlignmentRight];
    }
    return _readTimeLabel;
}

- (UILabel *)statusLabel {
    
    if (!_statusLabel) {
        
        _statusLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentRight];
    }
    return _statusLabel;
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
