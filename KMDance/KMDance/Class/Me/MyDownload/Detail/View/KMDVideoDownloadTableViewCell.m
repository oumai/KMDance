//
//  KMDVideoDownloadTableViewCell.m
//  KMDance
//
//  Created by KM on 17/6/262017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDVideoDownloadTableViewCell.h"

@implementation KMDVideoDownloadTableViewCell

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
        
        
        [self.contentView addSubview:self.sourceLabel];
        [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.danceImageView.mas_right).offset(10);
            make.top.equalTo(self.danceTitleLabel.mas_bottom).offset(10);
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
        
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        
    }
    return self;
}

#pragma mark - <KMDDownloadSourceDelegate>代理方法
- (void)downloadSource:(KMDDownloadSource *)source didWriteData:(NSData *)data totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    if (totalBytesWritten == totalBytesExpectedToWrite) {
        self.progressView.hidden = YES;
        self.rateLabel.hidden = YES;
        self.pauseButton.hidden = YES;
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
        
        self.progressView.hidden = NO;
        self.rateLabel.hidden = NO;
        self.pauseButton.hidden = NO;
        
        
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
        
        _source = nil;
        self.progressView.hidden = YES;
        self.rateLabel.hidden = YES;
        self.pauseButton.hidden = YES;
    }
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

- (UILabel *)sourceLabel {
    
    if (!_sourceLabel) {
        
        _sourceLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:11] textColor:STRING_LIGHT_COLOR textAlignment:NSTextAlignmentCenter];
    }
    return _sourceLabel;
}

- (UIProgressView *)progressView {
    
    if (!_progressView) {
        
        _progressView = [[UIProgressView alloc] init];
        _progressView.progress = 0;
        _progressView.tintColor = BASE_COLOR;
        _progressView.hidden = YES;
    }
    return _progressView;
}

- (UIButton *)pauseButton {
    
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setImage:[UIImage imageNamed:@"我的下载-暂停按钮"] forState:UIControlStateNormal];
        [_pauseButton setImage:[UIImage imageNamed:@"我的下载-继续下载"] forState:UIControlStateSelected];
        _pauseButton.hidden = YES;

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
        _rateLabel.hidden = YES;
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
