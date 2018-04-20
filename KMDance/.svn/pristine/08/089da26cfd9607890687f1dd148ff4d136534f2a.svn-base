//
//  KMDSearchHotKeyTableViewCell.m
//  KMDance
//
//  Created by KM on 17/5/262017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMDSearchHotKeyTableViewCell.h"
#import "KMDSearchHotKeyCollectionViewCell.h"
#import "KMDSearchHotKeyModel.h"

static  NSString * const HOT_KEY_CELL = @"KMDSearchHotKeyCollectionViewCell";

@implementation KMDSearchHotKeyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.hotKeyCollectionView];
        WEAK_SELF(self);
        [self.hotKeyCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.contentView);
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
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HotKeyData *data = self.dataArray[indexPath.row];
    
    KMDSearchHotKeyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HOT_KEY_CELL forIndexPath:indexPath];
    
    [cell.hotkeyLabel setTitle:data.Keyword forState:UIControlStateNormal];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotKeyData *data = self.dataArray[indexPath.row];

    if (self.hotKeyClick) {
        self.hotKeyClick(data.Keyword);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    HotKeyData *data = self.dataArray[indexPath.row];
    
    CGSize textSize = [data.Keyword boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    size = CGSizeMake(textSize.width+20, 30);
    
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority
{
    self.hotKeyCollectionView.frame = CGRectMake(0, 0, targetSize.width, SCREEN_HEIGHT);
    return [self.hotKeyCollectionView.collectionViewLayout collectionViewContentSize];
}


#pragma mark - getter
- (UICollectionView *)hotKeyCollectionView {
    if (!_hotKeyCollectionView) {
        
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
        _hotKeyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        
        _hotKeyCollectionView.backgroundColor = [UIColor whiteColor];
        _hotKeyCollectionView.showsVerticalScrollIndicator = NO;
        
    
        [_hotKeyCollectionView registerClass:[KMDSearchHotKeyCollectionViewCell class] forCellWithReuseIdentifier:HOT_KEY_CELL];

        
        _hotKeyCollectionView.delegate = self;
        _hotKeyCollectionView.dataSource = self;
    
    }
    return _hotKeyCollectionView;
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
