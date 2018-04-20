//
//  KMDMeTableViewCell.m
//  KMDance
//
//  Created by KM on 17/5/192017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDMeTableViewCell.h"

@implementation KMDMeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WEAK_SELF(self);
        [self addSubview:self.leftImageView];
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.centerY.equalTo(@0);
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.leftImageView.mas_right).offset(10);
            make.centerY.equalTo(@0);
        }];
        
        [self.contentView addSubview:self.rightArrowImageView];
        [self.rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.centerY.equalTo(@0);
        }];
        
        [self.contentView setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)leftImageView {
    
    if (!_leftImageView) {
        
        _leftImageView = [[UIImageView alloc] init];
        [_leftImageView sizeToFit];
    }
    return _leftImageView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UIImageView *)rightArrowImageView {
    
    if (!_rightArrowImageView) {
        
        _rightArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowgray_icon"]];
        [_rightArrowImageView sizeToFit];
    }
    return _rightArrowImageView;
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
