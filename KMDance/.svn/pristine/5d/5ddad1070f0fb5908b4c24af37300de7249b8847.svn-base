//
//  KMDDanceHeaderView.m
//  KMDance
//
//  Created by KM on 17/5/182017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDDanceHeaderView.h"

@implementation KMDDanceHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.centerY.equalTo(@0);
        }];
        
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
    }
    return self;
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
