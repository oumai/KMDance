//
//  KMDMusicDownloadTableViewCell.m
//  KMDance
//
//  Created by KM on 17/6/262017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDMusicDownloadTableViewCell.h"

@implementation KMDMusicDownloadTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self downloadedLayout];

        
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        
    }
    return self;
}

#pragma mark - <KMDDownloadSourceDelegate>代理方法
- (void)downloadSource:(KMDDownloadSource *)source didWriteData:(NSData *)data totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    if (totalBytesWritten == totalBytesExpectedToWrite) {
        [self downloadedLayout];
    }
    
    NSDate *now = [NSDate date];
    if (self.lastDate) {
        NSTimeInterval timeInterval = [now timeIntervalSinceDate:self.lastDate];
        self.bytes += data.length;
        if (timeInterval > 1) {
            float progress = totalBytesWritten/(float)totalBytesExpectedToWrite;
            self.progressView.progress = progress;
            
            self.rateLabel.text = [NSString stringWithFormat:@"%@/s", [KMDDownloadTool calculationDataWithBytes:(int64_t)(self.bytes/timeInterval)]];
            
            
            self.lastDate = now;
            self.bytes = 0;
        }
    }
    else
    {
        self.lastDate = [NSDate date];
    }
}
- (void)downloadSource:(KMDDownloadSource *)source changedStyle:(KMDDownloadSourceStyle)style
{
    if (style == KMDDownloadSourceStyleDown) {
        self.pauseButton.selected = NO;
    }
    else if (style == KMDDownloadSourceStyleSuspend)
    {
        self.pauseButton.selected = YES;
        self.rateLabel.text = @"暂停中";
    }
}

#pragma mark - 属性方法
- (void)setSource:(KMDDownloadSource *)source
{
    if (source) {
        
        _source = nil;

        if (_source) {
            _source.delegate = nil;
        }
        
        _source = source;
        source.delegate = self;
        self.lastDate = nil;
        self.bytes = 0;
        
        [self downloadingLayout];
        
        
        if (source.totalBytesExpectedToWrite) {
            float progress = source.totalBytesWritten/(float)source.totalBytesExpectedToWrite;
            
            self.progressView.progress = progress;
        }
        else
        {
            self.rateLabel.text = nil;
            self.progressView.progress = 0;
        }
        
        self.rateLabel.text = nil;
        switch (source.style) {
            case KMDDownloadSourceStyleDown:
                self.pauseButton.selected = NO;
                break;
            case KMDDownloadSourceStyleSuspend:
                self.pauseButton.selected = YES;
                self.rateLabel.text = @"暂停中";
                break;
            default:
                break;
        }
    }
    else {
        
        [self downloadedLayout];
    }
}


#pragma mark - layout
- (void)contentViewRemoveAllSubviews {
    
    [self.leftImageView removeFromSuperview];
    [self.songTitleLabel removeFromSuperview];
    [self.contentLabel removeFromSuperview];
    [self.rateLabel removeFromSuperview];
    [self.progressView removeFromSuperview];
    [self.pauseButton removeFromSuperview];
    [self.deletebutton removeFromSuperview];
}

- (void)downloadedLayout {
    
    [self contentViewRemoveAllSubviews];

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
    
    [self.contentView addSubview:self.deletebutton];
    [self.deletebutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.centerY.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];

}

- (void)downloadingLayout {
    
    [self contentViewRemoveAllSubviews];

    
    WEAK_SELF(self);
    
    [self.contentView addSubview:self.leftImageView];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(20, 19.5));
    }];
    
    [self.contentView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.bottom.equalTo(@-10);
        make.left.equalTo(self.leftImageView.mas_right).offset(5);
        make.height.mas_equalTo(3);
        make.width.mas_equalTo(SCREEN_WIDTH -10-20-5 -5-40 -5-40 -5);
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

    
    [self.contentView addSubview:self.songTitleLabel];
    [self.songTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.leftImageView.mas_right).offset(10);
        make.top.equalTo(@30);
    }];

    
    [self.contentView addSubview:self.rateLabel];
    [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.progressView.mas_right).offset(0);
        make.bottom.equalTo(self.progressView.mas_top).offset(-5);
    }];
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.greaterThanOrEqualTo(self.songTitleLabel.mas_right).offset(5);
        make.centerY.equalTo(self.songTitleLabel.mas_centerY);
        make.right.lessThanOrEqualTo(self.progressView.mas_right).offset(-5);
    }];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - setter && getter
- (UIImageView *)leftImageView {
    
    if (!_leftImageView) {
        
        _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的下载-音乐"]];
    }
    return _leftImageView;
}

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

- (UIProgressView *)progressView {
    
    if (!_progressView) {
        
        _progressView = [[UIProgressView alloc] init];
        _progressView.progress = 0;
        
    }
    return _progressView;
}

- (UIButton *)pauseButton {
    
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setImage:[UIImage imageNamed:@"我的下载-暂停按钮"] forState:UIControlStateNormal];
        [_pauseButton setImage:[UIImage imageNamed:@"我的下载-继续下载"] forState:UIControlStateSelected];
        
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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
