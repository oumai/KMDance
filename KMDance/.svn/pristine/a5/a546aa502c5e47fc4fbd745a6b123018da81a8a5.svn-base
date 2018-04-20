//
//  KMDDanceThemeTableViewCell.m
//  KMDance
//
//  Created by KM on 17/6/222017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDDanceThemeTableViewCell.h"
#import "KMDDanceThemeCollectionViewCell.h"

#import "KMDDanceThemeModel.h"

static  NSString * const DANCE_THEME_COLLECTIONVIEW_CELL = @"KMDDanceThemeCollectionViewCell.h";

@implementation KMDDanceThemeTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
//        self.multiple = 1;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        WEAK_SELF(self);

        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
        }];
        
        [self.contentView addSubview:self.desLabel];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.left.equalTo(@10);
            make.right.equalTo(@10);
        }];
        
        [self.contentView addSubview:self.videoCollectionView];
        [self.videoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.desLabel.mas_bottom).offset(10);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
        }];
        
        [self.contentView addSubview:self.expandButton];
        [self.expandButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.videoCollectionView.mas_bottom).offset(5);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.mas_equalTo(@0);
            make.bottom.equalTo(@0);
        }];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (!self.dataArray.count) {
        return 0;
    }
    
    NSInteger count = self.dataArray.count<4*self.multiple?self.dataArray.count:4*self.multiple;
    
    if (count < self.dataArray.count) {
        
        [self.expandButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
        }];
        
        self.expandButton.hidden = NO;
    }
    else {
        
        [self.expandButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        self.expandButton.hidden = YES;

    }
    
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *video = self.dataArray[indexPath.row];
    /*
     {
     AccountID = 3417;
     CategoryID = 0;
     CreatedTime = "2017-06-23 09:39:00";
     ID = 594c713484781c0e84539a8e;
     Name = "\U5e7f\U573a\U821e-\U9752\U9752\U6cb3\U8fb9\U8349";
     PlayCount = 0;
     Poster = "http://video.jkbat.com/977f6dbae4fb41928df549efc2a2c212.png";
     Singer = "\U672a\U77e5";
     UploadName = "<null>";
     Url = "http://video.jkbat.com/cf292c8e8f6742418e72aec9762f5665.mp4";
     VideoLong = 2;
     ZoneID = 594c7117b0b7c70b0c8be90b;
     }
     */
    
    KMDDanceThemeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DANCE_THEME_COLLECTIONVIEW_CELL forIndexPath:indexPath];
    [cell.videoImageView sd_setImageWithURL:[NSURL URLWithString:video[@"Poster"]] placeholderImage:nil];
    cell.timeLabel.text = video[@"VideoLong"];
    cell.titleLabel.text = video[@"Name"];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *video = self.dataArray[indexPath.row];

    if (self.videoClicked) {
        self.videoClicked(video[@"ID"]);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    
    if (self.dataArray.count == 1) {
        size = CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH-10)/16.0*9 + 10 + 20 + 5);
    }
    else if (self.dataArray.count > 1) {
        size = CGSizeMake(SCREEN_WIDTH/2.0, (SCREEN_WIDTH/2.0-10)/16.0*9 + 10 + 20 + 5);
    }
    
    return size;
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
    
    self.videoCollectionView.frame = CGRectMake(0, 0, targetSize.width, SCREEN_HEIGHT);
    
    CGSize size = [self.videoCollectionView.collectionViewLayout collectionViewContentSize];
    
    CGSize titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size;
    CGSize desSize = [self.desLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size;

    NSInteger bottomHeight;
    
    NSInteger count = self.dataArray.count<4*self.multiple?self.dataArray.count:4*self.multiple;
    
    if (count < self.dataArray.count) {
        bottomHeight = 35;
    }
    else {
        bottomHeight = 5;
    }
    
    size = CGSizeMake(size.width, 10+titleSize.height+10+desSize.height+10+size.height+bottomHeight);
    return size;
}


#pragma mark - getter
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [UILabel labelWithFont:[UIFont boldSystemFontOfSize:16] textColor:BASE_COLOR textAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UILabel *)desLabel {
    
    if (!_desLabel) {
        
        _desLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentLeft];
        _desLabel.numberOfLines = 0;
    }
    return _desLabel;
}

- (UICollectionView *)videoCollectionView {
    if (!_videoCollectionView) {
        
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumLineSpacing = CGFLOAT_MIN;
        flow.minimumInteritemSpacing = CGFLOAT_MIN;
        
        _videoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        
        _videoCollectionView.backgroundColor = [UIColor whiteColor];
        _videoCollectionView.showsVerticalScrollIndicator = NO;
        
        
        [_videoCollectionView registerClass:[KMDDanceThemeCollectionViewCell class] forCellWithReuseIdentifier:DANCE_THEME_COLLECTIONVIEW_CELL];
        
        
        _videoCollectionView.delegate = self;
        _videoCollectionView.dataSource = self;
        
    }
    return _videoCollectionView;
}

- (UIButton *)expandButton {
    
    if (!_expandButton) {
        
        _expandButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"查看更多" titleColor:STRING_DARK_COLOR backgroundColor:[UIColor whiteColor] backgroundImage:nil Font:[UIFont systemFontOfSize:16]];

        
        WEAK_SELF(self);
        [_expandButton bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.expandClicked) {
                self.expandClicked();
            }
            
        }];
    }
    return _expandButton;
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
