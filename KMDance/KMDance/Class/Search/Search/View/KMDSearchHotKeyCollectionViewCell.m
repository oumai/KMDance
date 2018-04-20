//
//  KMDSearchHotKeyCollectionViewCell.m
//  KMDance
//
//  Created by KM on 17/5/262017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDSearchHotKeyCollectionViewCell.h"

@implementation KMDSearchHotKeyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.hotkeyLabel];
        WEAK_SELF(self);
        [self.hotkeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - getter
- (BATGraditorButton *)hotkeyLabel {
    
    if (!_hotkeyLabel) {
        
        _hotkeyLabel = [[BATGraditorButton alloc]init];
        _hotkeyLabel.enbleGraditor = YES;
        _hotkeyLabel.titleLabel.font = [UIFont systemFontOfSize:14];
        [_hotkeyLabel setGradientColors:@[STRING_MID_COLOR,STRING_MID_COLOR]];
        _hotkeyLabel.userInteractionEnabled = NO;
        _hotkeyLabel.layer.cornerRadius = 15.0f;
        
        _hotkeyLabel.layer.borderWidth = 0.5;
        _hotkeyLabel.layer.borderColor = BASE_LINECOLOR.CGColor;
        
    }
    return _hotkeyLabel;
}

@end
