//
//  KMDUploadView.m
//  KMDance
//
//  Created by KM on 17/8/72017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDUploadView.h"

@implementation KMDUploadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorFromHEX(0x000000, 0.3);
        
        [self addSubview:self.bottomBackView];
        [self.bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(@0);
            make.height.mas_equalTo(150);
        }];
        
        [self addSubview:self.cameraBtn];
        [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomBackView.mas_top).offset(30);
            make.left.equalTo(@75);
        }];
        
        [self addSubview:self.cameraLabel];
        [self.cameraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cameraBtn.mas_bottom).offset(10);
            make.centerX.equalTo(self.cameraBtn);
        }];
        
        [self addSubview:self.videoBtn];
        [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomBackView.mas_top).offset(30);
            make.right.equalTo(@-75);
        }];
        
        [self addSubview:self.videoLabel];
        [self.videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.videoBtn.mas_bottom).offset(10);
            make.centerX.equalTo(self.videoBtn);
        }];
    }
    return self;
}

#pragma mark - getter
- (UIView *)bottomBackView {
    
    if (!_bottomBackView) {
        
        _bottomBackView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomBackView.backgroundColor = UIColorFromHEX(0xffffff, 0.8);
        [_bottomBackView bk_whenTapped:^{
            
        }];
    }
    return _bottomBackView;
}

- (UIButton *)cameraBtn {
    
    if (!_cameraBtn) {
        
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraBtn setImage:[UIImage imageNamed:@"shooting_icon"] forState:UIControlStateNormal];
        WEAK_SELF(self);
        [_cameraBtn bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.cameraClickBlock) {
                self.cameraClickBlock();
            }
        }];
    }
    return _cameraBtn;
}

- (UILabel *)cameraLabel {
    
    if (!_cameraLabel) {
        
        _cameraLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentCenter];
        _cameraLabel.text = @"拍摄视频";
    }
    return _cameraLabel;
}

- (UIButton *)videoBtn {
    
    if (!_videoBtn) {
        
        _videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoBtn setImage:[UIImage imageNamed:@"uploadvideo_icon"] forState:UIControlStateNormal];
        WEAK_SELF(self);
        [_videoBtn bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.videoClickBlock) {
                self.videoClickBlock();
            }
        }];
    }
    return _videoBtn;
}

- (UILabel *)videoLabel {
    
    if (!_videoLabel) {
        
        _videoLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentCenter];
        _videoLabel.text = @"上传视频";
    }
    return _videoLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
