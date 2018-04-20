//
//  KMDPersonAvatarTableViewCell.m
//  KMDance
//
//  Created by KM on 17/5/242017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDPersonAvatarTableViewCell.h"

@implementation KMDPersonAvatarTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.centerY.equalTo(@0);
        }];
        
        [self.contentView addSubview:self.rightArrowImageView];
        [self.rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.centerY.equalTo(@0);
        }];
        
        [self addSubview:self.avatarImageView];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.rightArrowImageView.mas_left).offset(-10);
            make.centerY.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(38, 38));
        }];
        
        [self.contentView setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
    }
    return self;
}

#pragma mark - getter
- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UIImageView *)avatarImageView {
    
    if (!_avatarImageView) {
        
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 19.0f;
        _avatarImageView.clipsToBounds = YES;
        [_avatarImageView sizeToFit];
        _avatarImageView.userInteractionEnabled = YES;
    }
    return _avatarImageView;
}

- (UIImageView *)rightArrowImageView {
    
    if (!_rightArrowImageView) {
        
        _rightArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowgray_icon"]];
        [_rightArrowImageView sizeToFit];
    }
    return _rightArrowImageView;
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
